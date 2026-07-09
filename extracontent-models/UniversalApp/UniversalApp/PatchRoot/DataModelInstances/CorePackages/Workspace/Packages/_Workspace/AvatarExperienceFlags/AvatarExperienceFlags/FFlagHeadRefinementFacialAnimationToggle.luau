local FFlagDynamicHeadsMigration = require(script.Parent.FFlagDynamicHeadsMigration)
local EngineFeature = game:GetEngineFeature("EnableFacsDisableOverride2")

return FFlagDynamicHeadsMigration and (EngineFeature and game:DefineFastFlag("HeadRefinementFacialAnimationToggle4", false))
