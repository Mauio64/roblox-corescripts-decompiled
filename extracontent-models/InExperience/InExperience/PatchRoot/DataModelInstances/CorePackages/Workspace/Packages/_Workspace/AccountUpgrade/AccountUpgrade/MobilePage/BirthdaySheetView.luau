local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)
local AuthSignup = require(parent.AuthSignup)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)

local AccountUpgradeDialogActions = require(AccountUpgrade.SuccessModal.AccountUpgradeDialogActions)

local BirthdayPicker = AuthSignup.Components.BirthdayPicker
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local View = Foundation.View
local Text = Foundation.Text
local IconButton = Foundation.IconButton
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function BirthdaySheetView(props)
	local v = Foundation.Hooks.useTokens()
	local v2 = Foundation.Hooks.useOverlay()
	local large = v.Radius.Large
	local backdrop = v.Color.Common.Backdrop
	local slideProgress = props.slideProgress
	local isCentered = props.isCentered
	local onDismiss = props.onDismiss

	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onDismiss()
					object:cancel()
				end)
			}
		}
	end, { onDismiss })

	local ref = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers
	})

	local createElement = React.createElement
	local v3 = {
		ref = ref,
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

	local v4 = {
		Backdrop = React.createElement(View, {
			tag = "position-center-center anchor-center-center",
			Size = UDim2.fromScale(2, 2),
			backgroundStyle = slideProgress:map(function(p: number)
				return {
					Color3 = backdrop.Color3,
					Transparency = math.lerp(1, backdrop.Transparency, p)
				}
			end),
			stateLayer = { affordance = StateLayerAffordance.None },
			onActivated = props.onDismiss,
			testId = "account-upgrade-birthday-sheet--backdrop"
		}),
		Panel = 0
	}

	local createElement2 = React.createElement
	local v5 = {
		tag = "col gap-medium size-full-0 auto-y radius-large bg-surface-100",
		AnchorPoint = slideProgress:map(function(p: number)
			return Vector2.new(0.5, isCentered and 0.5 or p)
		end),
		Position = slideProgress:map(function(p: number)
			if isCentered then
				return UDim2.fromScale(0.5, 1.5 - p)
			end

			return UDim2.new(0.5, 0, 1, large * p)
		end),
		ZIndex = 2,
		padding = 0,
		stateLayer = 0,
		onActivated = 0,
		testId = "account-upgrade-birthday-sheet--panel"
	}

	local padding = {
		top = UDim.new(0, v.Padding.Large),
		left = UDim.new(0, v.Padding.Large),
		right = UDim.new(0, v.Padding.Large),
		bottom = 0
	}
	local v6

	if isCentered then
		v6 = v.Padding.Large
	else
		v6 = large + v.Padding.Large
	end

	padding.bottom = UDim.new(0, v6)
	v5.padding = padding

	v5.stateLayer = { affordance = StateLayerAffordance.None }

	function v5.onActivated() end

	local sizeConstraint

	if isCentered then
		sizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(540, 1e999)
		})
	end

	local children = {
		SizeConstraint = sizeConstraint,
		Header = React.createElement(
			View,
			{ tag = "row align-y-center gap-small size-full-0 auto-y", LayoutOrder = 1 },
			{
				Title = React.createElement(Text, {
					Text = props.titleText,
					tag = "fill auto-y text-heading-small text-align-x-left content-emphasis",
					LayoutOrder = 1
				}),
				Close = React.createElement(IconButton, {
					icon = IconName.X,
					size = InputSize.Medium,
					onActivated = props.onDismiss,
					LayoutOrder = 2,
					testId = "account-upgrade-birthday-sheet--close"
				})
			}
		),
		Picker = React.createElement(View, { tag = "col size-full-0 auto-y", LayoutOrder = 2 }, {
			Wheels = React.createElement(BirthdayPicker, {
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
	local ageSummary

	if props.ageSummaryText then
		ageSummary = React.createElement(Text, {
			Text = props.ageSummaryText,
			tag = "size-full-0 auto-y text-label-medium text-wrap text-align-x-center content-default",
			LayoutOrder = 3,
			testId = "account-upgrade-birthday-sheet--age-summary"
		})
	end

	children.AgeSummary = ageSummary

	children.Actions = React.createElement(AccountUpgradeDialogActions, {
		LayoutOrder = 4,
		testId = "account-upgrade-birthday-sheet-actions",
		buttons = {
			{
				text = props.confirmText,
				variant = ButtonVariant.Emphasis,
				onActivated = props.onConfirmActivated,
				isDisabled = not props.isConfirmEnabled
			}
		}
	})
	v4.Panel = createElement2(View, v5, children)
	local element = createElement(View, v3, v4)

	if v2 == nil then
		return element
	end

	return ReactRoblox.createPortal(element, v2)
end

return BirthdaySheetView
