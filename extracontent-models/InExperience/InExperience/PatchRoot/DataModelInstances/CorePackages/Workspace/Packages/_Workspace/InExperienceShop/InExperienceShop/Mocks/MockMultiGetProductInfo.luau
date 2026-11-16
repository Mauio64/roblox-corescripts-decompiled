local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Promise = require(parent.Promise)
require(InExperienceShop.Types)
require(InExperienceShop.Api.multiGetProductInfo)

local v = {
	{
		id = "101",
		name = "product1",
		thumbnail = "rbxassetid://6789",
		price = 1,
		userBasePriceInRobux = 2,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "test",
		updated = "2026-02-09T22:14:44.486Z",
		creator = { name = "MockCreator", hasVerifiedBadge = false }
	},
	{
		id = "102",
		name = "product2",
		displayName = "Product Two",
		thumbnail = "rbxassetid://6789",
		price = 1,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "This is the description",
		updated = "2026-02-09T22:25:41.802Z",
		creator = { name = "MockCreator", hasVerifiedBadge = false }
	},
	{
		id = "103",
		name = "Dev2's` <3 Test",
		displayName = "Dev2's Love Test",
		thumbnail = "rbxassetid://6789",
		price = 1,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "Test Description...",
		updated = "2026-02-18T00:17:01.48Z",
		creator = { name = "MockCreator2", hasVerifiedBadge = false }
	},
	{
		id = "104",
		name = "Very Long Product1",
		thumbnail = "rbxassetid://6789",
		price = 2,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "Test",
		updated = "2026-04-21T04:37:16.988Z",
		creator = { name = "MockCreator", hasVerifiedBadge = false }
	},
	{
		id = "105",
		name = "Prod3",
		thumbnail = "rbxassetid://6789",
		price = 1,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "Test Description...",
		updated = "2026-04-21T04:29:53.708Z",
		creator = { name = "MockCreator3", hasVerifiedBadge = false }
	},
	{
		id = "106",
		name = "Prod5",
		thumbnail = "rbxassetid://6789",
		price = 2,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "",
		updated = "2026-04-21T04:36:12.611Z",
		creator = { name = "MockCreator44", hasVerifiedBadge = false }
	},
	{
		id = "107",
		name = "Prod7",
		thumbnail = "rbxassetid://6789",
		price = 2,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "Really long description that spans more than one line but could span multiple lines.",
		updated = "2026-04-21T04:36:37.726Z",
		creator = { name = "MockCreator5", hasVerifiedBadge = false }
	},
	{
		id = "108",
		name = "Prod8",
		thumbnail = "rbxassetid://6789",
		price = 2,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "Test &nbsp; Description with special characters <>#$%^&*()_+-=[]{}|\\:;\"'<>,.?/~`!",
		updated = "2026-04-21T04:37:03.186Z",
		creator = { name = "MockCreator", hasVerifiedBadge = false }
	},
	{
		id = "109",
		name = "Prod9",
		thumbnail = "rbxassetid://6789",
		price = 5,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "Test Description...",
		updated = "2026-04-21T04:36:50.442Z",
		creator = { name = "MockCreator", hasVerifiedBadge = false }
	},
	{
		id = "110",
		name = "Prod11",
		thumbnail = "rbxassetid://6789",
		price = 100,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "Test Description...",
		updated = "2026-04-25T00:01:47.859Z",
		creator = { name = "MockCreator", hasVerifiedBadge = false }
	},
	{
		id = "111",
		name = "Tire replacement (HARD)",
		displayName = "Hard Tire Replacement",
		thumbnail = "rbxassetid://6789",
		price = 45,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "",
		updated = "2025-12-15T22:53:13.711Z",
		creator = { name = "MockCreator2", hasVerifiedBadge = false }
	},
	{
		id = "112",
		name = "Tire replacement (SOFT)",
		thumbnail = "rbxassetid://6789",
		price = 45,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "Replace your car tires to SOFT",
		updated = "2025-12-15T22:44:39.501Z",
		creator = { name = "MockCreator3", hasVerifiedBadge = false }
	},
	{
		id = "113",
		name = "Steering boost",
		thumbnail = "rbxassetid://6789",
		price = 135,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "More responsive steering",
		updated = "2025-12-15T23:01:33.255Z",
		creator = { name = "MockCreator4", hasVerifiedBadge = false }
	},
	{
		id = "114",
		name = "Breaking boost",
		thumbnail = "rbxassetid://6789",
		price = 90,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "Faster breaking",
		updated = "2025-12-15T23:00:34.873Z",
		creator = { name = "MockCreator", hasVerifiedBadge = false }
	},
	{
		id = "115",
		name = "Emoji Happy",
		displayName = "😊 Happy Emoji",
		thumbnail = "rbxassetid://6789",
		price = 10,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "Dev product with happy emoji",
		updated = "2026-05-11T18:35:49.447Z",
		creator = { name = "MockCreator", hasVerifiedBadge = false }
	},
	{
		id = "116",
		name = "Nitro",
		thumbnail = "rbxassetid://6789",
		price = 68,
		isOwned = false,
		itemType = "Product",
		universeId = "12345",
		description = "Single-use very fast acceleration",
		updated = "2025-12-15T23:02:44.396Z",
		creator = { name = "MockCreator", hasVerifiedBadge = false }
	}
}

local v2 = {
	{
		id = "201",
		name = "pass5",
		thumbnail = "rbxassetid://6789",
		price = 2,
		isOwned = false,
		itemType = "GamePass",
		universeId = "12345",
		description = "Test Description...",
		updated = "2026-04-21T04:39:24.953Z",
		creator = { name = "MockCreatorK", hasVerifiedBadge = false }
	},
	{
		id = "202",
		name = "pass5",
		thumbnail = "rbxassetid://6789",
		price = 4,
		isOwned = false,
		itemType = "GamePass",
		universeId = "12345",
		description = "Test Description...",
		updated = "2026-04-21T04:39:59.813Z",
		creator = { name = "MockCreatorK", hasVerifiedBadge = false }
	},
	{
		id = "203",
		name = "Thanks's` <3",
		displayName = "Thanks ❤️",
		thumbnail = "rbxassetid://6789",
		price = 1,
		isOwned = false,
		itemType = "GamePass",
		universeId = "12345",
		description = "Test Description...",
		updated = "2026-02-18T00:09:23.903Z",
		creator = { name = "MockCreatorK", hasVerifiedBadge = false }
	},
	{
		id = "204",
		name = "Thanks’s <3 :heart::victory_hand:t2:",
		thumbnail = "rbxassetid://6789",
		price = 1,
		isOwned = false,
		itemType = "GamePass",
		universeId = "12345",
		description = "Test",
		updated = "2026-02-18T00:05:06.047Z",
		creator = { name = "MockCreatorK", hasVerifiedBadge = false }
	},
	{
		id = "205",
		name = "pass1",
		thumbnail = "rbxassetid://6789",
		price = 2,
		isOwned = false,
		itemType = "GamePass",
		universeId = "12345",
		description = "test",
		updated = "2026-04-21T04:38:16.87Z",
		creator = { name = "MockCreatorK", hasVerifiedBadge = false }
	},
	{
		id = "206",
		name = "bear animal pass",
		thumbnail = "rbxassetid://6789",
		price = 7,
		isOwned = false,
		itemType = "GamePass",
		universeId = "12345",
		description = "Bear animal pass description",
		updated = "2026-05-11T20:11:28.05Z",
		creator = { name = "MockCreatorK", hasVerifiedBadge = false }
	},
	{
		id = "207",
		name = "Pass Coke",
		thumbnail = "rbxassetid://6789",
		price = 8,
		isOwned = false,
		itemType = "GamePass",
		universeId = "12345",
		description = "#########",
		updated = "2026-05-11T20:10:42.79Z",
		creator = { name = "MockCreatorK", hasVerifiedBadge = false }
	},
	{
		id = "3456",
		name = "Smiley pass",
		thumbnail = "rbxassetid://6789",
		price = 2,
		isOwned = false,
		itemType = "GamePass",
		universeId = "12345",
		description = "root pass for other passes",
		updated = "2026-05-11T19:33:39.1Z",
		creator = { name = "MockCreatorK", hasVerifiedBadge = false }
	},
	{
		id = "208",
		name = "Blue pass neutral",
		thumbnail = "rbxassetid://6789",
		price = 5,
		isOwned = false,
		itemType = "GamePass",
		universeId = "12345",
		description = "Get this pass with blue power",
		updated = "2026-05-11T19:40:01.477Z",
		creator = { name = "MockCreatorK", hasVerifiedBadge = false }
	},
	{
		id = "4242",
		name = "Bonus Game Pass",
		thumbnail = "rbxassetid://6789",
		price = 99,
		isOwned = false,
		itemType = "GamePass",
		universeId = "12345",
		description = "Bonus item for Robux packages",
		updated = "2026-05-20T12:00:00.000Z",
		creator = { name = "MockCreator", hasVerifiedBadge = false }
	}
}

local function buildLookup()
	local lookup = {}

	for _, v3 in ipairs(v) do
		lookup["Product:" .. v3.id] = v3
	end

	for _, v3 in ipairs(v2) do
		lookup["GamePass:" .. v3.id] = v3
	end

	return lookup
end

local lookup = buildLookup()

local function parseIconImageAssetId(thumbnail: string?) -- 1 equivalent call inferred from this helper
	if thumbnail then
		return tonumber((string.match(thumbnail, "rbxassetid://(%d+)"))) or 0
	end

	return 0
end

local function shopItemToProductInfo(data)
	local id = tonumber(data.id) or 0
	local creator = data.creator or { name = "", hasVerifiedBadge = false }
	local displayName = data.displayName
	return {
		Name = data.name,
		DisplayName = displayName,
		Description = data.description or "",
		PriceInRobux = data.price or 0,
		UserBasePriceInRobux = data.userBasePriceInRobux,
		ProductId = id,
		AssetId = id,
		IsForSale = true,
		Updated = data.updated,
		IconImageAssetId = parseIconImageAssetId(data.thumbnail), -- inferred equivalent call
		Creator = { Name = creator.name, HasVerifiedBadge = creator.hasVerifiedBadge }
	}
end

local function resolveRequest(item)
	local v3 = lookup[item.infoType.Name .. ":" .. tostring(item.id)]

	if v3 == nil then
		return {
			request = item,
			ok = false,
			err = string.format("Mock product info not found for %s id %s", item.infoType.Name, (tostring(item.id)))
		}
	end

	return { request = item, ok = true, value = shopItemToProductInfo(v3) }
end

local function resolveStreamDelaySeconds(p: number?) -- 1 equivalent call inferred from this helper
	if p == nil then
		return math.random() * 0.5
	elseif p == 0 then
		return 0
	end

	return math.random() * p
end

local MockMultiGetProductInfo = {
	MOCK_PRODUCT_ITEMS_FOR_TESTING = v,
	MOCK_GAMEPASS_ITEMS_FOR_TESTING = v2
}

function MockMultiGetProductInfo.multiGetProductInfo(list, p: number?)
	local v3 = p == nil and 0.5 or p
	return Promise.delay(v3):andThen(function()
		local result = table.create(#list)

		for i, item in ipairs(list) do
			result[i] = resolveRequest(item)
		end

		return result
	end)
end

function MockMultiGetProductInfo.streamMultiGetProductInfo(list, p, p2: number?)
	local count = #list

	if count == 0 then
		return Promise.resolve({})
	end

	local requests = table.create(count)
	local count2 = 0

	return Promise.new(function(callback)
		for i, item in ipairs(list) do
			Promise.delay(resolveStreamDelaySeconds(p2)):andThen(function() -- inferred equivalent call
				local request = resolveRequest(item)
				requests[i] = request
				p.onResult(request)
				count2 += 1

				if count2 == count then
					callback(requests)
				end
			end)
		end
	end)
end

return MockMultiGetProductInfo
