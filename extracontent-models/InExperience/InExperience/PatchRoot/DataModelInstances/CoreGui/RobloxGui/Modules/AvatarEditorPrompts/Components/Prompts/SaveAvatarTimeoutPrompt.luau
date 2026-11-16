local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AXPartialPageModal = AvatarExperienceCommon.Components.AXPartialPageModal
local getTimeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore
local formatTimeoutEndTime = AvatarExperienceCommon.Utils.formatTimeoutEndTime
local LabelAbuseTypeMapping = AvatarExperienceCommon.Constants.LabelAbuseTypeMapping
local Foundation = require(CorePackages.Packages.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local parent = script.Parent.Parent.Parent

local CloseOpenPrompt = require(parent.Thunks.CloseOpenPrompt)

local function SaveAvatarTimeoutPrompt()
	local v = useDispatch()
	local v2 = useSignalState(getTimeoutStatusStore().getTimeoutDetails)

	local v3 = React.useCallback(function()
		v(CloseOpenPrompt)
	end, { v })

	local v4 = useLocalization({
		titleText = "Feature.Timeout.Prompt.SaveTitleText",
		bodyText = {
			"Feature.Timeout.Prompt.BodyText",
			rule = useLocalization({
				rule = v2 and LabelAbuseTypeMapping and LabelAbuseTypeMapping[v2.labelTranslationKey] or "Feature.NotApproved.Label.AbuseType.Other"
			}).rule or "",
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

return SaveAvatarTimeoutPrompt
