local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dwM")

local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")
local module3 = require("@luauforge/bundled/fvu")

return {
	FetchPPEConfig = function(callback)
		return callback(string.format("%s/v1/avatar/thumbnail-customizations", Url.AVATAR_URL), "GET")
	end,
	WritePPEConfig = function(callback, p2, p3, p4, p5, p6)
		module.isType(p2, "userdata", "WebApi.WritePPEConfig expects thumbnailType to be a userdata")
		module.isTypeOrNil(p3, "string", "WebApi.WritePPEConfig expects emoteAssetId to be a string or nil")
		module.isType(p4, "number", "WebApi.WritePPEConfig expects cameraDistanceScale to be a number")
		module.isType(p5, "number", "WebApi.WritePPEConfig expects cameraYRotDeg to be a number")
		module.isType(p6, "number", "WebApi.WritePPEConfig expects fieldOfViewDeg to be a number")

		local v5 = string.format("%s/v1/avatar/thumbnail-customization", Url.AVATAR_URL)

		local v6 = not p3 and 0 or tonumber(p3)

		return callback(v5, "POST", {
			postBody = HttpService:JSONEncode({
				thumbnailType = module3.ConvertThumbnailTypeToInt(p2),
				emoteAssetId = v6,
				camera = { fieldOfViewDeg = p6, yRotDeg = p5, distanceScale = p4 }
			})
		})
	end
}
