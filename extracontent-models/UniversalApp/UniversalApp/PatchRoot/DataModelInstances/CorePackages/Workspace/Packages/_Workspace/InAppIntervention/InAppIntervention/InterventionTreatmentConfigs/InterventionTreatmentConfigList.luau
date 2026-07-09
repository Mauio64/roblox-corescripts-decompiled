local InAppIntervention = script:FindFirstAncestor("InAppIntervention")
local PartyChatDialogNudgeConfig = require(InAppIntervention.InterventionTreatmentConfigs.PartyChatDialogNudgeConfig)
local PartyChatDialogTimeoutConfig = require(InAppIntervention.InterventionTreatmentConfigs.PartyChatDialogTimeoutConfig)

require(InAppIntervention.Utils.Types)

local t1 = {}

table.insert(t1, PartyChatDialogNudgeConfig)
table.insert(t1, PartyChatDialogTimeoutConfig)

return t1
