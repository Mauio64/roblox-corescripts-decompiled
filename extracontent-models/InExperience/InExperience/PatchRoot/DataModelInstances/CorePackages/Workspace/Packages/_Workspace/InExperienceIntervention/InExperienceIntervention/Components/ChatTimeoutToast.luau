local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local InExperienceInterventionParent = InExperienceIntervention.Parent
local React = require(InExperienceInterventionParent.React)
local Constants = require(InExperienceInterventionParent.InterventionShared).Utils.Constants
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local ChatInterventionGenericToast = require(InExperienceIntervention.Components.ChatInterventionGenericToast)
local useLocalization = require(InExperienceInterventionParent.Localization).Hooks.useLocalization
local determineToastDuration = require(InExperienceInterventionParent.InterventionShared).Utils.determineToastDuration

function ChatTimeoutToast(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), useLocalization (copy), Constants (copy), determineToastDuration (copy), ChatInterventionGenericToast (copy), InExperienceInterventionAnalytics (copy)
	local v10, v11 = React.useState(0)
	local v12 = useLocalization({
		cannotSend1MinText = Constants.localizationKeys.CannotSend1MinText,
		beRespectfulText = Constants.localizationKeys.BeRespectfulText
	})

	React.useEffect(function() -- line: 29
		-- upvalues: t1 (copy), v11 (copy)
		if t1.endTime then
			local UnixTimestamp = DateTime.now().UnixTimestamp
			local v15 = math.ceil((t1.endTime - UnixTimestamp) / 60)

			v11(v15)
		end
	end, {
		t1.endTime,
		t1.dispatchTimestamp
	})

	local v13 = determineToastDuration(v10)

	return React.createElement(ChatInterventionGenericToast, {
		toastTitle = v13,
		toastBody = v12.beRespectfulText,
		interventionType = InExperienceInterventionAnalytics.Constants.InterventionTypes.Timeout,
		remainingDurationSec = v10,
		toastAppearEventName = InExperienceInterventionAnalytics.Constants.EventTypes.ChatAttemptToastAppeared,
		toastDismissEventName = InExperienceInterventionAnalytics.Constants.EventTypes.ChatAttemptToastDismissed
	})
end

return ChatTimeoutToast
