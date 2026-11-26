local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")

local v5 = nil
pcall(function()
	local PlatformService = game:GetService("PlatformService")
	v5 = PlatformService
end)

local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/fAO")
local module3 = require("@luauforge/bundled/gIg")
local module4 = require("@luauforge/bundled/gIk")
local module5 = require("@luauforge/bundled/gIh")
local module6 = require("@luauforge/bundled/ehB")
local module7 = require("@luauforge/bundled/fAK")
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies
local module8 = require("@luauforge/bundled/fAF")

local desktopUpsellExperiment = require("@luauforge/deferred/gKv").Utility.DesktopUpsellExperiment

local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

return function(p2, p3, p4, p5)
	return function(object)
		object:dispatch(module4(p3, module3.Pending))

		if RunService:IsStudio() then
			delay(3, function()
				object:dispatch(module5(p2, p3, module3.Success))
			end)
			return
		end

		local v6 = module7()

		if v6 == module2.Web then
			if getAppFeaturePolicies().getRedirectBuyRobuxToVNG() then
				return object:dispatch(module8(function()
					return object:dispatch(module5(p2, p3, module3.Polling))
				end, p2))
			end

			if desktopUpsellExperiment.getVariant() == desktopUpsellExperiment.variants.OpenRobuxStore then
				local v7 = {
					name = module.PurchaseRobux,
					detail = p4,
					extraProps = { analyticId = p5, productId = p4 }
				}

				if fFlagSignalsNavP3Dispatch then
					return navigationCommands.down(navigationCommands.fromLegacyPage(v7))
				end

				return object:dispatch(module6(v7))
			else
				local v7 = {
					name = module.Payment,
					detail = p4,
					extraProps = { analyticId = p5 }
				}

				if fFlagSignalsNavP3Dispatch then
					return navigationCommands.down(navigationCommands.fromLegacyPage(v7))
				end

				return object:dispatch(module6(v7))
			end
		elseif v6 == module2.Xbox then
			local v7 = nil

			local success, result = pcall(function()
				v7 = v5:BeginPlatformStorePurchase(p3)
			end)

			local v8 = module3.Failed

			if success and v7 == 0 then
				v8 = module3.Success
			end

			return object:dispatch(module5(p2, p3, v8))
		elseif game:GetEngineFeature("NativePurchaseWithLocalPlayer") then
			return MarketplaceService:PromptNativePurchaseWithLocalPlayer(p3)
		else
			return MarketplaceService:PromptNativePurchase(Players.LocalPlayer, p3)
		end
	end
end
