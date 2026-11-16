local parent = script.Parent.Parent.Parent.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local function TouchControlIcon(props)
	local v = Foundation.Hooks.useTokens()
	local v2

	if props.iconDiameter then
		v2 = props.diameter
	else
		v2 = v.Size.Size_600
	end

	local scale

	if props.diameter ~= v2 then
		scale = props.diameter / v2
	end

	local iconDiameter = props.iconDiameter or v.Size.Size_400
	local alignxcenteralignycenterradiuscircle

	if props.showBackground == false then
		alignxcenteralignycenterradiuscircle = false
	else
		alignxcenteralignycenterradiuscircle = props.assetId == nil
	end

	local style

	if alignxcenteralignycenterradiuscircle and not props.inverted then
		style = v.Color.Surface.Surface_100
	else
		style = v.Color.Content.Emphasis
	end

	local v3

	if props.inverted then
		v3 = v.Color.Surface.Surface_100
	else
		v3 = v.Color.Content.Muted
	end

	local v4 = props.disabled and 0.5 or 1

	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		Size = UDim2.fromOffset(v2, v2),
		scale = scale,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		LayoutOrder = props.LayoutOrder,
		tag = {
			["align-x-center align-y-center radius-circle"] = alignxcenteralignycenterradiuscircle,
			["align-x-center align-y-center"] = not alignxcenteralignycenterradiuscircle
		},
		backgroundStyle = 0,
		testId = 0
	}
	local backgroundStyle

	if alignxcenteralignycenterradiuscircle then
		backgroundStyle = {
			Color3 = v3.Color3,
			Transparency = 1 - (1 - v3.Transparency) * v4
		}
	else
		backgroundStyle = v.Color.None
	end

	v5.backgroundStyle = backgroundStyle

	v5.testId = props.testId .. "Container"
	local icon

	if props.assetId == nil then
		icon = React.createElement(Foundation.Icon, {
			name = props.name,
			variant = Foundation.Enums.IconVariant.Filled,
			size = iconDiameter,
			style = style,
			testId = props.testId
		})
	else
		icon = React.createElement("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = props.assetId,
			ImageTransparency = 1 - v4,
			ScaleType = Enum.ScaleType.Fit,
			[React.Tag] = "data-testid=" .. props.testId
		})
	end

	return createElement(view, v5, { Icon = icon })
end

return React.memo(TouchControlIcon)
