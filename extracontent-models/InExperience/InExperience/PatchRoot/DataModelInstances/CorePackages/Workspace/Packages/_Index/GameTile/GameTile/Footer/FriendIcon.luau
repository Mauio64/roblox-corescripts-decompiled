local parent = script:FindFirstAncestor("GameTile").Parent
local Roact = require(parent.Roact)
local UserLib = require(parent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants2 = require(parent.AppChat.Constants)
local UIBlox = require(parent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local RobloxAppAssets = require(parent.RobloxAppAssets)
local GetImageData = RobloxAppAssets.GetImageData
local Style = require(parent.Style)
local Colors = Style.Colors

local extended = Roact.PureComponent:extend("FriendIcon")

extended.defaultProps = { layoutOrder = 0, maskColor = Colors.White, showBackground = true }

function extended.render(p)
	local user = p.props.user
	local dotSize = p.props.dotSize
	local itemSize = p.props.itemSize
	local layoutOrder = p.props.layoutOrder
	local showBackground = p.props.showBackground

	local maskColor = p.props.maskColor
	local v = dotSize ~= nil
	local presenceIndicatorSizeKey = Constants2:GetPresenceIndicatorSizeKey(dotSize)

	local image = nil
	local v2

	if user then
		if v then
			image = Constants2.PresenceIndicatorImagesBySize[presenceIndicatorSizeKey][user.presence]
		end

		v2 = getRbxthumbWithTypeSizeAndOptions(user.id, Constants.RbxthumbTypes.AvatarHeadShot, 48)
	end

	return Roact.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(209, 209, 209),
		BackgroundTransparency = showBackground and 0 or 1,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		Size = UDim2.new(0, itemSize, 0, itemSize)
	}, {
		Profile = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = GetImageData(v2) or v2,
			Size = UDim2.new(0, itemSize, 0, itemSize),
			ZIndex = 1
		}),
		Mask = showBackground and Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = "rbxasset://textures/ui/LuaApp/graphic/gr-avatar-frame-36x36.png",
			ImageColor3 = maskColor,
			Size = UDim2.new(0, itemSize, 0, itemSize),
			ZIndex = 2
		}) or nil,
		Dot = showBackground and v and Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = image,
			Position = UDim2.new(1, -dotSize, 1, -dotSize),
			Size = UDim2.new(0, dotSize, 0, dotSize),
			ZIndex = 3
		}) or nil
	})
end

return extended
