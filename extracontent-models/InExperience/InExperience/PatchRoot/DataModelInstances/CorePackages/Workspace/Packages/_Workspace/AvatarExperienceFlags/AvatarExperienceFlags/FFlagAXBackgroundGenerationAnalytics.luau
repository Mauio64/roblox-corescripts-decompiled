local FFlagAXBackgroundGeneration = require(script.Parent.FFlagAXBackgroundGeneration)
local FFlagAXItemDetailsIxpExposure = require(script.Parent.FFlagAXItemDetailsIxpExposure)
local FFlagAXSkipTapDetection = require(script.Parent.FFlagAXSkipTapDetection)

return game:DefineFastFlag("AXBackgroundGenerationAnalytics", false)
	and FFlagAXBackgroundGeneration
	and FFlagAXItemDetailsIxpExposure
	and FFlagAXSkipTapDetection
