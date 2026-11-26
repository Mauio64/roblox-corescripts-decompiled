local HttpService = game:GetService("HttpService")

local jsonEncode = HttpService:JSONEncode(require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/compiledMomentsEmojiFallbackCatalog").COMPILED_MOMENTS_EMOJI_FALLBACK_API_PAYLOAD)

game:DefineFastString("MomentsEmojiFallbackCatalogJSON", jsonEncode)

return function()
	return game:GetFastString("MomentsEmojiFallbackCatalogJSON")
end
