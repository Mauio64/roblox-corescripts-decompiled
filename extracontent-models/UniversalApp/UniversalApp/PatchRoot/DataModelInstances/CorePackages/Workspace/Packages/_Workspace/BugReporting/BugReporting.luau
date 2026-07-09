local BugReporterEventReceiver = require(script.BugReporterEventReceiver)
local BugReporterModalContainer = require(script.BugReporterModalContainer)

require(script.BugReporterTypes)

return {
	BugReporterEventReceiver = BugReporterEventReceiver,
	BugReporterModalContainer = BugReporterModalContainer,
	["jest.config"] = script["jest.config"]
}
