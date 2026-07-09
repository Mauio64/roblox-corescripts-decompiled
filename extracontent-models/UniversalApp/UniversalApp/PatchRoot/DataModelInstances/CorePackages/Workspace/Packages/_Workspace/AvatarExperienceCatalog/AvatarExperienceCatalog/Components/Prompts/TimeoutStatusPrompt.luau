local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local RoactNavigation = require(AvatarExperienceCatalogParent.RoactNavigation)
local useSignalState = require(AvatarExperienceCatalogParent.SignalsReact).useSignalState
local FFlagAXTimeoutPromptLabelAbuseTypeFallback = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FFlagAXTimeoutPromptLabelAbuseTypeFallback
local sendAXCounterV2 = require(AvatarExperienceCatalogParent.AvatarExperienceAnalytics).sendAXCounterV2
local Constants = require(AvatarExperienceCatalog.Constants)
local useLocalization = require(AvatarExperienceCatalogParent.Localization).Hooks.useLocalization
local useNavigation = require(AvatarExperienceCatalogParent.Navigation).useNavigation
local AvatarExperienceCommon = require(AvatarExperienceCatalogParent.AvatarExperienceCommon)
local AXPartialPageModal = AvatarExperienceCommon.Components.AXPartialPageModal
local getTimeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore
local formatTimeoutEndTime = AvatarExperienceCommon.Utils.formatTimeoutEndTime
local LabelAbuseTypeMapping = AvatarExperienceCommon.Constants.LabelAbuseTypeMapping
local Foundation = require(AvatarExperienceCatalogParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function TimeoutStatusPrompt() -- line: 34
	-- upvalues: useNavigation (copy), getTimeoutStatusStore (copy), useSignalState (copy), React (copy), sendAXCounterV2 (copy), Constants (copy), RoactNavigation (copy), FFlagAXTimeoutPromptLabelAbuseTypeFallback (copy), LabelAbuseTypeMapping (copy), useLocalization (copy), formatTimeoutEndTime (copy), AXPartialPageModal (copy), ButtonVariant (copy), InputSize (copy), View (copy), FoundationText (copy)
	local v22 = useNavigation()
	local v23 = getTimeoutStatusStore()
	local v24 = useSignalState(v23.getTimeoutDetails)

	React.useEffect(function() -- line: 39
		-- upvalues: sendAXCounterV2 (copy), Constants (copy), v24 (copy)
		sendAXCounterV2(Constants.COUNTERS.TimeoutStatusPromptShown, {
			labelTranslationKey = not v24 and "" or v24.labelTranslationKey
		})
	end, {})

	local v25 = React.useCallback(function() -- line: 45
		-- upvalues: v22 (copy), RoactNavigation (copy)
		v22.dispatch(RoactNavigation.Actions.back(nil))
	end, { v22 })
	local v26 = if not FFlagAXTimeoutPromptLabelAbuseTypeFallback then if not v24 or not LabelAbuseTypeMapping then nil else LabelAbuseTypeMapping[v24.labelTranslationKey] else (not v24 or not LabelAbuseTypeMapping) and "Feature.NotApproved.Label.AbuseType.Other" or (LabelAbuseTypeMapping[v24.labelTranslationKey] or "Feature.NotApproved.Label.AbuseType.Other")
	local v27 = useLocalization({
		rule = v26
	})
	local v28 = useLocalization({
		titleText = "Feature.Timeout.Prompt.TitleText",
		closeText = "Feature.Timeout.Label.OK",
		bodyText = {
			"Feature.Timeout.Prompt.BodyText",
			rule = v27.rule,
			time = not v24 and "" or formatTimeoutEndTime(v24.endDate)
		}
	})

	return React.createElement(AXPartialPageModal, {
		onBackgroundPress = v25,
		buttonStackProps = {
			rowLayout = false,
			buttons = {{
				props = {
					onActivated = v25,
					text = v28.closeText,
					variant = ButtonVariant.Standard,
					size = InputSize.Medium
				}
			}}
		}
	}, {
		ViewFrame = React.createElement(View, {
			tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top"
		}, {
			PromptBodyTitle = React.createElement(FoundationText, {
				tag = "auto-xy padding-bottom-small text-align-x-left text-heading-small text-wrap",
				LayoutOrder = 2,
				Text = v28.titleText
			}),
			PromptBodyText = React.createElement(FoundationText, {
				tag = "auto-xy text-align-x-left text-body-large text-wrap font-family-code",
				LayoutOrder = 3,
				Text = v28.bodyText
			})
		})
	})
end

return TimeoutStatusPrompt
