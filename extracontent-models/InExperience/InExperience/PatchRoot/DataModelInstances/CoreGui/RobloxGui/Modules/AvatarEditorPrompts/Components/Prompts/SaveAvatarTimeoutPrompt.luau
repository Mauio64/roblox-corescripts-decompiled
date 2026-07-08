local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local FFlagAXTimeoutPromptLabelAbuseTypeFallback = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXTimeoutPromptLabelAbuseTypeFallback
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AXPartialPageModal = AvatarExperienceCommon.Components.AXPartialPageModal
local getTimeoutStatusStore = AvatarExperienceCommon.Stores.getTimeoutStatusStore
local formatTimeoutEndTime = AvatarExperienceCommon.Utils.formatTimeoutEndTime
local LabelAbuseTypeMapping = AvatarExperienceCommon.Constants.LabelAbuseTypeMapping
local Foundation = require(CorePackages.Packages.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local ParentParent = script.Parent.Parent.Parent
local CloseOpenPrompt = require(ParentParent.Thunks.CloseOpenPrompt)

local function SaveAvatarTimeoutPrompt() -- line: 29
	-- upvalues: useDispatch (copy), getTimeoutStatusStore (copy), useSignalState (copy), React (copy), CloseOpenPrompt (copy), FFlagAXTimeoutPromptLabelAbuseTypeFallback (copy), LabelAbuseTypeMapping (copy), useLocalization (copy), formatTimeoutEndTime (copy), AXPartialPageModal (copy), ButtonVariant (copy), InputSize (copy), View (copy), FoundationText (copy)
	local v20 = useDispatch()
	local v21 = getTimeoutStatusStore()
	local v22 = useSignalState(v21.getTimeoutDetails)
	local v23 = React.useCallback(function() -- line: 34
		-- upvalues: v20 (copy), CloseOpenPrompt (copy)
		v20(CloseOpenPrompt)
	end, { v20 })
	local v24 = if not FFlagAXTimeoutPromptLabelAbuseTypeFallback then if not v22 then nil else LabelAbuseTypeMapping[v22.labelTranslationKey] else (not v22 or not LabelAbuseTypeMapping) and "Feature.NotApproved.Label.AbuseType.Other" or (LabelAbuseTypeMapping[v22.labelTranslationKey] or "Feature.NotApproved.Label.AbuseType.Other")
	local v25 = useLocalization({
		rule = v24
	})
	local v26 = useLocalization({
		titleText = "Feature.Timeout.Prompt.SaveTitleText",
		closeText = "Feature.Timeout.Label.OK",
		bodyText = {
			"Feature.Timeout.Prompt.BodyText",
			rule = v25.rule or "",
			time = not v22 and "" or formatTimeoutEndTime(v22.endDate)
		}
	})

	return React.createElement(AXPartialPageModal, {
		onBackgroundPress = v23,
		buttonStackProps = {
			rowLayout = false,
			buttons = {{
				props = {
					onActivated = v23,
					text = v26.closeText,
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
				Text = v26.titleText
			}),
			PromptBodyText = React.createElement(FoundationText, {
				tag = "auto-xy text-align-x-left text-body-large text-wrap font-family-code",
				LayoutOrder = 3,
				Text = v26.bodyText
			})
		})
	})
end

return SaveAvatarTimeoutPrompt
