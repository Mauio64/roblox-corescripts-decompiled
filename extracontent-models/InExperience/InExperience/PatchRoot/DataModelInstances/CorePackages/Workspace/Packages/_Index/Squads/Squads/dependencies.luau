local Parent = script:FindFirstAncestor("Squads").Parent
local React = require(Parent.React)
local RoduxSquads = require(Parent.RoduxSquads)
local Http = require(Parent.SquadsCore.Http)
local RoduxSquads2 = require(Parent.SquadsCore.RoduxSquads)
local RoduxNetworking = require(Parent.SquadsCore.Http).RoduxNetworking

return {
	Cryo = require(Parent.Cryo),
	Foundation = require(Parent.Foundation),
	Hooks = {
		dependencyArray = require(Parent.RoactUtils).Hooks.dependencyArray,
		useCurrentSquadSelector = RoduxSquads.Hooks.useCurrentSquadSelector,
		useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch,
		useEffectOnce = require(Parent.RoactUtils).Hooks.useEffectOnce,
		useLocalization = require(Parent.Localization).Hooks.useLocalization,
		usePrevious = require(Parent.RoactUtils).Hooks.usePrevious,
		useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector,
		useStore = require(Parent.RoactUtils).Hooks.RoactRodux.useStore
	},
	LuauPolyfill = require(Parent.LuauPolyfill),
	React = React,
	Roact = require(Parent.Roact),
	RoactRodux = require(Parent.RoactRodux),
	Rodux = require(Parent.Rodux),
	RoduxNetworking = RoduxNetworking,
	SharedFlags = require(Parent.SharedFlags),
	SocialExperiments = require(Parent.SocialExperiments),
	t = require(Parent.t),
	useNavigation = require(Parent.Navigation).useNavigation,
	RoduxPresence = Http.RoduxPresence,
	NetworkingPresence = Http.NetworkingPresence,
	RoduxSquads = RoduxSquads2,
	NetworkingSquads = Http.NetworkingSquads,
	UserBlockingRodux = Http.UserBlockingRodux,
	UserBlockingNetworking = Http.UserBlockingNetworking
}
