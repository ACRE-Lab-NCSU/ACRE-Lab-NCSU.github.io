-- Groups the publication list by year.
--
-- Pandoc normally formats the bibliography after all Lua filters have run, so here we
-- run citeproc ourselves first, add a year heading above each group of entries, and
-- then clear the bibliography settings so the normal pass does not rebuild the list.
-- Each entry's year comes from the BibTeX data (not the formatted text), so this works
-- with any citation style as long as the style sorts entries newest first.
--
-- Within a year, the style sorts by month. Pandoc understands `month = dec`, `{Dec}`, or
-- `{12}` but silently ignores full names such as `{December}`, so this filter reads each
-- entry's month from the .bib file itself and fills in any month Pandoc missed.
--
-- A page can instead set `recent-publications: N` in its front matter. The filter then
-- keeps only the first N entries (the newest) and adds no year headings. The home page
-- uses this for its "Recent publications" list.
--
-- If an entry has a `url` (or, failing that, a `doi`) field, its title becomes a link to
-- it. The URL and DOI are then removed before citeproc runs, so the style does not also
-- print them as text.

local years = {}
local links = {}

local month_numbers = {
  jan = 1, feb = 2, mar = 3, apr = 4, may = 5, jun = 6,
  jul = 7, aug = 8, sep = 9, oct = 10, nov = 11, dec = 12,
}

-- Returns 1-12 for values like "December", "Dec.", "dec", or "12"; nil otherwise.
local function parse_month(value)
  local n = tonumber(value)
  if n then return (n >= 1 and n <= 12) and math.floor(n) or nil end
  return month_numbers[value:sub(1, 3):lower()]
end

-- Reads `month` fields straight from the BibTeX source: { [citation key] = 1-12 }.
local function months_from_bib(paths)
  local months = {}
  for _, path in ipairs(paths) do
    local f = io.open(path, "r")
    if f then
      local text = "\n" .. f:read("a")
      f:close()
      -- Split the file into entries, each starting with "@" at the beginning of a line.
      local starts = {}
      local pos = 1
      while true do
        local s = text:find("\n[ \t]*@", pos)
        if not s then break end
        table.insert(starts, s)
        pos = s + 1
      end
      table.insert(starts, #text + 1)
      for i = 1, #starts - 1 do
        local entry = text:sub(starts[i], starts[i + 1] - 1)
        local key = entry:match("@%a+%s*[{(]%s*([^,%s]+)%s*,")
        local value = entry:match("[Mm][Oo][Nn][Tt][Hh]%s*=%s*[{\"]?%s*([%w%.]+)")
        local month = value and parse_month(value)
        if key and month then months[key] = month end
      end
    end
  end
  return months
end

local function bib_paths(meta)
  local bib = meta.bibliography
  if not bib then return {} end
  if pandoc.utils.type(bib) == "List" then
    return bib:map(pandoc.utils.stringify)
  end
  return { pandoc.utils.stringify(bib) }
end

local recent_limit = nil

-- Wraps the first quoted string (the paper title in IEEE style) in a link. Citeproc
-- emits it either as a Quoted element or as a Span that starts with an opening quote.
local function link_title(entry, url)
  local done = false
  local function wrap(el)
    if done then return nil end
    done = true
    return pandoc.Link({ el }, url)
  end
  return entry:walk({
    Quoted = wrap,
    Span = function(span)
      if pandoc.utils.stringify(span):sub(1, 3) == "\u{201C}" then return wrap(span) end
    end,
  })
end

local function group_refs(div)
  if div.identifier ~= "refs" then return nil end
  local out = pandoc.List()
  local current = nil
  local count = 0
  for _, child in ipairs(div.content) do
    if child.t == "Div" and child.classes:includes("csl-entry") then
      count = count + 1
      if recent_limit and count > recent_limit then break end
      local id = child.identifier:gsub("^ref%-", "")
      local year = years[id]
      if links[id] then child = link_title(child, links[id]) end
      if not recent_limit and year and year ~= current then
        current = year
        out:insert(pandoc.Header(2, year, pandoc.Attr("year-" .. year)))
      end
    end
    out:insert(child)
  end
  div.content = out
  return div
end

function Pandoc(doc)
  local limit = doc.meta["recent-publications"]
  recent_limit = limit and tonumber(pandoc.utils.stringify(limit)) or nil
  local months = months_from_bib(bib_paths(doc.meta))
  local refs = pandoc.utils.references(doc)
  for _, ref in ipairs(refs) do
    local url = ref.url and pandoc.utils.stringify(ref.url)
    local doi = ref.doi and pandoc.utils.stringify(ref.doi)
    if url and url ~= "" then
      links[ref.id] = url
    elseif doi and doi ~= "" then
      links[ref.id] = "https://doi.org/" .. doi
    end
    ref.url = nil
    ref.doi = nil
    local issued = ref.issued
    local parts = issued and issued["date-parts"]
    if parts and parts[1] and parts[1][1] then
      local year = math.floor(tonumber(parts[1][1]))
      years[ref.id] = tostring(year)
      if not parts[1][2] and months[ref.id] then
        ref.issued = { ["date-parts"] = { { year, months[ref.id] } } }
      end
    end
  end
  -- Hand citeproc the corrected references instead of the .bib file.
  doc.meta.references = refs
  doc.meta.bibliography = nil
  local processed = pandoc.utils.citeproc(doc)
  processed = processed:walk({ Div = group_refs })
  processed.meta.bibliography = nil
  processed.meta.references = nil
  processed.meta.nocite = nil
  processed.meta.csl = nil
  return processed
end
