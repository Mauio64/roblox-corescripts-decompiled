local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)
local IXPServiceWrapper = require(parent.IXPServiceWrapper)
local ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector

local InitiateBulkPurchaseFlow = require(BulkPurchaseApp.Store.Thunks.InitiateBulkPurchaseFlow)
local EconomyCommonCoreScriptHooks = require(parent.EconomyCommonCoreScriptHooks)
local useNetwork = EconomyCommonCoreScriptHooks.useNetwork
require(BulkPurchaseApp.Store.Types)
local PurchasableStateEnum = require(BulkPurchaseApp.Enums.PurchasableStateEnum)
local BulkPurchasePromptStateEnum = require(BulkPurchaseApp.Enums.BulkPurchasePromptStateEnum)
local selectPromptState = require(BulkPurchaseApp.Store.Selectors.selectPromptState)
local BulkPurchaseRefreshed = require(BulkPurchaseApp.Store.Actions.BulkPurchaseRefreshed)
local BulkPurchaseFailed = require(BulkPurchaseApp.Store.Actions.BulkPurchaseFailed)
local ErrorCodeEnum = require(BulkPurchaseApp.Enums.ErrorCodeEnum)
local BulkPurchaseCountersEnum = require(BulkPurchaseApp.Enums.BulkPurchaseCountersEnum)
local reportBulkPurchaseRequestCounters = require(BulkPurchaseApp.Utils.reportBulkPurchaseRequestCounters)

local FFlagBulkPurchaseEnablePurchaseOptions = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseEnablePurchaseOptions)
local FFlagAXAddPlusUpsellToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddPlusUpsellToBulkPurchase)
local FFlagBulkPurchaseReportCounters = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseReportCounters)
local FFlagAXAddOffersToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddOffersToBulkPurchase)
local convertToDiscountInformationOrNil = require(BulkPurchaseApp.Utils.convertToDiscountInformationOrNil)
local defineFastFlag = game:DefineFastFlag("AXAddPlusUpsellToBulkPurchaseExposure", false)

local defineFastString = game:DefineFastString(
	"AXAddPlusUpsellToBulkPurchaseLayerName",
	"AvatarExperience.UA.MarketplaceView"
)

require(BulkPurchaseApp.Store.Types)

local function decodeLuauUnicodeEscapes(value: string)
	return (value:gsub("\\u{(%x+)}", function(p: string)
		local v = tonumber(p, 16)

		if v == nil or v < 0 or v > 1114111 then
			return ""
		end

		return utf8.char(v)
	end))
end

local function getOffersAvailableMap(availableOffers)
	local offersAvailableMap = {}

	if availableOffers == nil then
		return offersAvailableMap
	end

	for _, item in availableOffers do
		offersAvailableMap[item.offerId] = item

		if item.localizedDescription then
			item.localizedDescription = item.localizedDescription:gsub("\\u{(%x+)}", function(p: string)
				local v = tonumber(p, 16)

				if v == nil or v < 0 or v > 1114111 then
					return ""
				end

				return utf8.char(v)
			end)
		end
	end

	return offersAvailableMap
end

local function transformItemDataToBulkPurchaseItemData(items)
	local result = {}

	for _, item in items do
		local v = {
			id = item.id,
			name = item.name,
			description = item.description,
			priceRobux = item.priceRobux,
			type = item.type,
			ownedCount = item.ownedCount,
			quantityLimitPerUser = item.quantityLimitPerUser,
			isLimited = item.isLimited,
			purchasableState = 0,
			discountInformation = 0,
			purchaseOptions = 0
		}
		local purchasableState

		if item.purchaseableState == "Purchaseable" then
			purchasableState = PurchasableStateEnum.Purchasable
		else
			purchasableState = item.purchaseableState
		end

		v.purchasableState = purchasableState

		v.discountInformation = item.discountInformation
		local purchaseOptions

		if FFlagBulkPurchaseEnablePurchaseOptions then
			purchaseOptions = item.purchaseOptions
		end

		v.purchaseOptions = purchaseOptions
		table.insert(result, v)
	end

	return result
end

local function useBulkPurchaseRequestListenerEffect()
	local v = useDispatch()
	local v2 = useNetwork()
	local v3

	if FFlagAXAddPlusUpsellToBulkPurchase then
		v3 = useSelector(selectPromptState) == BulkPurchasePromptStateEnum.Request
	else
		v3 = nil
	end

	if FFlagAXAddOffersToBulkPurchase then
		React.useEffect(function()
			local connection = nil

			if v and v2 then
				local success, result = pcall(function()
					return MarketplaceService.PromptBulkPurchaseRequestedV3:Connect(function(p, _: string, data)
						local orderRequest = data.orderRequest
						local purchaserRobuxBalance = data.purchaserRobuxBalance
						local orderTotalRobux = data.orderTotalRobux
						local options = data.options
						local discountInformation = data.discountInformation

						if p == Players.LocalPlayer then
							if
								FFlagBulkPurchaseEnablePurchaseOptions
								and require(BulkPurchaseApp.Flags.FFlagBulkPurchaseReportsMissingPurchaseOptions)
							then
								local reportBulkPurchaseRequestIssues = require(BulkPurchaseApp.Utils.reportBulkPurchaseRequestIssues)
								reportBulkPurchaseRequestIssues(data.displayData)
							end

							if defineFastFlag then
								ixpServiceWrapper:LogFlagLinkedUserLayerExposure(defineFastString)
							end

							local v4 = {
								offersAvailable = getOffersAvailableMap(data.availableOffers),
								savingsSummary = 0
							}
							local savingsSummary

							if data.savingsSummary then
								savingsSummary = data.savingsSummary:gsub("\\u{(%x+)}", function(p2: string)
									local v5 = tonumber(p2, 16)

									if v5 == nil or v5 < 0 or v5 > 1114111 then
										return ""
									end

									return utf8.char(v5)
								end)
							end

							v4.savingsSummary = savingsSummary

							v(InitiateBulkPurchaseFlow(
								v2,
								transformItemDataToBulkPurchaseItemData(data.displayData),
								orderRequest,
								purchaserRobuxBalance,
								orderTotalRobux,
								options,
								convertToDiscountInformationOrNil(discountInformation),
								v4
							))
						end
					end)
				end)

				if success then
					connection = result
				end
			end

			return function()
				if connection then
					connection:Disconnect()
					connection = nil
				end
			end
		end, { v, v2 })
	else
		React.useEffect(function()
			local promptBulkPurchaseRequestedV2Connection

			if v and v2 then
				promptBulkPurchaseRequestedV2Connection = MarketplaceService.PromptBulkPurchaseRequestedV2:Connect(function(p, p2, p3, p4: number, p5: number, p6, p7)
					if p == Players.LocalPlayer then
						if
							FFlagBulkPurchaseEnablePurchaseOptions
							and require(BulkPurchaseApp.Flags.FFlagBulkPurchaseReportsMissingPurchaseOptions)
						then
							local reportBulkPurchaseRequestIssues = require(BulkPurchaseApp.Utils.reportBulkPurchaseRequestIssues)
							reportBulkPurchaseRequestIssues(p2)
						end

						if defineFastFlag then
							ixpServiceWrapper:LogFlagLinkedUserLayerExposure(defineFastString)
						end

						v(InitiateBulkPurchaseFlow(
							v2,
							transformItemDataToBulkPurchaseItemData(p2),
							p3,
							p4,
							p5,
							p6,
							convertToDiscountInformationOrNil(p7)
						))
					end
				end)
			else
				promptBulkPurchaseRequestedV2Connection = nil
			end

			return function()
				if promptBulkPurchaseRequestedV2Connection then
					promptBulkPurchaseRequestedV2Connection:Disconnect()
					promptBulkPurchaseRequestedV2Connection = nil
				end
			end
		end, { v, v2 })
	end

	if FFlagAXAddPlusUpsellToBulkPurchase then
		React.useEffect(function()
			local connection = nil

			if v3 then
				local success, result = pcall(function()
					return MarketplaceService.PromptBulkPurchaseRefreshed:Connect(function(p, p2, data)
						local v4

						if FFlagAXAddOffersToBulkPurchase then
							v4 = {
								offersAvailable = getOffersAvailableMap(data.availableOffers),
								savingsSummary = 0
							}
							local savingsSummary

							if data.savingsSummary then
								savingsSummary = data.savingsSummary:gsub("\\u{(%x+)}", function(p3: string)
									local v5 = tonumber(p3, 16)

									if v5 == nil or v5 < 0 or v5 > 1114111 then
										return ""
									end

									return utf8.char(v5)
								end)
							end

							v4.savingsSummary = savingsSummary
						end

						if p == Players.LocalPlayer and p2 == Enum.MarketplaceBulkPurchasePromptStatus.Completed then
							if FFlagAXAddOffersToBulkPurchase then
								v(BulkPurchaseRefreshed(
									transformItemDataToBulkPurchaseItemData(data.displayData),
									data.orderRequest,
									data.purchaserRobuxBalance,
									data.orderTotalRobux,
									data.options,
									convertToDiscountInformationOrNil(data.discountInformation),
									v4
								))
							else
								v(BulkPurchaseRefreshed(
									transformItemDataToBulkPurchaseItemData(data.displayData),
									data.orderRequest,
									data.purchaserRobuxBalance,
									data.orderTotalRobux,
									data.options,
									convertToDiscountInformationOrNil(data.discountInformation)
								))
							end
						else
							if FFlagBulkPurchaseReportCounters then
								reportBulkPurchaseRequestCounters(BulkPurchaseCountersEnum.BulkPurchaseRefreshFailedCounter)
							end

							v(BulkPurchaseFailed(ErrorCodeEnum.Generic))
						end
					end)
				end)

				if success then
					connection = result
				end
			end

			return function()
				if connection then
					connection:Disconnect()
				end
			end
		end, { v, v3 })
	end
end
return useBulkPurchaseRequestListenerEffect
