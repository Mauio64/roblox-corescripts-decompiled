local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BuilderIcons = require(FoundationParent.BuilderIcons)
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)
local useTokens = require(Foundation.Providers.Style.useTokens)
local Components = Foundation.Components
local Flags = require(Foundation.Utility.Flags)
local Constants = require(Foundation.Constants)
local Icon = require(Components.Icon)
local Image = require(Components.Image)

require(Foundation.Components.Types)

local View = require(Components.View)
local blendTransparencies = require(Foundation.Utility.blendTransparencies)
local getDisabledStyle = require(Foundation.Utility.getDisabledStyle)
local mapBindable = require(Foundation.Utility.mapBindable)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local useNumberInputVariants = require(Components.NumberInput.useNumberInputVariants)
local useTextInputVariants = require(Components.TextInput.useTextInputVariants)

require(Foundation.Enums.InputSize)
require(Foundation.Enums.InputVariant)

local NumberInputControlsVariant = require(Foundation.Enums.NumberInputControlsVariant)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

local function v21(p1) -- line: 63
	-- upvalues: useTokens (copy), React (copy), View (copy), withCommonProps (copy), ReactIs (copy), mapBindable (copy)
	local v26 = useTokens()
	local uDim = UDim.new(0, v26.Radius.Medium)
	local v28 = React.useMemo(function() -- line: 67
		-- upvalues: uDim (copy), v26 (copy)
		return {
			radius = uDim,
			offset = v26.Size.Size_150,
			borderWidth = v26.Stroke.Thicker
		}
	end, { v26 })

	return React.createElement(View, withCommonProps(p1, {
		onActivated = p1.onActivated,
		isDisabled = not ReactIs.isBinding(p1.isDisabled) and p1.isDisabled,
		selection = {
			Selectable = mapBindable(p1.isDisabled, function(p2) -- line: 81
				return not p2
			end)
		},
		cursor = v28,
		padding = p1.padding,
		cornerRadius = uDim,
		tag = p1.tag
	}), p1.children)
end
local function SplitControls(t1: {[any]: any}) -- line: 94
	-- upvalues: useTokens (copy), useNumberInputVariants (copy), useTextInputVariants (copy), React (copy), getDisabledStyle (copy), mapBindable (copy), blendTransparencies (copy), Constants (copy), View (copy), ReactIs (copy), StateLayerAffordance (copy), Flags (copy), Icon (copy), BuilderIcons (copy)
	local v30 = useTokens()
	local v31 = useNumberInputVariants(v30, t1.size, t1.controlsVariant)
	local container = useTextInputVariants(v30, t1.size, t1.variant).container
	local v33 = math.ceil(v30.Stroke.Standard) * 2
	local uDim2 = UDim2.fromOffset(v31.splitButton.size - v33, v31.splitButton.size - v33)
	local v35 = React.useCallback(function(b1: boolean) -- line: 107
		-- upvalues: container (copy), getDisabledStyle (copy)
		if container.bgStyle then
			return (getDisabledStyle(container.bgStyle, b1))
		end

		return nil
	end, { container.bgStyle })
	local v36 = React.useCallback(function(p3) -- line: 113
		-- upvalues: container (copy), mapBindable (copy), blendTransparencies (copy), Constants (copy)
		if container.strokeStyle and container.strokeThickness then
			return {
				Color = container.strokeStyle.Color3,
				Transparency = mapBindable(p3, function(p4) -- line: 117
					-- upvalues: blendTransparencies (copy), container (copy), Constants (copy)
					if p4 then
						return (blendTransparencies(container.strokeStyle.Transparency, Constants.DISABLED_TRANSPARENCY))
					end

					return container.strokeStyle.Transparency
				end),
				Thickness = container.strokeThickness,
				BorderStrokePosition = Enum.BorderStrokePosition.Inner
			}
		end

		return nil
	end, {
		container.strokeStyle,
		container.strokeThickness
	})

	return React.createElement(React.Fragment, {}, {
		ControlIncrement = React.createElement(View, {
			LayoutOrder = 1,
			onActivated = t1.increment.onClick,
			isDisabled = not ReactIs.isBinding(t1.increment.isDisabled) and t1.increment.isDisabled,
			stateLayer = {
				affordance = mapBindable(t1.increment.isDisabled, function(p5) -- line: 138
					-- upvalues: StateLayerAffordance (copy)
					if p5 then
						return StateLayerAffordance.None
					end

					return StateLayerAffordance.Background
				end)
			},
			padding = v31.button.padding,
			Size = uDim2,
			backgroundStyle = if not Flags.FoundationTextInputRemoveBackgroundStyle then mapBindable(t1.increment.isDisabled, function(p6) -- line: 146
				-- upvalues: v35 (copy)
				return v35(p6)
			end) else nil,
			stroke = v36(t1.increment.isDisabled),
			tag = v31.splitButton.tag,
			testId = `{ t1.testId }--increment`
		}, {
			Icon = React.createElement(Icon, {
				name = BuilderIcons.Icon.PlusSmall,
				size = t1.size,
				style = mapBindable(t1.increment.isDisabled, function(p7) -- line: 157
					-- upvalues: Constants (copy)
					return {
						Color3 = nil,
						Transparency = if not p7 then nil else Constants.DISABLED_TRANSPARENCY
					}
				end),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				testId = `{ t1.testId }--increment-icon`
			})
		}),
		ControlDecrement = React.createElement(View, {
			LayoutOrder = -1,
			onActivated = t1.decrement.onClick,
			isDisabled = not ReactIs.isBinding(t1.decrement.isDisabled) and t1.decrement.isDisabled,
			stateLayer = {
				affordance = mapBindable(t1.decrement.isDisabled, function(p8) -- line: 174
					-- upvalues: StateLayerAffordance (copy)
					if p8 then
						return StateLayerAffordance.None
					end

					return StateLayerAffordance.Background
				end)
			},
			padding = v31.button.padding,
			Size = uDim2,
			backgroundStyle = if not Flags.FoundationTextInputRemoveBackgroundStyle then mapBindable(t1.decrement.isDisabled, function(p9) -- line: 182
				-- upvalues: v35 (copy)
				return v35(p9)
			end) else nil,
			stroke = v36(t1.decrement.isDisabled),
			tag = v31.splitButton.tag,
			testId = `{ t1.testId }--decrement`
		}, {
			Icon = React.createElement(Icon, {
				name = BuilderIcons.Icon.MinusSmall,
				size = t1.size,
				style = mapBindable(t1.decrement.isDisabled, function(p10) -- line: 193
					-- upvalues: Constants (copy)
					return {
						Color3 = nil,
						Transparency = if not p10 then nil else Constants.DISABLED_TRANSPARENCY
					}
				end),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				testId = `{ t1.testId }--decrement-icon`
			})
		})
	})
end
local function StackedControls(t2: {[any]: any}) -- line: 207
	-- upvalues: useTokens (copy), useNumberInputVariants (copy), React (copy), mapBindable (copy), Constants (copy), View (copy), v21 (copy), ReactIs (copy), Image (copy)
	local v38 = useTokens()
	local v39 = useNumberInputVariants(v38, t2.size, t2.controlsVariant)
	local v40 = React.useMemo(function() -- line: 211
		-- upvalues: mapBindable (copy), t2 (copy), v38 (copy), Constants (copy)
		return mapBindable(t2.increment.isDisabled, function(p11) -- line: 212
			-- upvalues: v38 (copy), Constants (copy)
			return {
				Color3 = v38.Color.Stroke.Emphasis.Color3,
				Transparency = not p11 and 0 or Constants.DISABLED_TRANSPARENCY
			}
		end)
	end, {
		v38,
		t2.increment.isDisabled
	})
	local v41 = React.useMemo(function() -- line: 220
		-- upvalues: mapBindable (copy), t2 (copy), v38 (copy), Constants (copy)
		return mapBindable(t2.decrement.isDisabled, function(p12) -- line: 221
			-- upvalues: v38 (copy), Constants (copy)
			return {
				Color3 = v38.Color.Stroke.Emphasis.Color3,
				Transparency = not p12 and 0 or Constants.DISABLED_TRANSPARENCY
			}
		end)
	end, {
		v38,
		t2.decrement.isDisabled
	})

	return React.createElement(View, {
		tag = "col",
		Size = UDim2.new(0, v39.button.width, 1, 0),
		LayoutOrder = t2.LayoutOrder
	}, {
		ControlIncrement = React.createElement(v21, {
			onActivated = t2.increment.onClick,
			isDisabled = not ReactIs.isBinding(t2.increment.isDisabled) and t2.increment.isDisabled,
			padding = v39.button.padding,
			tag = v39.upButton.tag,
			testId = `{ t2.testId }--increment`
		}, {
			Icon = React.createElement(Image, {
				Image = "component_assets/triangleUp_16",
				imageStyle = v40,
				tag = v39.icon.tag,
				testId = `{ t2.testId }--increment-icon`
			})
		}),
		ControlDecrement = React.createElement(v21, {
			tag = v39.downButton.tag,
			onActivated = t2.decrement.onClick,
			isDisabled = not ReactIs.isBinding(t2.decrement.isDisabled) and t2.decrement.isDisabled,
			padding = v39.button.padding,
			testId = `{ t2.testId }--decrement`
		}, {
			Icon = React.createElement(Image, {
				Image = "component_assets/triangleDown_16",
				imageStyle = v41,
				tag = v39.icon.tag,
				testId = `{ t2.testId }--decrement-icon`
			})
		})
	})
end
local function NumberInputControls(t3: {[any]: any}) -- line: 269
	-- upvalues: NumberInputControlsVariant (copy), React (copy), StackedControls (copy), SplitControls (copy)
	if t3.controlsVariant == NumberInputControlsVariant.Stacked then
		return React.createElement(StackedControls, t3)
	end

	return React.createElement(SplitControls, t3)
end

return NumberInputControls
