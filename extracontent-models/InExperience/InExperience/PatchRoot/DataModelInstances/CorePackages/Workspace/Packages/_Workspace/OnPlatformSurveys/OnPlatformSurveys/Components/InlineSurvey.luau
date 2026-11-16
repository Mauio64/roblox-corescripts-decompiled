local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local SharedFlags = require(parent.SharedFlags)
local FFlagInlineSurveyEnhancements = SharedFlags.FFlagInlineSurveyEnhancements

local Button = Foundation.Button
local FillBehavior = Foundation.Enums.FillBehavior
local useTokens = Foundation.Hooks.useTokens

local makeDevSurveyRequestImpl = require(OnPlatformSurveys.Dev.makeDevSurveyRequestImpl)
local InlineEventType = require(OnPlatformSurveys.Enums.InlineEventType)
require(OnPlatformSurveys.Enums.InlineSurveyPreset)
local InviteBanner = require(OnPlatformSurveys.Components.InviteBanner)
local InlineSurveyLocalizationKeys = require(OnPlatformSurveys.Constants.InlineSurveyLocalizationKeys)
local Phase = require(OnPlatformSurveys.Enums.Phase)
local InlineSurveyPresets = require(OnPlatformSurveys.Constants.InlineSurveyPresets)
local surveyPhaseSlots = require(OnPlatformSurveys.Components.surveyPhaseSlots)
local Surface = require(OnPlatformSurveys.Enums.Surface)
local SurfaceWrapper = require(OnPlatformSurveys.Components.SurfaceWrapper)
local SurveyCard = require(OnPlatformSurveys.Components.SurveyCard)
local SurveyModal = require(OnPlatformSurveys.Components.SurveyModal)
require(OnPlatformSurveys.Types.InlineSurveyTypes)
local useInlineSurveyFlow = require(OnPlatformSurveys.Hooks.useInlineSurveyFlow)

local function noop() end

local function InlineSurvey(props)
	local v = useRoactService(RoactNetworking)
	local v2 = props.eventType == InlineEventType.DevDoNotPushToProd
	local networkImpl = React.useMemo(function()
		if v2 then
			return (makeDevSurveyRequestImpl.makeRequestImpl())
		end

		return v
	end, { v2, v })

	local v3 = useTokens()
	local v4 = useLocalization({
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
	local v5

	if FFlagInlineSurveyEnhancements then
		v5 = InlineSurveyPresets.getPresentationConfig(props.preset)
	end

	local v6 = useInlineSurveyFlow({
		networkImpl = networkImpl,
		eventType = props.eventType,
		hasInvite = v5 ~= nil and v5.hasInvite,
		onClose = props.onClose,
		onComplete = props.onComplete,
		onEligible = props.onEligible
	})

	local phase = v6.state.phase

	local ref = React.useRef(false)

	local dismiss = v6.dismiss
	local errorType = v6.state.errorType
	React.useEffect(function()
		if phase == Phase.Error and errorType == "fetch" then
			dismiss()
		end
	end, { phase, errorType, dismiss })

	if phase == Phase.Closed then
		if not ref.current then
			return nil
		end

		if FFlagInlineSurveyEnhancements then
			return React.createElement(SurfaceWrapper, {
				surface = Surface.Modal,
				isOpen = false,
				onClose = noop,
				children = nil
			})
		end

		return React.createElement(SurveyModal, { isOpen = false, onClose = noop, children = nil })
	else
		if phase == Phase.Loading or phase == Phase.Error and v6.state.errorType == "fetch" then
			return nil
		end

		local slots = surveyPhaseSlots.getSlots(v6.state, v4, v3, {
			onAnswerChanged = v6.setAnswer,
			onSubmit = v6.submit,
			onRetry = v6.retry,
			onDismiss = v6.dismiss,
			onAccept = v6.acceptInvite
		})
		local footer

		if slots.primaryAction then
			footer = React.createElement(Button, {
				text = slots.primaryAction.text,
				variant = slots.primaryAction.variant,
				fillBehavior = FillBehavior.Fill,
				isLoading = slots.primaryAction.isLoading,
				isDisabled = slots.primaryAction.isDisabled,
				onActivated = slots.primaryAction.onActivated
			}) or nil
		end

		if not (FFlagInlineSurveyEnhancements and v5) then
			ref.current = true
			return React.createElement(SurveyModal, {
				isOpen = true,
				onClose = v6.dismiss,
				title = slots.headerTitle,
				footer = footer,
				children = slots.body
			})
		end

		local v7 = phase == Phase.Invite
		local v8

		if v5.hasInvite and v7 then
			v8 = v5.inviteSurface or v5.surveySurface
		else
			v8 = v5.surveySurface
		end

		local onClose = if v7 then v6.declineInvite else v6.dismiss

		if v8 == Surface.InContent and v7 then
			return React.createElement(SurfaceWrapper, {
				surface = Surface.InContent,
				onClose = onClose,
				children = React.createElement(InviteBanner, { onAccept = v6.acceptInvite })
			})
		end

		if v8 ~= Surface.Modal then
			return React.createElement(SurfaceWrapper, {
				surface = Surface.InContent,
				onClose = onClose,
				children = React.createElement(SurveyCard, { slots = slots, onDismiss = v6.dismiss })
			})
		end

		ref.current = true
		return React.createElement(SurfaceWrapper, {
			surface = Surface.Modal,
			isOpen = true,
			onClose = onClose,
			title = slots.headerTitle,
			footer = footer,
			children = slots.body
		})
	end
end

return React.memo(InlineSurvey)
