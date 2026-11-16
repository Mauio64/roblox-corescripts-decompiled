local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/DataHydration")

return {
	useGameInfo = require("@game/CorePackages/Workspace/Packages/_Index/GameHydrationReact/GameHydrationReact/useGameInfo"),
	useGameInfos = require("@game/CorePackages/Workspace/Packages/_Index/GameHydrationReact/GameHydrationReact/useGameInfos"),
	useGameVotes = require("@game/CorePackages/Workspace/Packages/_Index/GameHydrationReact/GameHydrationReact/useGameVotes"),
	useGameIcon = require("@game/CorePackages/Workspace/Packages/_Index/GameHydrationReact/GameHydrationReact/useGameIcon"),
	useLargeGameIcon = require("@game/CorePackages/Workspace/Packages/_Index/GameHydrationReact/GameHydrationReact/useLargeGameIcon"),
	useGameIcons = require("@game/CorePackages/Workspace/Packages/_Index/GameHydrationReact/GameHydrationReact/useGameIcons"),
	useFetchGameIcons = require("@game/CorePackages/Workspace/Packages/_Index/GameHydrationReact/GameHydrationReact/useFetchGameIcons"),
	subscribeGameInfo = require("@game/CorePackages/Workspace/Packages/_Index/GameHydrationReact/GameHydrationReact/subscribeGameInfo"),
	subscribeGameIcon = require("@game/CorePackages/Workspace/Packages/_Index/GameHydrationReact/GameHydrationReact/subscribeGameIcon"),
	subscribeGameIcons = require("@game/CorePackages/Workspace/Packages/_Index/GameHydrationReact/GameHydrationReact/subscribeGameIcons"),
	GameIconSize = DataHydration.Game.GameIconSize
}
