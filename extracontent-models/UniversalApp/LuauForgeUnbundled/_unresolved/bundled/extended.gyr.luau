local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local module = require("@luauforge/bundled/dzD")
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/RobloxAppAssets").GetImageData

local extended = Roact.PureComponent:extend("UserThumbnail")

function extended.render(p2)
	local size = p2.props.Size
	local position = p2.props.Position
	local anchorPoint = p2.props.AnchorPoint
	local sizeConstraint = p2.props.SizeConstraint
	local maskColor = p2.props.MaskColor

	local v5 = p2.props.Url == "" and "LuaApp/graphic/ph-avatar-portrait"
		or p2.props.Url
		or "LuaApp/graphic/ph-avatar-portrait"

	return Roact.createElement("Frame", {
		BackgroundColor3 = module.Color.GRAY_AVATAR_BACKGROUND,
		Size = size,
		Position = position,
		AnchorPoint = anchorPoint,
		SizeConstraint = sizeConstraint,
		BorderSizePixel = 0,
		BackgroundTransparency = maskColor and 0 or 1
	}, {
		Thumbnail = Roact.createElement(imageSetLabel, {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			SizeConstraint = sizeConstraint,
			Image = getImageData(v5) or v5,
			BorderSizePixel = 0,
			BackgroundTransparency = 1
		}),
		Mask = maskColor and Roact.createElement(imageSetLabel, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = getImageData("rbxasset://textures/ui/LuaApp/graphic/profilemask.png") or "rbxasset://textures/ui/LuaApp/graphic/profilemask.png",
			ImageColor3 = maskColor,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 2
		}) or nil
	})
end

return extended
