local HelpReactView = require(script.HelpReactView)
local Constants = require(script.Constants)

return {
	HelpReactView = HelpReactView,
	Constants = Constants,
	Flags = {
		FFlagRefactorHelpPage = require(script.Flags.FFlagRefactorHelpPage),
		FFlagHelpPageMountVR = require(script.Flags.FFlagHelpPageMountVR),
		FFlagHelpPageIXPExposure = require(script.Flags.FFlagHelpPageIXPExposure),
		FStringHelpPageIXPLayer = require(script.Flags.FStringHelpPageIXPLayer)
	},
	["jest.config"] = script["jest.config"]
}
