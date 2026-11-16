local parent = script:FindFirstAncestor("Squads").Parent

local React = require(parent.React)
local RoduxSquads = require(parent.RoduxSquads)
local Http = require(parent.SquadsCore.Http)
local RoduxSquads2 = require(parent.SquadsCore.RoduxSquads)

local Http2 = require(parent.SquadsCore.Http)
local RoduxNetworking = Http2.RoduxNetworking

local Dependencies = {
	Cryo = require(parent.Cryo),
	Foundation = require(parent.Foundation),
	Hooks = 0,
	LuauPolyfill = 0,
	React = 0,
	Roact = 0,
	RoactRodux = 0,
	Rodux = 0,
	RoduxNetworking = 0,
	SharedFlags = 0,
	SocialExperiments = 0,
	t = 0,
	useNavigation = 0,
	RoduxPresence = 0,
	NetworkingPresence = 0,
	RoduxSquads = 0,
	NetworkingSquads = 0,
	UserBlockingRodux = 0,
	UserBlockingNetworking = 0
}

local RoactUtils = require(parent.RoactUtils)
local hooks = {
	dependencyArray = RoactUtils.Hooks.dependencyArray,
	useCurrentSquadSelector = RoduxSquads.Hooks.useCurrentSquadSelector,
	useDispatch = 0,
	useEffectOnce = 0,
	useLocalization = 0,
	usePrevious = 0,
	useSelector = 0,
	useStore = 0
}
local RoactUtils2 = require(parent.RoactUtils)
hooks.useDispatch = RoactUtils2.Hooks.RoactRodux.useDispatch
local RoactUtils3 = require(parent.RoactUtils)
hooks.useEffectOnce = RoactUtils3.Hooks.useEffectOnce
local Localization = require(parent.Localization)
hooks.useLocalization = Localization.Hooks.useLocalization
local RoactUtils4 = require(parent.RoactUtils)
hooks.usePrevious = RoactUtils4.Hooks.usePrevious
local RoactUtils5 = require(parent.RoactUtils)
hooks.useSelector = RoactUtils5.Hooks.RoactRodux.useSelector
local RoactUtils6 = require(parent.RoactUtils)
hooks.useStore = RoactUtils6.Hooks.RoactRodux.useStore
Dependencies.Hooks = hooks

Dependencies.LuauPolyfill = require(parent.LuauPolyfill)
Dependencies.React = React
Dependencies.Roact = require(parent.Roact)
Dependencies.RoactRodux = require(parent.RoactRodux)
Dependencies.Rodux = require(parent.Rodux)
Dependencies.RoduxNetworking = RoduxNetworking
Dependencies.SharedFlags = require(parent.SharedFlags)
Dependencies.SocialExperiments = require(parent.SocialExperiments)
Dependencies.t = require(parent.t)
local Navigation = require(parent.Navigation)
Dependencies.useNavigation = Navigation.useNavigation

Dependencies.RoduxPresence = Http.RoduxPresence
Dependencies.NetworkingPresence = Http.NetworkingPresence
Dependencies.RoduxSquads = RoduxSquads2
Dependencies.NetworkingSquads = Http.NetworkingSquads
Dependencies.UserBlockingRodux = Http.UserBlockingRodux
Dependencies.UserBlockingNetworking = Http.UserBlockingNetworking
return Dependencies
