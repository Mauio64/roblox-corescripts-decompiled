local FFlagAXBackgroundsRoot = require(script.Parent.FFlagAXBackgroundsRoot)
local FFlagAXBackgroundCycloramaRendering = require(script.Parent.FFlagAXBackgroundCycloramaRendering)

return game:DefineFastFlag("AXBackgroundsCycloramaVR", false) and (FFlagAXBackgroundsRoot and FFlagAXBackgroundCycloramaRendering)
