local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Roact")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UserLib")
local constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/AppChat/Constants")
local imageSetLabel = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox").Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppAssets").GetImageData
local colors = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Style").Colors

local extended = Roact.PureComponent:extend("FriendIcon")

extended.defaultProps = {
	layoutOrder = 0,
	maskColor = colors.White,
	showBackground = true
}

function extended.render(p2)
	local user = p2.props.user
	local dotSize = p2.props.dotSize
	local itemSize = p2.props.itemSize
	local layoutOrder = p2.props.layoutOrder
	local showBackground = p2.props.showBackground

	local maskColor = p2.props.maskColor
	local v5 = dotSize ~= nil
	local presenceIndicatorSizeKey = Constants:GetPresenceIndicatorSizeKey(dotSize)

	local v6 = nil
	local v7

	if user then
		if v5 then
			v6 = Constants.PresenceIndicatorImagesBySize[presenceIndicatorSizeKey][user.presence]
		end

		v7 = getRbxthumbWithTypeSizeAndOptions(user.id, constants.RbxthumbTypes.AvatarHeadShot, 48)
	end

	return Roact.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(209, 209, 209),
		BackgroundTransparency = showBackground and 0 or 1,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		Size = UDim2.new(0, itemSize, 0, itemSize)
	}, {
		Profile = Roact.createElement(imageSetLabel, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = getImageData(v7) or v7,
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
		Dot = showBackground and v5 and Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = v6,
			Position = UDim2.new(1, -dotSize, 1, -dotSize),
			Size = UDim2.new(0, dotSize, 0, dotSize),
			ZIndex = 3
		}) or nil
	})
end

return extended
