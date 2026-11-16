local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

require("@luauforge/bundled/dHK")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local module2 = require("@luauforge/bundled/dMx")

local function selectHasModerationAlert(p2, p3): boolean
	local context = p3
		and p3.opaque
		and p3.opaque.name == avatarScreen.MySharedAvatars
		and widgetConstants.ContextWidgets.MySharedAvatars.Context
		or nil

	if not context then
		return false
	end

	local contextWidgetInfo = p2.AvatarExperience.Common.Widgets.ContextWidgetInfo
	local details = contextWidgetInfo and contextWidgetInfo[context] and contextWidgetInfo[context].Details
	local content = details and details[context] and details[context].content

	if not content or type(content) ~= "table" then
		return false
	end

	local v5 = p2.AvatarExperience.Common.Widgets.HydratedWidgetData[widgetConstants.ContentType.Look]

	for k, v6 in content do
		if
			v6
			and v6.id
			and v5
			and type(v5[v6.id]) == "table"
			and v5[v6.id].moderationStatus == module2.ModerationStatus.Moderated
		then
			return true
		end
	end

	return false
end

return selectHasModerationAlert
