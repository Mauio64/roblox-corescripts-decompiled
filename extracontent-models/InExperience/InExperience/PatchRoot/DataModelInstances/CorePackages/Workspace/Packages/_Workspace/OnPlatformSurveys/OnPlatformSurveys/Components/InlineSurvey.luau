local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local Foundation = require(OnPlatformSurveysParent.Foundation)
local React = require(OnPlatformSurveysParent.React)
local RoactNetworking = require(OnPlatformSurveysParent.RoactServiceTags).RoactNetworking
local useLocalization = require(OnPlatformSurveysParent.Localization).Hooks.useLocalization
local useRoactService = require(OnPlatformSurveysParent.RobloxAppHooks).useRoactService
local FFlagInlineSurveyEnhancements = require(OnPlatformSurveysParent.SharedFlags).FFlagInlineSurveyEnhancements
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

local function noop() -- line: 48
end
local function InlineSurvey(t1: {[any]: any}) -- line: 50
	-- upvalues: useRoactService (copy), RoactNetworking (copy), InlineEventType (copy), React (copy), makeDevSurveyRequestImpl (copy), useTokens (copy), useLocalization (copy), InlineSurveyLocalizationKeys (copy), FFlagInlineSurveyEnhancements (copy), InlineSurveyPresets (copy), useInlineSurveyFlow (copy), Phase (copy), SurfaceWrapper (copy), Surface (copy), noop (copy), SurveyModal (copy), surveyPhaseSlots (copy), Button (copy), FillBehavior (copy), InviteBanner (copy), SurveyCard (copy)
	local v27 = useRoactService(RoactNetworking)
	local v28 = t1.eventType == InlineEventType.DevDoNotPushToProd
	local v29 = React.useMemo(function() -- line: 53
		-- upvalues: v28 (copy), makeDevSurveyRequestImpl (copy), v27 (copy)
		if v28 then
			return (makeDevSurveyRequestImpl.makeRequestImpl())
		end

		return v27
	end, {
		v28,
		v27
	})
	local v30 = useTokens()
	local v31 = useLocalization({
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
	local v32 = if not FFlagInlineSurveyEnhancements then nil else InlineSurveyPresets.getPresentationConfig(t1.preset)
	local v33 = useInlineSurveyFlow({
		networkImpl = v29,
		eventType = t1.eventType,
		hasInvite = v32 ~= nil and v32.hasInvite,
		onClose = t1.onClose,
		onComplete = t1.onComplete,
		onEligible = t1.onEligible
	})
	local phase = v33.state.phase
	local v35 = React.useRef(false)
	local dismiss = v33.dismiss
	local errorType = v33.state.errorType

	React.useEffect(function() -- line: 88
		-- upvalues: phase (copy), Phase (copy), errorType (copy), dismiss (copy)
		if phase == Phase.Error and errorType == "fetch" then
			dismiss()
		end
	end, {
		phase,
		errorType,
		dismiss
	})

	if phase == Phase.Closed then
		if v35.current then
			if FFlagInlineSurveyEnhancements then
				return React.createElement(SurfaceWrapper, {
					isOpen = false,
					children = nil,
					surface = Surface.Modal,
					onClose = noop
				})
			end

			return React.createElement(SurveyModal, {
				isOpen = false,
				children = nil,
				onClose = noop
			})
		end

		return nil
	end

	if phase == Phase.Loading or phase == Phase.Error and v33.state.errorType == "fetch" then
		return nil
	end

	local v38 = surveyPhaseSlots.getSlots(v33.state, v31, v30, {
		onAnswerChanged = v33.setAnswer,
		onSubmit = v33.submit,
		onRetry = v33.retry,
		onDismiss = v33.dismiss,
		onAccept = v33.acceptInvite
	})
	local v39 = v38.primaryAction and React.createElement(Button, {
		text = v38.primaryAction.text,
		variant = v38.primaryAction.variant,
		fillBehavior = FillBehavior.Fill,
		isLoading = v38.primaryAction.isLoading,
		isDisabled = v38.primaryAction.isDisabled,
		onActivated = v38.primaryAction.onActivated
	}) or nil

	if FFlagInlineSurveyEnhancements and v32 then
		local v40 = phase == Phase.Invite
		local v41 = if not v32.hasInvite or not v40 then v32.surveySurface else v32.inviteSurface or v32.surveySurface
		local v42 = if not v40 then v33.dismiss else v33.declineInvite

		if v41 == Surface.InContent and v40 then
			return React.createElement(SurfaceWrapper, {
				surface = Surface.InContent,
				onClose = v42,
				children = React.createElement(InviteBanner, {
					onAccept = v33.acceptInvite
				})
			})
		end

		if v41 == Surface.Modal then
			v35.current = true

			return React.createElement(SurfaceWrapper, {
				isOpen = true,
				surface = Surface.Modal,
				onClose = v42,
				title = v38.headerTitle,
				footer = v39,
				children = v38.body
			})
		end

		return React.createElement(SurfaceWrapper, {
			surface = Surface.InContent,
			onClose = v42,
			children = React.createElement(SurveyCard, {
				slots = v38,
				onDismiss = v33.dismiss
			})
		})
	end

	v35.current = true

	return React.createElement(SurveyModal, {
		isOpen = true,
		onClose = v33.dismiss,
		title = v38.headerTitle,
		footer = v39,
		children = v38.body
	})
end

return React.memo(InlineSurvey)
