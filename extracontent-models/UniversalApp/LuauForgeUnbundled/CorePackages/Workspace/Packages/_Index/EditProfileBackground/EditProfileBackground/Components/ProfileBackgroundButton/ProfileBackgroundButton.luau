local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/React")
local image = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/Foundation").Image
local useSelectedTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/RoactUtils").Hooks.useSelectedTheme
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Common/Constants")

local v5 = Constants.BACKGROUND_ASSET_IDS[1]

local color = Color3.fromRGB(255, 255, 255)
local color2 = Color3.fromRGB(0, 0, 0)

local color3 = Color3.fromRGB(80, 80, 80)

local color4 = Color3.fromRGB(30, 38, 58)
local color5 = Color3.fromRGB(156, 178, 196)

local colors = {
	[Constants.BACKGROUND_ASSET_IDS[2]] = Color3.fromRGB(255, 242, 216),
	[Constants.BACKGROUND_ASSET_IDS[3]] = Color3.fromRGB(254, 244, 194),
	[Constants.BACKGROUND_ASSET_IDS[4]] = Color3.fromRGB(238, 246, 216),
	[Constants.BACKGROUND_ASSET_IDS[5]] = Color3.fromRGB(214, 254, 202),
	[Constants.BACKGROUND_ASSET_IDS[6]] = Color3.fromRGB(192, 255, 226),
	[Constants.BACKGROUND_ASSET_IDS[7]] = Color3.fromRGB(208, 252, 255),
	[Constants.BACKGROUND_ASSET_IDS[8]] = Color3.fromRGB(238, 244, 255)
}

local function getButtonColor(p2, p3)
	if p2 ~= v5 then
		return colors[p2]
	end

	if p3 == "dark" then
		return color4
	end

	return color5
end

local function ProfileBackgroundButton(props)
	local buttonSize = props.buttonSize
	local v6 = useSelectedTheme()

	local v7 = React.useCallback(function()
		if props.selected then
			return
		end

		if props.onActivated then
			props.onActivated(props.profileBackgroundId)
		end
	end, { props.onActivated, props.selected, props.profileBackgroundId })

	local v8 = math.floor(buttonSize * 0.4)
	local profileBackgroundId = props.profileBackgroundId
	local v9

	if profileBackgroundId == v5 then
		v9 = if v6 == "dark" then color4 else color5
	else
		v9 = colors[profileBackgroundId]
	end

	local createElement = React.createElement
	local v11 = {}
	v11.Size = UDim2.new(0, buttonSize, 0, buttonSize)
	v11.BackgroundTransparency = 0
	v11.BackgroundColor3 = v9
	v11.BorderSizePixel = props.selected and 3 or 0
	local v12 = if props.selected then color else color2
	v11.BorderColor3 = v12
	v11.LayoutOrder = props.LayoutOrder
	v11[React.Event.Activated] = v7
	return createElement("ImageButton", v11, {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) }),
		Overlay = props.selected and React.createElement("Frame", {
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = color3,
			BackgroundTransparency = 0.5,
			Size = UDim2.fromScale(0.8, 0.8),
			ZIndex = 2
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			})
		}) or nil,
		Checkmark = props.selected and React.createElement(image, {
			tag = "position-center-center anchor-center-center",
			Image = "rbxassetid://6031094667",
			Size = UDim2.fromOffset(v8, v8),
			ZIndex = 3
		}) or nil
	})
end

return ProfileBackgroundButton
