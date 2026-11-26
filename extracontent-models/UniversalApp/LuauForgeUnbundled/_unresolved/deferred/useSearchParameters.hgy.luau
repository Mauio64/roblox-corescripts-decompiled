local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
require("@luauforge/bundled/dXi")
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local function useSearchParameters()
	local v5 = useNavigation()
	local v6 = if v5.state.routeName == avatarScreen.CatalogSearch then v5.getParam("detail") else nil

	return (useSelector(function(p2)
		if v6 then
			return p2.SearchesParameters[v6]
		end

		return nil
	end, getUseSelectorDeepEquals()))
end

return useSearchParameters
