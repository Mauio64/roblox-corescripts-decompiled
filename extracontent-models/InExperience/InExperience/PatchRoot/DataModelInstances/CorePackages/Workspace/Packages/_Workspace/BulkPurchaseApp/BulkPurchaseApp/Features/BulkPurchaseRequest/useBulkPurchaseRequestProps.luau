local MarketplaceService = game:GetService("MarketplaceService")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
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
local v31 = game:DefineFastFlag("FixBuyRobuxForAndroid", false)
local v32 = game:DefineFastFlag("FixBulkPurchaseStarterGuiRename", false)

require(script.Parent.BulkPurchaseRequest)

local function useBulkPurchaseRequestProps() -- line: 43
	-- upvalues: useDispatch (copy), useSelector (copy), selectBulkPurchaseRequestState (copy), selectPurchaseResults (copy), selectOrderRequest (copy), selectOptions (copy), selectItemData (copy), MarketplaceService (copy), BulkPurchaseEnded (copy), isErrorReasonContainsEconomicRestrictions (copy), handleEconomicRestrictionError (copy), getItemResultsFromResponse (copy), getCommonItemStatus (copy), BulkPurchaseSucceeded (copy), BulkPurchasePromptStateEnum (copy), BulkPurchaseFailed (copy), ItemStatusToErrorCodeMap (copy), ErrorCodeEnum (copy), getPaymentPlatform (copy), PaymentPlatformEnum (copy), v31 (copy), HttpService (copy), getRobuxStoreUrl (copy), BrowserService (copy), FFlagFixVP8143 (copy), React (copy), RunService (copy), getGuiObjectIsObscured (copy), v32 (copy), StarterGui (copy)
	local v34 = useDispatch()
	local v35 = useSelector(selectBulkPurchaseRequestState)
	local v36 = useSelector(selectPurchaseResults)
	local v37 = useSelector(selectOrderRequest)
	local v38 = useSelector(selectOptions)
	local v39 = useSelector(selectItemData)
	local totalCost = v35.totalCost
	local balance = v35.balance
	local u42 = nil
	local v43 = nil
	local u44 = nil

	if FFlagFixVP8143 then
		u42 = React.useRef(nil)

		local v45

		v43, v45 = React.useState(true)
		u44 = v45
		React.useEffect(function() -- line: 129
			-- upvalues: RunService (copy), u42 (ref), getGuiObjectIsObscured (copy), v32 (copy), StarterGui (copy), u44 (ref)
			local connection = RunService.Heartbeat:Connect(function() -- line: 130
				-- upvalues: u42 (ref), getGuiObjectIsObscured (copy), v32 (copy), StarterGui (copy), u44 (ref)
				if u42.current and (typeof(u42.current) == "Instance" and u42.current:IsA("GuiObject")) then
					local v53 = getGuiObjectIsObscured(u42.current)
					local v54 = if not v32 then game.StarterGui:GetCore("DevConsoleVisible") else StarterGui:GetCore("DevConsoleVisible")

					u44(v53 or v54)
				end
			end)

			return function() -- line: 143
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, {})
	end

	return {
		currentBalance = v35.balance,
		items = v35.items,
		ownedItems = v35.ownedItems,
		unpurchasableItems = v35.unpurchasableItems,
		onClose = function() -- line: 53
			-- upvalues: MarketplaceService (copy), v36 (copy), v34 (copy), BulkPurchaseEnded (copy)
			MarketplaceService:signalPromptBulkPurchaseFinished(2, v36)
			v34(BulkPurchaseEnded())
		end,
		onAccept = not (balance < totalCost) and function() -- line: 60
			-- upvalues: MarketplaceService (copy), v37 (copy), v38 (copy), isErrorReasonContainsEconomicRestrictions (copy), handleEconomicRestrictionError (copy), v34 (copy), getItemResultsFromResponse (copy), v39 (copy), getCommonItemStatus (copy), BulkPurchaseSucceeded (copy), BulkPurchasePromptStateEnum (copy), BulkPurchaseFailed (copy), ItemStatusToErrorCodeMap (copy), ErrorCodeEnum (copy)
			local ok, result = pcall(function() -- line: 61
				-- upvalues: MarketplaceService (copy), v37 (copy), v38 (copy)
				return MarketplaceService:PerformBulkPurchase(v37, v38)
			end)

			if ok and result then
				if result.message and isErrorReasonContainsEconomicRestrictions(result.message) then
					handleEconomicRestrictionError(result.message, v34)

					return
				end

				local v48 = getItemResultsFromResponse(result, v39)
				local v49 = getCommonItemStatus(v48)

				if not v49 then
					v34(BulkPurchaseSucceeded(BulkPurchasePromptStateEnum.PartialSuccess, v48))

					return
				end

				if v49 == Enum.MarketplaceItemPurchaseStatus.Success then
					v34(BulkPurchaseSucceeded(BulkPurchasePromptStateEnum.Success, v48))

					return
				end

				v34(BulkPurchaseFailed(ItemStatusToErrorCodeMap[v49]))

				return
			end

			if string.find(result, "403") then
				v34(BulkPurchaseFailed(ErrorCodeEnum.TwoStepVerificationRequired))

				return
			end

			v34(BulkPurchaseFailed(ErrorCodeEnum.Generic))
		end or function() -- line: 98
			-- upvalues: getPaymentPlatform (copy), PaymentPlatformEnum (copy), v31 (copy), HttpService (copy), getRobuxStoreUrl (copy), BrowserService (copy), v34 (copy), BulkPurchaseEnded (copy), BulkPurchaseFailed (copy), ErrorCodeEnum (copy)
			local v50 = getPaymentPlatform()

			if v50 == PaymentPlatformEnum.Desktop or v50 == PaymentPlatformEnum.Mobile then
				if v31 then
					local json = HttpService:JSONEncode({
						command = "open",
						url = getRobuxStoreUrl()
					})

					BrowserService:SendCommand(json)
				else
					BrowserService:OpenBrowserWindow(getRobuxStoreUrl())
				end

				v34(BulkPurchaseEnded())

				return
			end

			v34(BulkPurchaseFailed(ErrorCodeEnum.InsufficientRobux))
		end,
		totalCost = v35.totalCost,
		isDisabled = FFlagFixVP8143 and v43 or #v35.items == 0,
		purchaseButtonRef = if not FFlagFixVP8143 then nil else u42,
		discountInformation = v35.discountInformation
	}
end

return useBulkPurchaseRequestProps
