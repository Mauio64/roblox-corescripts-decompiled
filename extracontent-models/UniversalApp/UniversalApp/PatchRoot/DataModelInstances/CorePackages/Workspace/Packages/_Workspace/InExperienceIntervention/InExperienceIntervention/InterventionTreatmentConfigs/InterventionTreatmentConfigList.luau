local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local ChatToastNudgeConfig = require(InExperienceIntervention.InterventionTreatmentConfigs.ChatToastNudgeConfig)
local ChatTimeoutConfig = require(InExperienceIntervention.InterventionTreatmentConfigs.ChatTimeoutConfig)
local ChatDialogNudgeConfig = require(InExperienceIntervention.InterventionTreatmentConfigs.ChatDialogNudgeConfig)
local PartyChatDialogNudgeConfig = require(InExperienceIntervention.InterventionTreatmentConfigs.PartyChatDialogNudgeConfig)
local PartyChatDialogTimeoutConfig = require(InExperienceIntervention.InterventionTreatmentConfigs.PartyChatDialogTimeoutConfig)
local t1 = {
	ChatToastNudgeConfig,
	ChatDialogNudgeConfig,
	ChatTimeoutConfig
}

table.insert(t1, PartyChatDialogNudgeConfig)
table.insert(t1, PartyChatDialogTimeoutConfig)

return t1
