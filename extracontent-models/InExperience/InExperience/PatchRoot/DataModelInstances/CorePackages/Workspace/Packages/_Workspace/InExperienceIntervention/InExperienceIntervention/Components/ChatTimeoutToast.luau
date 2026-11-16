local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local parent = InExperienceIntervention.Parent

local React = require(parent.React)

local InterventionShared = require(parent.InterventionShared)
local Constants = InterventionShared.Utils.Constants
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local ChatInterventionGenericToast = require(InExperienceIntervention.Components.ChatInterventionGenericToast)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local InterventionShared2 = require(parent.InterventionShared)
local determineToastDuration = InterventionShared2.Utils.determineToastDuration

function ChatTimeoutToast(p)
	local state, setState = React.useState(0)

	local v = useLocalization({
		cannotSend1MinText = Constants.localizationKeys.CannotSend1MinText,
		beRespectfulText = Constants.localizationKeys.BeRespectfulText
	})

	React.useEffect(function()
		if p.endTime then
			local unixTimestamp = DateTime.now().UnixTimestamp
			setState((math.ceil((p.endTime - unixTimestamp) / 60)))
		end
	end, { p.endTime, p.dispatchTimestamp })

	local toastTitle = determineToastDuration(state)

	return React.createElement(ChatInterventionGenericToast, {
		toastTitle = toastTitle,
		toastBody = v.beRespectfulText,
		interventionType = InExperienceInterventionAnalytics.Constants.InterventionTypes.Timeout,
		remainingDurationSec = state,
		toastAppearEventName = InExperienceInterventionAnalytics.Constants.EventTypes.ChatAttemptToastAppeared,
		toastDismissEventName = InExperienceInterventionAnalytics.Constants.EventTypes.ChatAttemptToastDismissed
	})
end

return ChatTimeoutToast
