require("@game/CorePackages/Workspace/Packages/Navigation")

local module = require("@luauforge/deferred/ejM")

local result = {}

for k, v5 in module do
	local v6 = {
		[v5.id] = { getScreen = v5.getScreen }
	}
	table.insert(result, v6)
end

return result
