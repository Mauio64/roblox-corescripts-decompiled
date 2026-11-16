local AvatarEditorService = game:GetService("AvatarEditorService")
local CorePackages = game:GetService("CorePackages")

local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local showAvatarChangeFeatureRestriction = AvatarExperienceCommon.Utils.showAvatarChangeFeatureRestriction

local function showSaveAvatarTimeoutFeatureRestriction(p)
	(p or AvatarEditorService):SignalSaveAvatarPermissionDenied()
	showAvatarChangeFeatureRestriction()
end

return showSaveAvatarTimeoutFeatureRestriction
