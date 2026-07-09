local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local ShareTargetGame = CoreGui.RobloxGui.Modules.ShareTargetGame
local getGameIcon = require(CorePackages.Workspace.Packages.GameIconRodux).GameIcons.getGameIcon
local getGameDetails = require(ShareTargetGame.Games.Selectors.getGameDetails)
local buildConversationModel = require(ShareTargetGame.ChatConversations.Models.buildConversationModel)

return function(p1, p2) -- line: 10
	-- upvalues: getGameIcon (copy), getGameDetails (copy), buildConversationModel (copy)
	local v9 = p1.ChatAppReducer.PlaceInfos[p2.placeId] or {}
	local Conversations = p1.ChatAppReducer.Conversations
	local AppLoaded = p1.ChatAppReducer.AppLoaded
	local s1 = ""
	local s2 = ""

	if v9.universeId then
		s1 = getGameIcon(p1, (tostring(v9.universeId)))
		s2 = getGameDetails(p1, (tostring(v9.universeId))).name
	end

	local t1 = {}

	for k, v in pairs(Conversations) do
		local Aliases = p1.ChatAppReducer.Aliases

		t1[k] = buildConversationModel(p1.Users, v, Aliases)
	end

	return {
		byBuilderText = "",
		appLoaded = AppLoaded,
		placeInfo = v9,
		senderId = p1.LocalUserId,
		conversations = t1,
		gameCreator = v9.builder,
		gameThumbnail = s1,
		gameName = s2
	}
end
