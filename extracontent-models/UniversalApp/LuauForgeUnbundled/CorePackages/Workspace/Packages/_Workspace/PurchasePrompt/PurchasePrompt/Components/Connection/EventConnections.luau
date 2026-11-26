local UserInputService = game:GetService("UserInputService")

local roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Roact

local UpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/UpsellFlow")
local getUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/NativeUpsell/getUpsellFlow")

local MarketplaceServiceEventConnector = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/MarketplaceServiceEventConnector")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/InputTypeManager")
local BrowserPurchaseFinishedConnector = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/BrowserPurchaseFinishedConnector")
local NativePurchaseFinishedConnector = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/NativePurchaseFinishedConnector")

local function EventConnections()
	local v5 = nil
	local v6 = getUpsellFlow(UserInputService:GetPlatform())

	if v6 == UpsellFlow.Web then
		v5 = roact.createElement(BrowserPurchaseFinishedConnector)
	elseif v6 == UpsellFlow.Mobile then
		v5 = roact.createElement(NativePurchaseFinishedConnector)
	end

	local v7 = UserInputService:GetPlatform() ~= Enum.Platform.XBoxOne

	return roact.createElement("Folder", {}, {
		MarketPlaceServiceEventConnector = roact.createElement(MarketplaceServiceEventConnector),
		InputTypeManager = v7 and roact.createElement(module4) or nil,
		UpsellFinishedConnector = v5
	})
end

return EventConnections
