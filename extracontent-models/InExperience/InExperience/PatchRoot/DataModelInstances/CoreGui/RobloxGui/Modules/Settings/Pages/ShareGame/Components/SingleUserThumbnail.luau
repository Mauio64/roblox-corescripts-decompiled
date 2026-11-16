local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local colors = CoreScriptsCommon.Constants.COLORS
local Constants = require(Modules.Settings.Pages.ShareGame.Constants)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local constants = UserLib.Utils.Constants

local UserLib2 = require(CorePackages.Workspace.Packages.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib2.Utils.getRbxthumbWithTypeSizeAndOptions

local InviteAvatarThumbnailSize = Constants.InviteAvatarThumbnailSize

return function(props)
	local user = props.user
	local v

	if user then
		local v2 = constants.RbxThumbnailSizeToNumberSize[InviteAvatarThumbnailSize]
		v = getRbxthumbWithTypeSizeAndOptions(user.id, Constants.InviteAvatarRbxthumbType, v2)
	end

	local createElement = React.createElement
	local v2 = {
		Size = props.size,
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		Image = v or "rbxasset://textures/ui/LuaApp/graphic/ph-avatar-portrait.png",
		BorderSizePixel = 0,
		BackgroundColor3 = colors.FLINT,
		BackgroundTransparency = props.backgroundTransparency
	}
	local corner

	if not props.square then
		corner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) })
	end

	return createElement("ImageLabel", v2, { Corner = corner })
end
