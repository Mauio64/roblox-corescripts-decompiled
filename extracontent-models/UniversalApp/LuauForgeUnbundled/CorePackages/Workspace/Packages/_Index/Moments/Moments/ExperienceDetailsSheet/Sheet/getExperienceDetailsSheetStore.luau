local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local createExperienceDetailsSheetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Sheet/createExperienceDetailsSheetStore")

return Signals.createComputed(createExperienceDetailsSheetStore)
