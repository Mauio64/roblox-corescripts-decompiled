local parent = script.Parent.Parent.Parent

local FFlagNewUpsellModalExperiment = require(parent.Flags.FFlagNewUpsellModalExperiment)
local defineFastFlag = game:DefineFastFlag("NewUpsellModalExperimentForPlatform", false)

return function()
	return FFlagNewUpsellModalExperiment or defineFastFlag
end
