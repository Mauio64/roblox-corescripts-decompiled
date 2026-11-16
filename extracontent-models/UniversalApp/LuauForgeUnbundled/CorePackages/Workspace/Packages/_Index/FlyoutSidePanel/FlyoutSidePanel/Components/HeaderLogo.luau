local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local useTokens = Foundation.Hooks.useTokens
local themeName = Foundation.Enums.ThemeName
local images = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/FoundationImages").Images

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Constants")

local v5 = images["icons/logo/letterform_classic"].ImageRectSize.X / images["icons/logo/letterform_classic"].ImageRectSize.Y

local function HeaderLogo()
	local v6 = useTokens()
	local v7 = v6.Config.Theme.Name == themeName.Classic
	local v8 = v7 and "icons/logo/letterform_classic" or "icons/logo/letterform"
	local v9 = if v7 then images[v8] else nil
	local size_500 = v6.Size.Size_500
	local vector2

	if v7 then
		vector2 = Vector2.new(30 * v6.Config.UI.Scale * v5, 30 * v6.Config.UI.Scale)
	else
		vector2 = Vector2.new(size_500 * Constants.ROBLOX_LOGO_ASPECT_RATIO, size_500)
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local image = Foundation.Image
	local v12 = {
		AnchorPoint = Vector2.zero,
		LayoutOrder = 2,
		tag = "size-full-full",
		Image = 0,
		imageRect = 0,
		imageStyle = 0,
		ScaleType = 0,
		Size = 0
	}

	if v9 then
		v8 = v9.Image
	end

	v12.Image = v8
	v12.imageRect = v9 and { offset = v9.ImageRectOffset, size = v9.ImageRectSize } or nil

	local v13 = if not v7 then v6.Color.Content.Emphasis else nil
	v12.imageStyle = v13
	v12.ScaleType = Enum.ScaleType.Fit
	v12.Size = UDim2.fromOffset(vector2.X, vector2.Y)
	return createElement(fragment, nil, {
		TitleOrRobloxLogoFrame = createElement2(image, v12)
	})
end

return HeaderLogo
