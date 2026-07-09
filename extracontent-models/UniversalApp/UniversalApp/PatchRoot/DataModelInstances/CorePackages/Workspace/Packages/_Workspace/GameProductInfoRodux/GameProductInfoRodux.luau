local GameProductInfo = require(script.GameProductInfo)

return {
	FetchGamesProductInfo = require(script.FetchGamesProductInfo),
	GameProductInfo = GameProductInfo,
	GamesProductInfoReducer = require(script.GamesProductInfoReducer),
	useGameProductInfoSelector = require(script.useGameProductInfoSelector),
	["jest.config"] = script["jest.config"]
}
