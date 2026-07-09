local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local InExperienceInterventionParent = InExperienceIntervention.Parent

require(InExperienceIntervention.Utils.Types)

local Constants = require(InExperienceInterventionParent.InterventionShared).Utils.Constants
local UIStateActions = Constants.UIStateActions
local v5 = game:DefineFastInt("ChatInterventionUIRateLimitWindowSec", 5)
local v6 = game:DefineFastFlag("RateLimitNudgeToast", false)
local v7 = game:DefineFastFlag("RateLimitTimeoutToast", false)
local v8 = game:DefineFastFlag("RateLimitNudgeDialog", false)
local v9 = game:DefineFastFlag("RateLimitTimeoutDialog", false)

local function InExperienceInterventionUIStateReducer(p1, p2) -- line: 13
	-- upvalues: v5 (copy), v7 (copy), Constants (copy), v6 (copy), v8 (copy), v9 (copy), UIStateActions (copy)
	local v13 = table.clone(p1)
	local type = p2.type
	local v15 = DateTime.now().UnixTimestamp - p1.dispatchTimestamp < v5
	local v16 = p2.treatmentType == p1.treatmentType
	local v17 = false

	if v7 then
		local v18 = p2.treatmentType == Constants.TreatmentType.ChatTimeoutChatAttempt and p1.treatmentType == Constants.TreatmentType.ChatTimeoutGameJoin or p2.treatmentType == Constants.TreatmentType.ChatTimeoutGameJoin and p1.treatmentType == Constants.TreatmentType.ChatTimeoutChatAttempt
		local v19 = p2.treatmentType == Constants.TreatmentType.ChatTimeoutChatAttempt or p2.treatmentType == Constants.TreatmentType.ChatTimeoutGameJoin

		v17 = v16 and v19 or v18
	end

	local v20 = false

	if v6 then
		v20 = p2.treatmentType == Constants.TreatmentType.ChatNudgeToast and v16
	end

	local v21 = false

	if v8 then
		v21 = p2.treatmentType == Constants.TreatmentType.ChatNudgeDialog and v16
	end

	local v22 = false

	if v9 then
		v22 = p2.treatmentType == Constants.TreatmentType.ChatTimeoutDialog and v16
	end

	local v23 = (v17 or (v20 or (v21 or v22))) and v15

	if type == UIStateActions.ToggleNotificationDialog and not v23 then
		v13.isShown = p2.isShown
		v13.treatmentType = p2.treatmentType
		v13.detail = p2.detail or {}
		v13.endTime = p2.endTime or 0
		v13.dispatchTimestamp = p2.dispatchTimestamp

		return v13
	end

	if v23 then
		print("Chat intervention UI treatment rate limited: ", p2.treatmentType)
	end

	return p1
end

return InExperienceInterventionUIStateReducer
