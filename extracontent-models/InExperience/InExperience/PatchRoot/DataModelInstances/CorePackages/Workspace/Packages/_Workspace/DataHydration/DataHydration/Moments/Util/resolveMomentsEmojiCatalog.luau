local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.MomentsTypes)

local GetFStringMomentsEmojiFallbackCatalogJSON = require(DataHydration.Moments.Flags.GetFStringMomentsEmojiFallbackCatalogJSON)
local FFlagMomentsEmojiSetsApi = require(DataHydration.Moments.FFlagMomentsEmojiSetsApi)
local FFlagMomentsReactToFeedItemV2 = require(DataHydration.Moments.FFlagMomentsReactToFeedItemV2)
local compiledMomentsEmojiFallbackCatalog = require(DataHydration.Moments.Util.compiledMomentsEmojiFallbackCatalog)
local decodeEmojiSets = require(DataHydration.Moments.Util.decodeEmojiSets)
local hardcodedMomentsEmojis = require(DataHydration.Moments.Util.hardcodedMomentsEmojis)
local parseMomentsEmojiFallbackCatalog = require(DataHydration.Moments.Util.parseMomentsEmojiFallbackCatalog)
local validateMomentsEmojiCatalog = require(DataHydration.Moments.Util.validateMomentsEmojiCatalog)

local decodeGetEmojiSetsResponse = decodeEmojiSets.decodeGetEmojiSetsResponse(compiledMomentsEmojiFallbackCatalog.COMPILED_MOMENTS_EMOJI_FALLBACK_API_PAYLOAD)

local flattenEmojis = decodeEmojiSets.flattenEmojis(decodeGetEmojiSetsResponse)

local function resolveFromCachedResponse(p) -- 1 equivalent call inferred from this helper
	if validateMomentsEmojiCatalog.isValidCachedGetEmojiSetsResponse(p) then
		return decodeEmojiSets.flattenEmojis(p)
	end

	return nil
end

local function resolveFromFString() -- 1 equivalent call inferred from this helper
	return parseMomentsEmojiFallbackCatalog.parseMomentsEmojiFallbackCatalogJson(GetFStringMomentsEmojiFallbackCatalogJSON())
end

local ResolveMomentsEmojiCatalog = {}

function ResolveMomentsEmojiCatalog.resolveMomentsEmojiCatalog(p)
	if not FFlagMomentsEmojiSetsApi then
		return { emojis = hardcodedMomentsEmojis, source = "legacy" }
	end

	local emojis = resolveFromCachedResponse(p) -- inferred equivalent call

	if emojis ~= nil then
		return { emojis = emojis, source = "cache" }
	end

	if not FFlagMomentsReactToFeedItemV2 then
		return { emojis = hardcodedMomentsEmojis, source = "legacy" }
	end

	local emojis2 = resolveFromFString() -- inferred equivalent call

	if emojis2 == nil then
		return { emojis = flattenEmojis, source = "compiled" }
	end

	return { emojis = emojis2, source = "fstring" }
end

function ResolveMomentsEmojiCatalog.shouldUseLegacyWireStringCatalog(): boolean
	return not FFlagMomentsEmojiSetsApi
end

function ResolveMomentsEmojiCatalog.shouldUseUuidFallbackCatalog()
	return FFlagMomentsReactToFeedItemV2
end

return ResolveMomentsEmojiCatalog
