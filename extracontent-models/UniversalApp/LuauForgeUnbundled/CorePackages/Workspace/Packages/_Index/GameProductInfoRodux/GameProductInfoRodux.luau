local module = require("@game/CorePackages/Workspace/Packages/_Index/GameProductInfoRodux/GameProductInfoRodux/GameProductInfo")

return {
	FetchGamesProductInfo = require("@game/CorePackages/Workspace/Packages/_Index/GameProductInfoRodux/GameProductInfoRodux/FetchGamesProductInfo"),
	GameProductInfo = module,
	GamesProductInfoReducer = require("@game/CorePackages/Workspace/Packages/_Index/GameProductInfoRodux/GameProductInfoRodux/GamesProductInfoReducer"),
	useGameProductInfoSelector = require("@game/CorePackages/Workspace/Packages/_Index/GameProductInfoRodux/GameProductInfoRodux/useGameProductInfoSelector")
}
