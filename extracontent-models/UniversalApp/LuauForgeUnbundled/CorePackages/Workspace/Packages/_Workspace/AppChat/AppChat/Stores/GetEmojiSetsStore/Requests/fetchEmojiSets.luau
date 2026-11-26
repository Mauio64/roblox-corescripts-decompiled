local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/HttpClient")

local decodeEmojiSets = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetEmojiSetsStore/decodeEmojiSets")

local v5 = Http.Url.APIS_URL .. "emoji-api/v1/get-emoji-sets?product=PlatformChat"

local function fetchEmojiSets(p2)
	return HttpClient.fetch({
		method = "GET",
		url = v5,
		analyticsKey = "app-chat.get-emoji-sets",
		network = p2,
		decode = decodeEmojiSets
	})
end

return fetchEmojiSets
