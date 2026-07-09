local useCrossPlaySettings = require(script.Hooks.useCrossPlaySettings)
local useInitializeCrossPlaySettings = require(script.Hooks.useInitializeCrossPlaySettings)
local CrossPlaySettings = require(script.Reducers.CrossPlaySettings)

return {
	Hooks = {
		useInitializeCrossPlaySettings = useInitializeCrossPlaySettings,
		useCrossPlaySettings = useCrossPlaySettings
	},
	Reducers = {
		CrossPlaySettings = CrossPlaySettings
	},
	["jest.config"] = script["jest.config"]
}
