local CorePackages = game:GetService("CorePackages")
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local checkbox = Foundation.Checkbox
local checkboxSize = Foundation.Enums.CheckboxSize
local React = require(CorePackages.Packages.React)
local useTopBarHeight = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useTopBarHeight
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local module2 = require("@luauforge/bundled/gTf")
local module3 = require("@luauforge/bundled/fvR")
local module4 = require("@luauforge/deferred/hhY")
require("@luauforge/bundled/dKT")
local module5 = require("@luauforge/deferred/hic")
local module6 = require("@luauforge/deferred/haz")

local module7 = require("@luauforge/deferred/gRz")

local module8 = require("@luauforge/bundled/dRs")

local module9 = require("@luauforge/deferred/haN")

local function selectGlobalGuiInset(p2)
	return p2.GlobalGuiInset
end

local function ColorAdjustmentPage(props)
	local ref = if module9 then React.useRef(nil) else nil
	local ref2 = if module9 then React.useRef(nil) else nil
	local v5 = useTokens()
	local v6 = useSelector(selectGlobalGuiInset)
	local v7 = useLocalization({
		topBarTitle = "Feature.Avatar.ColorAdjustmentPage.Title",
		defaultColorsLabel = "Feature.Avatar.ColorAdjustmentPage.Label.SelectDefaultColors",
		notAvailableForBodyMessage = "Feature.Avatar.ColorAdjustmentPage.AdjustmentNotAvailableForBody"
	})

	local v8 = Responsive.useOrientation()
	local v9 = if module9 then Responsive.usePreferredInput() else nil

	local v10 = if module9 then v9 == Responsive.Input.Directional else nil

	local v11 = not (v8 == Responsive.BreakpointConfig.Enum.Landscape) and (not module9 or not v10)

	local v12 = if Responsive.useResponsive() == "Small" then v5.Padding.XLarge else v5.Padding.XXLarge

	local v13 = useTopBarHeight()

	local createElement = React.createElement
	local v14 = not module9 and "Frame" or focusable.Frame
	local v15 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		defaultChild = if module9 then ref else nil
	}

	local children = {
		TopBar = React.createElement(module3.Container, {
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			titleText = v7.topBarTitle,
			transparentBackground = true,
			leftItem = module3.makeBackButton(props.onBackButtonPressed),
			ZIndex = 3,
			ref = if module9 then ref else nil,
			NextSelectionDown = if module9 then ref2 else nil
		}),
		RefinementNavBar = 0,
		Content = 0
	}
	local v20

	if v11 then
		local createElement3 = React.createElement
		local v21 = if module8() then module5 else module4
		v20 = createElement3(v21, {})
	end

	children.RefinementNavBar = v20

	local createElement3 = React.createElement
	local v22 = {
		Size = UDim2.new(1, 0, 1, -v13 + v6.bottom),
		Position = UDim2.fromOffset(0, v13),
		BackgroundTransparency = 1
	}

	local v23 = if v11 then React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Bottom
	}) else nil
	local children2 = {
		Layout = v23,
		SceneInteractionFrame = React.createElement(module2),
		ControlPanel = 0
	}
	local createElement4 = React.createElement
	local v25 = {
		BackgroundColor3 = v5.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v5.Color.Surface.Surface_0.Transparency,
		AnchorPoint = 0,
		Position = 0,
		Size = 0,
		AutomaticSize = 0,
		ZIndex = 3
	}
	local v26 = if v11 then Vector2.new(0, 1) else Vector2.new(0, 0.5)
	v25.AnchorPoint = v26
	local v27 = if v11 then UDim2.new(0, 0, 1, 0) else UDim2.new(0, v5.Size.Size_900, 0.5, 0)
	v25.Position = v27

	local v28 = if v11 then UDim2.new(1, 0, props.colorPickerAvailable and 0.5 or 0, 0) else UDim2.new(
		0.5,
		0,
		0,
		not props.colorPickerAvailable and 0 or v5.Size.Size_3000 * 3
	)
	v25.Size = v28

	local v29 = if not props.colorPickerAvailable then Enum.AutomaticSize.Y else nil
	v25.AutomaticSize = v29

	local createElement5 = React.createElement
	local v31 = {
		PaddingTop = UDim.new(0, v12),
		PaddingBottom = 0,
		PaddingLeft = 0,
		PaddingRight = 0
	}
	local newUDim = UDim.new

	local v33 = if v11 then v12 + v6.bottom else v12
	v31.PaddingBottom = newUDim(0, v33)

	v31.PaddingLeft = UDim.new(0, v12)
	v31.PaddingRight = UDim.new(0, v12)
	local children3 = {
		UIPadding = createElement5("UIPadding", v31),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v5.Radius.Large)
		}),
		ColorPicker = 0,
		BottomFiller = 0
	}
	local v34

	if props.colorPickerAvailable then
		local createElement6 = React.createElement
		local v36 = {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local v37 = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalFlex = Enum.UIFlexAlignment.Fill
			}),
			AboveDivider = 0,
			BodyColorPicker = 0
		}

		local v38 = if props.defaultColorCheckboxAvailable then React.createElement("Frame", {
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			BackgroundColor3 = v5.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v5.Color.Surface.Surface_0.Transparency
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, v5.Gap.XLarge + 3)
			}),
			DefaultColorCheckBox = React.createElement(checkbox, {
				label = v7.defaultColorsLabel,
				isChecked = props.defaultColorChecked,
				isDisabled = false,
				onActivated = props.onDefaultColorCheckboxActivated,
				size = checkboxSize.Medium
			}),
			Divider = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, v5.Gap.Large),
				BackgroundColor3 = v5.Color.Stroke.Default.Color3,
				BackgroundTransparency = v5.Color.Stroke.Default.Transparency,
				BorderSizePixel = 0
			})
		}) else nil
		v37.AboveDivider = v38

		local createElement7 = React.createElement
		local v40 = {
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = 2,
			PaddingRight = UDim.new(),
			PaddingLeft = UDim.new(),
			PaddingTop = UDim.new(0, v5.Gap.Large),
			PaddingBottom = UDim.new(),
			ref = 0,
			NextSelectionUp = 0
		}

		if not module9 then
			ref2 = nil
		end

		v40.ref = ref2

		if not module9 then
			ref = nil
		end

		v40.NextSelectionUp = ref
		v37.BodyColorPicker = createElement7(module6, v40)
		v34 = createElement6("Frame", v36, v37)
	else
		v34 = React.createElement(text, {
			Text = v7.notAvailableForBodyMessage,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			fontStyle = {
				Font = v5.Typography.LabelSmall.Font,
				FontSize = v5.Typography.LabelSmall.FontSize,
				LineHeight = v5.Typography.LabelSmall.LineHeight
			}
		})
	end

	children3.ColorPicker = v34

	local v35 = if v11 then React.createElement("Frame", {
		LayoutOrder = 2,
		ZIndex = -1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, v6.bottom),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = v5.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v5.Color.Surface.Surface_0.Transparency
	}) else nil
	children3.BottomFiller = v35
	children2.ControlPanel = createElement4("Frame", v25, children3)
	children.Content = createElement3("Frame", v22, children2)
	return createElement(v14, v15, children)
end

return (module7(ColorAdjustmentPage))
