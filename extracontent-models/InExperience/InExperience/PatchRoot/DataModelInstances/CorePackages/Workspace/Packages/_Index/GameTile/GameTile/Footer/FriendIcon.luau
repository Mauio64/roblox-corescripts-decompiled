local Parent = script:FindFirstAncestor("GameTile").Parent
local Roact = require(Parent.Roact)
local UserLib = require(Parent.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants2 = require(Parent.AppChat.Constants)
local ImageSetLabel = require(Parent.UIBlox).Core.ImageSet.ImageSetLabel
local GetImageData = require(Parent.RobloxAppAssets).GetImageData
local Colors = require(Parent.Style).Colors
local v10 = Roact.PureComponent:extend("FriendIcon")

v10.defaultProps = {
	layoutOrder = 0,
	showBackground = true,
	maskColor = Colors.White
}

function v10.render(p1) -- line: 25
	-- upvalues: Constants2 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), Roact (copy), ImageSetLabel (copy), GetImageData (copy)
	local user = p1.props.user
	local dotSize = p1.props.dotSize
	local itemSize = p1.props.itemSize
	local layoutOrder = p1.props.layoutOrder
	local showBackground = p1.props.showBackground
	local maskColor = p1.props.maskColor
	local v18 = dotSize ~= nil
	local PresenceIndicatorSizeKey = Constants2:GetPresenceIndicatorSizeKey(dotSize)
	local v20 = nil
	local v21 = nil

	if user then
		if v18 then
			v21 = Constants2.PresenceIndicatorImagesBySize[PresenceIndicatorSizeKey][user.presence]
		end

		v20 = getRbxthumbWithTypeSizeAndOptions(user.id, Constants.RbxthumbTypes.AvatarHeadShot, 48)
	end

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(209, 209, 209),
		BackgroundTransparency = not showBackground and 1 or 0,
		LayoutOrder = layoutOrder,
		Size = UDim2.new(0, itemSize, 0, itemSize)
	}, {
		Profile = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 1,
			Image = GetImageData(v20) or v20,
			Size = UDim2.new(0, itemSize, 0, itemSize)
		}),
		Mask = showBackground and Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = "rbxasset://textures/ui/LuaApp/graphic/gr-avatar-frame-36x36.png",
			ZIndex = 2,
			ImageColor3 = maskColor,
			Size = UDim2.new(0, itemSize, 0, itemSize)
		}) or nil,
		Dot = showBackground and (not not v18 and Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 3,
			Image = v21,
			Position = UDim2.new(1, -dotSize, 1, -dotSize),
			Size = UDim2.new(0, dotSize, 0, dotSize)
		})) or nil
	})
end

return v10
