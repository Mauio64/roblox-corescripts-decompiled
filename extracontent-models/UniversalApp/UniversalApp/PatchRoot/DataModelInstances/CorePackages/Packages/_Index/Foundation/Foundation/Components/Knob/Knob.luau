local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(parent.BuilderIcons)
local Dash = require(parent.Dash)
local React = require(parent.React)
local ReactIs = require(parent.ReactIs)

local Components = Foundation.Components
local Constants = require(Foundation.Constants)
local Icon = require(Components.Icon)
require(Components.Types)
local View = require(Components.View)

local blendTransparencies = require(Foundation.Utility.blendTransparencies)
local mapBindable = require(Foundation.Utility.mapBindable)
local useBindable = require(Foundation.Utility.useBindable)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local useKnobVariants = require(script.Parent.useKnobVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local usePresentationContext = PresentationContext.usePresentationContext
local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local InputSize = require(Foundation.Enums.InputSize)

local v = {
	size = InputSize.Medium,
	hasShadow = true,
	isDisabled = false,
	testId = "--foundation-knob"
}

local function Knob(p)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local v4 = usePresentationContext()
	local v5 = useKnobVariants(v3, v2.size, v4 and v4.colorNamespace == ColorNamespace.Inverse)

	local backgroundStyle = v2.style or v5.knob.style
	local groupTransparency = mapBindable(backgroundStyle, function(p2)
		return p2.Transparency or 0
	end)
	local v6

	if v2.stroke then
		v6 = v2.stroke.Transparency
	end

	local v7 = useBindable(v6)
	local v8 = useBindable(backgroundStyle)
	local v9 = useBindable(v5.knob.style)

	local size = React.useMemo(function()
		local size = v5.knob.size

		if not (v2.stroke and v2.stroke.Thickness) then
			return size
		end

		if ReactIs.isBinding(v2.stroke.Thickness) then
			return v2.stroke.Thickness:map(function(p2: number)
				return size - UDim2.fromOffset(p2 * 2, p2 * 2)
			end)
		end

		local thickness = v2.stroke.Thickness
		size -= UDim2.fromOffset(thickness * 2, thickness * 2)

		return size
	end, { v5, v2.stroke })

	local createElement = React.createElement

	local v10 = withCommonProps(v2, { Size = v5.knob.size, isDisabled = v2.isDisabled })
	local icon

	if v2.icon then
		local createElement2 = React.createElement

		local v11 = {
			tag = v5.knob.tag,
			Size = size,
			ZIndex = 4,
			backgroundStyle = v5.iconContainer.backgroundStyle
		}

		local createElement3 = React.createElement
		local v12 = {
			name = v2.icon.name,
			variant = v2.icon.variant,
			style = 0,
			size = 0,
			testId = 0
		}
		local style

		if v2.isDisabled then
			style = v9:map(function(p2)
				return {
					Color3 = p2.Color3,
					Transparency = blendTransparencies(p2.Transparency, Constants.DISABLED_TRANSPARENCY)
				}
			end)
		else
			style = v5.knob.style
		end

		v12.style = style

		v12.size = v5.knob.iconSize
		v12.testId = `{v2.testId}--icon`
		icon = createElement2(View, v11, createElement3(Icon, v12))
	else
		local createElement2 = React.createElement
		local v11 = {
			tag = v5.knob.tag,
			backgroundStyle = 0,
			Size = 0,
			stroke = 0,
			ZIndex = 4,
			testId = 0
		}

		if v2.isDisabled then
			backgroundStyle = v8:map(function(p2)
				return {
					Color3 = p2.Color3,
					Transparency = blendTransparencies(p2.Transparency, Constants.DISABLED_TRANSPARENCY)
				}
			end)
		end

		v11.backgroundStyle = backgroundStyle

		v11.Size = size
		v11.stroke = v7:map(function(p2)
			local stroke = v2.stroke

			if v2.stroke and p2 ~= nil and v2.isDisabled then
				stroke = Dash.join(stroke, {
					Transparency = blendTransparencies(p2, Constants.DISABLED_TRANSPARENCY)
				})
			end

			return stroke
		end):getValue()

		v11.testId = `{v2.testId}--circle`
		icon = createElement2(View, v11)
	end

	local shadow

	if v2.hasShadow and not v2.isDisabled then
		shadow = React.createElement(View, {
			tag = "position-center-center anchor-center-center radius-circle shadow-raised-100",
			GroupTransparency = groupTransparency,
			Size = size,
			Visible = mapBindable(groupTransparency, function(p2: number): boolean
				return p2 < 1
			end),
			ZIndex = 3,
			testId = `{v2.testId}--shadow`
		})
	end

	return createElement(View, v10, { Icon = icon, Shadow = shadow })
end

return React.memo(Knob)
