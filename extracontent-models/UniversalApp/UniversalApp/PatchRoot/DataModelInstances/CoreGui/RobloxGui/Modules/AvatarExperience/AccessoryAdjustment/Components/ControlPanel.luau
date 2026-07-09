local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local useStyle = UIBlox.Core.Style.useStyle
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local AccessoryAdjustmentUtils = require(Modules.AvatarExperience.AccessoryAdjustment.AccessoryAdjustmentUtils)
local SetAccessoryAdjustments = require(Modules.AvatarExperience.AccessoryAdjustment.Actions.SetAccessoryAdjustments)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Button2 = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local View = Foundation.View
local AdjustmentTypeButtons = require(Modules.AvatarExperience.AccessoryAdjustment.Components.AdjustmentTypeButtons)
local AdjustmentSliders = require(Modules.AvatarExperience.AccessoryAdjustment.Components.AdjustmentSliders)
local SendRefinementAnalytics = require(Modules.AvatarExperience.AccessoryAdjustment.Thunks.SendRefinementAnalytics)
local Analytics = require(Modules.AvatarExperience.AccessoryAdjustment.Services.Analytics)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)

require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AdjustmentType)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local FFlagAXMoveResetButtonToControlPanel = require(Modules.AvatarExperience.Flags.FFlagAXMoveResetButtonToControlPanel)
local AXEnableAccessoryAdjustmentDuringTryOnIXP = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments).AXEnableAccessoryAdjustmentDuringTryOnIXP

local function mapTokens(p1) -- line: 73
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return {
		smallIconSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Icon.Size.Small else p1.Size.Size_400,
		buttonSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_400 else p1.Size.Size_800,
		portraitPadding = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_100 else p1.Size.Size_200,
		landscapePadding = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_150 else p1.Size.Size_300,
		sidePadding = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_150 else p1.Size.Size_300,
		cornerRadius = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Radius.Medium else p1.Radius.Medium,
		panelMargin = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_450 else p1.Size.Size_900
	}
end
local function selectAdjustmentTypeSelected(p2) -- line: 89
	return p2.AvatarExperience.AccessoryAdjustment.AdjustmentTypeSelected
end
local function selectSelectedAccessory(p3) -- line: 93
	return p3.AvatarExperience.AccessoryAdjustment.SelectedAccessory
end
local function ControlPanel(t1: {[any]: any}) -- line: 98
	-- upvalues: useStyle (copy), useDesignTokens (copy), mapTokens (copy), useRoactService (copy), Analytics (copy), useSelector (copy), selectIsPortrait (copy), useDispatch (copy), useLocalization (copy), FFlagAXMoveResetButtonToControlPanel (copy), selectAdjustmentTypeSelected (copy), selectSelectedAccessory (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), IxpUtils (copy), useNavigation (copy), React (copy), SendRefinementAnalytics (copy), AccessoryAdjustmentUtils (copy), SetAccessoryAdjustments (copy), Focusable (copy), AdjustmentTypeButtons (copy), AdjustmentSliders (copy), Button (copy), ButtonType (copy), View (copy), Button2 (copy), ButtonVariant (copy), InputSize (copy), FillBehavior (copy)
	local Theme = useStyle().Theme
	local v42 = useDesignTokens(mapTokens)
	local v43 = useRoactService(Analytics)
	local v44 = useSelector(selectIsPortrait)
	local v45 = useDispatch()
	local v46 = useLocalization({
		apply = "CommonUI.Messages.Action.Apply",
		reset = if not FFlagAXMoveResetButtonToControlPanel then nil else "Feature.Avatar.Action.Reset"
	})
	local v47 = useSelector(selectAdjustmentTypeSelected)
	local v48 = useSelector(selectSelectedAccessory)
	local v49 = if not v44 then v42.landscapePadding else v42.portraitPadding
	local v50 = if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXEnableAccessoryAdjustmentDuringTryOnIXP.EnabledForUser)
	local v51 = if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else useNavigation().state.params
	local v52 = nil

	if FFlagAXMoveResetButtonToControlPanel then
		v52 = React.useCallback(function() -- line: 127
			-- upvalues: t1 (copy), v45 (copy), SendRefinementAnalytics (copy), v43 (copy), AccessoryAdjustmentUtils (copy), SetAccessoryAdjustments (copy), v48 (copy), v50 (copy), v51 (copy)
			t1.isApplyingAdjustment.current = true
			v45(SendRefinementAnalytics(v43.avatarRefineAccessoryApply(t1.sliderValues)))

			local v54, v55, v56 = AccessoryAdjustmentUtils.sliderInfoToVector3s(t1.sliderValues)

			v45(SetAccessoryAdjustments(v54, v55, v56, v48))

			if v50 and (v51 and v51.fromRoute) then
				t1.navigation.popToTop()
				t1.navigation.navigate(v51.fromRoute)

				return
			end

			t1.navigation.pop()
		end, {
			t1.sliderValues,
			v48,
			v50,
			v51,
			v45,
			v43,
			t1.navigation,
			t1.isApplyingAdjustment
		})
	end

	local v53 = nil

	if FFlagAXMoveResetButtonToControlPanel then
		v53 = React.useCallback(function() -- line: 156
			-- upvalues: t1 (copy)
			if t1.onResetButtonPressed then
				t1.onResetButtonPressed()
			end
		end, { t1.onResetButtonPressed })
	end

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		ZIndex = 3,
		AnchorPoint = if not v44 then Vector2.new(0, 0.5) else Vector2.new(0, 1),
		Position = if not v44 then UDim2.new(0, v42.panelMargin, 0.5, 0) else UDim2.new(0, 0, 1, 0),
		Size = if not v44 then UDim2.fromScale(0.4, 0) else UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		Content = React.createElement(Focusable.Frame, {
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v49),
				PaddingBottom = UDim.new(0, v49),
				PaddingLeft = UDim.new(0, v42.sidePadding),
				PaddingRight = UDim.new(0, v42.sidePadding)
			}),
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v42.cornerRadius)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, v49),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			AdjustmentTypeButtons = React.createElement(AdjustmentTypeButtons, {
				LayoutOrder = 1,
				adjustmentTypeSelected = v47,
				frameRef = t1.adjustmentTypeFrameRef,
				NextSelectionDown = t1.sliderFrameRef,
				NextSelectionUp = t1.topBarRef,
				NextSelectionLeft = t1.topBarRef,
				NextSelectionRight = if FFlagAXMoveResetButtonToControlPanel then nil else t1.resetRef
			}),
			AdjustmentSliders = React.createElement(AdjustmentSliders, {
				LayoutOrder = 2,
				adjustmentTypeSelected = v47,
				updateCharacterCallback = t1.updateCharacterCallback,
				setSliderValuesCallback = t1.setSliderValuesCallback,
				sliderValues = t1.sliderValues,
				NextSelectionUp = t1.adjustmentTypeFrameRef,
				frameRef = t1.sliderFrameRef,
				NextSelectionDown = t1.applyButtonRef,
				NextSelectionRight = if FFlagAXMoveResetButtonToControlPanel then nil else t1.resetRef
			}),
			ApplyButton = if FFlagAXMoveResetButtonToControlPanel then nil else React.createElement(Button, {
				layoutOrder = 3,
				ref = t1.applyButtonRef,
				NextSelectionUp = t1.sliderFrameRef,
				buttonType = ButtonType.PrimarySystem,
				size = UDim2.new(1, 0, 0, v42.buttonSize),
				text = v46.apply,
				onActivated = function() -- line: 221
					-- upvalues: t1 (copy), v45 (copy), SendRefinementAnalytics (copy), v43 (copy), AccessoryAdjustmentUtils (copy), SetAccessoryAdjustments (copy), v48 (copy), v50 (copy), v51 (copy)
					t1.isApplyingAdjustment.current = true
					v45(SendRefinementAnalytics(v43.avatarRefineAccessoryApply(t1.sliderValues)))

					local v57, v58, v59 = AccessoryAdjustmentUtils.sliderInfoToVector3s(t1.sliderValues)

					v45(SetAccessoryAdjustments(v57, v58, v59, v48))

					if v50 and (v51 and v51.fromRoute) then
						t1.navigation.popToTop()
						t1.navigation.navigate(v51.fromRoute)

						return
					end

					t1.navigation.pop()
				end
			}),
			ButtonRow = if not FFlagAXMoveResetButtonToControlPanel then nil else React.createElement(View, {
				tag = "row gap-medium size-full-0 auto-y",
				LayoutOrder = 3
			}, {
				ApplyButton = React.createElement(Button2, {
					LayoutOrder = 1,
					ref = t1.applyButtonRef,
					text = v46.apply,
					variant = ButtonVariant.Emphasis,
					size = InputSize.Small,
					fillBehavior = FillBehavior.Fill,
					onActivated = v52
				}),
				ResetButton = React.createElement(Button2, {
					LayoutOrder = 2,
					text = v46.reset,
					variant = ButtonVariant.Standard,
					size = InputSize.Small,
					fillBehavior = FillBehavior.Fill,
					onActivated = v53
				})
			})
		}),
		HideBottomCorners = if not v44 then nil else React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = -5,
			Size = UDim2.fromScale(1, 0.3),
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency
		})
	})
end

return (withStackVisibilityWrapper(ControlPanel))
