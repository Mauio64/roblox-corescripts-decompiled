local EditProfileBackground = script:FindFirstAncestor("EditProfileBackground")
local parent = EditProfileBackground.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Image = Foundation.Image
local RoactUtils = require(parent.RoactUtils)
local useSelectedTheme = RoactUtils.Hooks.useSelectedTheme
local Constants = require(EditProfileBackground.Common.Constants)

local v = Constants.BACKGROUND_ASSET_IDS[1]

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

local function getButtonColor(profileBackgroundId: number, p: string) -- 1 equivalent call inferred from this helper
	if profileBackgroundId ~= v then
		return colors[profileBackgroundId]
	end

	return if p == "dark" then color4 else color5
end

local function ProfileBackgroundButton(props)
	local buttonSize = props.buttonSize
	local v2 = useSelectedTheme()

	local v3 = React.useCallback(function()
		if props.selected then
			return
		end

		if props.onActivated then
			props.onActivated(props.profileBackgroundId)
		end
	end, { props.onActivated, props.selected, props.profileBackgroundId })

	local v4 = math.floor(buttonSize * 0.4)
	local buttonColor = getButtonColor(props.profileBackgroundId, v2) -- inferred equivalent call

	local createElement = React.createElement
	local v5 = {}
	v5.Size = UDim2.new(0, buttonSize, 0, buttonSize)
	v5.BackgroundTransparency = 0
	v5.BackgroundColor3 = buttonColor
	v5.BorderSizePixel = props.selected and 3 or 0
	local borderColor = if props.selected then color else color2
	v5.BorderColor3 = borderColor
	v5.LayoutOrder = props.LayoutOrder
	v5[React.Event.Activated] = v3
	return createElement("ImageButton", v5, {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) }),
		Overlay = props.selected and React.createElement("Frame", {
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = color3,
			BackgroundTransparency = 0.5,
			Size = UDim2.fromScale(0.8, 0.8),
			ZIndex = 2
		}, {
			UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) })
		}) or nil,
		Checkmark = props.selected and React.createElement(Image, {
			tag = "position-center-center anchor-center-center",
			Image = "rbxassetid://6031094667",
			Size = UDim2.fromOffset(v4, v4),
			ZIndex = 3
		}) or nil
	})
end

return ProfileBackgroundButton
