local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useDispatch = require(BulkPurchaseAppParent.RoactUtils).Hooks.RoactRodux.useDispatch
local InitiateBulkPurchaseFlow = require(BulkPurchaseApp.Store.Thunks.InitiateBulkPurchaseFlow)
local useNetwork = require(BulkPurchaseAppParent.EconomyCommonCoreScriptHooks).useNetwork

require(BulkPurchaseApp.Store.Types)

local PurchasableStateEnum = require(BulkPurchaseApp.Enums.PurchasableStateEnum)
local FFlagBulkPurchaseEnablePurchaseOptions = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseEnablePurchaseOptions)
local convertToDiscountInformationOrNil = require(BulkPurchaseApp.Utils.convertToDiscountInformationOrNil)

require(BulkPurchaseApp.Store.Types)

local function transformItemDataToBulkPurchaseItemData(t1: {[any]: any}) -- line: 24
	-- upvalues: PurchasableStateEnum (copy), FFlagBulkPurchaseEnablePurchaseOptions (copy)
	local t2 = {}

	for _, v17 in t1 do
		table.insert(t2, {
			id = v17.id,
			name = v17.name,
			description = v17.description,
			priceRobux = v17.priceRobux,
			type = v17.type,
			ownedCount = v17.ownedCount,
			quantityLimitPerUser = v17.quantityLimitPerUser,
			isLimited = v17.isLimited,
			purchasableState = if v17.purchaseableState ~= "Purchaseable" then v17.purchaseableState else PurchasableStateEnum.Purchasable,
			discountInformation = v17.discountInformation,
			purchaseOptions = if not FFlagBulkPurchaseEnablePurchaseOptions then nil else v17.purchaseOptions
		})
	end

	return t2
end
local function useBulkPurchaseRequestListenerEffect() -- line: 47
	-- upvalues: useDispatch (copy), useNetwork (copy), React (copy), MarketplaceService (copy), Players (copy), FFlagBulkPurchaseEnablePurchaseOptions (copy), BulkPurchaseApp (copy), InitiateBulkPurchaseFlow (copy), transformItemDataToBulkPurchaseItemData (copy), convertToDiscountInformationOrNil (copy)
	local v18 = useDispatch()
	local v19 = useNetwork()

	React.useEffect(function() -- line: 50
		-- upvalues: v18 (copy), v19 (copy), MarketplaceService (copy), Players (copy), FFlagBulkPurchaseEnablePurchaseOptions (copy), BulkPurchaseApp (copy), InitiateBulkPurchaseFlow (copy), transformItemDataToBulkPurchaseItemData (copy), convertToDiscountInformationOrNil (copy)
		local connection = nil

		if v18 and v19 then
			connection = MarketplaceService.PromptBulkPurchaseRequestedV2:Connect(function(p1, t3: {[any]: any}, p2, n1: number, n2: number, p3, p4) -- line: 54
				-- upvalues: Players (copy), FFlagBulkPurchaseEnablePurchaseOptions (copy), BulkPurchaseApp (copy), v18 (copy), InitiateBulkPurchaseFlow (copy), v19 (copy), transformItemDataToBulkPurchaseItemData (copy), convertToDiscountInformationOrNil (copy)
				if p1 == Players.LocalPlayer then
					if FFlagBulkPurchaseEnablePurchaseOptions and require(BulkPurchaseApp.Flags.FFlagBulkPurchaseReportsMissingPurchaseOptions) then
						require(BulkPurchaseApp.Utils.reportBulkPurchaseRequestIssues)(t3)
					end

					v18(InitiateBulkPurchaseFlow(v19, transformItemDataToBulkPurchaseItemData(t3), p2, n1, n2, p3, convertToDiscountInformationOrNil(p4)))
				end
			end)
		end

		return function() -- line: 88
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, {
		v18,
		v19
	})
end

return useBulkPurchaseRequestListenerEffect
