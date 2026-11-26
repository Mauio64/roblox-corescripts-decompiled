local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module = require("@luauforge/bundled/eie")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module2 = require("@luauforge/bundled/gJS")
local module3 = require("@luauforge/deferred/fCL")
local setAccessoryAdjustments = require("@luauforge/bundled/dKU").Actions.SetAccessoryAdjustments
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local Foundation = require(CorePackages.Packages.Foundation)

local button2 = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize
local view = Foundation.View
local module4 = require("@luauforge/deferred/him")
local module5 = require("@luauforge/deferred/hip")
local module6 = require("@luauforge/deferred/hia")
local module7 = require("@luauforge/deferred/hhZ")

local module8 = require("@luauforge/deferred/gRz")

require("@luauforge/bundled/dWP")
require("@luauforge/bundled/dKT")

local module9 = require("@luauforge/deferred/hiv")

local fFlagAXUseSignalsForAdjustmentTypeSelected = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForAdjustmentTypeSelected
local getAdjustmentTypeSelectedStore

if fFlagAXUseSignalsForAdjustmentTypeSelected then
	getAdjustmentTypeSelectedStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Stores.getAdjustmentTypeSelectedStore
else
	getAdjustmentTypeSelectedStore = nil
end

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local function mapTokens(p2)
	return {
		smallIconSize = p2.Size.Size_400,
		buttonSize = p2.Size.Size_800,
		portraitPadding = p2.Size.Size_200,
		landscapePadding = p2.Size.Size_300,
		sidePadding = p2.Size.Size_300,
		cornerRadius = p2.Radius.Medium,
		panelMargin = p2.Size.Size_900
	}
end

local function selectAdjustmentTypeSelected(p2)
	return p2.AvatarExperience.AccessoryAdjustment.AdjustmentTypeSelected
end

local function selectSelectedAccessory(p2)
	return p2.AvatarExperience.AccessoryAdjustment.SelectedAccessory
end

local function ControlPanel(props)
	local theme = useStyle().Theme
	local v5 = useDesignTokens(mapTokens)
	local v6 = module(module7)
	local v7 = useSelector(module2)
	local v8 = useDispatch()
	local v9 = useLocalization({
		apply = "CommonUI.Messages.Action.Apply",
		reset = module9 and "Feature.Avatar.Action.Reset" or nil
	})
	local v10

	if fFlagAXUseSignalsForAdjustmentTypeSelected then
		v10 = useSignalState(getAdjustmentTypeSelectedStore(false).getAdjustmentTypeSelected)
	else
		v10 = useSelector(selectAdjustmentTypeSelected)
	end

	local v11 = useSelector(selectSelectedAccessory)

	local v12 = if v7 then v5.portraitPadding else v5.landscapePadding
	local v13

	if module9 then
		v13 = React.useCallback(function()
			props.isApplyingAdjustment.current = true
			v8(module6(v6.avatarRefineAccessoryApply(props.sliderValues)))

			local sliderInfoToVector3s, v14, v15 = module3.sliderInfoToVector3s(props.sliderValues)
			v8(setAccessoryAdjustments(sliderInfoToVector3s, v14, v15, v11))

			props.navigation.pop()
		end, {
			props.sliderValues,
			v11,
			v8,
			v6,
			props.navigation,
			props.isApplyingAdjustment
		})
	end

	local v14

	if module9 then
		v14 = React.useCallback(function()
			if props.onResetButtonPressed then
				props.onResetButtonPressed()
			end
		end, { props.onResetButtonPressed })
	end

	local createElement = React.createElement
	local frame = focusable.Frame

	local v16 = if v7 then Vector2.new(0, 1) else Vector2.new(0, 0.5)
	local v17 = if v7 then UDim2.new(0, 0, 1, 0) else UDim2.new(0, v5.panelMargin, 0.5, 0)
	local v18 = if v7 then UDim2.new(1, 0, 0, 0) else UDim2.fromScale(0.4, 0)
	local v15 = {
		BackgroundTransparency = 1,
		AnchorPoint = v16,
		Position = v17,
		Size = v18,
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 3
	}

	local createElement2 = React.createElement
	local frame2 = focusable.Frame
	local v20 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0
	}

	local children = {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v12),
			PaddingBottom = UDim.new(0, v12),
			PaddingLeft = UDim.new(0, v5.sidePadding),
			PaddingRight = UDim.new(0, v5.sidePadding)
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v5.cornerRadius)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v12),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		AdjustmentTypeButtons = 0,
		AdjustmentSliders = 0,
		ApplyButton = 0,
		ButtonRow = 0
	}

	local createElement3 = React.createElement
	local v22 = {
		adjustmentTypeSelected = v10,
		LayoutOrder = 1,
		frameRef = props.adjustmentTypeFrameRef,
		NextSelectionDown = props.sliderFrameRef,
		NextSelectionUp = props.topBarRef,
		NextSelectionLeft = props.topBarRef,
		NextSelectionRight = 0
	}
	local v23 = if not module9 then props.resetRef else nil
	v22.NextSelectionRight = v23
	children.AdjustmentTypeButtons = createElement3(module4, v22)

	local createElement4 = React.createElement
	local v25 = {
		adjustmentTypeSelected = v10,
		LayoutOrder = 2,
		updateCharacterCallback = props.updateCharacterCallback,
		setSliderValuesCallback = props.setSliderValuesCallback,
		sliderValues = props.sliderValues,
		NextSelectionUp = props.adjustmentTypeFrameRef,
		frameRef = props.sliderFrameRef,
		NextSelectionDown = props.applyButtonRef,
		NextSelectionRight = 0
	}
	local v26 = if not module9 then props.resetRef else nil
	v25.NextSelectionRight = v26
	children.AdjustmentSliders = createElement4(module5, v25)
	local v27

	if not module9 then
		v27 = React.createElement(button, {
			ref = props.applyButtonRef,
			NextSelectionUp = props.sliderFrameRef,
			buttonType = buttonType.PrimarySystem,
			size = UDim2.new(1, 0, 0, v5.buttonSize),
			layoutOrder = 3,
			text = v9.apply,
			onActivated = function()
				props.isApplyingAdjustment.current = true
				v8(module6(v6.avatarRefineAccessoryApply(props.sliderValues)))

				local sliderInfoToVector3s, v28, v29 = module3.sliderInfoToVector3s(props.sliderValues)
				v8(setAccessoryAdjustments(sliderInfoToVector3s, v28, v29, v11))

				props.navigation.pop()
			end
		})
	end

	children.ApplyButton = v27

	local v28 = if module9 then React.createElement(
		view,
		{ tag = "row gap-medium size-full-0 auto-y", LayoutOrder = 3 },
		{
			ApplyButton = React.createElement(button2, {
				ref = props.applyButtonRef,
				text = v9.apply,
				variant = buttonVariant.Emphasis,
				size = inputSize.Small,
				fillBehavior = fillBehavior.Fill,
				LayoutOrder = 1,
				onActivated = v13
			}),
			ResetButton = React.createElement(button2, {
				text = v9.reset,
				variant = buttonVariant.Standard,
				size = inputSize.Small,
				fillBehavior = fillBehavior.Fill,
				LayoutOrder = 2,
				onActivated = v14
			})
		}
	) else nil
	children.ButtonRow = v28
	local v19 = {
		Content = createElement2(frame2, v20, children),
		HideBottomCorners = 0
	}

	local v29 = if v7 then React.createElement("Frame", {
		Size = UDim2.fromScale(1, 0.3),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		ZIndex = -5
	}) else nil
	v19.HideBottomCorners = v29
	return createElement(frame, v15, v19)
end

return (module8(ControlPanel))
