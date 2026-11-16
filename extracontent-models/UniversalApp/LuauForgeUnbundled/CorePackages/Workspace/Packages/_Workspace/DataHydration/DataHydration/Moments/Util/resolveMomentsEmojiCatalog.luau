require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")

local GetFStringMomentsEmojiFallbackCatalogJSON = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Flags/GetFStringMomentsEmojiFallbackCatalogJSON")
local FFlagMomentsEmojiSetsApi = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/FFlagMomentsEmojiSetsApi")
local FFlagMomentsReactToFeedItemV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/FFlagMomentsReactToFeedItemV2")
local compiledMomentsEmojiFallbackCatalog = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/compiledMomentsEmojiFallbackCatalog")
local decodeEmojiSets = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/decodeEmojiSets")
local hardcodedMomentsEmojis = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/hardcodedMomentsEmojis")
local parseMomentsEmojiFallbackCatalog = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/parseMomentsEmojiFallbackCatalog")
local validateMomentsEmojiCatalog = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/validateMomentsEmojiCatalog")

local decodeGetEmojiSetsResponse = decodeEmojiSets.decodeGetEmojiSetsResponse(compiledMomentsEmojiFallbackCatalog.COMPILED_MOMENTS_EMOJI_FALLBACK_API_PAYLOAD)

local flattenEmojis = decodeEmojiSets.flattenEmojis(decodeGetEmojiSetsResponse)

local function resolveFromCachedResponse(p2)
	if validateMomentsEmojiCatalog.isValidCachedGetEmojiSetsResponse(p2) then
		return decodeEmojiSets.flattenEmojis(p2)
	end

	return nil
end

local function resolveFromFString()
	return parseMomentsEmojiFallbackCatalog.parseMomentsEmojiFallbackCatalogJson(GetFStringMomentsEmojiFallbackCatalogJSON())
end

return {
	resolveMomentsEmojiCatalog = function(p2)
		if not FFlagMomentsEmojiSetsApi then
			return { emojis = hardcodedMomentsEmojis, source = "legacy" }
		end

		local v5 = if validateMomentsEmojiCatalog.isValidCachedGetEmojiSetsResponse(p2) then decodeEmojiSets.flattenEmojis(p2) else nil

		if v5 ~= nil then
			return { emojis = v5, source = "cache" }
		end

		if not FFlagMomentsReactToFeedItemV2 then
			return { emojis = hardcodedMomentsEmojis, source = "legacy" }
		end

		local momentsEmojiFallbackCatalogJson = parseMomentsEmojiFallbackCatalog.parseMomentsEmojiFallbackCatalogJson(GetFStringMomentsEmojiFallbackCatalogJSON())

		if momentsEmojiFallbackCatalogJson == nil then
			return { emojis = flattenEmojis, source = "compiled" }
		end

		return { emojis = momentsEmojiFallbackCatalogJson, source = "fstring" }
	end,
	shouldUseLegacyWireStringCatalog = function(): boolean
		return not FFlagMomentsEmojiSetsApi
	end,
	shouldUseUuidFallbackCatalog = function()
		return FFlagMomentsReactToFeedItemV2
	end
}
