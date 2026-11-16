local immutable = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Immutable

local modules = require("@luauforge/bundled/dpZ").Modules
local setSearchInGames = modules.LuaApp.Actions.SetSearchInGames
local appendSearchInGames = modules.LuaApp.Actions.AppendSearchInGames
local fFlagSearchEmphasisViewportNonSdui = modules.LuaApp.Flags.FFlagSearchEmphasisViewportNonSdui

local module = require("@luauforge/bundled/hFd")
local module2 = require("@luauforge/bundled/hJk")

return function(options, data)
	local v5 = options or {}

	if data.type == setSearchInGames.name then
		return (immutable.Set(v5, data.searchUuid, data.searchInGames))
	end

	if data.type == appendSearchInGames.name then
		local searchUuid = data.searchUuid
		local v6 = v5[searchUuid]
		local searchInGames = data.searchInGames

		if v6 then
			searchInGames.emphasis = v6.emphasis

			if fFlagSearchEmphasisViewportNonSdui then
				searchInGames.viewportSize = v6.viewportSize
			end

			searchInGames.entries = immutable.JoinLists(v6.entries, searchInGames.entries)
		end

		return (immutable.Set(v5, searchUuid, searchInGames))
	elseif data.type == module.name then
		return (immutable.Set(v5, data.searchUuid, nil))
	else
		return data.type == module2.name and {} or v5
	end
end
