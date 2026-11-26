local module = require("@luauforge/bundled/dFh")

local function getFormattedUserSearchEntries(items)
	local v5 = {}

	if not items then
		return {}
	end

	for k, item in items do
		module.fromOmniJsonData(item):match(function(p2)
			table.insert(v5, p2)
		end):matchError(function(p2)
			warn("Failure in parsing UserSearchEntry: " .. p2)
		end)
	end

	return v5
end

return getFormattedUserSearchEntries
