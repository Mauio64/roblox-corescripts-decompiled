local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local Dash = require(CorePackages.Packages.Dash)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants

local function selectHasNoSharedAvatarsOnMySharedAvatars(p1, p2) -- line: 14
	-- upvalues: AvatarScreen (copy), WidgetConstants (copy), Dash (copy)
	local v10 = p2 and (not not p2.opaque and (p2.opaque.name == AvatarScreen.MySharedAvatars and WidgetConstants.ContextWidgets.MySharedAvatars.Context)) or nil

	if not v10 then
		return false
	end

	local ContextWidgetInfo = p1.AvatarExperience.Common.Widgets.ContextWidgetInfo
	local v12 = ContextWidgetInfo and (ContextWidgetInfo[v10] and ContextWidgetInfo[v10].Details)

	if not v12 or type(v12) ~= "table" then
		return false
	end

	local v13 = v12[v10] and v12[v10].content

	if not v13 or type(v13) ~= "table" or #Dash.keys(v13) == 0 then
		return true
	end

	return false
end

return selectHasNoSharedAvatarsOnMySharedAvatars
