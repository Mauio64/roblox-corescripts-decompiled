local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpService = game:GetService("HttpService")

local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)

require(script.Parent.AvatarInventoryStoreTypes)

local InventoryOutfitTypeToInventoryTypeId = AvatarExperienceModel.Constants.InventoryOutfitTypeToInventoryTypeId

local function parseAvatarInventoryResponse(p)
	local items = (typeof(p) ~= "table" or typeof(p.avatarInventoryItems) ~= "table") and {} or p.avatarInventoryItems
	local nextPageToken

	if typeof(p) == "table" then
		nextPageToken = p.nextPageToken
	end

	if typeof(nextPageToken) ~= "string" or nextPageToken == "" then
		nextPageToken = nil
	end

	return { items = items, nextPageToken = nextPageToken }
end

local function buildQueryString(data, p: string?)
	local v = {
		pageLimit = data.pageLimit or 25,
		sortOption = data.sortOption or "recentAdded",
		pageToken = 0
	}
	local pageToken

	if p then
		pageToken = HttpService:UrlEncode(p)
	end

	v.pageToken = pageToken

	local count = 0
	local function addCategory(p2: string, p3: number) -- 2 equivalent calls inferred from this helper
		v[`itemCategories[{count}].itemType`] = p2
		v[`itemCategories[{count}].itemSubType`] = p3
		count += 1
	end

	for _, v2 in data.assetTypeIds or {} do
		addCategory("asset", v2) -- inferred equivalent call
	end

	for _, v2 in data.outfitInventoryTypes or {} do
		local v3 = InventoryOutfitTypeToInventoryTypeId[v2]

		if v3 == nil then
			error(`AvatarInventory: unknown outfit inventory type {v2}`)
		end

		addCategory("outfit", v3) -- inferred equivalent call
	end

	return Http.Url:makeQueryString(v)
end

local function fetchAvatarInventoryPage(p, p2: string?, options)
	local v = options or {}
	local v2 = string.gsub(v.baseUrl or Http.Url.AVATAR_URL, "/$", "")
	local fetched = HttpClient.fetch({
		network = v.network,
		method = "GET",
		url = `{v2}/v1/avatar-inventory?{buildQueryString(p, p2)}`,
		analyticsKey = "avatar.avatar-inventory.get",
		decode = parseAvatarInventoryResponse
	})

	return HttpClient.asPromise(fetched)
end

return fetchAvatarInventoryPage
