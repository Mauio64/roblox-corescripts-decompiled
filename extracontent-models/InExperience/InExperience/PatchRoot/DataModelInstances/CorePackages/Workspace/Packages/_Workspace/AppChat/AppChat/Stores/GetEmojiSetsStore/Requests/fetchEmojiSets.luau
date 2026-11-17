local parent = script:FindFirstAncestor("AppChat").Parent

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)

local decodeEmojiSets = require(script.Parent.Parent.decodeEmojiSets)

local url = Http.Url.APIS_URL .. "emoji-api/v1/get-emoji-sets?product=PlatformChat"

local function fetchEmojiSets(network)
	return HttpClient.fetch({
		method = "GET",
		url = url,
		analyticsKey = "app-chat.get-emoji-sets",
		network = network,
		decode = decodeEmojiSets
	})
end

return fetchEmojiSets
