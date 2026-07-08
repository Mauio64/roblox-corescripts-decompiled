local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Components = Foundation.Components

require(Components.BaseMenu)

local View = require(Components.View)
local Constants = require(Foundation.Constants)
local Icon = require(Components.Icon)
local InputField = require(Components.InputField)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local Text = require(Components.Text)

require(Foundation.Components.Types)

local Flags = require(Foundation.Utility.Flags)
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
local BuilderIcons = require(FoundationParent.BuilderIcons)
local ChevronLargeUp = BuilderIcons.Icon.ChevronLargeUp
local ChevronLargeDown = BuilderIcons.Icon.ChevronLargeDown
local t1 = {
	isMenuOpen = false,
	placeholder = "",
	variant = if not Flags.FoundationDropdownVariant then nil else InputVariant.Standard,
	Selectable = not not Flags.FoundationDropdownSelectionProps or nil
}

local function DropdownControl(p1, p2) -- line: 66
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), React (copy), ControlState (copy), Flags (copy), InputVariant (copy), useDropdownVariants (copy), InputField (copy), withCommonProps (copy), getInputTextSize (copy), View (copy), StateLayerAffordance (copy), blendTransparencies (copy), Constants (copy), Text (copy), Icon (copy), ChevronLargeUp (copy), ChevronLargeDown (copy)
	local v27 = withDefaults(p1, t1)
	local v28 = useTokens()
	local v29, v30 = React.useState(ControlState.Initialize)
	local v31 = v27.item == nil

	if Flags.FoundationDropdownVariant and v27.variant == nil then
		v27.variant = InputVariant.Standard
	end

	local v32 = useDropdownVariants(v28, v27.size, if not Flags.FoundationDropdownVariant then nil else v27.variant, v29, v31, v27.hasError or false, if not Flags.FoundationDropdownVariant then nil else v27.isMenuOpen, if not Flags.FoundationDropdownVariant then nil else v29 == ControlState.Hover)
	local v33 = React.useMemo(function() -- line: 86
		-- upvalues: v28 (copy)
		return {
			radius = UDim.new(0, v28.Radius.Small),
			offset = v28.Size.Size_200,
			borderWidth = v28.Stroke.Thicker
		}
	end, { v28 })

	return React.createElement(InputField, withCommonProps(v27, {
		size = getInputTextSize(v27.size),
		hasError = v27.hasError,
		isDisabled = v27.isDisabled,
		label = v27.label,
		hint = v27.hint,
		ref = p2,
		width = v27.width,
		input = function(_) -- line: 104
			-- upvalues: React (copy), View (copy), v30 (copy), v27 (copy), Flags (copy), v33 (copy), StateLayerAffordance (copy), v32 (copy), blendTransparencies (copy), Constants (copy), Text (copy), Icon (copy), ChevronLargeUp (copy), ChevronLargeDown (copy), v28 (copy)
			return React.createElement(View, {
				onStateChanged = v30,
				isDisabled = v27.isDisabled,
				onActivated = v27.onActivated,
				selection = {
					Selectable = if not Flags.FoundationDropdownSelectionProps then not v27.isDisabled else not v27.isDisabled and v27.Selectable,
					NextSelectionUp = if not Flags.FoundationDropdownSelectionProps then nil else v27.NextSelectionUp,
					NextSelectionDown = if not Flags.FoundationDropdownSelectionProps then nil else v27.NextSelectionDown,
					NextSelectionLeft = if not Flags.FoundationDropdownSelectionProps then nil else v27.NextSelectionLeft,
					NextSelectionRight = if not Flags.FoundationDropdownSelectionProps then nil else v27.NextSelectionRight
				},
				cursor = v33,
				stateLayer = {
					affordance = StateLayerAffordance.None
				},
				backgroundStyle = if not Flags.FoundationDropdownVariant or not v32.container.bgStyle then nil else {
					Color3 = v32.container.bgStyle.Color3,
					Transparency = if not v27.isDisabled then v32.container.bgStyle.Transparency else blendTransparencies(v32.container.bgStyle.Transparency, Constants.DISABLED_TRANSPARENCY)
				},
				stroke = if not Flags.FoundationDropdownVariant or not v32.container.strokeStyle then nil else {
					Color = v32.container.strokeStyle.Color3,
					Transparency = if not v27.isDisabled then v32.container.strokeStyle.Transparency else blendTransparencies(v32.container.strokeStyle.Transparency, Constants.DISABLED_TRANSPARENCY),
					Thickness = v32.container.strokeThickness,
					BorderStrokePosition = Enum.BorderStrokePosition.Inner
				},
				tag = v32.container.tag,
				ref = v27.inputRef,
				testId = `{ v27.testId }--control`
			}, {
				Text = React.createElement(Text, {
					LayoutOrder = 1,
					Text = if not v27.item then v27.placeholder else v27.item.text,
					tag = v32.text.tag
				}),
				Arrow = React.createElement(Icon, {
					LayoutOrder = 2,
					name = if not v27.isMenuOpen then ChevronLargeDown else ChevronLargeUp,
					size = v32.arrow.size,
					style = if not v27.isDisabled then nil else v28.Color.Content.Muted,
					tag = v32.text.tag,
					testId = `{ v27.testId }--arrow`
				})
			})
		end
	}))
end

return React.memo(React.forwardRef(DropdownControl))
