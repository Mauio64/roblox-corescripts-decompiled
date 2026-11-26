local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")

local ContentProvider = game:GetService("ContentProvider")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local WebViewService = game:GetService("WebViewService")

local v5 = nil

pcall(function()
	local PlatformService = game:GetService("PlatformService")
	v5 = PlatformService
end)

local UpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/UpsellFlow")
local getUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/NativeUpsell/getUpsellFlow")
local GetFFlagEnablePaymentSessionIdInRobuxPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnablePaymentSessionIdInRobuxPurchase")

local getEngineFeaturePromptNativePurchaseWithContext = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/getEngineFeaturePromptNativePurchaseWithContext")
local fFlagEnableBonusJwtInShop = SharedFlags.FFlagEnableBonusJwtInShop

local function getWebBaseUrl()
	local baseUrl = ContentProvider.BaseUrl:lower()
	return (string.gsub(baseUrl, "/m%.", "/www."))
end

local function openRobuxPackageWebView(p2, callback)
	local onWindowClosedConnection = nil
	onWindowClosedConnection = WebViewService.OnWindowClosed:Connect(function()
		WebViewService:CloseWindow()

		if onWindowClosedConnection then
			onWindowClosedConnection:Disconnect()
			onWindowClosedConnection = nil
		end

		if callback then
			callback()
		end
	end)
	WebViewService:OpenWindow(p2, "", true)
end

local function tryLaunchNativePurchaseWithContext(data, paymentSessionId)
	local purchaseType = data.purchaseType
	local isInApp = data.isInApp

	if purchaseType == nil or isInApp == nil then
		return false
	end

	local v6 = MarketplaceService
	local promptNativePurchaseWithContext = v6.PromptNativePurchaseWithContext

	if typeof(promptNativePurchaseWithContext) ~= "function" then
		return false
	end

	local v7 = { paymentSessionId = 0, purchaseType = 0, isInApp = 0 }

	if paymentSessionId == "" then
		paymentSessionId = nil
	end

	v7.paymentSessionId = paymentSessionId
	v7.purchaseType = purchaseType
	v7.isInApp = isInApp

	local v8 = false
	pcall(function()
		promptNativePurchaseWithContext(v6, data.mobileProductId, v7)
		v8 = true

		if data.onNativePurchaseLaunched ~= nil then
			data.onNativePurchaseLaunched()
		end
	end)
	return v8
end

local function startPurchase(data, p2)
	local mobileProductId = data.mobileProductId
	local productId = data.productId

	local v6 = getUpsellFlow((UserInputService:GetPlatform()))

	if v6 == UpsellFlow.Mobile then
		if getEngineFeaturePromptNativePurchaseWithContext() and tryLaunchNativePurchaseWithContext(data, p2) then
			return
		end

		local localPlayer = Players.LocalPlayer
		local engineFeature = game:GetEngineFeature("NativePurchaseWithLocalPlayer")
		local engineFeature2 = game:GetEngineFeature("PromptNativePurchaseWithPaymentSessionId")

		pcall(function()
			local v7 = MarketplaceService

			local promptNativePurchaseWithLocalPlayerWithPaymentSessionId = v7.PromptNativePurchaseWithLocalPlayerWithPaymentSessionId
			local promptNativePurchaseWithLocalPlayer = v7.PromptNativePurchaseWithLocalPlayer
			local promptNativePurchaseWithPaymentSessionId = v7.PromptNativePurchaseWithPaymentSessionId
			local promptNativePurchase = v7.PromptNativePurchase

			if
				engineFeature
				and engineFeature2
				and typeof(promptNativePurchaseWithLocalPlayerWithPaymentSessionId) == "function"
			then
				promptNativePurchaseWithLocalPlayerWithPaymentSessionId(v7, mobileProductId, p2)
			elseif engineFeature and typeof(promptNativePurchaseWithLocalPlayer) == "function" then
				promptNativePurchaseWithLocalPlayer(v7, mobileProductId)
			elseif engineFeature2 and typeof(promptNativePurchaseWithPaymentSessionId) == "function" then
				promptNativePurchaseWithPaymentSessionId(v7, localPlayer, mobileProductId, p2)
			elseif typeof(promptNativePurchase) == "function" then
				promptNativePurchase(v7, localPlayer, mobileProductId)
			else
				error("MarketplaceService has no PromptNativePurchase APIs bound")
			end

			if data.onNativePurchaseLaunched ~= nil then
				data.onNativePurchaseLaunched()
			end
		end)
	elseif v6 == UpsellFlow.Xbox then
		if v5 == nil then
			return
		end

		pcall(function()
			v5:BeginPlatformStorePurchase(mobileProductId)
		end)
	elseif v6 == UpsellFlow.Web then
		if productId == nil then
			return
		end

		local baseUrl = ContentProvider.BaseUrl:lower()
		local formatted = ("%supgrades/paymentmethods?ap=%s"):format(
			string.gsub(baseUrl, "/m%.", "/www."),
			(tostring(productId))
		)

		if p2 ~= "" then
			formatted = ("%s&paymentSessionId=%s"):format(formatted, p2)
		end

		pcall(function()
			local onWebViewClosed = data.onWebViewClosed
			local onWindowClosedConnection = nil
			onWindowClosedConnection = WebViewService.OnWindowClosed:Connect(function()
				WebViewService:CloseWindow()

				if onWindowClosedConnection then
					onWindowClosedConnection:Disconnect()
					onWindowClosedConnection = nil
				end

				if onWebViewClosed then
					onWebViewClosed()
				end
			end)
			WebViewService:OpenWindow(formatted, "", true)
		end)
	end
end

local function launchRobuxPackagePurchase(data)
	local paymentSessionId = GetFFlagEnablePaymentSessionIdInRobuxPurchase() and data.paymentSessionId or ""

	if RunService:IsStudio() then
		return nil
	end

	if fFlagEnableBonusJwtInShop then
		local v6 = getUpsellFlow(UserInputService:GetPlatform())
		local v7 = not (v6 == UpsellFlow.Mobile) and v6 ~= UpsellFlow.Web
		local bonusJwt = data.bonusJwt
		local redeemBonusToken = data.redeemBonusToken

		if not v7 and typeof(bonusJwt) == "string" and bonusJwt ~= "" and redeemBonusToken ~= nil then
			local success, result = pcall(function()
				return redeemBonusToken(bonusJwt, game.GameId)
			end)

			if not success then
				return nil
			end

			if typeof(result) == "table" and typeof(result.andThen) == "function" then
				return result:andThen(function(value)
					startPurchase(data, typeof(value) ~= "string" and "" or value)
				end)
			end

			return nil
		end
	end

	startPurchase(data, paymentSessionId)
	return nil
end

return launchRobuxPackagePurchase
