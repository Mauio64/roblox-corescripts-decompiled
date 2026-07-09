local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local Checkbox = Foundation.Checkbox
local CheckboxSize = Foundation.Enums.CheckboxSize
local React = require(CorePackages.Packages.React)
local useTopBarHeight = require(CorePackages.Workspace.Packages.RobloxAppHooks).useTopBarHeight
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local SceneInteractionFrame = require(Modules.AvatarExperience.Common.Components.Scene.SceneInteractionFrame)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local RefinementNavBar = require(Modules.AvatarExperience.AvatarRefinement.Components.RefinementNavBar)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local RefinementControlBar = require(Modules.AvatarExperience.AvatarRefinement.Components.RefinementControlBar)
local BodyColorsFrame = require(Modules.AvatarExperience.AvatarEditor.Components.BodyColorsFrame)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXFixColorAdjustmentGamepadSupport = require(Modules.AvatarExperience.Flags.FFlagAXFixColorAdjustmentGamepadSupport)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v25 = game:DefineFastFlag("AXRemoveColorAdjustmentPageGamepadBindings", false)

local function selectGlobalGuiInset(p1) -- line: 40
	return p1.GlobalGuiInset
end
local function ColorAdjustmentPage(t1: {[any]: any}) -- line: 52
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagAXFixColorAdjustmentGamepadSupport (copy), RoactGamepad (copy), React (copy), useTokens (copy), useSelector (copy), selectGlobalGuiInset (copy), useLocalization (copy), Responsive (copy), useTopBarHeight (copy), Focusable (copy), v25 (copy), TopBar (copy), GamepadFocusHandlerForPage (copy), GetFFlagAXEnableSlotBasedEditor (copy), RefinementControlBar (copy), RefinementNavBar (copy), SceneInteractionFrame (copy), Checkbox (copy), CheckboxSize (copy), BodyColorsFrame (copy), FoundationText (copy)
	local v30 = if not FFlagAXMigrateAXToGlobalAutofocus then if not FFlagAXFixColorAdjustmentGamepadSupport then nil else RoactGamepad.useRootFocusController() else nil
	local v31 = if not FFlagAXFixColorAdjustmentGamepadSupport then nil else React.useRef(nil)
	local v32 = if not FFlagAXFixColorAdjustmentGamepadSupport then nil else React.useRef(nil)
	local v33 = useTokens()
	local v34 = useSelector(selectGlobalGuiInset)
	local v35 = useLocalization({
		topBarTitle = "Feature.Avatar.ColorAdjustmentPage.Title",
		defaultColorsLabel = "Feature.Avatar.ColorAdjustmentPage.Label.SelectDefaultColors",
		notAvailableForBodyMessage = "Feature.Avatar.ColorAdjustmentPage.AdjustmentNotAvailableForBody"
	})
	local v36 = Responsive.useOrientation()
	local v37 = if not FFlagAXFixColorAdjustmentGamepadSupport then nil else Responsive.usePreferredInput()
	local v38 = if not FFlagAXFixColorAdjustmentGamepadSupport then nil else v37 == Responsive.Input.Directional
	local v39 = v36 ~= Responsive.BreakpointConfig.Enum.Landscape and (not FFlagAXFixColorAdjustmentGamepadSupport or not v38)
	local v40 = if Responsive.useResponsive() ~= "Small" then v33.Padding.XXLarge else v33.Padding.XLarge
	local v41 = useTopBarHeight()

	return React.createElement(not FFlagAXFixColorAdjustmentGamepadSupport and "Frame" or Focusable.Frame, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		focusController = if FFlagAXMigrateAXToGlobalAutofocus or not FFlagAXFixColorAdjustmentGamepadSupport then nil else v30,
		defaultChild = if not FFlagAXFixColorAdjustmentGamepadSupport then nil else v31,
		inputBindings = if not FFlagAXFixColorAdjustmentGamepadSupport or v25 then nil else {
			Back = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, t1.onBackButtonPressed)
		}
	}, {
		TopBar = React.createElement(TopBar.Container, {
			transparentBackground = true,
			ZIndex = 3,
			titleText = v35.topBarTitle,
			leftItem = TopBar.makeBackButton(t1.onBackButtonPressed),
			ref = if not FFlagAXFixColorAdjustmentGamepadSupport then nil else v31,
			NextSelectionDown = if not FFlagAXFixColorAdjustmentGamepadSupport then nil else v32
		}),
		GamepadFocusHandlerForPage = if FFlagAXMigrateAXToGlobalAutofocus or not FFlagAXFixColorAdjustmentGamepadSupport then nil else React.createElement(GamepadFocusHandlerForPage, {
			captureFocusOnMount = true,
			focusController = v30
		}),
		RefinementNavBar = if not v39 then nil else React.createElement(if not GetFFlagAXEnableSlotBasedEditor() then RefinementNavBar else RefinementControlBar, {}),
		Content = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -v41 + v34.bottom),
			Position = UDim2.fromOffset(0, v41)
		}, {
			Layout = if not v39 then nil else React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom
			}),
			SceneInteractionFrame = React.createElement(SceneInteractionFrame),
			ControlPanel = React.createElement("Frame", {
				ZIndex = 3,
				BackgroundColor3 = v33.Color.Surface.Surface_0.Color3,
				BackgroundTransparency = v33.Color.Surface.Surface_0.Transparency,
				AnchorPoint = if not v39 then Vector2.new(0, 0.5) else Vector2.new(0, 1),
				Position = if not v39 then UDim2.new(0, v33.Size.Size_900, 0.5, 0) else UDim2.new(0, 0, 1, 0),
				Size = if not v39 then UDim2.new(0.5, 0, 0, not t1.colorPickerAvailable and 0 or v33.Size.Size_3000 * 3) else UDim2.new(1, 0, not t1.colorPickerAvailable and 0 or 0.5, 0),
				AutomaticSize = if not t1.colorPickerAvailable then Enum.AutomaticSize.Y else nil
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v40),
					PaddingBottom = UDim.new(0, if not v39 then v40 else v40 + v34.bottom),
					PaddingLeft = UDim.new(0, v40),
					PaddingRight = UDim.new(0, v40)
				}),
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v33.Radius.Large)
				}),
				ColorPicker = if not t1.colorPickerAvailable then React.createElement(FoundationText, {
					Text = v35.notAvailableForBodyMessage,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					fontStyle = {
						Font = v33.Typography.LabelSmall.Font,
						FontSize = v33.Typography.LabelSmall.FontSize,
						LineHeight = v33.Typography.LabelSmall.LineHeight
					}
				}) else React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1)
				}, {
					Layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Bottom,
						FillDirection = Enum.FillDirection.Vertical,
						VerticalFlex = Enum.UIFlexAlignment.Fill
					}),
					AboveDivider = if not t1.defaultColorCheckboxAvailable then nil else React.createElement("Frame", {
						BorderSizePixel = 0,
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = v33.Color.Surface.Surface_0.Color3,
						BackgroundTransparency = v33.Color.Surface.Surface_0.Transparency
					}, {
						Padding = React.createElement("UIPadding", {
							PaddingBottom = UDim.new(0, v33.Gap.XLarge + 3)
						}),
						DefaultColorCheckBox = React.createElement(Checkbox, {
							isDisabled = false,
							label = v35.defaultColorsLabel,
							isChecked = t1.defaultColorChecked,
							onActivated = t1.onDefaultColorCheckboxActivated,
							size = CheckboxSize.Medium
						}),
						Divider = React.createElement("Frame", {
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 1),
							Position = UDim2.new(0, 0, 1, v33.Gap.Large),
							BackgroundColor3 = v33.Color.Stroke.Default.Color3,
							BackgroundTransparency = v33.Color.Stroke.Default.Transparency
						})
					}),
					BodyColorPicker = React.createElement(BodyColorsFrame, {
						LayoutOrder = 2,
						Size = UDim2.fromScale(1, 1),
						PaddingRight = UDim.new(),
						PaddingLeft = UDim.new(),
						PaddingTop = UDim.new(0, v33.Gap.Large),
						PaddingBottom = UDim.new(),
						ref = if not FFlagAXFixColorAdjustmentGamepadSupport then nil else v32,
						NextSelectionUp = if not FFlagAXFixColorAdjustmentGamepadSupport then nil else v31
					})
				}),
				BottomFiller = if not v39 then nil else React.createElement("Frame", {
					LayoutOrder = 2,
					ZIndex = -1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, v34.bottom),
					Position = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = v33.Color.Surface.Surface_0.Color3,
					BackgroundTransparency = v33.Color.Surface.Surface_0.Transparency
				})
			})
		})
	})
end

return (withStackVisibilityWrapper(ColorAdjustmentPage))
