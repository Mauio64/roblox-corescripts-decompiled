local InterventionShared = script:FindFirstAncestor("InterventionShared")
local parent = InterventionShared.Parent

local IXPService = game:GetService("IXPService")

local React = require(parent.React)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef

local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local Constants = require(InterventionShared.Utils.Constants)
local determineAppealsState = require(InterventionShared.Utils.determineAppealsState)
local determineUFRInterventionType = require(InterventionShared.Utils.determineUFRInterventionType)
local GenericInterventionDialog = require(InterventionShared.Components.genericComponents.GenericInterventionDialog)
require(InterventionShared.Utils.Types)
local useParsedBadUtterances = require(InterventionShared.Hooks.useParsedBadUtterances)
local useRestrictionEndDateInfo = require(InterventionShared.Hooks.useRestrictionEndDateInfo)

local FFlagUFRAppealsAndModNoteFix = require(InterventionShared.Flags.FFlagUFRAppealsAndModNoteFix)
local FFlagUFRFriendsChatIXPExposure = require(InterventionShared.Flags.FFlagUFRFriendsChatIXPExposure)
local FFlagUFRImprovements = require(InterventionShared.Flags.FFlagUFRImprovements)

local FFlagUFRRunUnlessFeatureRestricted = require(parent.UniversalFeatureRestrictions.FFlagUFRRunUnlessFeatureRestricted)

local function UniversalFeatureRestrictionDialog(props)
	local moderationDetail = props.moderationDetail
	local consequenceTransparencyMessage = moderationDetail.consequenceTransparencyMessage
	local interventionId = moderationDetail.interventionId
	local acknowledgeable = moderationDetail.acknowledgeable
	local badUtterances = moderationDetail.badUtterances
	local labelTranslationKey = moderationDetail.labelTranslationKey
	local violation = moderationDetail.violation
	local messageToUser

	if not (FFlagUFRAppealsAndModNoteFix and props.abuseVector ~= Constants.AbuseVectorType.RobloxExperienceKick) then
		messageToUser = moderationDetail.messageToUser
	end

	local interventionTypeForAnalytics = determineUFRInterventionType(moderationDetail.punishmentTypeDescription)

	local v = useParsedBadUtterances(badUtterances or {}, {
		labelTranslationKey = labelTranslationKey
	})

	local joined = table.concat(v.textItems, "\n")
	local joined2 = table.concat(v.abuseTypes, ", ")

	local v2 = useRestrictionEndDateInfo(moderationDetail.endDate)
	local v3 = determineAppealsState({
		onAppeal = props.onAppeal,
		beginDate = moderationDetail.beginDate,
		endDate = moderationDetail.endDate,
		acknowledgeable = acknowledgeable
	})

	useEffect(function()
		if
			FFlagUFRFriendsChatIXPExposure
			and props.abuseVector == Constants.AbuseVectorType.PartyChat
			and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure")
		then
			IXPService:LogFlagLinkedUserLayerExposure(AppUserLayers.FriendsChatRestrictionUserIDLayer)
		end

		if FFlagUFRImprovements and props.onShownCallback then
			props.onShownCallback()
		end
	end, {})
	local v4

	if FFlagUFRRunUnlessFeatureRestricted then
		v4 = useRef(false)

		useEffect(function()
			local onClosedCallback = props.onClosedCallback
			v4.current = false
			return function()
				if onClosedCallback then
					onClosedCallback(v4.current)
				end
			end
		end, { props.onClosedCallback })
	else
		v4 = nil
	end

	local function fn()
		if FFlagUFRRunUnlessFeatureRestricted and v4 then
			v4.current = true
		end

		props.onDismiss()

		if props.onDismissCallback then
			props.onDismissCallback()
		end
	end
	local onDismiss = props.onDismiss
	local onDismissCallback = props.onDismissCallback
	local v5

	if FFlagUFRRunUnlessFeatureRestricted then
		v5 = v4
	end

	local onDismiss2 = useCallback(fn, { onDismiss, onDismissCallback, v5 })

	local titleOverride = props.titleOverride
		or FFlagUFRImprovements and (moderationDetail.title or "")
		or "Chat suspended for 2 days"
	local bodyOverride = props.bodyOverride
		or FFlagUFRImprovements and (moderationDetail.body or "")
		or "You can't use chat because one or more of your messages broke the rules. If you break the rules again, you could be banned."

	local createElement = React.createElement
	local v6 = {
		titleText = titleOverride,
		bodyText = bodyOverride,
		userNote = messageToUser,
		isAppealable = v3.isAppealable,
		evidence = joined,
		violationReason = joined2,
		onDismiss = onDismiss2,
		dsaMessage = consequenceTransparencyMessage,
		interventionId = interventionId,
		acknowledgeable = acknowledgeable,
		eventId = props.analyticsEventId or interventionId,
		interventionTypeForAnalytics = interventionTypeForAnalytics,
		abuseVectorForAnalytics = props.abuseVector,
		useDetailedLayout = true,
		formattedEndDate = v2.formattedEndDate,
		countdownText = v2.countdownText,
		onAppeal = props.onAppeal,
		onAcknowledgementSuccess = props.onAcknowledgementSuccess,
		onAcknowledgementFailure = props.onAcknowledgementFailure,
		shouldOpenAppealsPortal = v3.shouldOpenAppealsPortal,
		violationUid = 0
	}
	local violationUid

	if violation then
		violationUid = violation.uid
	end

	v6.violationUid = violationUid
	return createElement(GenericInterventionDialog, v6)
end

return React.memo(UniversalFeatureRestrictionDialog)
