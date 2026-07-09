local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local Constants = require(Modules.AvatarExperience.Common.Constants)

local function selectHasModerationAlert(p1, p2) -- line: 13
	-- upvalues: AvatarScreen (copy), WidgetConstants (copy), Constants (copy)
	local v10 = p2 and (not not p2.opaque and (p2.opaque.name == AvatarScreen.MySharedAvatars and WidgetConstants.ContextWidgets.MySharedAvatars.Context)) or nil

	if not v10 then
		return false
	end

	local ContextWidgetInfo = p1.AvatarExperience.Common.Widgets.ContextWidgetInfo
	local v12 = ContextWidgetInfo and (ContextWidgetInfo[v10] and ContextWidgetInfo[v10].Details)
	local v13 = v12 and (v12[v10] and v12[v10].content)

	if not v13 or type(v13) ~= "table" then
		return false
	end

	local v14 = p1.AvatarExperience.Common.Widgets.HydratedWidgetData[WidgetConstants.ContentType.Look]

	for _, v16 in v13 do
		if v16 and v16.id and v14 and type(v14[v16.id]) == "table" and v14[v16.id].moderationStatus == Constants.ModerationStatus.Moderated then
			return true
		end
	end

	return false
end

return selectHasModerationAlert
