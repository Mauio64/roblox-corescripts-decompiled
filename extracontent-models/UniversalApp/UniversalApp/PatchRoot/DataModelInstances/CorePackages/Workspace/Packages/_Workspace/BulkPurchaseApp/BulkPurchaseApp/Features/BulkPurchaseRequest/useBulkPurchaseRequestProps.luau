local MarketplaceService = game:GetService("MarketplaceService")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local useDispatch = require(BulkPurchaseAppParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(BulkPurchaseAppParent.RoactUtils).Hooks.RoactRodux.useSelector
local React = require(BulkPurchaseAppParent.React)
local isErrorReasonContainsEconomicRestrictions = require(BulkPurchaseAppParent.IAPExperience).Utility.isErrorReasonContainsEconomicRestrictions
local selectPurchaseResults = require(BulkPurchaseApp.Store.Selectors.selectPurchaseResults)
local selectOrderRequest = require(BulkPurchaseApp.Store.Selectors.selectOrderRequest)
local selectItemData = require(BulkPurchaseApp.Store.Selectors.selectItemData)
local BulkPurchaseEnded = require(BulkPurchaseApp.Store.Actions.BulkPurchaseEnded)
local BulkPurchaseFailed = require(BulkPurchaseApp.Store.Actions.BulkPurchaseFailed)
local BulkPurchaseSucceeded = require(BulkPurchaseApp.Store.Actions.BulkPurchaseSucceeded)
local BulkPurchasePromptStateEnum = require(BulkPurchaseApp.Enums.BulkPurchasePromptStateEnum)
local ErrorCodeEnum = require(BulkPurchaseApp.Enums.ErrorCodeEnum)
local ItemStatusToErrorCodeMap = require(BulkPurchaseApp.Enums.ItemStatusToErrorCodeMap)
local PaymentPlatformEnum = require(BulkPurchaseApp.Enums.PaymentPlatformEnum)
local getPaymentPlatform = require(BulkPurchaseApp.Utils.getPaymentPlatform)
local getRobuxStoreUrl = require(BulkPurchaseApp.Utils.getRobuxStoreUrl)
local getGuiObjectIsObscured = require(BulkPurchaseApp.Utils.getGuiObjectIsObscured)
local FFlagFixVP8143 = require(BulkPurchaseApp.Flags.FFlagFixVP8143)
local getItemResultsFromResponse = require(script.Parent.Utils.getItemResultsFromResponse)
local getCommonItemStatus = require(script.Parent.Utils.getCommonItemStatus)
local handleEconomicRestrictionError = require(script.Parent.Utils.handleEconomicRestrictionError)
local selectBulkPurchaseRequestState = require(script.Parent.Utils.selectBulkPurchaseRequestState)
local selectOptions = require(script.Parent.Utils.selectOptions)
local v30 = game:DefineFastFlag("FixBuyRobuxForAndroid", false)

require(script.Parent.BulkPurchaseRequest)

local function useBulkPurchaseRequestProps() -- line: 41
	-- upvalues: useDispatch (copy), useSelector (copy), selectBulkPurchaseRequestState (copy), selectPurchaseResults (copy), selectOrderRequest (copy), selectOptions (copy), selectItemData (copy), MarketplaceService (copy), BulkPurchaseEnded (copy), isErrorReasonContainsEconomicRestrictions (copy), handleEconomicRestrictionError (copy), getItemResultsFromResponse (copy), getCommonItemStatus (copy), BulkPurchaseSucceeded (copy), BulkPurchasePromptStateEnum (copy), BulkPurchaseFailed (copy), ItemStatusToErrorCodeMap (copy), ErrorCodeEnum (copy), getPaymentPlatform (copy), PaymentPlatformEnum (copy), v30 (copy), HttpService (copy), getRobuxStoreUrl (copy), BrowserService (copy), FFlagFixVP8143 (copy), React (copy), RunService (copy), getGuiObjectIsObscured (copy)
	local v32 = useDispatch()
	local v33 = useSelector(selectBulkPurchaseRequestState)
	local v34 = useSelector(selectPurchaseResults)
	local v35 = useSelector(selectOrderRequest)
	local v36 = useSelector(selectOptions)
	local v37 = useSelector(selectItemData)
	local totalCost = v33.totalCost
	local balance = v33.balance
	local u40 = nil
	local v41 = nil
	local u42 = nil

	if FFlagFixVP8143 then
		u40 = React.useRef(nil)

		local v43

		v41, v43 = React.useState(true)
		u42 = v43
		React.useEffect(function() -- line: 127
			-- upvalues: RunService (copy), u40 (ref), getGuiObjectIsObscured (copy), u42 (ref)
			local connection = RunService.Heartbeat:Connect(function() -- line: 128
				-- upvalues: u40 (ref), getGuiObjectIsObscured (copy), u42 (ref)
				if u40.current and (typeof(u40.current) == "Instance" and u40.current:IsA("GuiObject")) then
					local v51 = getGuiObjectIsObscured(u40.current)
					local Core = game.StarterGui:GetCore("DevConsoleVisible")

					u42(v51 or Core)
				end
			end)

			return function() -- line: 139
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, {})
	end

	return {
		currentBalance = v33.balance,
		items = v33.items,
		ownedItems = v33.ownedItems,
		unpurchasableItems = v33.unpurchasableItems,
		onClose = function() -- line: 51
			-- upvalues: MarketplaceService (copy), v34 (copy), v32 (copy), BulkPurchaseEnded (copy)
			MarketplaceService:signalPromptBulkPurchaseFinished(2, v34)
			v32(BulkPurchaseEnded())
		end,
		onAccept = not (balance < totalCost) and function() -- line: 58
			-- upvalues: MarketplaceService (copy), v35 (copy), v36 (copy), isErrorReasonContainsEconomicRestrictions (copy), handleEconomicRestrictionError (copy), v32 (copy), getItemResultsFromResponse (copy), v37 (copy), getCommonItemStatus (copy), BulkPurchaseSucceeded (copy), BulkPurchasePromptStateEnum (copy), BulkPurchaseFailed (copy), ItemStatusToErrorCodeMap (copy), ErrorCodeEnum (copy)
			local ok, result = pcall(function() -- line: 59
				-- upvalues: MarketplaceService (copy), v35 (copy), v36 (copy)
				return MarketplaceService:PerformBulkPurchase(v35, v36)
			end)

			if ok and result then
				if result.message and isErrorReasonContainsEconomicRestrictions(result.message) then
					handleEconomicRestrictionError(result.message, v32)

					return
				end

				local v46 = getItemResultsFromResponse(result, v37)
				local v47 = getCommonItemStatus(v46)

				if not v47 then
					v32(BulkPurchaseSucceeded(BulkPurchasePromptStateEnum.PartialSuccess, v46))

					return
				end

				if v47 == Enum.MarketplaceItemPurchaseStatus.Success then
					v32(BulkPurchaseSucceeded(BulkPurchasePromptStateEnum.Success, v46))

					return
				end

				v32(BulkPurchaseFailed(ItemStatusToErrorCodeMap[v47]))

				return
			end

			if string.find(result, "403") then
				v32(BulkPurchaseFailed(ErrorCodeEnum.TwoStepVerificationRequired))

				return
			end

			v32(BulkPurchaseFailed(ErrorCodeEnum.Generic))
		end or function() -- line: 96
			-- upvalues: getPaymentPlatform (copy), PaymentPlatformEnum (copy), v30 (copy), HttpService (copy), getRobuxStoreUrl (copy), BrowserService (copy), v32 (copy), BulkPurchaseEnded (copy), BulkPurchaseFailed (copy), ErrorCodeEnum (copy)
			local v48 = getPaymentPlatform()

			if v48 == PaymentPlatformEnum.Desktop or v48 == PaymentPlatformEnum.Mobile then
				if v30 then
					local json = HttpService:JSONEncode({
						command = "open",
						url = getRobuxStoreUrl()
					})

					BrowserService:SendCommand(json)
				else
					BrowserService:OpenBrowserWindow(getRobuxStoreUrl())
				end

				v32(BulkPurchaseEnded())

				return
			end

			v32(BulkPurchaseFailed(ErrorCodeEnum.InsufficientRobux))
		end,
		totalCost = v33.totalCost,
		isDisabled = FFlagFixVP8143 and v41 or #v33.items == 0,
		purchaseButtonRef = if not FFlagFixVP8143 then nil else u40,
		discountInformation = v33.discountInformation
	}
end

return useBulkPurchaseRequestProps
