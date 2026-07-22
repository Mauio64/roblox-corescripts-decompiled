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
local mapBindable = require(Foundation.Utility.mapBindable)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local useNumberInputVariants = require(Components.NumberInput.useNumberInputVariants)
local useTextInputVariants = require(Components.TextInput.useTextInputVariants)

require(Foundation.Enums.InputSize)
require(Foundation.Enums.IconSize)
require(Foundation.Enums.InputVariant)

local NumberInputControlsVariant = require(Foundation.Enums.NumberInputControlsVariant)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

local function v20(p1) -- line: 69
	-- upvalues: useTokens (copy), React (copy), View (copy), withCommonProps (copy), ReactIs (copy), mapBindable (copy)
	local v27 = useTokens()
	local uDim = UDim.new(0, v27.Radius.Medium)
	local v29 = React.useMemo(function() -- line: 73
		-- upvalues: uDim (copy), v27 (copy)
		return {
			radius = uDim,
			offset = v27.Size.Size_150,
			borderWidth = v27.Stroke.Thicker
		}
	end, { v27 })

	return React.createElement(View, withCommonProps(p1, {
		onActivated = p1.onActivated,
		isDisabled = not ReactIs.isBinding(p1.isDisabled) and p1.isDisabled,
		selection = {
			Selectable = mapBindable(p1.isDisabled, function(p2) -- line: 87
				return not p2
			end)
		},
		cursor = v29,
		padding = p1.padding,
		cornerRadius = uDim,
		tag = p1.tag
	}), p1.children)
end
local function SplitControls(t1: {[any]: any}) -- line: 101
	-- upvalues: useTokens (copy), useNumberInputVariants (copy), useTextInputVariants (copy), React (copy), mapBindable (copy), blendTransparencies (copy), Constants (copy), View (copy), ReactIs (copy), StateLayerAffordance (copy), Icon (copy), BuilderIcons (copy)
	local v31 = useTokens()
	local v32 = useNumberInputVariants(v31, t1.size, t1.controlsVariant)
	local container = useTextInputVariants(v31, t1.size, t1.variant).container
	local v34 = math.ceil(v31.Stroke.Standard) * 2
	local uDim2 = UDim2.fromOffset(v32.splitButton.size - v34, v32.splitButton.size - v34)
	local v36 = React.useCallback(function(p3) -- line: 114
		-- upvalues: container (copy), mapBindable (copy), blendTransparencies (copy), Constants (copy)
		if container.strokeStyle and container.strokeThickness then
			return {
				Color = container.strokeStyle.Color3,
				Transparency = mapBindable(p3, function(p4) -- line: 118
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
				affordance = mapBindable(t1.increment.isDisabled, function(p5) -- line: 139
					-- upvalues: StateLayerAffordance (copy)
					if p5 then
						return StateLayerAffordance.None
					end

					return StateLayerAffordance.Background
				end)
			},
			padding = v32.button.padding,
			Size = uDim2,
			stroke = v36(t1.increment.isDisabled),
			tag = v32.splitButton.tag,
			testId = `{ t1.testId }--increment`
		}, {
			Icon = React.createElement(Icon, {
				name = BuilderIcons.Icon.PlusSmall,
				size = t1.size,
				style = mapBindable(t1.increment.isDisabled, function(p6) -- line: 153
					-- upvalues: Constants (copy)
					return {
						Color3 = nil,
						Transparency = if not p6 then nil else Constants.DISABLED_TRANSPARENCY
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
				affordance = mapBindable(t1.decrement.isDisabled, function(p7) -- line: 170
					-- upvalues: StateLayerAffordance (copy)
					if p7 then
						return StateLayerAffordance.None
					end

					return StateLayerAffordance.Background
				end)
			},
			padding = v32.button.padding,
			Size = uDim2,
			stroke = v36(t1.decrement.isDisabled),
			tag = v32.splitButton.tag,
			testId = `{ t1.testId }--decrement`
		}, {
			Icon = React.createElement(Icon, {
				name = BuilderIcons.Icon.MinusSmall,
				size = t1.size,
				style = mapBindable(t1.decrement.isDisabled, function(p8) -- line: 184
					-- upvalues: Constants (copy)
					return {
						Color3 = nil,
						Transparency = if not p8 then nil else Constants.DISABLED_TRANSPARENCY
					}
				end),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				testId = `{ t1.testId }--decrement-icon`
			})
		})
	})
end
local function StackedControls(t2: {[any]: any}) -- line: 199
	-- upvalues: useTokens (copy), useNumberInputVariants (copy), React (copy), mapBindable (copy), Constants (copy), View (copy), v20 (copy), ReactIs (copy), Image (copy)
	local v38 = useTokens()
	local v39 = useNumberInputVariants(v38, t2.size, t2.controlsVariant)
	local v40 = React.useMemo(function() -- line: 203
		-- upvalues: mapBindable (copy), t2 (copy), v38 (copy), Constants (copy)
		return mapBindable(t2.increment.isDisabled, function(p9) -- line: 204
			-- upvalues: v38 (copy), Constants (copy)
			return {
				Color3 = v38.Color.Stroke.Emphasis.Color3,
				Transparency = not p9 and 0 or Constants.DISABLED_TRANSPARENCY
			}
		end)
	end, {
		v38,
		t2.increment.isDisabled
	})
	local v41 = React.useMemo(function() -- line: 212
		-- upvalues: mapBindable (copy), t2 (copy), v38 (copy), Constants (copy)
		return mapBindable(t2.decrement.isDisabled, function(p10) -- line: 213
			-- upvalues: v38 (copy), Constants (copy)
			return {
				Color3 = v38.Color.Stroke.Emphasis.Color3,
				Transparency = not p10 and 0 or Constants.DISABLED_TRANSPARENCY
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
		ControlIncrement = React.createElement(v20, {
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
		ControlDecrement = React.createElement(v20, {
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
local function IncrementButton(t3: {[any]: any}) -- line: 261
	-- upvalues: useTokens (copy), React (copy), View (copy), ReactIs (copy), mapBindable (copy), StateLayerAffordance (copy), Icon (copy), blendTransparencies (copy), Constants (copy)
	local v43 = useTokens()
	local v44 = React.useMemo(function() -- line: 274
		-- upvalues: t3 (copy), v43 (copy)
		return {
			radius = UDim.new(0, t3.radius),
			offset = v43.Size.Size_150,
			borderWidth = v43.Stroke.Thicker
		}
	end, {
		t3.radius,
		v43.Size.Size_150,
		v43.Stroke.Thicker
	})

	return React.createElement(View, {
		onActivated = t3.onActivated,
		isDisabled = not ReactIs.isBinding(t3.isDisabled) and t3.isDisabled,
		selection = {
			Selectable = mapBindable(t3.isDisabled, function(p11) -- line: 282
				return not p11
			end)
		},
		stateLayer = {
			affordance = mapBindable(t3.isDisabled, function(p12) -- line: 287
				-- upvalues: StateLayerAffordance (copy)
				if p12 then
					return StateLayerAffordance.None
				end

				return StateLayerAffordance.Background
			end)
		},
		cursor = v44,
		cornerRadius = UDim.new(0, t3.radius),
		Size = UDim2.fromOffset(t3.size, t3.size),
		LayoutOrder = t3.LayoutOrder,
		testId = t3.testId
	}, {
		Divider = if not t3.hasDivider then nil else React.createElement(View, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.new(0, v43.Stroke.Standard, 1, 0),
			backgroundStyle = v43.Color.Stroke.Default,
			testId = `{ t3.testId }--divider`
		}),
		Icon = React.createElement(Icon, {
			name = t3.icon,
			size = t3.iconSize,
			style = mapBindable(t3.isDisabled, function(p13) -- line: 309
				-- upvalues: v43 (copy), blendTransparencies (copy), Constants (copy)
				return {
					Color3 = v43.Color.ActionUtility.Foreground.Color3,
					Transparency = if not p13 then v43.Color.ActionUtility.Foreground.Transparency else blendTransparencies(v43.Color.ActionUtility.Foreground.Transparency, Constants.DISABLED_TRANSPARENCY)
				}
			end),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			testId = `{ t3.testId }--icon`
		})
	})
end
local function IncrementControls(t4: {[any]: any}) -- line: 327
	-- upvalues: useTokens (copy), useNumberInputVariants (copy), React (copy), View (copy), IncrementButton (copy), BuilderIcons (copy)
	local v46 = useTokens()
	local controls = useNumberInputVariants(v46, t4.size, nil).controls

	return React.createElement(View, {
		LayoutOrder = 1,
		tag = controls.tag,
		Size = UDim2.fromOffset(controls.width, controls.buttonSize),
		testId = `{ t4.testId }--increment-buttons`
	}, {
		ControlDecrement = React.createElement(IncrementButton, {
			LayoutOrder = 1,
			icon = BuilderIcons.Icon.MinusSmall,
			iconSize = controls.iconSize,
			isDisabled = t4.decrement.isDisabled,
			onActivated = t4.decrement.onClick,
			radius = controls.radius,
			size = controls.buttonSize,
			testId = `{ t4.testId }--decrement`
		}),
		ControlIncrement = React.createElement(IncrementButton, {
			LayoutOrder = 2,
			icon = BuilderIcons.Icon.PlusSmall,
			iconSize = controls.iconSize,
			hasDivider = t4.hasDivider,
			isDisabled = t4.increment.isDisabled,
			onActivated = t4.increment.onClick,
			radius = controls.radius,
			size = controls.buttonSize,
			testId = `{ t4.testId }--increment`
		})
	})
end
local function NumberInputControls(t5: {[any]: any}) -- line: 362
	-- upvalues: Flags (copy), React (copy), IncrementControls (copy), NumberInputControlsVariant (copy), StackedControls (copy), SplitControls (copy)
	if Flags.FoundationNumberInputBeta then
		return React.createElement(IncrementControls, t5)
	end

	if t5.controlsVariant == NumberInputControlsVariant.Stacked then
		return React.createElement(StackedControls, t5)
	end

	return React.createElement(SplitControls, t5)
end

return NumberInputControls
