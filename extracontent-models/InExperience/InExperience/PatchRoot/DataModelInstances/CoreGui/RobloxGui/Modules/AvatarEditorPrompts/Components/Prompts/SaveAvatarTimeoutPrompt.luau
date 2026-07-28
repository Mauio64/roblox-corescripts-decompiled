local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
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

local function SaveAvatarTimeoutPrompt() -- line: 26
	-- upvalues: useDispatch (copy), getTimeoutStatusStore (copy), useSignalState (copy), React (copy), CloseOpenPrompt (copy), LabelAbuseTypeMapping (copy), useLocalization (copy), formatTimeoutEndTime (copy), AXPartialPageModal (copy), ButtonVariant (copy), InputSize (copy), View (copy), FoundationText (copy)
	local v19 = useDispatch()
	local v20 = getTimeoutStatusStore()
	local v21 = useSignalState(v20.getTimeoutDetails)
	local v22 = React.useCallback(function() -- line: 31
		-- upvalues: v19 (copy), CloseOpenPrompt (copy)
		v19(CloseOpenPrompt)
	end, { v19 })
	local v23 = (not v21 or not LabelAbuseTypeMapping) and "Feature.NotApproved.Label.AbuseType.Other" or (LabelAbuseTypeMapping[v21.labelTranslationKey] or "Feature.NotApproved.Label.AbuseType.Other")
	local v24 = useLocalization({
		rule = v23
	})
	local v25 = useLocalization({
		titleText = "Feature.Timeout.Prompt.SaveTitleText",
		closeText = "Feature.Timeout.Label.OK",
		bodyText = {
			"Feature.Timeout.Prompt.BodyText",
			rule = v24.rule or "",
			time = not v21 and "" or formatTimeoutEndTime(v21.endDate)
		}
	})

	return React.createElement(AXPartialPageModal, {
		onBackgroundPress = v22,
		buttonStackProps = {
			rowLayout = false,
			buttons = {{
				props = {
					onActivated = v22,
					text = v25.closeText,
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
				Text = v25.titleText
			}),
			PromptBodyText = React.createElement(FoundationText, {
				tag = "auto-xy text-align-x-left text-body-large text-wrap font-family-code",
				LayoutOrder = 3,
				Text = v25.bodyText
			})
		})
	})
end

return SaveAvatarTimeoutPrompt
