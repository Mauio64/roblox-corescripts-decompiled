local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactNavigation")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SignalsReact").useSignalState

local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics").sendAXCounterV2
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Constants")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Navigation").useNavigation

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local axPartialPageModal = AvatarExperienceCommon.Components.AXPartialPageModal
local getTimeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore
local formatTimeoutEndTime = AvatarExperienceCommon.Utils.formatTimeoutEndTime
local labelAbuseTypeMapping = AvatarExperienceCommon.Constants.LabelAbuseTypeMapping
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local view = Foundation.View
local text = Foundation.Text
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local function TimeoutStatusPrompt()
	local v5 = useNavigation()
	local v6 = useSignalState(getTimeoutStatusStore().getTimeoutDetails)

	React.useEffect(function()
		sendAXCounterV2(Constants.COUNTERS.TimeoutStatusPromptShown, {
			labelTranslationKey = not v6 and "" or v6.labelTranslationKey
		})
	end, {})

	local v7 = React.useCallback(function()
		v5.dispatch(RoactNavigation.Actions.back(nil))
	end, { v5 })

	local v10 = useLocalization({
		titleText = "Feature.Timeout.Prompt.TitleText",
		bodyText = {
			"Feature.Timeout.Prompt.BodyText",
			rule = useLocalization({
				rule = v6 and labelAbuseTypeMapping and labelAbuseTypeMapping[v6.labelTranslationKey] or "Feature.NotApproved.Label.AbuseType.Other"
			}).rule,
			time = not v6 and "" or formatTimeoutEndTime(v6.endDate)
		},
		closeText = "Feature.Timeout.Label.OK"
	})

	return React.createElement(axPartialPageModal, {
		onBackgroundPress = v7,
		buttonStackProps = {
			rowLayout = false,
			buttons = {
				{
					props = {
						onActivated = v7,
						text = v10.closeText,
						variant = buttonVariant.Standard,
						size = inputSize.Medium
					}
				}
			}
		}
	}, {
		ViewFrame = React.createElement(
			view,
			{
				tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top"
			},
			{
				PromptBodyTitle = React.createElement(text, {
					tag = "auto-xy padding-bottom-small text-align-x-left text-heading-small text-wrap",
					Text = v10.titleText,
					LayoutOrder = 2
				}),
				PromptBodyText = React.createElement(text, {
					tag = "auto-xy text-align-x-left text-body-large text-wrap font-family-code",
					Text = v10.bodyText,
					LayoutOrder = 3
				})
			}
		)
	})
end

return TimeoutStatusPrompt
