local ParentParent = script.Parent.Parent.Parent
local FFlagNewUpsellModalExperiment = require(ParentParent.Flags.FFlagNewUpsellModalExperiment)
local v3 = game:DefineFastFlag("NewUpsellModalExperimentForPlatform", false)

return function() -- line: 7
	-- upvalues: FFlagNewUpsellModalExperiment (copy), v3 (copy)
	return FFlagNewUpsellModalExperiment or v3
end
