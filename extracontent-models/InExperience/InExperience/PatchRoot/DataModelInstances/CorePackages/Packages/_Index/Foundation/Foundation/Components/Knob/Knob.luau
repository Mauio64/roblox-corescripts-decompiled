local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(FoundationParent.BuilderIcons)

local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)
local Components = Foundation.Components
local Constants = require(Foundation.Constants)
local Icon = require(Components.Icon)
local Image = require(Components.Image)

require(Components.Types)

local View = require(Components.View)
local blendTransparencies = require(Foundation.Utility.blendTransparencies)
local useBindable = require(Foundation.Utility.useBindable)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local useKnobVariants = require(script.Parent.useKnobVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local usePresentationContext = require(Foundation.Providers.Style.PresentationContext).usePresentationContext
local ColorMode = require(Foundation.Enums.ColorMode)
local InputSize = require(Foundation.Enums.InputSize)
local Flags = require(Foundation.Utility.Flags)
local t1 = {
	hasShadow = true,
	isDisabled = false,
	testId = "--foundation-knob",
	size = InputSize.Medium
}

local function Knob(p1) -- line: 49
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), usePresentationContext (copy), useKnobVariants (copy), ColorMode (copy), React (copy), useBindable (copy), ReactIs (copy), View (copy), withCommonProps (copy), Flags (copy), Icon (copy), blendTransparencies (copy), Constants (copy), Dash (copy), Image (copy)
	local v24 = withDefaults(p1, t1)
	local v25 = useTokens()
	local v26 = usePresentationContext()
	local v27 = useKnobVariants(v25, v24.size, v26 and v26.colorMode == ColorMode.Inverse)
	local v28 = v24.style or v27.knob.style
	local v29 = React.useCallback(function(p2) -- line: 57
		-- upvalues: v25 (copy)
		return {
			Color3 = v25.Color.Extended.White.White_100.Color3,
			Transparency = p2.Transparency
		}
	end, { v25 })
	local v30 = useBindable(if not v24.stroke then nil else v24.stroke.Transparency)
	local v31 = useBindable(v28)
	local v32 = useBindable(v27.knob.style)
	local v33 = React.useMemo(function() -- line: 68
		-- upvalues: v27 (copy), v24 (copy), ReactIs (copy)
		local size = v27.knob.size

		if v24.stroke and v24.stroke.Thickness then
			if ReactIs.isBinding(v24.stroke.Thickness) then
				return v24.stroke.Thickness:map(function(n1: number) -- line: 72
					-- upvalues: size (ref)
					return size - UDim2.fromOffset(n1 * 2, n1 * 2)
				end)
			end

			local strokeThickness = v24.stroke.Thickness

			size -= UDim2.fromOffset(strokeThickness * 2, strokeThickness * 2)
		end

		return size
	end, {
		v27,
		v24.stroke
	})

	return React.createElement(View, withCommonProps(v24, {
		Size = v27.knob.size,
		isDisabled = if not Flags.FoundationToggleVisualUpdate then nil else v24.isDisabled
	}), {
		Icon = if not Flags.FoundationToggleVisualUpdate or not v24.icon then React.createElement(View, {
			ZIndex = 4,
			tag = v27.knob.tag,
			backgroundStyle = if not v24.isDisabled then v28 else v31:map(function(p3) -- line: 121
				-- upvalues: blendTransparencies (copy), Constants (copy)
				return {
					Color3 = p3.Color3,
					Transparency = blendTransparencies(p3.Transparency, Constants.DISABLED_TRANSPARENCY)
				}
			end),
			Size = v33,
			stroke = v30:map(function(p4) -- line: 130
				-- upvalues: v24 (copy), Dash (copy), blendTransparencies (copy), Constants (copy)
				local stroke = v24.stroke

				if v24.stroke and (p4 ~= nil and v24.isDisabled) then
					stroke = Dash.join(stroke, {
						Transparency = blendTransparencies(p4, Constants.DISABLED_TRANSPARENCY)
					})
				end

				return stroke
			end):getValue(),
			testId = `{ v24.testId }--circle`
		}) else React.createElement(View, {
			ZIndex = 4,
			tag = v27.knob.tag,
			Size = v33,
			backgroundStyle = v27.iconContainer.backgroundStyle
		}, React.createElement(Icon, {
			name = v24.icon.name,
			variant = v24.icon.variant,
			style = if not v24.isDisabled then v27.knob.style else v32:map(function(p5) -- line: 104
				-- upvalues: blendTransparencies (copy), Constants (copy)
				return {
					Color3 = p5.Color3,
					Transparency = blendTransparencies(p5.Transparency, Constants.DISABLED_TRANSPARENCY)
				}
			end),
			size = v27.knob.iconSize,
			testId = `{ v24.testId }--icon`
		})),
		Shadow = if not v24.hasShadow or not not Flags.FoundationToggleVisualUpdate and v24.isDisabled then nil else React.createElement(Image, {
			Image = "component_assets/dropshadow_28",
			ZIndex = 3,
			tag = v27.knobShadow.tag,
			imageStyle = if not ReactIs.isBinding(v28) then v29(v28) else v28:map(v29),
			Size = v27.knobShadow.size,
			testId = `{ v24.testId }--shadow`
		})
	})
end

return React.memo(Knob)
