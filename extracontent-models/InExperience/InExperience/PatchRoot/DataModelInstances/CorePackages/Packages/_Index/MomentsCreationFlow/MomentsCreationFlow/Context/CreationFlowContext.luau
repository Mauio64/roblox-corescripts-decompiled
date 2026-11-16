local parent = script:FindFirstAncestor("MomentsCreationFlow").Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

return React.createContext({
	captures = {},
	capturesPagesIsFinished = Dash.noop,
	createMoment = Dash.noop,
	exitCreationFlow = Dash.noop,
	fetchAdditionalCaptures = Dash.noop,
	fetchInitialCaptures = Dash.noop,
	fireEvent = Dash.noop,
	getLocalization = Dash.noop,
	getUserConfiguration = Dash.noop,
	isTextFiltered = Dash.noop,
	setScreenOrientation = Dash.noop
})
