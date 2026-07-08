local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local CorePackages = game:GetService("CorePackages")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Url = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Url
local FFlagAXEnableInspectAndBuyBulkPurchase = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXEnableInspectAndBuyBulkPurchase
local FIntBulkPurchaseRequestLimit = require(CorePackages.Workspace.Packages.SharedFlags).FIntBulkPurchaseRequestLimit
local FIntBulkPurchaseThrottleLimit = require(CorePackages.Workspace.Packages.SharedFlags).FIntBulkPurchaseThrottleLimit
local FFlagFilterOutShopOnlyItemsOnBulkPurchase = require(CorePackages.Workspace.Packages.SharedFlags).FFlagFilterOutShopOnlyItemsOnBulkPurchase
local FFlagAXEnableTimedOptionsServerScript = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXEnableTimedOptionsServerScript

if FFlagAXEnableInspectAndBuyBulkPurchase then
	local RemoteEvent = Instance.new("RemoteEvent")

	RemoteEvent.Name = "ServerSideBulkPurchaseEvent"
	RemoteEvent.Parent = RobloxReplicatedStorage

	local t1 = {}
	local _ = {
		MyExperiencesOnly = "MyExperiencesOnly",
		ExperiencesById = "ExperiencesById",
		ExperiencesDevApiOnly = "ExperiencesDevApiOnly"
	}
	local v16 = if not FFlagFilterOutShopOnlyItemsOnBulkPurchase then nil else {
		ShopOnly = "ShopOnly"
	}
	local _ = {
		Limited = "Limited",
		LimitedUnique = "LimitedUnique",
		Collectible = "Collectible"
	}
	local t2 = {
		Bundle = Enum.MarketplaceProductType.AvatarBundle,
		Asset = Enum.MarketplaceProductType.AvatarAsset
	}

	local function getBatchItemDetailsServerSide(p1) -- line: 77
		-- upvalues: Url (copy), FFlagAXEnableTimedOptionsServerScript (copy), HttpService (copy), HttpRbxApiService (copy)
		local ok, result = pcall(function() -- line: 78
			-- upvalues: Url (copy), FFlagAXEnableTimedOptionsServerScript (copy), p1 (copy), HttpService (copy), HttpRbxApiService (copy)
			local v57 = Url.CATALOG_URL .. "v1/catalog/items/details"
			local json

			if FFlagAXEnableTimedOptionsServerScript then
				local t3 = {}

				for _, v60 in p1 do
					table.insert(t3, {
						id = v60.id,
						itemType = v60.itemType
					})
				end

				json = HttpService:JSONEncode({
					items = t3
				})
			else
				json = HttpService:JSONEncode({
					items = p1
				})
			end

			local v62 = HttpRbxApiService:PostAsyncFullUrl(v57, json, Enum.ThrottlingPriority.Default, Enum.HttpContentType.ApplicationJson)

			return HttpService:JSONDecode(v62)
		end)

		if ok then
			return result
		end

		return nil
	end
	local function isLimited(p2) -- line: 121
		local itemRestrictions = p2.itemRestrictions
		local v30 = itemRestrictions and table.find(itemRestrictions, "Limited")
		local v31 = itemRestrictions and table.find(itemRestrictions, "LimitedUnique")
		local v32 = itemRestrictions and table.find(itemRestrictions, "Collectible")

		return v30 ~= nil or (v31 ~= nil or v32 ~= nil)
	end
	local function validatePlayer(p3) -- line: 132
		if not p3.UserId or p3.UserId <= 0 then
			return false
		end

		return true
	end
	local function validateItem(t4: {[any]: any}) -- line: 143
		if type(t4) ~= "table" or (t4.id == nil or t4.itemType == nil or type(t4.itemType) ~= "number" or type(t4.id) ~= "number" or t4.id == 0) or t4.itemType ~= Enum.AvatarItemType.Asset.Value and t4.itemType ~= Enum.AvatarItemType.Bundle.Value then
			return false
		end

		return true
	end
	local function validateIncomingItems(t5: {[any]: any}) -- line: 161
		-- upvalues: FIntBulkPurchaseRequestLimit (copy), validateItem (copy), FFlagAXEnableTimedOptionsServerScript (copy)
		local t6 = {}

		if not t5 then
			return nil
		end

		if type(t5) ~= "table" then
			return nil
		end

		if #t5 > FIntBulkPurchaseRequestLimit then
			return nil
		end

		local n1 = 0

		for _, v39 in t5 do
			if n1 >= FIntBulkPurchaseRequestLimit then
				return t6
			end

			if validateItem(v39) then
				table.insert(t6, {
					id = v39.id,
					itemType = v39.itemType,
					PurchaseOptions = if not FFlagAXEnableTimedOptionsServerScript then nil else v39.PurchaseOptions
				})
				n1 += 1
			end
		end

		return t6
	end
	local function isThrottled(p4) -- line: 195
		-- upvalues: t1 (copy), FIntBulkPurchaseThrottleLimit (copy)
		local v41 = t1[p4]

		if v41 and v41 > tick() then
			return true
		end

		t1[p4] = tick() + FIntBulkPurchaseThrottleLimit

		return false
	end

	Players.PlayerRemoving:Connect(function(player) -- line: 204
		-- upvalues: t1 (copy)
		t1[player] = nil
	end)
	RemoteEvent.OnServerEvent:Connect(function(player, t7: {[any]: any}) -- line: 208
		-- upvalues: t1 (copy), FIntBulkPurchaseThrottleLimit (copy), validateIncomingItems (copy), Url (copy), FFlagAXEnableTimedOptionsServerScript (copy), HttpService (copy), HttpRbxApiService (copy), isLimited (copy), FFlagFilterOutShopOnlyItemsOnBulkPurchase (copy), v16 (copy), t2 (copy), MarketplaceService (copy)
		if not player.UserId or player.UserId <= 0 then
			return
		end

		local v45 = t1[player]
		local v46

		if v45 and v45 > tick() then
			v46 = true
		else
			t1[player] = tick() + FIntBulkPurchaseThrottleLimit
			v46 = false
		end

		if v46 then
			return
		end

		local v47 = validateIncomingItems(t7)

		if v47 == nil or #v47 == 0 then
			return
		end

		local ok, result = pcall(function() -- line: 78
			-- upvalues: Url (copy), FFlagAXEnableTimedOptionsServerScript (copy), v47 (copy), HttpService (copy), HttpRbxApiService (copy)
			local v63 = Url.CATALOG_URL .. "v1/catalog/items/details"
			local json

			if FFlagAXEnableTimedOptionsServerScript then
				local t8 = {}

				for _, v66 in v47 do
					table.insert(t8, {
						id = v66.id,
						itemType = v66.itemType
					})
				end

				json = HttpService:JSONEncode({
					items = t8
				})
			else
				json = HttpService:JSONEncode({
					items = v47
				})
			end

			local v68 = HttpRbxApiService:PostAsyncFullUrl(v63, json, Enum.ThrottlingPriority.Default, Enum.HttpContentType.ApplicationJson)

			return HttpService:JSONDecode(v68)
		end)
		local v50 = if not ok then nil else result
		local v51 = if not FFlagAXEnableTimedOptionsServerScript then nil else {}

		if FFlagAXEnableTimedOptionsServerScript then
			for _, v53 in v47 do
				if v53.PurchaseOptions and v51 then
					v51[v53.id] = v53.PurchaseOptions
				end
			end
		end

		local t9 = {}

		if v50 ~= nil then
			for _, v56 in v50.data do
				if (v56.saleLocationType ~= "MyExperiencesOnly" and v56.saleLocationType ~= "ExperiencesById" and v56.saleLocationType ~= "ExperiencesDevApiOnly" or v56.unitsAvailableForConsumption == 0 and isLimited(v56)) and (not FFlagFilterOutShopOnlyItemsOnBulkPurchase or not v16 or v56.saleLocationType ~= v16.ShopOnly or v56.unitsAvailableForConsumption == 0 and isLimited(v56)) then
					table.insert(t9, {
						Id = tostring(v56.id),
						Type = t2[v56.itemType],
						PurchaseOptions = if not FFlagAXEnableTimedOptionsServerScript or (not v51 or not v51[v56.id]) then nil else v51[v56.id]
					})
				end
			end
		end

		if #t9 > 0 then
			MarketplaceService:PromptBulkPurchase(player, t9, {})
		end
	end)
end
