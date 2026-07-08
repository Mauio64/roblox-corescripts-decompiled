local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Promise = require(CorePackages.Packages.Promise)
local PlayabilityStatusEnum = require(CorePackages.Workspace.Packages.DiscoveryTypes).PlayabilityStatusEnum
local t1 = {
	[1] = {
		id = 100425207,
		name = "Reinforced Wizard",
		assetType = {
			id = 8,
			name = "Hat"
		}
	},
	[2] = {
		id = 2510238627,
		name = "Rthro Run",
		assetType = {
			id = 53,
			name = "Run Animation"
		}
	},
	[3] = {
		id = 2807164805,
		name = "Mech Golem - Head",
		assetType = {
			id = 17,
			name = "Head"
		}
	}
}
local t2 = {
	data = {
		[1] = {
			id = 451,
			name = "test name",
			description = "test description",
			bundleType = "testBundleType",
			items = {
				[1] = {
					owned = false,
					id = 2510230574,
					name = "test asset name"
				},
				[2] = {
					owned = false,
					id = 2510233257,
					name = "test asset name 2"
				},
				[3] = {
					owned = false,
					type = "UserOutfit",
					id = 2510233258,
					name = "Outfit"
				}
			},
			creator = {
				id = 1,
				name = "test creator name"
			},
			product = {
				id = 480872498,
				isForSale = true,
				priceInRobux = 250
			}
		}
	}
}
local HumanoidDescription = Instance.new("HumanoidDescription")

HumanoidDescription.HatAccessory = 1
HumanoidDescription.LeftArm = 2
HumanoidDescription.ClimbAnimation = 3
HumanoidDescription.BodyTypeScale = 0.3
HumanoidDescription.LeftLegColor = Color3.new(0, 0, 0)
HumanoidDescription.GraphicTShirt = 4

local HumanoidDescription2 = Instance.new("HumanoidDescription")

HumanoidDescription2:SetEmotes({
	Wave = { 1 },
	Laugh = { 2 },
	Cheer = { 3 }
})

local HumanoidDescription3 = Instance.new("HumanoidDescription")
local t3 = {
	assetId = 123,
	userId = 401784814,
	created = ""
}
local t4 = {
	Name = "test name",
	Description = "test description",
	PriceInRobux = 100,
	AssetId = 100425207,
	AssetTypeId = 8,
	ProductId = 18929548,
	Creator = {
		Id = 1,
		Name = "TEST CREATOR"
	}
}
local t5 = {
	Owned = true,
	IsPurchasable = false,
	Id = 100425207,
	ItemType = "Asset"
}
local t6 = {
	purchasable = false,
	reason = "InsufficientFunds",
	price = 200,
	assetId = 10
}
local t7 = {
	universeId = 13,
	isPlayable = true,
	playabilityStatus = PlayabilityStatusEnum.Playable
}
local t8 = {
	name = "fakename",
	id = 13,
	rootPlaceId = 17
}

local function getRobloxProductInfo(p1) -- line: 145
	-- upvalues: Cryo (copy), t4 (copy), Promise (copy)
	local v39 = Cryo.Dictionary.join(t4, {
		AssetId = p1
	})

	return Promise.resolve(v39)
end
local function getProductInfo(p2) -- line: 150
	-- upvalues: Cryo (copy), t4 (copy), Promise (copy)
	local v41 = Cryo.Dictionary.join(t4, {
		AssetId = p2
	})

	v41.Creator.Id = 2

	return Promise.resolve(v41)
end
local function getItemDetails(p3, p4) -- line: 156
	-- upvalues: Cryo (copy), t5 (copy), Promise (copy)
	local v44 = Cryo.Dictionary.join(t5, {
		Id = p3,
		ItemType = p4
	})

	return Promise.resolve(v44)
end
local function getBatchItemDetails(p5) -- line: 161
	-- upvalues: Cryo (copy), t5 (copy), Promise (copy)
	local t9 = {}

	for _, v in ipairs(p5) do
		table.insert(t9, Cryo.Dictionary.join(t5, {
			Id = v
		}))
	end

	return Promise.resolve(t9)
end

local t10 = {
	data = {{
		assetId = 17,
		creatingUniverseId = 13
	}}
}

local function getVersionInfo(p6) -- line: 183
	-- upvalues: Cryo (copy), t10 (copy), Promise (copy)
	local v50 = Cryo.Dictionary.join(t10, {
		AssetId = p6
	})

	return Promise.resolve(v50)
end
local function getExperiencePlayability(p7) -- line: 188
	-- upvalues: Cryo (copy), t7 (copy), Promise (copy)
	local v52 = Cryo.Dictionary.join(t7, {
		universeId = p7
	})

	return Promise.resolve({ v52 })
end
local function getExperienceInfo(p8) -- line: 193
	-- upvalues: Cryo (copy), t8 (copy), Promise (copy)
	local v54 = Cryo.Dictionary.join(t8, {
		id = p8
	})

	return Promise.resolve({
		data = { v54 }
	})
end
local function getAssetBundles(_) -- line: 198
	-- upvalues: Promise (copy), t2 (copy)
	return Promise.resolve(t2)
end
local function getPlayerName(_) -- line: 202
	-- upvalues: Promise (copy)
	return Promise.resolve("TEST")
end
local function createFavoriteForAsset(_) -- line: 206
	-- upvalues: Promise (copy)
	return Promise.resolve()
end
local function createFavoriteForBundle(_) -- line: 210
	-- upvalues: Promise (copy)
	return Promise.resolve()
end
local function deleteFavoriteForAsset(_) -- line: 214
	-- upvalues: Promise (copy)
	return Promise.resolve()
end
local function deleteFavoriteForBundle(_) -- line: 218
	-- upvalues: Promise (copy)
	return Promise.resolve()
end
local function getAssetFavoriteCount(_) -- line: 222
	-- upvalues: Promise (copy)
	return Promise.resolve(120)
end
local function getBundleFavoriteCount(_) -- line: 226
	-- upvalues: Promise (copy)
	return Promise.resolve(120)
end
local function getFavoriteForAsset(p17) -- line: 230
	-- upvalues: Promise (copy), t3 (copy)
	if p17 == "GetFavoriteModel" then
		return Promise.resolve(t3)
	end

	return Promise.resolve("null")
end
local function getFavoriteForBundle(p18) -- line: 238
	-- upvalues: Promise (copy), t3 (copy)
	if p18 == "GetFavoriteModel" then
		return Promise.resolve(t3)
	end

	return Promise.resolve("null")
end
local function getEconomyProductInfo(_) -- line: 246
	-- upvalues: Promise (copy), t6 (copy)
	return Promise.resolve(t6)
end
local function getModelFromUserId(_) -- line: 250
	-- upvalues: Promise (copy)
	return Promise.resolve()
end
local function networkFailure(_, _) -- line: 254
	-- upvalues: Promise (copy)
	return Promise.reject("Failed to access network service")
end

local t11 = {}

t11.__index = t11

function t11.new(p23, p24) -- line: 261
	-- upvalues: networkFailure (copy), getProductInfo (copy), getRobloxProductInfo (copy), getPlayerName (copy), getAssetBundles (copy), createFavoriteForAsset (copy), createFavoriteForBundle (copy), deleteFavoriteForAsset (copy), deleteFavoriteForBundle (copy), getAssetFavoriteCount (copy), getBundleFavoriteCount (copy), getFavoriteForAsset (copy), getFavoriteForBundle (copy), getEconomyProductInfo (copy), getModelFromUserId (copy), getVersionInfo (copy), getExperiencePlayability (copy), getExperienceInfo (copy), getItemDetails (copy), getBatchItemDetails (copy)
	local v71 = if not p23 then {
		getProductInfo = p24 and getProductInfo or getRobloxProductInfo,
		getPlayerName = getPlayerName,
		getAssetBundles = getAssetBundles,
		createFavoriteForAsset = createFavoriteForAsset,
		createFavoriteForBundle = createFavoriteForBundle,
		deleteFavoriteForAsset = deleteFavoriteForAsset,
		deleteFavoriteForBundle = deleteFavoriteForBundle,
		getAssetFavoriteCount = getAssetFavoriteCount,
		getBundleFavoriteCount = getBundleFavoriteCount,
		getFavoriteForAsset = getFavoriteForAsset,
		getFavoriteForBundle = getFavoriteForBundle,
		getEconomyProductInfo = getEconomyProductInfo,
		getModelFromUserId = getModelFromUserId,
		getVersionInfo = getVersionInfo,
		getExperiencePlayability = getExperiencePlayability,
		getExperienceInfo = getExperienceInfo,
		getItemDetails = getItemDetails,
		getBatchItemDetails = getBatchItemDetails
	} else {
		getProductInfo = networkFailure,
		getPlayerName = networkFailure,
		getAssetBundles = networkFailure,
		createFavoriteForAsset = networkFailure,
		createFavoriteForBundle = networkFailure,
		deleteFavoriteForAsset = networkFailure,
		deleteFavoriteForBundle = networkFailure,
		getAssetFavoriteCount = networkFailure,
		getBundleFavoriteCount = networkFailure,
		getFavoriteForAsset = networkFailure,
		getFavoriteForBundle = networkFailure,
		getEconomyProductInfo = networkFailure,
		getModelFromUserId = networkFailure,
		getVersionInfo = networkFailure,
		getExperiencePlayability = networkFailure,
		getExperienceInfo = networkFailure,
		getItemDetails = networkFailure,
		getBatchItemDetails = networkFailure
	}

	setmetatable(v71, {
		__tostring = function() -- line: 309
			return "MockService(Network)"
		end
	})

	return v71
end
function t11.GetMockAssetData() -- line: 317
	-- upvalues: t1 (copy)
	return t1
end
function t11.GetMockHumanoidDescription() -- line: 321
	-- upvalues: HumanoidDescription (copy)
	return HumanoidDescription
end
function t11.GetMockHumanoidDescriptionEmpty() -- line: 325
	-- upvalues: HumanoidDescription3 (copy)
	return HumanoidDescription3
end
function t11.GetMockPlayerName() -- line: 329
	return "TEST"
end
function t11.GetMockAssetBundlesData() -- line: 333
	-- upvalues: t2 (copy)
	return t2
end
function t11.GetMockFavoriteCount() -- line: 337
	return 120
end
function t11.GetFavoriteModelId() -- line: 341
	return "GetFavoriteModel"
end
function t11.GetProductInfo() -- line: 345
	-- upvalues: t4 (copy)
	return t4
end
function t11.GetEconomyProductInfo() -- line: 349
	-- upvalues: t6 (copy)
	return t6
end
function t11.GetMockHumanoidDescriptionEmotes() -- line: 353
	-- upvalues: HumanoidDescription2 (copy)
	return HumanoidDescription2
end
function t11.GetVersionInfo() -- line: 357
	-- upvalues: t10 (copy)
	return t10
end
function t11.GetExperiencePlayability() -- line: 361
	-- upvalues: t7 (copy)
	return { t7 }
end
function t11.GetExperienceInfo() -- line: 365
	-- upvalues: t8 (copy)
	return {
		data = { t8 }
	}
end

return t11
