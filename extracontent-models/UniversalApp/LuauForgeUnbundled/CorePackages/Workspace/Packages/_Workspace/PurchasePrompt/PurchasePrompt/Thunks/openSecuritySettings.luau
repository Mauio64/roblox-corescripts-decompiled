require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local UpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/UpsellFlow")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local hideWindow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/hideWindow")
local getUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/NativeUpsell/getUpsellFlow")
local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Analytics")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local PlatformInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/PlatformInterface")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")

local v5 = { Analytics, ExternalSettings, Network, PlatformInterface }

local function openSecuritySettings(p2)
	return Thunk.new("openSecuritySettings", v5, function(object, p3)
		local v6 = p3[Analytics]
		local v7 = p3[ExternalSettings]
		local v8 = p3[PlatformInterface]
		local state = object:getState()

		if getUpsellFlow(v7.getPlatform()) == UpsellFlow.Web then
			local productId = state.productInfo.productId
			local requestType = state.requestType

			v6.signalTwoSVSettingsErrorConfirmed(productId, requestType)

			if p2 then
				v8.openSecuritySettings(p2)
			else
				v8.openSecuritySettings()
			end
		end

		object:dispatch(hideWindow())
	end)
end

return openSecuritySettings
