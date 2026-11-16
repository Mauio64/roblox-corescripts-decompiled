local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local ChatCardPriority = require(script.Parent.ChatCardEmphasis.ChatCardPriority)
local useChatCardEmphasis = require(script.Parent.ChatCardEmphasis.useChatCardEmphasis)
local FFlagBuildExperienceChatCardEmphasis = require(BuildExperience.Flags.FFlagBuildExperienceChatCardEmphasis)

local Button = Foundation.Button
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local function PushNotificationsUpsellCard(props)
	local v = useLocalization({
		disabledDescription = LocalizationStrings.CHAT_NOTIFICATION_DISABLED_DESCRIPTION,
		dontAskAgain = LocalizationStrings.CHAT_DONT_ASK_AGAIN,
		notifyMe = LocalizationStrings.CHAT_NOTIFY_ME,
		openSettings = LocalizationStrings.CHAT_OPEN_SETTINGS,
		promptDescription = LocalizationStrings.CHAT_NOTIFICATION_PROMPT_DESCRIPTION,
		promptTitle = LocalizationStrings.CHAT_NOTIFICATION_PROMPT_TITLE
	})

	local shouldOpenSettings = props.shouldOpenSettings == true
	local v2

	if FFlagBuildExperienceChatCardEmphasis then
		v2 = useChatCardEmphasis(ChatCardPriority.PushNotificationsUpsell)
	end

	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-medium size-full-0 auto-y padding-large stroke-standard stroke-default radius-large",
		testId = "PushNotificationsUpsellCard"
	}

	local children = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = v.promptTitle,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		}),
		Description = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local text

	if shouldOpenSettings then
		text = v.disabledDescription
	else
		text = v.promptDescription
	end

	children.Description = createElement2(Text, {
		LayoutOrder = 2,
		Text = text,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis"
	})

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local text2

	if shouldOpenSettings then
		text2 = v.openSettings
	else
		text2 = v.notifyMe
	end

	local v4 = {
		LayoutOrder = 1,
		text = text2,
		size = InputSize.Small,
		variant = 0,
		fillBehavior = 0,
		isLoading = 0,
		onActivated = 0,
		testId = 0
	}
	local variant

	if v2 == false then
		variant = ButtonVariant.SoftEmphasis
	else
		variant = ButtonVariant.Emphasis
	end

	v4.variant = variant
	v4.fillBehavior = FillBehavior.Fill
	v4.isLoading = props.isRequestPending == true
	local onActivated

	if shouldOpenSettings then
		onActivated = props.onOpenSettings
	else
		onActivated = props.onNotifyMe
	end

	v4.onActivated = onActivated
	v4.testId = shouldOpenSettings and "PushNotificationsUpsellCard.OpenSettings"
		or "PushNotificationsUpsellCard.NotifyMe"
	children.Actions = createElement3(View, {
		LayoutOrder = 3,
		tag = "row gap-small size-full-0 auto-y"
	}, {
		PrimaryAction = createElement4(Button, v4),
		NotNow = React.createElement(Button, {
			LayoutOrder = 2,
			text = v.dontAskAgain,
			size = InputSize.Small,
			variant = ButtonVariant.Standard,
			fillBehavior = FillBehavior.Fill,
			onActivated = props.onNotNow,
			testId = "PushNotificationsUpsellCard.NotNow"
		})
	})
	return createElement(View, v3, children)
end

return PushNotificationsUpsellCard
