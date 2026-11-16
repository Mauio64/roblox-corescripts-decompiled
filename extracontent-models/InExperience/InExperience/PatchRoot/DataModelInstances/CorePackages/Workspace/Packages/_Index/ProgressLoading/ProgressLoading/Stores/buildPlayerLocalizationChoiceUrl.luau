local parent = script:FindFirstAncestor("ProgressLoading").Parent

local Http = require(parent.Http)
local Url = Http.Url
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local function buildPlayerLocalizationChoiceUrl(universeId: string)
	return urlBuilder.new({
		base = Url.GAME_INTERNATIONALIZATION_URL,
		path = "v1/user-localization-settings/player-choice/{universeId}"
	})({ universeId = universeId })
end

return buildPlayerLocalizationChoiceUrl
