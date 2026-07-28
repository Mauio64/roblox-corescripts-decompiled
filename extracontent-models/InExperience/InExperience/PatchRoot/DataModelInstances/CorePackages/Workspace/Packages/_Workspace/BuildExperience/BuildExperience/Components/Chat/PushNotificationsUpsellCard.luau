local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local Button = Foundation.Button
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local function PushNotificationsUpsellCard(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), View (copy), FoundationText (copy), LocalizationStrings (copy), Button (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy)
	local v14 = t1.shouldOpenSettings == true

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-large stroke-standard stroke-default radius-large",
		testId = "PushNotificationsUpsellCard",
		LayoutOrder = t1.LayoutOrder
	}, {
		Title = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
			Text = LocalizationStrings.CHAT_NOTIFICATION_PROMPT_TITLE
		}),
		Description = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis",
			Text = if not v14 then LocalizationStrings.CHAT_NOTIFICATION_PROMPT_DESCRIPTION else LocalizationStrings.CHAT_NOTIFICATION_DISABLED_DESCRIPTION
		}),
		Actions = React.createElement(View, {
			LayoutOrder = 3,
			tag = "row gap-small size-full-0 auto-y"
		}, {
			PrimaryAction = React.createElement(Button, {
				LayoutOrder = 1,
				text = if not v14 then LocalizationStrings.CHAT_NOTIFY_ME else LocalizationStrings.CHAT_OPEN_SETTINGS,
				size = InputSize.Small,
				variant = ButtonVariant.Emphasis,
				fillBehavior = FillBehavior.Fill,
				isLoading = t1.isRequestPending == true,
				onActivated = if not v14 then t1.onNotifyMe else t1.onOpenSettings,
				testId = not v14 and "PushNotificationsUpsellCard.NotifyMe" or "PushNotificationsUpsellCard.OpenSettings"
			}),
			NotNow = React.createElement(Button, {
				LayoutOrder = 2,
				testId = "PushNotificationsUpsellCard.NotNow",
				text = LocalizationStrings.CHAT_NOT_NOW,
				size = InputSize.Small,
				variant = ButtonVariant.Standard,
				fillBehavior = FillBehavior.Fill,
				onActivated = t1.onNotNow
			})
		})
	})
end

return PushNotificationsUpsellCard
