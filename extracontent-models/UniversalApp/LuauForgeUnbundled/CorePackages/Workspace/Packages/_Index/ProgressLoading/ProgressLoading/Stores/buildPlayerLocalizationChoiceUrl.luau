local url = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/UrlBuilder").UrlBuilder

local function buildPlayerLocalizationChoiceUrl(p2)
	return urlBuilder.new({
		base = url.GAME_INTERNATIONALIZATION_URL,
		path = "v1/user-localization-settings/player-choice/{universeId}"
	})({ universeId = p2 })
end

return buildPlayerLocalizationChoiceUrl
