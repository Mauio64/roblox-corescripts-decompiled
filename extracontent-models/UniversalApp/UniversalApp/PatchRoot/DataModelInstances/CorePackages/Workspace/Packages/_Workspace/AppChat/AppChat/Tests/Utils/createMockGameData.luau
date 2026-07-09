local AppChat = script:FindFirstAncestor("AppChat")
local RoundedVariant = require(AppChat.Enums.RoundedVariant)

return function(t1: {[any]: any}?) -- line: 19
	-- upvalues: RoundedVariant (copy)
	local t2 = {
		gameName = "Test Game",
		gameThumbnail = "rbxassetid://12345",
		gameRating = "95%",
		gamePlayerCount = 1000,
		thumbnailAspectRatio = 1.7777777777777777,
		cornerRadius = 12,
		thumbnailRoundedVariant = RoundedVariant.Top
	}

	if not t1 then
		return t2
	end

	return {
		gameName = if t1.gameName == nil then t2.gameName else t1.gameName,
		gameThumbnail = if t1.gameThumbnail == nil then t2.gameThumbnail else t1.gameThumbnail,
		gameRating = if t1.gameRating == nil then t2.gameRating else t1.gameRating,
		gamePlayerCount = if t1.gamePlayerCount == nil then t2.gamePlayerCount else t1.gamePlayerCount,
		thumbnailAspectRatio = if t1.thumbnailAspectRatio == nil then t2.thumbnailAspectRatio else t1.thumbnailAspectRatio,
		thumbnailRoundedVariant = if t1.thumbnailRoundedVariant == nil then t2.thumbnailRoundedVariant else t1.thumbnailRoundedVariant,
		cornerRadius = if t1.cornerRadius == nil then t2.cornerRadius else t1.cornerRadius
	}
end
