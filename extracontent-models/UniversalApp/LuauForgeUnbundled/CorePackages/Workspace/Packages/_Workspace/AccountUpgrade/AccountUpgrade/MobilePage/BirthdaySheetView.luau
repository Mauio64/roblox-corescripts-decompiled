local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/ReactRoblox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")
local AuthSignup = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthSignup")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/InputHandlers")

local AccountUpgradeDialogActions = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/SuccessModal/AccountUpgradeDialogActions")

local birthdayPicker = AuthSignup.Components.BirthdayPicker
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local view = Foundation.View
local text = Foundation.Text
local iconButton = Foundation.IconButton
local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function BirthdaySheetView(props)
	local v5 = Foundation.Hooks.useTokens()
	local v6 = Foundation.Hooks.useOverlay()
	local large = v5.Radius.Large
	local backdrop = v5.Color.Common.Backdrop
	local slideProgress = props.slideProgress
	local isCentered = props.isCentered
	local onDismiss = props.onDismiss

	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onDismiss()
					object:cancel()
				end)
			}
		}
	end, { onDismiss })

	local v8 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = v7
	})

	local createElement = React.createElement
	local v10 = {
		ref = v8,
		tag = "size-full",
		ZIndex = 200,
		selectionGroup = {
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		},
		testId = "account-upgrade-birthday-sheet"
	}

	local v11 = {
		Backdrop = React.createElement(view, {
			tag = "position-center-center anchor-center-center",
			Size = UDim2.fromScale(2, 2),
			backgroundStyle = slideProgress:map(function(p2)
				return {
					Color3 = backdrop.Color3,
					Transparency = math.lerp(1, backdrop.Transparency, p2)
				}
			end),
			stateLayer = { affordance = stateLayerAffordance.None },
			onActivated = props.onDismiss,
			testId = "account-upgrade-birthday-sheet--backdrop"
		}),
		Panel = 0
	}

	local createElement2 = React.createElement
	local v13 = {
		tag = "col gap-medium size-full-0 auto-y radius-large bg-surface-100",
		AnchorPoint = slideProgress:map(function(p2)
			return Vector2.new(0.5, isCentered and 0.5 or p2)
		end),
		Position = slideProgress:map(function(p2)
			if isCentered then
				return UDim2.fromScale(0.5, 1.5 - p2)
			end

			return UDim2.new(0.5, 0, 1, large * p2)
		end),
		ZIndex = 2,
		padding = 0,
		stateLayer = 0,
		onActivated = 0,
		testId = "account-upgrade-birthday-sheet--panel"
	}

	local v14 = {
		top = UDim.new(0, v5.Padding.Large),
		left = UDim.new(0, v5.Padding.Large),
		right = UDim.new(0, v5.Padding.Large),
		bottom = 0
	}
	local newUDim = UDim.new
	local v16 = if isCentered then v5.Padding.Large else large + v5.Padding.Large
	v14.bottom = newUDim(0, v16)
	v13.padding = v14

	v13.stateLayer = { affordance = stateLayerAffordance.None }

	function v13.onActivated() end

	local v17 = if isCentered then React.createElement("UISizeConstraint", {
		MaxSize = Vector2.new(540, 1e999)
	}) else nil
	local children = {
		SizeConstraint = v17,
		Header = React.createElement(
			view,
			{ tag = "row align-y-center gap-small size-full-0 auto-y", LayoutOrder = 1 },
			{
				Title = React.createElement(text, {
					Text = props.titleText,
					tag = "fill auto-y text-heading-small text-align-x-left content-emphasis",
					LayoutOrder = 1
				}),
				Close = React.createElement(iconButton, {
					icon = iconName.X,
					size = inputSize.Medium,
					onActivated = props.onDismiss,
					LayoutOrder = 2,
					testId = "account-upgrade-birthday-sheet--close"
				})
			}
		),
		Picker = React.createElement(view, {
			tag = "col size-full-0 auto-y",
			LayoutOrder = 2
		}, {
			Wheels = React.createElement(birthdayPicker, {
				layoutOrder = 1,
				minAgeAllowed = props.minAgeAllowed,
				requireManualSelection = props.requireManualSelection,
				updateBirthday = props.updateBirthday,
				initialMonth = props.initialMonth,
				initialDay = props.initialDay,
				initialYear = props.initialYear
			})
		}),
		AgeSummary = 0,
		Actions = 0
	}

	local v18 = if props.ageSummaryText then React.createElement(text, {
		Text = props.ageSummaryText,
		tag = "size-full-0 auto-y text-label-medium text-wrap text-align-x-center content-default",
		LayoutOrder = 3,
		testId = "account-upgrade-birthday-sheet--age-summary"
	}) else nil
	children.AgeSummary = v18

	children.Actions = React.createElement(AccountUpgradeDialogActions, {
		LayoutOrder = 4,
		testId = "account-upgrade-birthday-sheet-actions",
		buttons = {
			{
				text = props.confirmText,
				variant = buttonVariant.Emphasis,
				onActivated = props.onConfirmActivated,
				isDisabled = not props.isConfirmEnabled
			}
		}
	})
	v11.Panel = createElement2(view, v13, children)
	local element = createElement(view, v10, v11)

	if v6 == nil then
		return element
	end

	return ReactRoblox.createPortal(element, v6)
end

return BirthdaySheetView
