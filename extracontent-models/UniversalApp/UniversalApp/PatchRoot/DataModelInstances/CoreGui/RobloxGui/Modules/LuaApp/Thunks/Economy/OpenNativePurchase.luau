local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local PlatformService = nil

pcall(function() -- line: 9
	-- upvalues: PlatformService (ref)
	PlatformService = game:GetService("PlatformService")
end)

local AppPage = require(Modules.LuaApp.AppPage)
local PaymentPlatform = require(Modules.LuaApp.Enum.PaymentPlatform)
local NativePurchaseStatus = require(Modules.LuaApp.Enum.NativePurchaseStatus)
local SetNativePurchaseResult = require(Modules.LuaApp.Actions.SetNativePurchaseResult)
local NativePurchaseComplete = require(Modules.LuaApp.Thunks.NativePurchaseComplete)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local getPaymentPlatform = require(Modules.LuaApp.Util.getPaymentPlatform)
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local OpenPurchaseRobuxPage = require(Modules.LuaApp.Thunks.Economy.OpenPurchaseRobuxPage)
local DesktopUpsellExperiment = require(CorePackages.Workspace.Packages.IAPExperience).Utility.DesktopUpsellExperiment
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v19 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

return function(p1: ((...any) -> ...any), s1: string, n1: number?, s2: string?) -- line: 33
	-- upvalues: SetNativePurchaseResult (copy), NativePurchaseStatus (copy), RunService (copy), NativePurchaseComplete (copy), getPaymentPlatform (copy), PaymentPlatform (copy), getAppFeaturePolicies (copy), OpenPurchaseRobuxPage (copy), DesktopUpsellExperiment (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v19 (copy), NavigateDown (copy), PlatformService (ref), MarketplaceService (copy), Players (copy)
	return function(p2) -- line: 34
		-- upvalues: SetNativePurchaseResult (copy), s1 (copy), NativePurchaseStatus (copy), RunService (copy), NativePurchaseComplete (copy), p1 (copy), getPaymentPlatform (copy), PaymentPlatform (copy), getAppFeaturePolicies (copy), OpenPurchaseRobuxPage (copy), DesktopUpsellExperiment (copy), AppPage (copy), n1 (copy), s2 (copy), FFlagSignalsNavP3Dispatch (copy), v19 (copy), NavigateDown (copy), PlatformService (ref), MarketplaceService (copy), Players (copy)
		p2:dispatch(SetNativePurchaseResult(s1, NativePurchaseStatus.Pending))

		if RunService:IsStudio() then
			delay(3, function() -- line: 39
				-- upvalues: p2 (copy), NativePurchaseComplete (copy), p1 (copy), s1 (copy), NativePurchaseStatus (copy)
				p2:dispatch(NativePurchaseComplete(p1, s1, NativePurchaseStatus.Success))
			end)

			return
		end

		local v25 = getPaymentPlatform()

		if v25 == PaymentPlatform.Web then
			if getAppFeaturePolicies().getRedirectBuyRobuxToVNG() then
				return p2:dispatch(OpenPurchaseRobuxPage(function() -- line: 48
					-- upvalues: p2 (copy), NativePurchaseComplete (copy), p1 (copy), s1 (copy), NativePurchaseStatus (copy)
					return p2:dispatch(NativePurchaseComplete(p1, s1, NativePurchaseStatus.Polling))
				end, p1))
			end

			if DesktopUpsellExperiment.getVariant() == DesktopUpsellExperiment.variants.OpenRobuxStore then
				local t1 = {
					name = AppPage.PurchaseRobux,
					detail = n1,
					extraProps = {
						analyticId = s2,
						productId = n1
					}
				}

				if FFlagSignalsNavP3Dispatch then
					return v19.down(v19.fromLegacyPage(t1))
				end

				return p2:dispatch(NavigateDown(t1))
			end

			local t2 = {
				name = AppPage.Payment,
				detail = n1,
				extraProps = {
					analyticId = s2
				}
			}

			if FFlagSignalsNavP3Dispatch then
				return v19.down(v19.fromLegacyPage(t2))
			end

			return p2:dispatch(NavigateDown(t2))
		end

		if v25 == PaymentPlatform.Xbox then
			local u28 = nil
			local _, _ = pcall(function() -- line: 88
				-- upvalues: u28 (ref), PlatformService (ref), s1 (copy)
				u28 = PlatformService:BeginPlatformStorePurchase(s1)
			end)
			local v31 = NativePurchaseStatus.Failed and (u28 ~= 0 or NativePurchaseStatus.Success)

			return p2:dispatch(NativePurchaseComplete(p1, s1, v31))
		end

		if game:GetEngineFeature("NativePurchaseWithLocalPlayer") then
			return MarketplaceService:PromptNativePurchaseWithLocalPlayer(s1)
		end

		return MarketplaceService:PromptNativePurchase(Players.LocalPlayer, s1)
	end
end
