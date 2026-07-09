local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Modules = CoreGui.RobloxGui.Modules
local SetEntryPage = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetEntryPage)
local LockCharacterUpdates = require(Modules.AvatarExperience.LayeredClothingSort.Actions.LockCharacterUpdates)
local SendRefinementAnalytics = require(Modules.AvatarExperience.LayeredClothingSort.Thunks.SendRefinementAnalytics)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock

return function(p1, p2, p3, p4: ((...any) -> ...any)?) -- line: 19
	-- upvalues: SetEntryPage (copy), SendRefinementAnalytics (copy), LockCharacterUpdates (copy), AvatarScreen (copy), NavigateWithLock (copy)
	return function(p5) -- line: 20
		-- upvalues: SetEntryPage (copy), p2 (copy), SendRefinementAnalytics (copy), p3 (copy), p4 (copy), LockCharacterUpdates (copy), p1 (copy), AvatarScreen (copy), NavigateWithLock (copy)
		local v14 = p5:getState()

		if v14.AvatarExperience.AvatarScene.Character.WaitingOnLayeredClothingUpdates or not v14.AvatarExperience.AvatarEditor.Character.EquippedAssets then
			return
		end

		p5:dispatch(SetEntryPage(p2.opaque.name))
		p5:dispatch(SendRefinementAnalytics(p3.avatarRefineButtonTap))

		if p4 then
			p4()
		end

		p5:dispatch(NavigateWithLock(function() -- line: 34
			-- upvalues: p5 (copy), LockCharacterUpdates (copy), p1 (copy), AvatarScreen (copy)
			p5:dispatch(LockCharacterUpdates())
			p1.navigate(AvatarScreen.AvatarRefinement)
		end))
	end
end
