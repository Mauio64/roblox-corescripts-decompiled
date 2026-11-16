local CorePackages = game:GetService("CorePackages")

local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local Dash = require(CorePackages.Packages.Dash)

require("@luauforge/bundled/dHK")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local widgetConstants = AvatarExperienceCatalog.WidgetConstants

local function selectHasNoSharedAvatarsOnMySharedAvatars(p2, p3): boolean
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

	if not details or type(details) ~= "table" then
		return false
	end

	local content = details[context] and details[context].content

	if content and type(content) == "table" and #Dash.keys(content) ~= 0 then
		return false
	end

	return true
end

return selectHasNoSharedAvatarsOnMySharedAvatars
