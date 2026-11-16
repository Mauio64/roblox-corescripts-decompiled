local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Components = Foundation.Components
require(Components.BaseMenu)
local View = require(Components.View)

local Constants = require(Foundation.Constants)
local Icon = require(Components.Icon)
local InputField = require(Components.InputField)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local Text = require(Components.Text)
require(Foundation.Components.Types)

local blendTransparencies = require(Foundation.Utility.blendTransparencies)
local getInputTextSize = require(Foundation.Utility.getInputTextSize)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local useDropdownVariants = require(script.Parent.useDropdownVariants)

local ControlState = require(Foundation.Enums.ControlState)

require(Foundation.Enums.CursorType)

require(Foundation.Enums.InputSize)

local InputVariant = require(Foundation.Enums.InputVariant)

local BuilderIcons = require(parent.BuilderIcons)
local ChevronLargeUp = BuilderIcons.Icon.ChevronLargeUp
local ChevronLargeDown = BuilderIcons.Icon.ChevronLargeDown

local v = {
	variant = InputVariant.Standard,
	isMenuOpen = false,
	placeholder = "",
	Selectable = true
}

local function DropdownControl(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local state, setState = React.useState(ControlState.Initialize)
	local v4 = v2.item == nil
	local v5 = useDropdownVariants(
		v3,
		v2.size,
		v2.variant,
		state,
		v4,
		v2.hasError or false,
		v2.isMenuOpen,
		state == ControlState.Hover
	)

	local cursor = React.useMemo(function()
		return {
			radius = UDim.new(0, v3.Radius.Small),
			offset = v3.Size.Size_200,
			borderWidth = v3.Stroke.Thicker
		}
	end, { v3 })

	return React.createElement(InputField, withCommonProps(v2, {
		size = getInputTextSize(v2.size),
		hasError = v2.hasError,
		isDisabled = v2.isDisabled,
		label = v2.label,
		hint = v2.hint,
		ref = ref,
		width = v2.width,
		input = function(_)
			local createElement = React.createElement
			local v6 = {
				onStateChanged = setState,
				isDisabled = v2.isDisabled,
				onActivated = v2.onActivated,
				selection = {
					Selectable = not v2.isDisabled and v2.Selectable,
					NextSelectionUp = v2.NextSelectionUp,
					NextSelectionDown = v2.NextSelectionDown,
					NextSelectionLeft = v2.NextSelectionLeft,
					NextSelectionRight = v2.NextSelectionRight
				},
				cursor = cursor,
				stateLayer = { affordance = StateLayerAffordance.None },
				backgroundStyle = 0,
				stroke = 0,
				tag = 0,
				ref = 0,
				testId = 0
			}
			local backgroundStyle

			if v5.container.bgStyle then
				backgroundStyle = { Color3 = v5.container.bgStyle.Color3, Transparency = 0 }
				local transparency

				if v2.isDisabled then
					transparency = blendTransparencies(
						v5.container.bgStyle.Transparency,
						Constants.DISABLED_TRANSPARENCY
					)
				else
					transparency = v5.container.bgStyle.Transparency
				end

				backgroundStyle.Transparency = transparency
			end

			v6.backgroundStyle = backgroundStyle
			local stroke

			if v5.container.strokeStyle then
				stroke = {
					Color = v5.container.strokeStyle.Color3,
					Transparency = 0,
					Thickness = 0,
					BorderStrokePosition = 0
				}
				local transparency

				if v2.isDisabled then
					transparency = blendTransparencies(
						v5.container.strokeStyle.Transparency,
						Constants.DISABLED_TRANSPARENCY
					)
				else
					transparency = v5.container.strokeStyle.Transparency
				end

				stroke.Transparency = transparency

				stroke.Thickness = v5.container.strokeThickness
				stroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
			end

			v6.stroke = stroke

			v6.tag = v5.container.tag
			v6.ref = v2.inputRef
			v6.testId = `{v2.testId}--control`

			local createElement2 = React.createElement
			local text

			if v2.item then
				text = v2.item.text
			else
				text = v2.placeholder
			end

			local children = {
				Text = createElement2(Text, { LayoutOrder = 1, Text = text, tag = v5.text.tag }),
				Arrow = 0
			}

			local createElement3 = React.createElement
			local name

			if v2.isMenuOpen then
				name = ChevronLargeUp
			else
				name = ChevronLargeDown
			end

			local v7 = {
				LayoutOrder = 2,
				name = name,
				size = v5.arrow.size,
				style = 0,
				tag = 0,
				testId = 0
			}
			local style

			if v2.isDisabled then
				style = v3.Color.Content.Muted
			end

			v7.style = style
			v7.tag = v5.text.tag
			v7.testId = `{v2.testId}--arrow`
			children.Arrow = createElement3(Icon, v7)
			return createElement(View, v6, children)
		end
	}))
end

return React.memo(React.forwardRef(DropdownControl))
