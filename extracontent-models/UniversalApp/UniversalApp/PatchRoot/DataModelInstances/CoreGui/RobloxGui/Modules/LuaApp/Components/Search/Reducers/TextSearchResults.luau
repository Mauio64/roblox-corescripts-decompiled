local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local AddTextSearchResults = Modules.LuaApp.Actions.AddTextSearchResults
local RemoveTextSearchResults = Modules.LuaApp.Actions.RemoveTextSearchResults

return function(p1, p2) -- line: 9
	-- upvalues: AddTextSearchResults (copy), Cryo (copy), RemoveTextSearchResults (copy)
	local v8 = p1 or {}

	if p2.type == AddTextSearchResults.name then
		local searchUuid = p2.searchUuid
		local topicId = p2.topicId
		local v11 = v8[searchUuid] or {}
		local v12 = Cryo.Dictionary.join(v11, {
			[topicId] = p2.entry
		})

		return (Cryo.Dictionary.join(v8, {
			[searchUuid] = v12
		}))
	end

	if p2.type == RemoveTextSearchResults.name then
		local searchUuid = p2.searchUuid

		v8 = Cryo.Dictionary.join(v8, {
			[searchUuid] = Cryo.None
		})
	end

	return v8
end
