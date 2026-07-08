local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local COLORS = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Constants.COLORS
local Constants = require(Modules.Settings.Pages.ShareGame.Constants)
local Constants2 = require(CorePackages.Workspace.Packages.UserLib).Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = require(CorePackages.Workspace.Packages.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions
local InviteAvatarThumbnailSize = Constants.InviteAvatarThumbnailSize

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: Constants2 (copy), InviteAvatarThumbnailSize (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), React (copy), COLORS (copy)
	local user = t1.user
	local v11 = nil

	if user then
		local v12 = Constants2.RbxThumbnailSizeToNumberSize[InviteAvatarThumbnailSize]

		v11 = getRbxthumbWithTypeSizeAndOptions(user.id, Constants.InviteAvatarRbxthumbType, v12)
	end

	if not v11 then
		v11 = "rbxasset://textures/ui/LuaApp/graphic/ph-avatar-portrait.png"
	end

	return React.createElement("ImageLabel", {
		BorderSizePixel = 0,
		Size = t1.size,
		Position = t1.position,
		AnchorPoint = t1.anchorPoint,
		Image = v11,
		BackgroundColor3 = COLORS.FLINT,
		BackgroundTransparency = t1.backgroundTransparency
	}, {
		Corner = if not t1.square then React.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0)
		}) else nil
	})
end
