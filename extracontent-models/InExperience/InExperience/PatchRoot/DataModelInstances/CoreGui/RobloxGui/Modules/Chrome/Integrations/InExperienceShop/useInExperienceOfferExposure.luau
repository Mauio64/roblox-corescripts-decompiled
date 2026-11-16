local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)

local InExperienceOffers = require(CorePackages.Workspace.Packages.InExperienceOffers)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)

local LocalStore = require(Chrome.ChromeShared.Service.LocalStore)

local FFlagOfferNotifyOnGlobalIcon = SharedFlags.FFlagOfferNotifyOnGlobalIcon

local getOffersStore = InExperienceOffers.getOffersStore
local isNotificationEligible = InExperienceOffers.Utils.isNotificationEligible
local NotificationLocation = InExperienceOffers.NotificationLocation

local defineFastString = game:DefineFastString("InExperienceOfferExposureStorageKey", "InExperienceOfferExposure")

local defineFastInt = game:DefineFastInt("InExperienceOfferExposureMaxStoredOffers", 50)

local offerIdSet = {}

local function loadPersistedTally()
	local loadForLocalPlayer = LocalStore.loadForLocalPlayer(defineFastString)
	local persistedTally = {}

	if type(loadForLocalPlayer) ~= "table" then
		return persistedTally
	end

	for k, v in loadForLocalPlayer do
		if not (type(k) == "string" and type(v) == "table" and type(v.exposureCount) == "number") then
			continue
		end

		if type(v.lastExposureUTCTime) ~= "string" then
			continue
		end

		persistedTally[k] = {
			exposureCount = v.exposureCount,
			lastExposureUTCTime = v.lastExposureUTCTime
		}
	end

	return persistedTally
end

local function withOldestEvicted(items)
	local v = {}

	for k in items do
		table.insert(v, k)
	end

	if #v <= defineFastInt then
		return items
	end

	table.sort(v, function(a, b): boolean
		return items[a].lastExposureUTCTime > items[b].lastExposureUTCTime
	end)

	local result = {}

	for i = 1, defineFastInt do
		local v2 = v[i]
		result[v2] = items[v2]
	end

	return result
end

local function tallyExposures(items, p)
	if items == nil or p == nil then
		return
	end

	local offerIds = {}

	for _, item in items do
		for _, v in item do
			if offerIdSet[v.offerId] or not isNotificationEligible(v, p) then
				continue
			end

			offerIdSet[v.offerId] = true
			table.insert(offerIds, v.offerId)
		end
	end

	if #offerIds == 0 then
		return
	end

	local v = loadPersistedTally()
	local isoDate = DateTime.now():ToIsoDate()

	for _, v2 in offerIds do
		local v3 = v[v2]
		v[v2] = {
			exposureCount = v3 == nil and 1 or v3.exposureCount + 1,
			lastExposureUTCTime = isoDate
		}
	end

	local v2 = withOldestEvicted(v)
	LocalStore.storeForLocalPlayer(defineFastString, v2)
end

local function useInExperienceOfferExposure()
	React.useEffect(function()
		local offersStore = getOffersStore(false)

		offersStore.hydrateOfferExposureSnapshot(loadPersistedTally())

		return Signals.createEffect(function(p)
			if FFlagOfferNotifyOnGlobalIcon then
				if offersStore.getOfferNotificationShownWithEnum(p) == NotificationLocation.None then
					return
				end
			elseif not offersStore.getIsShopAvailable(p) then
				return
			end

			tallyExposures(offersStore.getOffers(p), offersStore.getOfferExposureSnapshot(p))
		end)
	end, {})
end

return useInExperienceOfferExposure
