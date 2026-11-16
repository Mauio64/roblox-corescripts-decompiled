local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/React")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/RoactServiceTags").RoactNetworking
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/Localization").Hooks.useLocalization
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/RobloxAppHooks").useRoactService

local fFlagInlineSurveyEnhancements = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/SharedFlags").FFlagInlineSurveyEnhancements

local button = Foundation.Button
local fillBehavior = Foundation.Enums.FillBehavior
local useTokens = Foundation.Hooks.useTokens

local makeDevSurveyRequestImpl = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Dev/makeDevSurveyRequestImpl")
local InlineEventType = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Enums/InlineEventType")
require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Enums/InlineSurveyPreset")
local InviteBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Components/InviteBanner")
local InlineSurveyLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Constants/InlineSurveyLocalizationKeys")
local Phase = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Enums/Phase")
local InlineSurveyPresets = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Constants/InlineSurveyPresets")
local surveyPhaseSlots = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Components/surveyPhaseSlots")
local Surface = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Enums/Surface")
local SurfaceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Components/SurfaceWrapper")
local SurveyCard = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Components/SurveyCard")
local SurveyModal = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Components/SurveyModal")
require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Types/InlineSurveyTypes")
local useInlineSurveyFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Hooks/useInlineSurveyFlow")

local function noop() end

local function InlineSurvey(props)
	local v5 = useRoactService(roactNetworking)
	local v6 = props.eventType == InlineEventType.DevDoNotPushToProd
	local v7 = React.useMemo(function()
		if v6 then
			return (makeDevSurveyRequestImpl.makeRequestImpl())
		end

		return v5
	end, { v6, v5 })

	local v8 = useTokens()
	local v9 = useLocalization({
		surveyTitle = InlineSurveyLocalizationKeys.surveyTitle,
		completedTitle = InlineSurveyLocalizationKeys.completedTitle,
		inviteBody = InlineSurveyLocalizationKeys.inviteBody,
		inviteAccept = InlineSurveyLocalizationKeys.inviteAccept,
		next = InlineSurveyLocalizationKeys.next,
		send = InlineSurveyLocalizationKeys.send,
		done = InlineSurveyLocalizationKeys.done,
		errorText = InlineSurveyLocalizationKeys.errorText,
		retry = InlineSurveyLocalizationKeys.retry
	})

	local v10 = if fFlagInlineSurveyEnhancements then InlineSurveyPresets.getPresentationConfig(props.preset) else nil

	local v14 = useInlineSurveyFlow({
		networkImpl = v7,
		eventType = props.eventType,
		hasInvite = v10 ~= nil and v10.hasInvite,
		onClose = props.onClose,
		onComplete = props.onComplete,
		onEligible = props.onEligible
	})

	local phase = v14.state.phase

	local ref = React.useRef(false)

	local dismiss = v14.dismiss
	local errorType = v14.state.errorType
	React.useEffect(function()
		if phase == Phase.Error and errorType == "fetch" then
			dismiss()
		end
	end, { phase, errorType, dismiss })

	if phase == Phase.Closed then
		if not ref.current then
			return nil
		end

		if fFlagInlineSurveyEnhancements then
			return React.createElement(SurfaceWrapper, {
				surface = Surface.Modal,
				isOpen = false,
				onClose = noop,
				children = nil
			})
		end

		return React.createElement(SurveyModal, {
			isOpen = false,
			onClose = noop,
			children = nil
		})
	else
		if phase == Phase.Loading or phase == Phase.Error and v14.state.errorType == "fetch" then
			return nil
		end

		local slots = surveyPhaseSlots.getSlots(v14.state, v9, v8, {
			onAnswerChanged = v14.setAnswer,
			onSubmit = v14.submit,
			onRetry = v14.retry,
			onDismiss = v14.dismiss,
			onAccept = v14.acceptInvite
		})
		local v15

		if slots.primaryAction then
			v15 = React.createElement(button, {
				text = slots.primaryAction.text,
				variant = slots.primaryAction.variant,
				fillBehavior = fillBehavior.Fill,
				isLoading = slots.primaryAction.isLoading,
				isDisabled = slots.primaryAction.isDisabled,
				onActivated = slots.primaryAction.onActivated
			}) or nil
		end

		if not (fFlagInlineSurveyEnhancements and v10) then
			ref.current = true
			return React.createElement(SurveyModal, {
				isOpen = true,
				onClose = v14.dismiss,
				title = slots.headerTitle,
				footer = v15,
				children = slots.body
			})
		end

		local v16 = phase == Phase.Invite
		local v17

		if v10.hasInvite and v16 then
			v17 = v10.inviteSurface or v10.surveySurface
		else
			v17 = v10.surveySurface
		end

		local v18 = if v16 then v14.declineInvite else v14.dismiss

		if v17 == Surface.InContent and v16 then
			return React.createElement(SurfaceWrapper, {
				surface = Surface.InContent,
				onClose = v18,
				children = React.createElement(InviteBanner, {
					onAccept = v14.acceptInvite
				})
			})
		end

		if v17 ~= Surface.Modal then
			return React.createElement(SurfaceWrapper, {
				surface = Surface.InContent,
				onClose = v18,
				children = React.createElement(SurveyCard, {
					slots = slots,
					onDismiss = v14.dismiss
				})
			})
		end

		ref.current = true
		return React.createElement(SurfaceWrapper, {
			surface = Surface.Modal,
			isOpen = true,
			onClose = v18,
			title = slots.headerTitle,
			footer = v15,
			children = slots.body
		})
	end
end

return React.memo(InlineSurvey)
