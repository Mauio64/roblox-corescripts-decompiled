local UserInputService = game:GetService("UserInputService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Roact = require(PurchasePromptParent.PurchasePromptDeps).Roact
local UpsellFlow = require(PurchasePrompt.Enums.UpsellFlow)
local getUpsellFlow = require(PurchasePrompt.NativeUpsell.getUpsellFlow)
local MarketplaceServiceEventConnector = require(script.Parent.MarketplaceServiceEventConnector)
local InputTypeManager = require(script.Parent.InputTypeManager)
local BrowserPurchaseFinishedConnector = require(script.Parent.BrowserPurchaseFinishedConnector)
local NativePurchaseFinishedConnector = require(script.Parent.NativePurchaseFinishedConnector)

local function EventConnections() -- line: 20
	-- upvalues: getUpsellFlow (copy), UserInputService (copy), UpsellFlow (copy), Roact (copy), BrowserPurchaseFinishedConnector (copy), NativePurchaseFinishedConnector (copy), MarketplaceServiceEventConnector (copy), InputTypeManager (copy)
	local v12 = nil
	local v13 = getUpsellFlow(UserInputService:GetPlatform())

	if v13 == UpsellFlow.Web then
		v12 = Roact.createElement(BrowserPurchaseFinishedConnector)
	elseif v13 == UpsellFlow.Mobile then
		v12 = Roact.createElement(NativePurchaseFinishedConnector)
	end

	local v14 = UserInputService:GetPlatform() ~= Enum.Platform.XBoxOne

	return Roact.createElement("Folder", {}, {
		MarketPlaceServiceEventConnector = Roact.createElement(MarketplaceServiceEventConnector),
		InputTypeManager = v14 and Roact.createElement(InputTypeManager) or nil,
		UpsellFinishedConnector = v12
	})
end

return EventConnections
