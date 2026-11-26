local module = require("@luauforge/deferred/gHH")

local module2 = require("@luauforge/deferred/gHI")

return function(data, p2)
	local v5 = data.ChatAppReducer.PlaceInfos[p2.placeId] or {}
	local conversations = data.ChatAppReducer.Conversations
	local appLoaded = data.ChatAppReducer.AppLoaded

	local v6 = not v5.universeId and "" or module(data, (tostring(v5.universeId))).name

	local v7 = {}

	for k, conversation in pairs(conversations) do
		local aliases = data.ChatAppReducer.Aliases
		v7[k] = module2(data.Users, conversation, aliases)
	end

	return {
		appLoaded = appLoaded,
		placeInfo = v5,
		senderId = data.LocalUserId,
		conversations = v7,
		gameCreator = v5.builder,
		gameThumbnail = "",
		gameName = v6,
		byBuilderText = ""
	}
end
