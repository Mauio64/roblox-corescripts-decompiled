local PeekViewState = require(script.PeekViewState)
local PeekView = require(script.PeekView)
local PeekViewWithTopBar = require(script.PeekViewWithTopBar)
local peekViewDismissedEvent = require(script.analytics.peekViewDismissedEvent)
local Scrim = require(script.Scrim)

return {
	analytics = {
		peekViewDismissedEvent = peekViewDismissedEvent
	},
	["jest.config"] = script["jest.config"],
	PeekViewState = PeekViewState,
	PeekView = PeekView,
	PeekViewWithTopBar = PeekViewWithTopBar,
	Scrim = Scrim
}
