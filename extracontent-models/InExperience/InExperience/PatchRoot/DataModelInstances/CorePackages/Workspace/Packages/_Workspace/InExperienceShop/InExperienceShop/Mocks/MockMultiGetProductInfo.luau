local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local Promise = require(InExperienceShopParent.Promise)

require(InExperienceShop.Types)
require(InExperienceShop.Api.multiGetProductInfo)

local t1 = {
	{
		id = "3520436958",
		name = "product1",
		thumbnail = "rbxassetid://139209047523431",
		price = 1,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "test",
		updated = "2026-02-09T22:14:44.486Z",
		creator = {
			name = "MockCreator",
			hasVerifiedBadge = false
		}
	},
	{
		id = "3533934241",
		name = "product2",
		displayName = "Product Two",
		thumbnail = "rbxassetid://87392709922646",
		price = 1,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "This is the description",
		updated = "2026-02-09T22:25:41.802Z",
		creator = {
			name = "MockCreator",
			hasVerifiedBadge = false
		}
	},
	{
		id = "3539559418",
		name = "Dev2's` <3 Test",
		displayName = "Dev2's Love Test",
		thumbnail = "rbxassetid://87631972256697",
		price = 1,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "Test Description...",
		updated = "2026-02-18T00:17:01.48Z",
		creator = {
			name = "MockCreator2",
			hasVerifiedBadge = false
		}
	},
	{
		id = "3579160491",
		name = "Very Long Product1",
		thumbnail = "rbxassetid://100887043069019",
		price = 2,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "Test",
		updated = "2026-04-21T04:37:16.988Z",
		creator = {
			name = "MockCreator",
			hasVerifiedBadge = false
		}
	},
	{
		id = "3579160539",
		name = "Prod3",
		thumbnail = "rbxassetid://81961804970825",
		price = 1,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "Test Description...",
		updated = "2026-04-21T04:29:53.708Z",
		creator = {
			name = "MockCreator3",
			hasVerifiedBadge = false
		}
	},
	{
		id = "3579160572",
		name = "Prod5",
		thumbnail = "rbxassetid://114076823404152",
		price = 2,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "",
		updated = "2026-04-21T04:36:12.611Z",
		creator = {
			name = "MockCreator44",
			hasVerifiedBadge = false
		}
	},
	{
		id = "3579166829",
		name = "Prod7",
		thumbnail = "rbxassetid://126948782997414",
		price = 2,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "Really long description that spans more than one line but could span multiple lines.",
		updated = "2026-04-21T04:36:37.726Z",
		creator = {
			name = "MockCreator5",
			hasVerifiedBadge = false
		}
	},
	{
		id = "3579166863",
		name = "Prod8",
		thumbnail = "rbxassetid://133455066661752",
		price = 2,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "Test &nbsp; Description with special characters <>#$%^&*()_+-=[]{}|\\:;\"'<>,.?/~`!",
		updated = "2026-04-21T04:37:03.186Z",
		creator = {
			name = "MockCreator",
			hasVerifiedBadge = false
		}
	},
	{
		id = "3579166918",
		name = "Prod9",
		thumbnail = "rbxassetid://104454970093144",
		price = 5,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "Test Description...",
		updated = "2026-04-21T04:36:50.442Z",
		creator = {
			name = "MockCreator",
			hasVerifiedBadge = false
		}
	},
	{
		id = "3579166948",
		name = "Prod11",
		thumbnail = "rbxassetid://79364533981550",
		price = 100,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "Test Description...",
		updated = "2026-04-25T00:01:47.859Z",
		creator = {
			name = "MockCreator",
			hasVerifiedBadge = false
		}
	},
	{
		id = "39470720",
		name = "Tire replacement (HARD)",
		displayName = "Hard Tire Replacement",
		thumbnail = "rbxassetid://122887820466566",
		price = 45,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "",
		updated = "2025-12-15T22:53:13.711Z",
		creator = {
			name = "testCreator2",
			hasVerifiedBadge = false
		}
	},
	{
		id = "39470718",
		name = "Tire replacement (SOFT)",
		thumbnail = "rbxassetid://130586726558884",
		price = 45,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "Replace your car tires to SOFT",
		updated = "2025-12-15T22:44:39.501Z",
		creator = {
			name = "testCreator3",
			hasVerifiedBadge = false
		}
	},
	{
		id = "39470724",
		name = "Steering boost",
		thumbnail = "rbxassetid://72184904612174",
		price = 135,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "More responsive steering",
		updated = "2025-12-15T23:01:33.255Z",
		creator = {
			name = "testCreator4",
			hasVerifiedBadge = false
		}
	},
	{
		id = "39470723",
		name = "Breaking boost",
		thumbnail = "rbxassetid://91006335819368",
		price = 90,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "Faster breaking",
		updated = "2025-12-15T23:00:34.873Z",
		creator = {
			name = "CreatorBoost",
			hasVerifiedBadge = false
		}
	},
	{
		id = "40896176",
		name = "Emoji Happy",
		displayName = "😊 Happy Emoji",
		thumbnail = "rbxassetid://81645138491017",
		price = 10,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "Dev product with happy emoji",
		updated = "2026-05-11T18:35:49.447Z",
		creator = {
			name = "testCreator1",
			hasVerifiedBadge = false
		}
	},
	{
		id = "39470725",
		name = "Nitro",
		thumbnail = "rbxassetid://121119743518857",
		price = 68,
		isOwned = false,
		itemType = "Product",
		universeId = "9238531179",
		description = "Single-use very fast acceleration",
		updated = "2025-12-15T23:02:44.396Z",
		creator = {
			name = "randomCreator",
			hasVerifiedBadge = false
		}
	}
}
local t2 = {
	{
		id = "1804642568",
		name = "pass5",
		thumbnail = "rbxassetid://87272847166128",
		price = 2,
		isOwned = false,
		itemType = "GamePass",
		universeId = "9238531179",
		description = "Test Description...",
		updated = "2026-04-21T04:39:24.953Z",
		creator = {
			name = "KickCodePrep",
			hasVerifiedBadge = false
		}
	},
	{
		id = "1804340575",
		name = "pass5",
		thumbnail = "rbxassetid://109612833123000",
		price = 4,
		isOwned = false,
		itemType = "GamePass",
		universeId = "9238531179",
		description = "Test Description...",
		updated = "2026-04-21T04:39:59.813Z",
		creator = {
			name = "KickCodePrep",
			hasVerifiedBadge = false
		}
	},
	{
		id = "1714448958",
		name = "Thanks's` <3",
		displayName = "Thanks ❤\239\184\143",
		thumbnail = "rbxassetid://77927364622086",
		price = 1,
		isOwned = false,
		itemType = "GamePass",
		universeId = "9238531179",
		description = "Test Description...",
		updated = "2026-02-18T00:09:23.903Z",
		creator = {
			name = "KickCodePrep",
			hasVerifiedBadge = false
		}
	},
	{
		id = "1716550603",
		name = "Thanks’s <3 :heart::victory_hand:t2:",
		thumbnail = "rbxassetid://125786017250029",
		price = 1,
		isOwned = false,
		itemType = "GamePass",
		universeId = "9238531179",
		description = "Test",
		updated = "2026-02-18T00:05:06.047Z",
		creator = {
			name = "KickCodePrep",
			hasVerifiedBadge = false
		}
	},
	{
		id = "1683715929",
		name = "pass1",
		thumbnail = "rbxassetid://104071175854790",
		price = 2,
		isOwned = false,
		itemType = "GamePass",
		universeId = "9238531179",
		description = "test",
		updated = "2026-04-21T04:38:16.87Z",
		creator = {
			name = "KickCodePrep",
			hasVerifiedBadge = false
		}
	},
	{
		id = "11836039",
		name = "bear animal pass",
		thumbnail = "rbxassetid://98258991849897",
		price = 7,
		isOwned = false,
		itemType = "GamePass",
		universeId = "9238531179",
		description = "Bear animal pass description",
		updated = "2026-05-11T20:11:28.05Z",
		creator = {
			name = "LeonardoCuteFingers",
			hasVerifiedBadge = false
		}
	},
	{
		id = "11839039",
		name = "Pass Coke",
		thumbnail = "rbxassetid://94688592507289",
		price = 8,
		isOwned = false,
		itemType = "GamePass",
		universeId = "9238531179",
		description = "#########",
		updated = "2026-05-11T20:10:42.79Z",
		creator = {
			name = "LeonardoCuteFingers",
			hasVerifiedBadge = false
		}
	},
	{
		id = "11809057",
		name = "Smiley pass",
		thumbnail = "rbxassetid://126864504460481",
		price = 2,
		isOwned = false,
		itemType = "GamePass",
		universeId = "9238531179",
		description = "root pass for other passes",
		updated = "2026-05-11T19:33:39.1Z",
		creator = {
			name = "LeonardoCuteFingers",
			hasVerifiedBadge = false
		}
	},
	{
		id = "11839038",
		name = "Blue pass neutral",
		thumbnail = "rbxassetid://78120758531563",
		price = 5,
		isOwned = false,
		itemType = "GamePass",
		universeId = "9238531179",
		description = "Get this pass with blue power",
		updated = "2026-05-11T19:40:01.477Z",
		creator = {
			name = "LeonardoCuteFingers",
			hasVerifiedBadge = false
		}
	},
	{
		id = "4242",
		name = "Bonus Game Pass",
		thumbnail = "rbxassetid://42424242424242",
		price = 99,
		isOwned = false,
		itemType = "GamePass",
		universeId = "9238531179",
		description = "Bonus item for Robux packages",
		updated = "2026-05-20T12:00:00.000Z",
		creator = {
			name = "MockCreator",
			hasVerifiedBadge = false
		}
	}
}

local function buildLookup() -- line: 441
	-- upvalues: t1 (copy), t2 (copy)
	local t3 = {}

	for _, v in ipairs(t1) do
		t3["Product:" .. v.id] = v
	end

	for _, v in ipairs(t2) do
		t3["GamePass:" .. v.id] = v
	end

	return t3
end

local v7 = buildLookup()

local function parseIconImageAssetId(s1: string?) -- line: 455
	if not s1 then
		return 0
	end

	return tonumber((string.match(s1, "rbxassetid://(%d+)"))) or 0
end
local function shopItemToProductInfo(p1) -- line: 463
	local v19 = tonumber(p1.id) or 0
	local v20 = p1.creator or {
		name = "",
		hasVerifiedBadge = false
	}
	local displayName = p1.displayName
	local t4 = {
		IsForSale = true,
		Name = p1.name,
		DisplayName = displayName,
		Description = p1.description or "",
		PriceInRobux = p1.price or 0,
		ProductId = v19,
		AssetId = v19,
		Updated = p1.updated
	}
	local thumbnail = p1.thumbnail

	t4.IconImageAssetId = if thumbnail then tonumber((string.match(thumbnail, "rbxassetid://(%d+)"))) or 0 else 0
	t4.Creator = {
		Name = v20.name,
		HasVerifiedBadge = v20.hasVerifiedBadge
	}

	return t4
end
local function resolveRequest(p2) -- line: 484
	-- upvalues: v7 (copy), shopItemToProductInfo (copy)
	local v25 = v7[p2.infoType.Name .. ":" .. tostring(p2.id)]

	if v25 == nil then
		return {
			ok = false,
			request = p2,
			err = string.format("Mock product info not found for %s id %s", p2.infoType.Name, (tostring(p2.id)))
		}
	end

	return {
		ok = true,
		request = p2,
		value = shopItemToProductInfo(v25)
	}
end
local function resolveStreamDelaySeconds(n1: number?) -- line: 506
	if n1 ~= nil then
		if n1 == 0 then
			return 0
		end

		return math.random() * n1
	end

	return math.random() * 0.5
end

return {
	MOCK_PRODUCT_ITEMS_FOR_TESTING = t1,
	MOCK_GAMEPASS_ITEMS_FOR_TESTING = t2,
	multiGetProductInfo = function(t5: {[any]: any}, n2: number?) -- line: 528
		-- upvalues: Promise (copy), resolveRequest (copy)
		local v29 = n2 == nil and 0.5 or n2

		return Promise.delay(v29):andThen(function() -- line: 533
			-- upvalues: t5 (copy), resolveRequest (copy)
			local t6 = table.create(#t5)

			for i, v in ipairs(t5) do
				t6[i] = resolveRequest(v)
			end

			return t6
		end)
	end,
	streamMultiGetProductInfo = function(t7: {[any]: any}, t8: {[any]: any}, n3: number?) -- line: 549
		-- upvalues: Promise (copy), resolveRequest (copy)
		local v33 = #t7

		if v33 == 0 then
			return Promise.resolve({})
		end

		local t9 = table.create(v33)
		local n4 = 0

		return Promise.new(function(resolve) -- line: 562
			-- upvalues: t7 (copy), Promise (copy), n3 (copy), resolveRequest (copy), t9 (copy), t8 (copy), n4 (ref), v33 (copy)
			for i, v in ipairs(t7) do
				local delay = Promise.delay
				local v43 = n3

				delay((if v43 == nil then math.random() * 0.5 else (if v43 ~= 0 then math.random() * v43 else 0))):andThen(function() -- line: 564
					-- upvalues: resolveRequest (copy), v (copy), t9 (copy), i (copy), t8 (copy), n4 (ref), v33 (copy), resolve (copy)
					local v44 = resolveRequest(v)

					t9[i] = v44
					t8.onResult(v44)
					n4 += 1

					if n4 == v33 then
						resolve(t9)
					end
				end)
			end
		end)
	end
}
