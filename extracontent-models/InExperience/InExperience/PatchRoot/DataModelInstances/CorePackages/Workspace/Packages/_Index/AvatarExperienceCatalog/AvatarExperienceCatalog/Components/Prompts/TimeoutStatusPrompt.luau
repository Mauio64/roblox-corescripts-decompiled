local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2
local Constants = require(AvatarExperienceCatalog.Constants)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AXPartialPageModal = AvatarExperienceCommon.Components.AXPartialPageModal
local getTimeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore
local formatTimeoutEndTime = AvatarExperienceCommon.Utils.formatTimeoutEndTime
local LabelAbuseTypeMapping = AvatarExperienceCommon.Constants.LabelAbuseTypeMapping
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function TimeoutStatusPrompt()
	local v = useNavigation()
	local v2 = useSignalState(getTimeoutStatusStore().getTimeoutDetails)

	React.useEffect(function()
		sendAXCounterV2(Constants.COUNTERS.TimeoutStatusPromptShown, {
			labelTranslationKey = not v2 and "" or v2.labelTranslationKey
		})
	end, {})

	local v3 = React.useCallback(function()
		v.dispatch(RoactNavigation.Actions.back(nil))
	end, { v })

	local v4 = useLocalization({
		titleText = "Feature.Timeout.Prompt.TitleText",
		bodyText = {
			"Feature.Timeout.Prompt.BodyText",
			rule = useLocalization({
				rule = v2 and LabelAbuseTypeMapping and LabelAbuseTypeMapping[v2.labelTranslationKey] or "Feature.NotApproved.Label.AbuseType.Other"
			}).rule,
			time = not v2 and "" or formatTimeoutEndTime(v2.endDate)
		},
		closeText = "Feature.Timeout.Label.OK"
	})

	return React.createElement(AXPartialPageModal, {
		onBackgroundPress = v3,
		buttonStackProps = {
			rowLayout = false,
			buttons = {
				{
					props = {
						onActivated = v3,
						text = v4.closeText,
						variant = ButtonVariant.Standard,
						size = InputSize.Medium
					}
				}
			}
		}
	}, {
		ViewFrame = React.createElement(
			View,
			{ tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top" },
			{
				PromptBodyTitle = React.createElement(Text, {
					tag = "auto-xy padding-bottom-small text-align-x-left text-heading-small text-wrap",
					Text = v4.titleText,
					LayoutOrder = 2
				}),
				PromptBodyText = React.createElement(Text, {
					tag = "auto-xy text-align-x-left text-body-large text-wrap font-family-code",
					Text = v4.bodyText,
					LayoutOrder = 3
				})
			}
		)
	})
end

return TimeoutStatusPrompt
