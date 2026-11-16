local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")
local HttpService = game:GetService("HttpService")

local module2 = require("@luauforge/bundled/dwM")

return function(callback, p2)
	module2.isType(
		p2,
		"boolean",
		"PostAgeVerificationOptOutCheckbox request expects showOverlay to be a boolean"
	)

	return callback(string.format("%s/v1/settings/verify/show-overlay", Url.VOICE_URL), "POST", {
		postBody = HttpService:JSONEncode({ showOverlay = p2 })
	})
end
