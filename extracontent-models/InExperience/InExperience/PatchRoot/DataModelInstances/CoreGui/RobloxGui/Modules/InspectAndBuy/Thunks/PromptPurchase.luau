local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Analytics = require(parent.Services.Analytics)
local Constants = require(parent.Constants)
local SetItemBeingPurchased = require(parent.Actions.SetItemBeingPurchased)

local SendCounter = require(parent.Thunks.SendCounter)
local ReportPurchaseAttemptUnifiedEvent = require(parent.Thunks.ReportPurchaseAttemptUnifiedEvent)

local FFlagAXIaBSinglePurchaseUnifiedEvents = require(parent.Flags.FFlagAXIaBSinglePurchaseUnifiedEvents)
local defineFastFlag = game:DefineFastFlag("FixInspectAndBuyThirdPartySales", false)

local v = { Analytics }

local function PromptPurchase(p, p2, p3, p4, p5, p6, p7)
	return Thunk.new(script.Name, v, function(object, p8)
		local v2 = p8[Analytics]
		local v3

		if p4 == nil then
			v3 = false
		else
			v3 = p2 ~= Constants.ItemType.Bundle
		end

		local v4

		if FFlagAXIaBSinglePurchaseUnifiedEvents and v3 then
			v4 = p6
		end

		object:dispatch(SetItemBeingPurchased(p, p2, v4))

		if v3 then
			MarketplaceService:PromptCollectiblesPurchase(Players.LocalPlayer, p, p3, p5, p4, p6)

			object:dispatch(SendCounter(Constants.Counters.PromptLimitedCollectiblesPurchase))
		elseif p2 == Constants.ItemType.Bundle then
			MarketplaceService:PromptBundlePurchase(Players.LocalPlayer, p)
			object:dispatch(SendCounter(Constants.Counters.PromptBundlePurchase))
		elseif p2 == Constants.ItemType.Asset then
			if defineFastFlag or p3 == nil or p7 then
				MarketplaceService:PromptRobloxPurchase(p, false)
				object:dispatch(SendCounter(Constants.Counters.PromptRobloxPurchase))
			else
				MarketplaceService:PromptPurchase(Players.LocalPlayer, p, false)
				object:dispatch(SendCounter(Constants.Counters.PromptUnlimitedCollectiblePurchase))
			end
		else
			object:dispatch(SendCounter(Constants.Counters.PromptPurchaseUnknownItemType))
		end

		if FFlagAXIaBSinglePurchaseUnifiedEvents then
			object:dispatch(ReportPurchaseAttemptUnifiedEvent(p, p2, v4))
		else
			v2.reportPurchaseAttempt(p2, p)
		end
	end)
end

return PromptPurchase
