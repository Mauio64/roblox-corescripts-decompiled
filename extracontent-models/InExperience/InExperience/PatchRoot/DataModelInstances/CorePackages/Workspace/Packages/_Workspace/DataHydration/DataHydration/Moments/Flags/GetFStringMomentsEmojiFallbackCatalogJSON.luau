local HttpService = game:GetService("HttpService")

local DataHydration = script:FindFirstAncestor("DataHydration")

local compiledMomentsEmojiFallbackCatalog = require(DataHydration.Moments.Util.compiledMomentsEmojiFallbackCatalog)

local jsonEncode = HttpService:JSONEncode(compiledMomentsEmojiFallbackCatalog.COMPILED_MOMENTS_EMOJI_FALLBACK_API_PAYLOAD)

game:DefineFastString("MomentsEmojiFallbackCatalogJSON", jsonEncode)

return function()
	return game:GetFastString("MomentsEmojiFallbackCatalogJSON")
end
