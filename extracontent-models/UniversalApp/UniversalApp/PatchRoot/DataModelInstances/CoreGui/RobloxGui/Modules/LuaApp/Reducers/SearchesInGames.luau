local CorePackages = game:GetService("CorePackages")
local Immutable = require(CorePackages.Workspace.Packages.AppCommonLib).Immutable
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local SetSearchInGames = Modules.LuaApp.Actions.SetSearchInGames
local AppendSearchInGames = Modules.LuaApp.Actions.AppendSearchInGames
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local RemoveSearchInGames = require(Modules2.LuaApp.Actions.RemoveSearchInGames)
local ResetSearchesInGames = require(Modules2.LuaApp.Actions.ResetSearchesInGames)

return function(p1, p2) -- line: 13
	-- upvalues: SetSearchInGames (copy), Immutable (copy), AppendSearchInGames (copy), RemoveSearchInGames (copy), ResetSearchesInGames (copy)
	local v11 = p1 or {}

	if p2.type == SetSearchInGames.name then
		return (Immutable.Set(v11, p2.searchUuid, p2.searchInGames))
	end

	if p2.type == AppendSearchInGames.name then
		local searchUuid = p2.searchUuid
		local v13 = v11[searchUuid]
		local searchInGames = p2.searchInGames

		if v13 then
			searchInGames.emphasis = v13.emphasis
			searchInGames.entries = Immutable.JoinLists(v13.entries, searchInGames.entries)
		end

		return (Immutable.Set(v11, searchUuid, searchInGames))
	end

	if p2.type == RemoveSearchInGames.name then
		return (Immutable.Set(v11, p2.searchUuid, nil))
	end

	if p2.type == ResetSearchesInGames.name then
		v11 = {}
	end

	return v11
end
