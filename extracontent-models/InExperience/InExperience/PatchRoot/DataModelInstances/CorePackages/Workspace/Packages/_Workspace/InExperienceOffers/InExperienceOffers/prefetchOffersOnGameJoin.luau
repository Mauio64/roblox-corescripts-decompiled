local InExperienceOffers = script:FindFirstAncestor("InExperienceOffers")
local parent = InExperienceOffers.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableOffersPrefetch = SharedFlags.FFlagEnableOffersPrefetch
local FIntOffersPrefetchDelayMs = require(InExperienceOffers.Flags.FIntOffersPrefetchDelayMs)
local FStringOffersPrefetchFeatureKeys = require(InExperienceOffers.Flags.FStringOffersPrefetchFeatureKeys)

local GetOffersStore = require(InExperienceOffers.Stores.GetOffersStore)
require(InExperienceOffers.Enums.FeatureKey)
local whenJoinSettles = require(InExperienceOffers.JoinLifecycle.whenJoinSettles)
local schedulePrefetchDelay = require(InExperienceOffers.JoinLifecycle.schedulePrefetchDelay)
local OffersDebugLogger = require(InExperienceOffers.Internal.OffersDebugLogger)

local function parseFeatureKeys(FStringOffersPrefetchFeatureKeys2: string)
	local featureKeys = {}

	for _, v in string.split(FStringOffersPrefetchFeatureKeys2, ",") do
		local match = v:match("^%s*(.-)%s*$")

		if match and match ~= "" then
			table.insert(featureKeys, match)
		end
	end

	return featureKeys
end

local v = parseFeatureKeys(FStringOffersPrefetchFeatureKeys)

local function triggerFetch() -- 1 equivalent call inferred from this helper
	if #v == 0 then
		return
	end

	GetOffersStore(false).fetchOffers(v)
end

local function prefetchOffersOnGameJoin()
	if not FFlagEnableOffersPrefetch then
		return
	end

	OffersDebugLogger.log("prefetchOffersOnGameJoin: waiting for join to settle")
	whenJoinSettles(function(p)
		OffersDebugLogger.logLazy(function()
			return "prefetchOffersOnGameJoin: join settled path=" .. p
		end)

		local v2 = FIntOffersPrefetchDelayMs

		if not (v2 <= 0) then
			schedulePrefetchDelay(v2 / 1000, triggerFetch)
			return
		end

		triggerFetch() -- inferred equivalent call
	end)
end

return prefetchOffersOnGameJoin
