local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Promise = require(CorePackages.Packages.Promise)
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local PlayabilityStatusEnum = DiscoveryTypes.PlayabilityStatusEnum

local mockAssetData = {
	{
		id = 100425207,
		name = "Reinforced Wizard",
		assetType = { id = 8, name = "Hat" }
	},
	{
		id = 2510238627,
		name = "Rthro Run",
		assetType = { id = 53, name = "Run Animation" }
	},
	{
		id = 2807164805,
		name = "Mech Golem - Head",
		assetType = { id = 17, name = "Head" }
	}
}

local mockAssetBundlesData = {
	data = {
		{
			id = 451,
			name = "test name",
			description = "test description",
			bundleType = "testBundleType",
			items = {
				{ owned = false, id = 2510230574, name = "test asset name" },
				{ owned = false, id = 2510233257, name = "test asset name 2" },
				{ owned = false, type = "UserOutfit", id = 2510233258, name = "Outfit" }
			},
			creator = { id = 1, name = "test creator name" },
			product = { id = 480872498, isForSale = true, priceInRobux = 250 }
		}
	}
}

local humanoidDescription = Instance.new("HumanoidDescription")
humanoidDescription.HatAccessory = 1
humanoidDescription.LeftArm = 2
humanoidDescription.ClimbAnimation = 3
humanoidDescription.BodyTypeScale = 0.3
humanoidDescription.LeftLegColor = Color3.new(0, 0, 0)
humanoidDescription.GraphicTShirt = 4

local humanoidDescription2 = Instance.new("HumanoidDescription")
humanoidDescription2:SetEmotes({
	Wave = { 1 },
	Laugh = { 2 },
	Cheer = { 3 }
})

local humanoidDescription3 = Instance.new("HumanoidDescription")

local v = { assetId = 123, userId = 401784814, created = "" }

local testname = {
	Name = "test name",
	Description = "test description",
	PriceInRobux = 100,
	Creator = { Id = 1, Name = "TEST CREATOR" },
	AssetId = 100425207,
	AssetTypeId = 8,
	ProductId = 18929548
}

local v2 = { Owned = true, IsPurchasable = false, Id = 100425207, ItemType = "Asset" }

local economyProductInfo = {
	purchasable = false,
	reason = "InsufficientFunds",
	price = 200,
	assetId = 10
}

local v3 = {
	playabilityStatus = PlayabilityStatusEnum.Playable,
	universeId = 13,
	isPlayable = true
}

local v4 = { name = "fakename", id = 13, rootPlaceId = 17 }

local function getRobloxProductInfo(assetId)
	local joined = Cryo.Dictionary.join(testname, { AssetId = assetId })
	return Promise.resolve(joined)
end

local function getProductInfo(assetId)
	local joined = Cryo.Dictionary.join(testname, { AssetId = assetId })
	joined.Creator.Id = 2
	return Promise.resolve(joined)
end

local function getItemDetails(id, itemType)
	local joined = Cryo.Dictionary.join(v2, { Id = id, ItemType = itemType })
	return Promise.resolve(joined)
end

local function getBatchItemDetails(list)
	local values = {}

	for _, item in ipairs(list) do
		table.insert(values, Cryo.Dictionary.join(v2, { Id = item }))
	end

	return Promise.resolve(values)
end

local versionInfo = {
	data = {
		{ assetId = 17, creatingUniverseId = 13 }
	}
}

local function getVersionInfo(assetId)
	local joined = Cryo.Dictionary.join(versionInfo, { AssetId = assetId })
	return Promise.resolve(joined)
end

local function getExperiencePlayability(universeId)
	local v5 = { (Cryo.Dictionary.join(v3, { universeId = universeId })) }
	return Promise.resolve(v5)
end

local function getExperienceInfo(id)
	local joined = Cryo.Dictionary.join(v4, { id = id })
	return Promise.resolve({
		data = { joined }
	})
end

local function getAssetBundles(_)
	return Promise.resolve(mockAssetBundlesData)
end

local function getPlayerName(_)
	return Promise.resolve("TEST")
end

local function createFavoriteForAsset(_)
	return Promise.resolve()
end

local function createFavoriteForBundle(_)
	return Promise.resolve()
end

local function deleteFavoriteForAsset(_)
	return Promise.resolve()
end

local function deleteFavoriteForBundle(_)
	return Promise.resolve()
end

local function getAssetFavoriteCount(_)
	return Promise.resolve(120)
end

local function getBundleFavoriteCount(_)
	return Promise.resolve(120)
end

local function getFavoriteForAsset(p)
	if p == "GetFavoriteModel" then
		return Promise.resolve(v)
	end

	return Promise.resolve("null")
end

local function getFavoriteForBundle(p)
	if p == "GetFavoriteModel" then
		return Promise.resolve(v)
	end

	return Promise.resolve("null")
end

local function getEconomyProductInfo(_)
	return Promise.resolve(economyProductInfo)
end

local function getModelFromUserId(_)
	return Promise.resolve()
end

local function networkFailure(_, _)
	return Promise.reject("Failed to access network service")
end

local MockNetwork = {}
MockNetwork.__index = MockNetwork

function MockNetwork.new(p, p2)
	local v5

	if p then
		v5 = {
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
	else
		v5 = {
			getProductInfo = p2 and getProductInfo or getRobloxProductInfo,
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
		}
	end

	setmetatable(v5, {
		__tostring = function(): string
			return "MockService(Network)"
		end
	})

	return v5
end

function MockNetwork.GetMockAssetData()
	return mockAssetData
end

function MockNetwork.GetMockHumanoidDescription()
	return humanoidDescription
end

function MockNetwork.GetMockHumanoidDescriptionEmpty()
	return humanoidDescription3
end

function MockNetwork.GetMockPlayerName(): string
	return "TEST"
end

function MockNetwork.GetMockAssetBundlesData()
	return mockAssetBundlesData
end

function MockNetwork.GetMockFavoriteCount(): number
	return 120
end

function MockNetwork.GetFavoriteModelId(): string
	return "GetFavoriteModel"
end

function MockNetwork.GetProductInfo()
	return testname
end

function MockNetwork.GetEconomyProductInfo()
	return economyProductInfo
end

function MockNetwork.GetMockHumanoidDescriptionEmotes()
	return humanoidDescription2
end

function MockNetwork.GetVersionInfo()
	return versionInfo
end

function MockNetwork.GetExperiencePlayability()
	return { v3 }
end

function MockNetwork.GetExperienceInfo()
	return {
		data = { v4 }
	}
end

return MockNetwork
