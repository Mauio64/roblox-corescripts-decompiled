local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)
local ReactIs = require(parent.ReactIs)

local useTokens = require(Foundation.Providers.Style.useTokens)

local Components = Foundation.Components
local Constants = require(Foundation.Constants)
local Icon = require(Components.Icon)
require(Foundation.Components.Types)
local View = require(Components.View)
local blendTransparencies = require(Foundation.Utility.blendTransparencies)
local mapBindable = require(Foundation.Utility.mapBindable)

local useNumberInputVariants = require(Components.NumberInput.useNumberInputVariants)

require(Foundation.Enums.InputSize)

require(Foundation.Enums.IconSize)

require(Foundation.Enums.InputVariant)

require(Foundation.Enums.NumberInputControlsVariant)

local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

local function IncrementButton(props)
	local v = useTokens()

	local cursor = React.useMemo(function()
		return {
			radius = UDim.new(0, props.radius),
			offset = v.Size.Size_150,
			borderWidth = v.Stroke.Thicker
		}
	end, { props.radius, v.Size.Size_150, v.Stroke.Thicker })

	local createElement = React.createElement
	local v2 = {
		onActivated = props.onActivated,
		isDisabled = not ReactIs.isBinding(props.isDisabled) and props.isDisabled,
		selection = {
			Selectable = mapBindable(props.isDisabled, function(p): boolean
				return not p
			end)
		},
		stateLayer = {
			affordance = mapBindable(props.isDisabled, function(p)
				if p then
					return StateLayerAffordance.None
				end

				return StateLayerAffordance.Background
			end)
		},
		cursor = cursor,
		cornerRadius = UDim.new(0, props.radius),
		Size = UDim2.fromOffset(props.size, props.size),
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	}
	local divider

	if props.hasDivider then
		divider = React.createElement(View, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.new(0, v.Stroke.Standard, 1, 0),
			backgroundStyle = v.Color.Stroke.Default,
			testId = `{props.testId}--divider`
		})
	end

	return createElement(View, v2, {
		Divider = divider,
		Icon = React.createElement(Icon, {
			name = props.icon,
			size = props.iconSize,
			style = mapBindable(props.isDisabled, function(p)
				local v3 = { Color3 = v.Color.ActionUtility.Foreground.Color3, Transparency = 0 }
				local transparency

				if p then
					transparency = blendTransparencies(
						v.Color.ActionUtility.Foreground.Transparency,
						Constants.DISABLED_TRANSPARENCY
					)
				else
					transparency = v.Color.ActionUtility.Foreground.Transparency
				end

				v3.Transparency = transparency
				return v3
			end),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			testId = `{props.testId}--icon`
		})
	})
end

local function IncrementControls(props)
	local controls = useNumberInputVariants(useTokens(), props.size).controls

	return React.createElement(
		View,
		{
			tag = controls.tag,
			Size = UDim2.fromOffset(controls.width, controls.buttonSize),
			LayoutOrder = 1,
			testId = `{props.testId}--increment-buttons`
		},
		{
			ControlDecrement = React.createElement(IncrementButton, {
				icon = BuilderIcons.Icon.MinusSmall,
				iconSize = controls.iconSize,
				isDisabled = props.decrement.isDisabled,
				onActivated = props.decrement.onClick,
				radius = controls.radius,
				size = controls.buttonSize,
				LayoutOrder = 1,
				testId = `{props.testId}--decrement`
			}),
			ControlIncrement = React.createElement(IncrementButton, {
				icon = BuilderIcons.Icon.PlusSmall,
				iconSize = controls.iconSize,
				hasDivider = props.hasDivider,
				isDisabled = props.increment.isDisabled,
				onActivated = props.increment.onClick,
				radius = controls.radius,
				size = controls.buttonSize,
				LayoutOrder = 2,
				testId = `{props.testId}--increment`
			})
		}
	)
end

local function NumberInputControls(p)
	return React.createElement(IncrementControls, p)
end

return NumberInputControls
