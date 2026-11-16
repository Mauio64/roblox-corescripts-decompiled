local FFlagAXBackgroundsRoot = require(script.Parent.FFlagAXBackgroundsRoot)
local FFlagAXBackgroundsCustomizeHydration = require(script.Parent.FFlagAXBackgroundsCustomizeHydration)

local v = require(script.Parent.FFlagAXBackgroundGenerationResultActionButtons)

local defineFastFlag = game:DefineFastFlag("AXBackgroundGenerationV2", false)

local defineFastFlag2 = game:DefineFastFlag("AXBackgroundGenerationBuildGate", false)

if defineFastFlag or defineFastFlag2 or v then
	return FFlagAXBackgroundsRoot and FFlagAXBackgroundsCustomizeHydration
end

return v
