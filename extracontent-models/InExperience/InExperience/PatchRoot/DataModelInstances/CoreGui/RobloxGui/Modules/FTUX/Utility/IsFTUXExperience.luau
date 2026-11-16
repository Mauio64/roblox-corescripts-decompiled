local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local IsVRAppBuild = AppCommonLib.IsVRAppBuild
local PlatformEnum = require(parent.Enums.PlatformEnum)
local FTUXConstants = require(parent.Resources.FTUXConstants)

function IsFTUXExperience(p)
	if p == PlatformEnum.QuestVR then
		return IsVRAppBuild() and tostring(game.PlaceId) == FTUXConstants[PlatformEnum.QuestVR].ExperienceIds.PlaceId
	end

	return false
end

return IsFTUXExperience
