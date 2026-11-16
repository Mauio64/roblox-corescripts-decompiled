local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local ThemeName = Foundation.Enums.ThemeName
local FoundationImages = require(parent.FoundationImages)
local Images = FoundationImages.Images

local Constants = require(script.Parent.Parent.Constants)

local v = Images["icons/logo/letterform_classic"].ImageRectSize.X / Images["icons/logo/letterform_classic"].ImageRectSize.Y

local function HeaderLogo()
	local v2 = useTokens()
	local v3 = v2.Config.Theme.Name == ThemeName.Classic
	local image2 = v3 and "icons/logo/letterform_classic" or "icons/logo/letterform"
	local v4

	if v3 then
		v4 = Images[image2]
	end

	local size_500 = v2.Size.Size_500
	local vector2

	if v3 then
		vector2 = Vector2.new(30 * v2.Config.UI.Scale * v, 30 * v2.Config.UI.Scale)
	else
		vector2 = Vector2.new(size_500 * Constants.ROBLOX_LOGO_ASPECT_RATIO, size_500)
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local image = Foundation.Image
	local v5 = {
		AnchorPoint = Vector2.zero,
		LayoutOrder = 2,
		tag = "size-full-full",
		Image = 0,
		imageRect = 0,
		imageStyle = 0,
		ScaleType = 0,
		Size = 0
	}

	if v4 then
		image2 = v4.Image
	end

	v5.Image = image2
	v5.imageRect = v4 and { offset = v4.ImageRectOffset, size = v4.ImageRectSize } or nil
	local imageStyle

	if not v3 then
		imageStyle = v2.Color.Content.Emphasis
	end

	v5.imageStyle = imageStyle
	v5.ScaleType = Enum.ScaleType.Fit
	v5.Size = UDim2.fromOffset(vector2.X, vector2.Y)
	return createElement(fragment, nil, { TitleOrRobloxLogoFrame = createElement2(image, v5) })
end

return HeaderLogo
