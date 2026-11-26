local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local modules = require("@luauforge/bundled/dtb").Modules
local addTextSearchResults = modules.LuaApp.Actions.AddTextSearchResults
local removeTextSearchResults = modules.LuaApp.Actions.RemoveTextSearchResults

return function(options, data)
	local joined = options or {}

	if data.type == addTextSearchResults.name then
		local searchUuid = data.searchUuid
		local topicId = data.topicId

		local v5 = joined[searchUuid] or {}
		local joined2 = Cryo.Dictionary.join(v5, { [topicId] = data.entry })

		return (Cryo.Dictionary.join(joined, { [searchUuid] = joined2 }))
	end

	if data.type == removeTextSearchResults.name then
		local searchUuid = data.searchUuid

		joined = Cryo.Dictionary.join(joined, { [searchUuid] = Cryo.None })
	end

	return joined
end
