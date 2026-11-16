local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")
local parent = AvatarWorkshop.Parent

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

local AvatarInventory = require(parent.DataHydration.AvatarInventory)
require(AvatarWorkshop.Constants.InventoryPagesData)

local function getQuery(p)
	if p.assetTypes then
		local assetTypeIds = table.create(#p.assetTypes)

		for _, assetType in p.assetTypes do
			table.insert(assetTypeIds, assetType.Value)
		end

		return { assetTypeIds = assetTypeIds }
	elseif p.outfitInventoryType then
		return {
			outfitInventoryTypes = { p.outfitInventoryType }
		}
	else
		return nil
	end
end

local function createInventoryPageStore(p, p2)
	local v = p2 or AvatarInventory.getAvatarInventoryStore(false)
	local query = getQuery(p)

	local signal, v2 = createSignal({})
	local signal2, v3 = createSignal(false)
	local signal3, v4 = createSignal(false)
	local signal4, v5 = createSignal(false)
	local signal5, v6 = createSignal(false)

	local nextPageToken = nil

	local function applyPage(p3)
		nextPageToken = p3.nextPageToken
		v4(p3.nextPageToken == nil)

		if #p3.items > 0 then
			local clone = table.clone(signal(false))
			table.move(p3.items, 1, #p3.items, #clone + 1, clone)
			v2(clone)
		end
	end

	local function fetchNextPage()
		if signal4(false) or signal3(false) then
			return
		end

		if not query then
			warn("createInventoryPageStore: pageData must specify assetTypes or outfitInventoryType")
			return
		end

		v5(true)
		v6(false)

		v.fetchPage(query, nextPageToken):andThen(applyPage):catch(function(p3)
			if typeof(p3) == "table" then
				p3 = p3.errorMessage
			end

			warn("createInventoryPageStore: avatar-inventory fetch failed:", p3)
			v6(true)
		end):finally(function()
			v3(true)
			v5(false)
		end)
	end

	return {
		getEntries = signal,
		getDidInitialFetch = signal2,
		getLastPageReached = signal3,
		getIsFetching = signal4,
		getHasFetchError = signal5,
		fetchNextPage = fetchNextPage
	}
end

return createInventoryPageStore
