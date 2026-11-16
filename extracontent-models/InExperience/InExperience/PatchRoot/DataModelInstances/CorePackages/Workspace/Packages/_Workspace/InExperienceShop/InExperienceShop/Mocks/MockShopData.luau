local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Promise = require(parent.Promise)
local Constants = require(InExperienceShop.Constants)
require(InExperienceShop.Types)

local v = {
	{
		id = "101",
		name = "product1",
		thumbnail = "rbxassetid://6789",
		price = 1,
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
	}
}

local robuxPackages = {
	{
		id = "229",
		productId = 229,
		mobileProductId = "com.roblox.client.robux40",
		robuxAmount = 40,
		currencyAmountStr = "$0.49",
		robuxImage = Constants.ROBUX_PACKAGE_IMAGE
	},
	{
		id = "613",
		productId = 613,
		mobileProductId = "com.roblox.robloxmobile.premium80robux",
		robuxAmount = 80,
		currencyAmountStr = "$0.99",
		robuxImage = Constants.ROBUX_PACKAGE_IMAGE
	},
	{
		id = "470",
		productId = 470,
		mobileProductId = "com.roblox.robloxmobile.premium400robux",
		robuxAmount = 400,
		currencyAmountStr = "$4.99",
		robuxImage = Constants.ROBUX_PACKAGE_IMAGE
	},
	{
		id = "471",
		productId = 471,
		mobileProductId = "com.roblox.robloxmobile.premium800robux",
		robuxAmount = 800,
		currencyAmountStr = "$9.99",
		robuxImage = Constants.ROBUX_PACKAGE_IMAGE
	},
	{
		id = "472",
		productId = 472,
		mobileProductId = "com.roblox.robloxmobile.premium1700robux",
		robuxAmount = 1700,
		currencyAmountStr = "$19.99",
		robuxImage = Constants.ROBUX_PACKAGE_IMAGE
	},
	{
		id = "473",
		productId = 473,
		mobileProductId = "com.roblox.robloxmobile.premium4500robux",
		robuxAmount = 4500,
		currencyAmountStr = "$49.99",
		robuxImage = Constants.ROBUX_PACKAGE_IMAGE
	},
	{
		id = "474",
		productId = 474,
		mobileProductId = "com.roblox.robloxmobile.premium10000robux",
		robuxAmount = 10000,
		currencyAmountStr = "$99.99",
		robuxImage = Constants.ROBUX_PACKAGE_IMAGE
	},
	{
		id = "21",
		productId = 21,
		mobileProductId = "com.roblox.client.robux22500",
		robuxAmount = 22500,
		currencyAmountStr = "$199.99",
		robuxImage = Constants.ROBUX_PACKAGE_IMAGE
	}
}

local function pickRandomItems()
	local v3 = table.create(#v + #v2)
	table.move(v, 1, #v, 1, v3)
	table.move(v2, 1, #v2, #v + 1, v3)

	for i = #v3, 2, -1 do
		local v4 = math.random(1, i)
		local v5 = v3[v4]
		local v6 = v3[i]
		v3[i] = v5
		v3[v4] = v6
	end

	local v4 = math.min(math.random(8, 10), #v3)
	local randomItems = table.create(v4)

	for i = 1, v4 do
		randomItems[i] = v3[i]
	end

	return randomItems
end

local v3 = {
	{ name = "Home" },
	{
		name = "Top picks",
		items = pickRandomItems(),
		categoryType = Constants.TOP_PICKS_CATEGORY_TYPE,
		stableCategoryId = "Top picks",
		categoryGroup = "Featured"
	},
	{ name = "Robux", robuxPackages = robuxPackages, bonusJwt = "mock-bonus-jwt" },
	{ name = "Coins", items = pickRandomItems() },
	{ name = "Boosts", items = pickRandomItems() },
	{ name = "Upgrades", items = pickRandomItems() },
	{ name = "Cosmetics", items = pickRandomItems() },
	{ name = "Gear", items = pickRandomItems() }
}

local function buildShopData()
	local categories = table.create(#v3)
	local sections = {}

	for i, v4 in ipairs(v3) do
		local id = tostring(i)
		categories[i] = { id = id, name = v4.name }

		if v4.name ~= "Home" then
			table.insert(sections, {
				id = id,
				name = v4.name,
				items = v4.items or {},
				robuxPackages = v4.robuxPackages,
				bonusJwt = v4.bonusJwt,
				categoryType = v4.categoryType,
				stableCategoryId = v4.stableCategoryId,
				categoryGroup = v4.categoryGroup
			})
		end
	end

	return { categories = categories, sections = sections }
end

local MockShopData = {
	MOCK_PRODUCT_ITEMS = v,
	MOCK_GAMEPASS_ITEMS = v2,
	buildShopItems = function()
		local categories = {}

		for _, v4 in ipairs(v3) do
			if not (v4.name ~= "Home" and v4.name ~= "Robux") then
				continue
			end

			local items = v4.items or {}
			local items2 = table.create(#items)

			for i, item in ipairs(items) do
				items2[i] = { id = i, type = item.itemType }
			end

			table.insert(categories, {
				id = #categories + 1,
				name = v4.name,
				items = items2
			})
		end

		return { categories = categories }
	end
}

function MockShopData.getShopData(p: number?)
	local v4 = p == nil and 0.5 or p
	return Promise.delay(v4):andThen(function()
		return buildShopData()
	end)
end

return MockShopData
