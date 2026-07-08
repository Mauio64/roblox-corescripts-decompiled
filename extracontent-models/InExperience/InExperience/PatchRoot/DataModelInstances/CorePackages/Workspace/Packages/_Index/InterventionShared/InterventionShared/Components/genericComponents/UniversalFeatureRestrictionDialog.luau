local InterventionShared = script:FindFirstAncestor("InterventionShared")
local InterventionSharedParent = InterventionShared.Parent
local React = require(InterventionSharedParent.React)
local useCallback = React.useCallback
local determineAppealsState = require(InterventionShared.Utils.determineAppealsState)
local determineUFRInterventionType = require(InterventionShared.Utils.determineUFRInterventionType)
local GenericInterventionDialog = require(InterventionShared.Components.genericComponents.GenericInterventionDialog)

require(InterventionShared.Utils.Types)

local useParsedBadUtterances = require(InterventionShared.Hooks.useParsedBadUtterances)
local useRestrictionEndDateInfo = require(InterventionShared.Hooks.useRestrictionEndDateInfo)

local function UniversalFeatureRestrictionDialog(t1: {[any]: any}) -- line: 45
	-- upvalues: determineUFRInterventionType (copy), useParsedBadUtterances (copy), useRestrictionEndDateInfo (copy), determineAppealsState (copy), useCallback (copy), React (copy), GenericInterventionDialog (copy)
	local moderationDetail = t1.moderationDetail
	local consequenceTransparencyMessage = moderationDetail.consequenceTransparencyMessage
	local interventionId = moderationDetail.interventionId
	local acknowledgeable = moderationDetail.acknowledgeable
	local badUtterances = moderationDetail.badUtterances
	local labelTranslationKey = moderationDetail.labelTranslationKey
	local messageToUser = moderationDetail.messageToUser
	local v19 = determineUFRInterventionType(moderationDetail.punishmentTypeDescription)
	local v20 = useParsedBadUtterances(badUtterances or {}, labelTranslationKey)
	local v21 = table.concat(v20.textItems, "\n")
	local v22 = table.concat(v20.abuseTypes, ", ")
	local v23 = useRestrictionEndDateInfo(moderationDetail.endDate)
	local v24 = determineAppealsState({
		onAppeal = t1.onAppeal,
		beginDate = moderationDetail.beginDate,
		endDate = moderationDetail.endDate,
		acknowledgeable = acknowledgeable
	})
	local v25 = useCallback(function() -- line: 69
		-- upvalues: t1 (copy)
		t1.onDismiss()

		if t1.onDismissCallback then
			t1.onDismissCallback()
		end
	end, {
		t1.onDismiss,
		t1.onDismissCallback
	})

	return React.createElement(GenericInterventionDialog, {
		useDetailedLayout = true,
		titleText = t1.titleOverride or "Chat suspended for 2 days",
		bodyText = t1.bodyOverride or "You can't use chat because one or more of your messages broke the rules. If you break the rules again, you could be banned.",
		userNote = messageToUser,
		isAppealable = v24.isAppealable,
		evidence = v21,
		violationReason = v22,
		onDismiss = v25,
		dsaMessage = consequenceTransparencyMessage,
		interventionId = interventionId,
		acknowledgeable = acknowledgeable,
		eventId = interventionId,
		interventionTypeForAnalytics = v19,
		abuseVectorForAnalytics = t1.abuseVector,
		formattedEndDate = v23.formattedEndDate,
		countdownText = v23.countdownText,
		onAppeal = t1.onAppeal,
		shouldOpenAppealsPortal = v24.shouldOpenAppealsPortal
	})
end

return React.memo(UniversalFeatureRestrictionDialog)
