local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local React = require(CorePackages.Packages.React)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation

local function v11(p1) -- line: 19
	return p1.AvatarExperience.AvatarEditor.OutfitInfos
end
local function v12(p2) -- line: 23
	return p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
end

return function(p3, s1: string) -- line: 27
	-- upvalues: useDispatch (copy), useNavigation (copy), useSelector (copy), v11 (copy), v12 (copy), React (copy), Utils (copy), NavigateWithLock (copy), NavigationUtils (copy), AvatarScreen (copy)
	local v17 = useDispatch()
	local v18 = useNavigation()
	local v19 = useSelector(v11)
	local v20 = useSelector(v12)

	return React.useCallback(function(s2: string, p4: ((...any) -> ...any)) -- line: 35
		-- upvalues: Utils (copy), v20 (copy), v19 (copy), p3 (copy), v17 (copy), NavigateWithLock (copy), NavigationUtils (copy), v18 (copy), AvatarScreen (copy), s1 (copy)
		if Utils.isDuplicateOutfitName(v20, v19, s2, p3) then
			v17(NavigateWithLock(function() -- line: 37
				-- upvalues: NavigationUtils (copy), v18 (copy), AvatarScreen (copy), s2 (copy), p3 (copy), p4 (copy), s1 (copy)
				NavigationUtils.navigateToNextOverlay(v18, AvatarScreen.DuplicateOutfitNameDialog, {
					outfitName = s2,
					outfitType = p3,
					onComplete = p4,
					backScreen = s1
				})
			end))

			return true
		end

		return false
	end, {
		p3,
		v20,
		v19,
		v18,
		v17,
		s1
	})
end
