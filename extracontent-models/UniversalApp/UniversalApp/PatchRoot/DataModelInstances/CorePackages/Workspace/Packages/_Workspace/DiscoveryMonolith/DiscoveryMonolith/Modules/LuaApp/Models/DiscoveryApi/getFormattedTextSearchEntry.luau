local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local reportWarning = require(Parent.DiscoveryAnalytics).Points.reportWarning
local LoggingProtocol = require(Parent.LoggingProtocol)
local TextSearchEntry = require(script.Parent.TextSearchEntry)

local function getFormattedTextSearchEntry(t1: {[any]: any}) -- line: 9
	-- upvalues: reportWarning (copy), LoggingProtocol (copy), TextSearchEntry (copy)
	if not t1 then
		reportWarning(LoggingProtocol.default, "TextSearchEntryNoResults", "Text search results is nil")

		return nil
	end

	if t1 and #t1 == 0 then
		reportWarning(LoggingProtocol.default, "TextSearchEntryNoResults", "Text search results is empty")

		return nil
	end

	local u7 = nil
	local v8 = t1[1]

	TextSearchEntry.fromTextSearchEntryJson(v8):match(function(p1) -- line: 27
		-- upvalues: u7 (ref)
		u7 = p1
	end):matchError(function(s1: string) -- line: 30
		-- upvalues: reportWarning (copy), LoggingProtocol (copy)
		reportWarning(LoggingProtocol.default, "TextSearchEntryParseError", s1)
	end)

	return u7
end

return getFormattedTextSearchEntry
