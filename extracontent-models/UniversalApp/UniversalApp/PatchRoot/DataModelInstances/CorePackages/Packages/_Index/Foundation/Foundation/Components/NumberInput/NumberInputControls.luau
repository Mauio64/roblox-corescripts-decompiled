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
require(Foundation.Enums.IconSize)
require(Foundation.Enums.InputVariant)

local NumberInputControlsVariant = require(Foundation.Enums.NumberInputControlsVariant)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

local function v21(p1) -- line: 70
	-- upvalues: useTokens (copy), React (copy), View (copy), withCommonProps (copy), ReactIs (copy), mapBindable (copy)
	local v28 = useTokens()
	local uDim = UDim.new(0, v28.Radius.Medium)
	local v30 = React.useMemo(function() -- line: 74
		-- upvalues: uDim (copy), v28 (copy)
		return {
			radius = uDim,
			offset = v28.Size.Size_150,
			borderWidth = v28.Stroke.Thicker
		}
	end, { v28 })

	return React.createElement(View, withCommonProps(p1, {
		onActivated = p1.onActivated,
		isDisabled = not ReactIs.isBinding(p1.isDisabled) and p1.isDisabled,
		selection = {
			Selectable = mapBindable(p1.isDisabled, function(p2) -- line: 88
				return not p2
			end)
		},
		cursor = v30,
		padding = p1.padding,
		cornerRadius = uDim,
		tag = p1.tag
	}), p1.children)
end
local function SplitControls(t1: {[any]: any}) -- line: 102
	-- upvalues: useTokens (copy), useNumberInputVariants (copy), useTextInputVariants (copy), React (copy), getDisabledStyle (copy), mapBindable (copy), blendTransparencies (copy), Constants (copy), View (copy), ReactIs (copy), StateLayerAffordance (copy), Flags (copy), Icon (copy), BuilderIcons (copy)
	local v32 = useTokens()
	local v33 = useNumberInputVariants(v32, t1.size, t1.controlsVariant)
	local container = useTextInputVariants(v32, t1.size, t1.variant).container
	local v35 = math.ceil(v32.Stroke.Standard) * 2
	local uDim2 = UDim2.fromOffset(v33.splitButton.size - v35, v33.splitButton.size - v35)
	local v37 = React.useCallback(function(b1: boolean) -- line: 115
		-- upvalues: container (copy), getDisabledStyle (copy)
		if container.bgStyle then
			return (getDisabledStyle(container.bgStyle, b1))
		end

		return nil
	end, { container.bgStyle })
	local v38 = React.useCallback(function(p3) -- line: 121
		-- upvalues: container (copy), mapBindable (copy), blendTransparencies (copy), Constants (copy)
		if container.strokeStyle and container.strokeThickness then
			return {
				Color = container.strokeStyle.Color3,
				Transparency = mapBindable(p3, function(p4) -- line: 125
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
				affordance = mapBindable(t1.increment.isDisabled, function(p5) -- line: 146
					-- upvalues: StateLayerAffordance (copy)
					if p5 then
						return StateLayerAffordance.None
					end

					return StateLayerAffordance.Background
				end)
			},
			padding = v33.button.padding,
			Size = uDim2,
			backgroundStyle = if not Flags.FoundationTextInputRemoveBackgroundStyle then mapBindable(t1.increment.isDisabled, function(p6) -- line: 154
				-- upvalues: v37 (copy)
				return v37(p6)
			end) else nil,
			stroke = v38(t1.increment.isDisabled),
			tag = v33.splitButton.tag,
			testId = `{ t1.testId }--increment`
		}, {
			Icon = React.createElement(Icon, {
				name = BuilderIcons.Icon.PlusSmall,
				size = t1.size,
				style = mapBindable(t1.increment.isDisabled, function(p7) -- line: 165
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
				affordance = mapBindable(t1.decrement.isDisabled, function(p8) -- line: 182
					-- upvalues: StateLayerAffordance (copy)
					if p8 then
						return StateLayerAffordance.None
					end

					return StateLayerAffordance.Background
				end)
			},
			padding = v33.button.padding,
			Size = uDim2,
			backgroundStyle = if not Flags.FoundationTextInputRemoveBackgroundStyle then mapBindable(t1.decrement.isDisabled, function(p9) -- line: 190
				-- upvalues: v37 (copy)
				return v37(p9)
			end) else nil,
			stroke = v38(t1.decrement.isDisabled),
			tag = v33.splitButton.tag,
			testId = `{ t1.testId }--decrement`
		}, {
			Icon = React.createElement(Icon, {
				name = BuilderIcons.Icon.MinusSmall,
				size = t1.size,
				style = mapBindable(t1.decrement.isDisabled, function(p10) -- line: 201
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
local function StackedControls(t2: {[any]: any}) -- line: 216
	-- upvalues: useTokens (copy), useNumberInputVariants (copy), React (copy), mapBindable (copy), Constants (copy), View (copy), v21 (copy), ReactIs (copy), Image (copy)
	local v40 = useTokens()
	local v41 = useNumberInputVariants(v40, t2.size, t2.controlsVariant)
	local v42 = React.useMemo(function() -- line: 220
		-- upvalues: mapBindable (copy), t2 (copy), v40 (copy), Constants (copy)
		return mapBindable(t2.increment.isDisabled, function(p11) -- line: 221
			-- upvalues: v40 (copy), Constants (copy)
			return {
				Color3 = v40.Color.Stroke.Emphasis.Color3,
				Transparency = not p11 and 0 or Constants.DISABLED_TRANSPARENCY
			}
		end)
	end, {
		v40,
		t2.increment.isDisabled
	})
	local v43 = React.useMemo(function() -- line: 229
		-- upvalues: mapBindable (copy), t2 (copy), v40 (copy), Constants (copy)
		return mapBindable(t2.decrement.isDisabled, function(p12) -- line: 230
			-- upvalues: v40 (copy), Constants (copy)
			return {
				Color3 = v40.Color.Stroke.Emphasis.Color3,
				Transparency = not p12 and 0 or Constants.DISABLED_TRANSPARENCY
			}
		end)
	end, {
		v40,
		t2.decrement.isDisabled
	})

	return React.createElement(View, {
		tag = "col",
		Size = UDim2.new(0, v41.button.width, 1, 0),
		LayoutOrder = t2.LayoutOrder
	}, {
		ControlIncrement = React.createElement(v21, {
			onActivated = t2.increment.onClick,
			isDisabled = not ReactIs.isBinding(t2.increment.isDisabled) and t2.increment.isDisabled,
			padding = v41.button.padding,
			tag = v41.upButton.tag,
			testId = `{ t2.testId }--increment`
		}, {
			Icon = React.createElement(Image, {
				Image = "component_assets/triangleUp_16",
				imageStyle = v42,
				tag = v41.icon.tag,
				testId = `{ t2.testId }--increment-icon`
			})
		}),
		ControlDecrement = React.createElement(v21, {
			tag = v41.downButton.tag,
			onActivated = t2.decrement.onClick,
			isDisabled = not ReactIs.isBinding(t2.decrement.isDisabled) and t2.decrement.isDisabled,
			padding = v41.button.padding,
			testId = `{ t2.testId }--decrement`
		}, {
			Icon = React.createElement(Image, {
				Image = "component_assets/triangleDown_16",
				imageStyle = v43,
				tag = v41.icon.tag,
				testId = `{ t2.testId }--decrement-icon`
			})
		})
	})
end
local function IncrementButton(t3: {[any]: any}) -- line: 278
	-- upvalues: useTokens (copy), React (copy), View (copy), ReactIs (copy), mapBindable (copy), StateLayerAffordance (copy), Icon (copy), blendTransparencies (copy), Constants (copy)
	local v45 = useTokens()
	local v46 = React.useMemo(function() -- line: 291
		-- upvalues: t3 (copy), v45 (copy)
		return {
			radius = UDim.new(0, t3.radius),
			offset = v45.Size.Size_150,
			borderWidth = v45.Stroke.Thicker
		}
	end, {
		t3.radius,
		v45.Size.Size_150,
		v45.Stroke.Thicker
	})

	return React.createElement(View, {
		onActivated = t3.onActivated,
		isDisabled = not ReactIs.isBinding(t3.isDisabled) and t3.isDisabled,
		selection = {
			Selectable = mapBindable(t3.isDisabled, function(p13) -- line: 299
				return not p13
			end)
		},
		stateLayer = {
			affordance = mapBindable(t3.isDisabled, function(p14) -- line: 304
				-- upvalues: StateLayerAffordance (copy)
				if p14 then
					return StateLayerAffordance.None
				end

				return StateLayerAffordance.Background
			end)
		},
		cursor = v46,
		cornerRadius = UDim.new(0, t3.radius),
		Size = UDim2.fromOffset(t3.size, t3.size),
		LayoutOrder = t3.LayoutOrder,
		testId = t3.testId
	}, {
		Divider = if not t3.hasDivider then nil else React.createElement(View, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.new(0, v45.Stroke.Standard, 1, 0),
			backgroundStyle = v45.Color.Stroke.Default,
			testId = `{ t3.testId }--divider`
		}),
		Icon = React.createElement(Icon, {
			name = t3.icon,
			size = t3.iconSize,
			style = mapBindable(t3.isDisabled, function(p15) -- line: 326
				-- upvalues: v45 (copy), blendTransparencies (copy), Constants (copy)
				return {
					Color3 = v45.Color.ActionUtility.Foreground.Color3,
					Transparency = if not p15 then v45.Color.ActionUtility.Foreground.Transparency else blendTransparencies(v45.Color.ActionUtility.Foreground.Transparency, Constants.DISABLED_TRANSPARENCY)
				}
			end),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			testId = `{ t3.testId }--icon`
		})
	})
end
local function IncrementControls(t4: {[any]: any}) -- line: 344
	-- upvalues: useTokens (copy), useNumberInputVariants (copy), React (copy), View (copy), IncrementButton (copy), BuilderIcons (copy)
	local v48 = useTokens()
	local controls = useNumberInputVariants(v48, t4.size, nil).controls

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
local function NumberInputControls(t5: {[any]: any}) -- line: 379
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
