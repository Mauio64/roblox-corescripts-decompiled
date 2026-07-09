local AppStartupSequence = require(script.AppStartupSequence)
local PlatformAccountRouter = require(script.Components.PlatformAccountRouter)
local StartupMessageContainer = require(script.Components.StartupMessage.StartupMessageContainer)
local navigateWithPlatformAccount = require(script.navigateWithPlatformAccount)
local Reducers = require(script.Reducers)
local Actions = require(script.Actions)
local Enums = require(script.Enums)
local Hooks = require(script.Hooks)

return {
	AppStartupSequence = AppStartupSequence,
	PlatformAccountRouter = PlatformAccountRouter,
	StartupMessageContainer = StartupMessageContainer,
	PostAppInteractiveContainer = require(script.Components.PostAppInteractiveContainer),
	navigateWithPlatformAccount = navigateWithPlatformAccount,
	Reducers = Reducers,
	Actions = Actions,
	Hooks = Hooks,
	Enums = Enums,
	["jest.config"] = script["jest.config"]
}
