local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Constants = require(Modules.LuaApp.Constants)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(CorePackages.Workspace.Packages.RobloxAppAssets).GetImageData
local v8 = Roact.PureComponent:extend("UserThumbnail")

function v8.render(p1) -- line: 16
	-- upvalues: Roact (copy), Constants (copy), ImageSetLabel (copy), GetImageData (copy)
	local propsSize = p1.props.Size
	local propsPosition = p1.props.Position
	local propsAnchorPoint = p1.props.AnchorPoint
	local SizeConstraint = p1.props.SizeConstraint
	local MaskColor = p1.props.MaskColor
	local v15 = p1.props.Url ~= "" and p1.props.Url or "LuaApp/graphic/ph-avatar-portrait"

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = Constants.Color.GRAY_AVATAR_BACKGROUND,
		Size = propsSize,
		Position = propsPosition,
		AnchorPoint = propsAnchorPoint,
		SizeConstraint = SizeConstraint,
		BackgroundTransparency = not MaskColor and 1 or 0
	}, {
		Thumbnail = Roact.createElement(ImageSetLabel, {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			SizeConstraint = SizeConstraint,
			Image = GetImageData(v15) or v15
		}),
		Mask = MaskColor and Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 2,
			Image = GetImageData("rbxasset://textures/ui/LuaApp/graphic/profilemask.png") or "rbxasset://textures/ui/LuaApp/graphic/profilemask.png",
			ImageColor3 = MaskColor,
			Size = UDim2.new(1, 0, 1, 0)
		}) or nil
	})
end

return v8
