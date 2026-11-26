local PartyChatDialogNudgeConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InExperienceIntervention/InterventionTreatmentConfigs/PartyChatDialogNudgeConfig")
local PartyChatDialogTimeoutConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InExperienceIntervention/InterventionTreatmentConfigs/PartyChatDialogTimeoutConfig")
require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InExperienceIntervention/Utils/Types")

local modules = {}
table.insert(modules, PartyChatDialogNudgeConfig)
table.insert(modules, PartyChatDialogTimeoutConfig)

return modules
