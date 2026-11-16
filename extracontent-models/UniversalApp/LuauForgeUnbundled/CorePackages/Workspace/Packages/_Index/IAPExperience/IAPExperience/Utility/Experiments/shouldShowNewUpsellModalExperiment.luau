local FFlagNewUpsellModalExperiment = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagNewUpsellModalExperiment")
local defineFastFlag = game:DefineFastFlag("NewUpsellModalExperimentForPlatform", false)

return function()
	return FFlagNewUpsellModalExperiment or defineFastFlag
end
