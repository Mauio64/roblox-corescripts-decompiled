local IXPService = game:GetService("IXPService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef

local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/ExperimentLayers").AppUserLayers
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Utils/Constants")
local determineAppealsState = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Utils/determineAppealsState")
local determineUFRInterventionType = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Utils/determineUFRInterventionType")
local GenericInterventionDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Components/genericComponents/GenericInterventionDialog")
require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Utils/Types")
local useParsedBadUtterances = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Hooks/useParsedBadUtterances")
local useRestrictionEndDateInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Hooks/useRestrictionEndDateInfo")

local FFlagUFRAppealsAndModNoteFix = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Flags/FFlagUFRAppealsAndModNoteFix")
local FFlagUFRFriendsChatIXPExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Flags/FFlagUFRFriendsChatIXPExposure")
local FFlagUFRImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Flags/FFlagUFRImprovements")

local FFlagUFRRunUnlessFeatureRestricted = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/UniversalFeatureRestrictions/FFlagUFRRunUnlessFeatureRestricted")

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

	local v5 = determineUFRInterventionType(moderationDetail.punishmentTypeDescription)

	local v6 = useParsedBadUtterances(badUtterances or {}, {
		labelTranslationKey = labelTranslationKey
	})

	local joined = table.concat(v6.textItems, "\n")
	local joined2 = table.concat(v6.abuseTypes, ", ")

	local v7 = useRestrictionEndDateInfo(moderationDetail.endDate)
	local v8 = determineAppealsState({
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
			IXPService:LogFlagLinkedUserLayerExposure(appUserLayers.FriendsChatRestrictionUserIDLayer)
		end

		if FFlagUFRImprovements and props.onShownCallback then
			props.onShownCallback()
		end
	end, {})
	local v9

	if FFlagUFRRunUnlessFeatureRestricted then
		local v10 = useRef(false)

		useEffect(function()
			local onClosedCallback = props.onClosedCallback
			v10.current = false
			return function()
				if onClosedCallback then
					onClosedCallback(v10.current)
				end
			end
		end, { props.onClosedCallback })
		v9 = v10
	else
		v9 = nil
	end

	local function fn()
		if FFlagUFRRunUnlessFeatureRestricted and v9 then
			v9.current = true
		end

		props.onDismiss()

		if props.onDismissCallback then
			props.onDismissCallback()
		end
	end

	local v13 = useCallback(fn, { props.onDismiss, props.onDismissCallback, if FFlagUFRRunUnlessFeatureRestricted then v9 else nil })

	local titleOverride = props.titleOverride
		or FFlagUFRImprovements and (moderationDetail.title or "")
		or "Chat suspended for 2 days"
	local bodyOverride = props.bodyOverride
		or FFlagUFRImprovements and (moderationDetail.body or "")
		or "You can't use chat because one or more of your messages broke the rules. If you break the rules again, you could be banned."

	local createElement = React.createElement
	local v15 = {
		titleText = titleOverride,
		bodyText = bodyOverride,
		userNote = messageToUser,
		isAppealable = v8.isAppealable,
		evidence = joined,
		violationReason = joined2,
		onDismiss = v13,
		dsaMessage = consequenceTransparencyMessage,
		interventionId = interventionId,
		acknowledgeable = acknowledgeable,
		eventId = props.analyticsEventId or interventionId,
		interventionTypeForAnalytics = v5,
		abuseVectorForAnalytics = props.abuseVector,
		useDetailedLayout = true,
		formattedEndDate = v7.formattedEndDate,
		countdownText = v7.countdownText,
		onAppeal = props.onAppeal,
		onAcknowledgementSuccess = props.onAcknowledgementSuccess,
		onAcknowledgementFailure = props.onAcknowledgementFailure,
		shouldOpenAppealsPortal = v8.shouldOpenAppealsPortal,
		violationUid = 0
	}
	local v16 = if violation then violation.uid else nil
	v15.violationUid = v16
	return createElement(GenericInterventionDialog, v15)
end

return React.memo(UniversalFeatureRestrictionDialog)
