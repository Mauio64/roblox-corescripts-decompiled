local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local CorePackages = game:GetService("CorePackages")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAXEnableInspectAndBuyBulkPurchase = SharedFlags.FFlagAXEnableInspectAndBuyBulkPurchase
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FIntBulkPurchaseRequestLimit = SharedFlags2.FIntBulkPurchaseRequestLimit
local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local FIntBulkPurchaseThrottleLimit = SharedFlags3.FIntBulkPurchaseThrottleLimit

local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagFilterOutShopOnlyItemsOnBulkPurchase = SharedFlags4.FFlagFilterOutShopOnlyItemsOnBulkPurchase

local SharedFlags5 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAXEnableTimedOptionsServerScript = SharedFlags5.FFlagAXEnableTimedOptionsServerScript

if FFlagAXEnableInspectAndBuyBulkPurchase then
	local serverSideBulkPurchaseEvent = Instance.new("RemoteEvent")
	serverSideBulkPurchaseEvent.Name = "ServerSideBulkPurchaseEvent"
	serverSideBulkPurchaseEvent.Parent = RobloxReplicatedStorage
	local v = {}

	local _ = {
		MyExperiencesOnly = "MyExperiencesOnly",
		ExperiencesById = "ExperiencesById",
		ExperiencesDevApiOnly = "ExperiencesDevApiOnly"
	}

	local v2 = FFlagFilterOutShopOnlyItemsOnBulkPurchase and { ShopOnly = "ShopOnly" } or nil

	local _ = { Limited = "Limited", LimitedUnique = "LimitedUnique", Collectible = "Collectible" }

	local v3 = {
		["Bundle"] = Enum.MarketplaceProductType.AvatarBundle,
		Asset = Enum.MarketplaceProductType.AvatarAsset
	}

	local function getBatchItemDetailsServerSide(items) -- 1 equivalent call inferred from this helper
		local success, result = pcall(function()
			local v4 = Url.CATALOG_URL .. "v1/catalog/items/details"
			local v5

			if FFlagAXEnableTimedOptionsServerScript then
				local items2 = {}

				for _, item in items do
					table.insert(items2, { id = item.id, itemType = item.itemType })
				end

				v5 = HttpService:JSONEncode({ items = items2 })
			else
				v5 = HttpService:JSONEncode({ items = items })
			end

			return HttpService:JSONDecode((HttpRbxApiService:PostAsyncFullUrl(
				v4,
				v5,
				Enum.ThrottlingPriority.Default,
				Enum.HttpContentType.ApplicationJson
			)))
		end)
		return if success then result else nil
	end

	local function isLimited(p): boolean
		local itemRestrictions = p.itemRestrictions
		local index = itemRestrictions and table.find(itemRestrictions, "Limited")
		local index2 = itemRestrictions and table.find(itemRestrictions, "LimitedUnique")
		local index3 = itemRestrictions and table.find(itemRestrictions, "Collectible")
		return index ~= nil or index2 ~= nil or index3 ~= nil
	end

	local function validatePlayer(p): boolean -- 1 equivalent call inferred from this helper
		return if p.UserId and not (p.UserId <= 0) then true else false
	end

	local function validateItem(item): boolean
		return type(item) == "table"
			and item.id ~= nil
			and item.itemType ~= nil
			and type(item.itemType) == "number"
			and type(item.id) == "number"
			and item.id ~= 0
			and (item.itemType == Enum.AvatarItemType.Asset.Value or item.itemType == Enum.AvatarItemType.Bundle.Value)
	end

	local function validateIncomingItems(list)
		local result = {}

		if not list or type(list) ~= "table" or FIntBulkPurchaseRequestLimit < #list then
			return nil
		end

		local count = 0

		for _, item in list do
			if FIntBulkPurchaseRequestLimit <= count then
				break
			end

			if not validateItem(item) then
				continue
			end

			local v4 = { id = item.id, itemType = item.itemType, PurchaseOptions = 0 }
			local purchaseOptions

			if FFlagAXEnableTimedOptionsServerScript then
				purchaseOptions = item.PurchaseOptions
			end

			v4.PurchaseOptions = purchaseOptions
			table.insert(result, v4)

			count += 1
		end

		return result
	end

	local function isThrottled(p): boolean -- 1 equivalent call inferred from this helper
		local v4 = v[p]

		if v4 and tick() < v4 then
			return true
		end

		v[p] = tick() + FIntBulkPurchaseThrottleLimit
		return false
	end

	Players.PlayerRemoving:Connect(function(player)
		v[player] = nil
	end)

	serverSideBulkPurchaseEvent.OnServerEvent:Connect(function(p, p2)
		if not validatePlayer(p) or isThrottled(p) then -- inferred equivalent call
			return
		end

		local items = validateIncomingItems(p2)

		if items == nil or #items == 0 then
			return
		end

		local batchItemDetailsServerSide = getBatchItemDetailsServerSide(items) -- inferred equivalent call
		local purchaseOptionsById = FFlagAXEnableTimedOptionsServerScript and {} or nil

		if FFlagAXEnableTimedOptionsServerScript then
			for _, v4 in items do
				if v4.PurchaseOptions and purchaseOptionsById then
					purchaseOptionsById[v4.id] = v4.PurchaseOptions
				end
			end
		end

		local v4 = {}

		if batchItemDetailsServerSide ~= nil then
			for _, v5 in batchItemDetailsServerSide.data do
				if not (v5.saleLocationType ~= "MyExperiencesOnly" and v5.saleLocationType ~= "ExperiencesById" and v5.saleLocationType ~= "ExperiencesDevApiOnly" or v5.unitsAvailableForConsumption == 0 and isLimited(v5)) then
					continue
				end

				if not (not FFlagFilterOutShopOnlyItemsOnBulkPurchase or not v2 or v5.saleLocationType ~= v2.ShopOnly or v5.unitsAvailableForConsumption == 0 and isLimited(v5)) then
					continue
				end

				local v6 = { Id = tostring(v5.id), Type = v3[v5.itemType], PurchaseOptions = 0 }
				local purchaseOptions

				if FFlagAXEnableTimedOptionsServerScript and purchaseOptionsById and purchaseOptionsById[v5.id] then
					purchaseOptions = purchaseOptionsById[v5.id]
				end

				v6.PurchaseOptions = purchaseOptions
				table.insert(v4, v6)
			end
		end

		if #v4 > 0 then
			MarketplaceService:PromptBulkPurchase(p, v4, {})
		end
	end)
end
