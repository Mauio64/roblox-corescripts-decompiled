local reportWarning = require("@luauforge/bundled/dtq").Points.reportWarning
local module = require("@luauforge/bundled/dts")

local module2 = require("@luauforge/bundled/dtL")

local function getFormattedTextSearchEntry(list)
	if not list then
		reportWarning(module.default, "TextSearchEntryNoResults", "Text search results is nil")
		return nil
	end

	if list and #list == 0 then
		reportWarning(module.default, "TextSearchEntryNoResults", "Text search results is empty")
		return nil
	end

	local v5 = nil

	local item = list[1]
	module2.fromTextSearchEntryJson(item):match(function(p2)
		v5 = p2
	end):matchError(function(p2)
		reportWarning(module.default, "TextSearchEntryParseError", p2)
	end)

	return v5
end

return getFormattedTextSearchEntry
