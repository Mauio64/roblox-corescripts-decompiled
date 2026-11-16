local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local ChatCardPriority = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/ChatCardPriority")
local useChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCardEmphasis/useChatCardEmphasis")
local FFlagBuildExperienceChatCardEmphasis = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatCardEmphasis")

local button = Foundation.Button
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

local function PushNotificationsUpsellCard(props)
	local v5 = useLocalization({
		disabledDescription = LocalizationStrings.CHAT_NOTIFICATION_DISABLED_DESCRIPTION,
		dontAskAgain = LocalizationStrings.CHAT_DONT_ASK_AGAIN,
		notifyMe = LocalizationStrings.CHAT_NOTIFY_ME,
		openSettings = LocalizationStrings.CHAT_OPEN_SETTINGS,
		promptDescription = LocalizationStrings.CHAT_NOTIFICATION_PROMPT_DESCRIPTION,
		promptTitle = LocalizationStrings.CHAT_NOTIFICATION_PROMPT_TITLE
	})

	local shouldOpenSettings = props.shouldOpenSettings == true

	local v6 = if FFlagBuildExperienceChatCardEmphasis then useChatCardEmphasis(ChatCardPriority.PushNotificationsUpsell) else nil

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-medium size-full-0 auto-y padding-large stroke-standard stroke-default radius-large",
		testId = "PushNotificationsUpsellCard"
	}

	local children = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = v5.promptTitle,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		}),
		Description = 0,
		Actions = 0
	}

	local createElement2 = React.createElement

	local v11 = if shouldOpenSettings then v5.disabledDescription else v5.promptDescription
	children.Description = createElement2(text, {
		LayoutOrder = 2,
		Text = v11,
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis"
	})

	local createElement3 = React.createElement

	local createElement4 = React.createElement

	local v16 = if shouldOpenSettings then v5.openSettings else v5.notifyMe
	local v15 = {
		LayoutOrder = 1,
		text = v16,
		size = inputSize.Small,
		variant = 0,
		fillBehavior = 0,
		isLoading = 0,
		onActivated = 0,
		testId = 0
	}
	local v17 = if v6 == false then buttonVariant.SoftEmphasis else buttonVariant.Emphasis
	v15.variant = v17
	v15.fillBehavior = fillBehavior.Fill
	v15.isLoading = props.isRequestPending == true
	local v18 = if shouldOpenSettings then props.onOpenSettings else props.onNotifyMe
	v15.onActivated = v18
	v15.testId = shouldOpenSettings and "PushNotificationsUpsellCard.OpenSettings"
		or "PushNotificationsUpsellCard.NotifyMe"
	children.Actions = createElement3(view, {
		LayoutOrder = 3,
		tag = "row gap-small size-full-0 auto-y"
	}, {
		PrimaryAction = createElement4(button, v15),
		NotNow = React.createElement(button, {
			LayoutOrder = 2,
			text = v5.dontAskAgain,
			size = inputSize.Small,
			variant = buttonVariant.Standard,
			fillBehavior = fillBehavior.Fill,
			onActivated = props.onNotNow,
			testId = "PushNotificationsUpsellCard.NotNow"
		})
	})
	return createElement(view, v8, children)
end

return PushNotificationsUpsellCard
