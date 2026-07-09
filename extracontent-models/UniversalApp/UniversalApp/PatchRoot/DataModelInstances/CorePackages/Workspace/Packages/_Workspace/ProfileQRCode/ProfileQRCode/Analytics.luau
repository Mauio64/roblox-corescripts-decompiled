local ProfileQRCodeAnalytics = require(script.ProfileQRCodeAnalytics)
local setupFireEvent = require(script.setupFireEvent)
local useAnalytics = require(script.useAnalytics)

return {
	Context = ProfileQRCodeAnalytics,
	EventNames = require(script.EventNames),
	setupFireEvent = setupFireEvent,
	useAnalytics = useAnalytics
}
