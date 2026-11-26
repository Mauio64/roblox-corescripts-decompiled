local module = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/React")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoduxSquads")
local Http = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Http")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/RoduxSquads")

local roduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Http").RoduxNetworking

return {
	Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Cryo"),
	Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Foundation"),
	Hooks = {
		dependencyArray = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactUtils").Hooks.dependencyArray,
		useCurrentSquadSelector = module2.Hooks.useCurrentSquadSelector,
		useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactUtils").Hooks.RoactRodux.useDispatch,
		useEffectOnce = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactUtils").Hooks.useEffectOnce,
		useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Localization").Hooks.useLocalization,
		usePrevious = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactUtils").Hooks.usePrevious,
		useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactUtils").Hooks.RoactRodux.useSelector,
		useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactUtils").Hooks.RoactRodux.useStore
	},
	LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/LuauPolyfill"),
	React = module,
	Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Roact"),
	RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactRodux"),
	Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Rodux"),
	RoduxNetworking = roduxNetworking,
	SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/SharedFlags"),
	SocialExperiments = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/SocialExperiments"),
	t = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/t"),
	useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Navigation").useNavigation,
	RoduxPresence = Http.RoduxPresence,
	NetworkingPresence = Http.NetworkingPresence,
	RoduxSquads = module4,
	NetworkingSquads = Http.NetworkingSquads,
	UserBlockingRodux = Http.UserBlockingRodux,
	UserBlockingNetworking = Http.UserBlockingNetworking
}
