local Parent = script:FindFirstAncestor("MomentsCreationFlow").Parent
local Dash = require(Parent.Dash)

return require(Parent.React).createContext({
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
