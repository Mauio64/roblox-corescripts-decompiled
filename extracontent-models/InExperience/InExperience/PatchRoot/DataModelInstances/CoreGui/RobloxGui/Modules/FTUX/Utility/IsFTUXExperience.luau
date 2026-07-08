local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local PlatformEnum = require(ParentParent.Enums.PlatformEnum)
local FTUXConstants = require(ParentParent.Resources.FTUXConstants)

function IsFTUXExperience(p1) -- line: 10
	-- upvalues: PlatformEnum (copy), IsVRAppBuild (copy), FTUXConstants (copy)
	if p1 == PlatformEnum.QuestVR then
		return IsVRAppBuild() and tostring(game.PlaceId) == FTUXConstants[PlatformEnum.QuestVR].ExperienceIds.PlaceId
	end

	return false
end

return IsFTUXExperience
