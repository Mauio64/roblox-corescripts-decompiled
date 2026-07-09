local Components = require(script.Components)

return {
	openPlayerContextualMenu = require(script.openPlayerContextualMenu),
	Component = Components.PlayerContextualMenu,
	installReducer = require(script.Reducers.installReducer),
	["jest.config"] = script["jest.config"]
}
