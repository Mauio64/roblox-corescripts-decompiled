local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local parent = InExperienceIntervention.Parent

require(InExperienceIntervention.Utils.Types)
local InterventionShared = require(parent.InterventionShared)
local Constants = InterventionShared.Utils.Constants
local UIStateActions = Constants.UIStateActions
local defineFastInt = game:DefineFastInt("ChatInterventionUIRateLimitWindowSec", 5)
local defineFastFlag = game:DefineFastFlag("RateLimitNudgeToast", false)
local defineFastFlag2 = game:DefineFastFlag("RateLimitTimeoutToast", false)
local defineFastFlag3 = game:DefineFastFlag("RateLimitNudgeDialog", false)
local defineFastFlag4 = game:DefineFastFlag("RateLimitTimeoutDialog", false)

local function InExperienceInterventionUIStateReducer(p, data)
	local clone = table.clone(p)
	local kind = data.type

	local v = DateTime.now().UnixTimestamp - p.dispatchTimestamp < defineFastInt
	local v2 = data.treatmentType == p.treatmentType
	local v3

	if defineFastFlag2 then
		if
			data.treatmentType == Constants.TreatmentType.ChatTimeoutChatAttempt
			and p.treatmentType == Constants.TreatmentType.ChatTimeoutGameJoin
		then
			v3 = true
		elseif data.treatmentType == Constants.TreatmentType.ChatTimeoutGameJoin then
			v3 = p.treatmentType == Constants.TreatmentType.ChatTimeoutChatAttempt
		else
			v3 = false
		end

		local v4 = data.treatmentType == Constants.TreatmentType.ChatTimeoutChatAttempt
			or data.treatmentType == Constants.TreatmentType.ChatTimeoutGameJoin
		v3 = v2 and v4 or v3
	else
		v3 = false
	end

	local v4

	if defineFastFlag then
		v4 = data.treatmentType == Constants.TreatmentType.ChatNudgeToast and v2
	else
		v4 = false
	end

	local v5

	if defineFastFlag3 then
		v5 = data.treatmentType == Constants.TreatmentType.ChatNudgeDialog and v2
	else
		v5 = false
	end

	local v6

	if defineFastFlag4 then
		v6 = data.treatmentType == Constants.TreatmentType.ChatTimeoutDialog and v2
	else
		v6 = false
	end

	if not (v3 or v4 or v5 or v6) then
		v = v6
	end

	if kind == UIStateActions.ToggleNotificationDialog and not v then
		clone.isShown = data.isShown
		clone.treatmentType = data.treatmentType
		clone.detail = data.detail or {}
		clone.endTime = data.endTime or 0
		clone.dispatchTimestamp = data.dispatchTimestamp
		return clone
	end

	if v then
		print("Chat intervention UI treatment rate limited: ", data.treatmentType)
	end

	return p
end

return InExperienceInterventionUIStateReducer
