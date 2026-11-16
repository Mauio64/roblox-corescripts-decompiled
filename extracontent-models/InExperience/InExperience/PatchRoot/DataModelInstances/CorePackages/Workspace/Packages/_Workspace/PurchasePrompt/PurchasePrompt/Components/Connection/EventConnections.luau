local UserInputService = game:GetService("UserInputService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact

local UpsellFlow = require(PurchasePrompt.Enums.UpsellFlow)
local getUpsellFlow = require(PurchasePrompt.NativeUpsell.getUpsellFlow)

local MarketplaceServiceEventConnector = require(script.Parent.MarketplaceServiceEventConnector)
local InputTypeManager = require(script.Parent.InputTypeManager)
local BrowserPurchaseFinishedConnector = require(script.Parent.BrowserPurchaseFinishedConnector)
local NativePurchaseFinishedConnector = require(script.Parent.NativePurchaseFinishedConnector)

local function EventConnections()
	local upsellFinishedConnector = nil
	local upsellFlow = getUpsellFlow(UserInputService:GetPlatform())

	if upsellFlow == UpsellFlow.Web then
		upsellFinishedConnector = Roact.createElement(BrowserPurchaseFinishedConnector)
	elseif upsellFlow == UpsellFlow.Mobile then
		upsellFinishedConnector = Roact.createElement(NativePurchaseFinishedConnector)
	end

	local v = UserInputService:GetPlatform() ~= Enum.Platform.XBoxOne

	return Roact.createElement("Folder", {}, {
		MarketPlaceServiceEventConnector = Roact.createElement(MarketplaceServiceEventConnector),
		InputTypeManager = v and Roact.createElement(InputTypeManager) or nil,
		UpsellFinishedConnector = upsellFinishedConnector
	})
end

return EventConnections
