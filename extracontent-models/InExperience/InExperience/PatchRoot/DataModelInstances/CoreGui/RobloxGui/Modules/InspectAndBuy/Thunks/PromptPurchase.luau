local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Analytics = require(ParentParent.Services.Analytics)
local Constants = require(ParentParent.Constants)
local SetItemBeingPurchased = require(ParentParent.Actions.SetItemBeingPurchased)
local SendCounter = require(ParentParent.Thunks.SendCounter)
local t1 = { Analytics }

local function PromptPurchase(p1, p2, p3, p4, p5, p6, p7) -- line: 18
	-- upvalues: Thunk (copy), t1 (copy), Analytics (copy), SetItemBeingPurchased (copy), Constants (copy), MarketplaceService (copy), Players (copy), SendCounter (copy)
	return Thunk.new(script.Name, t1, function(p8, p9) -- line: 27
		-- upvalues: Analytics (copy), SetItemBeingPurchased (copy), p1 (copy), p2 (copy), p4 (copy), Constants (copy), MarketplaceService (copy), Players (copy), p3 (copy), p5 (copy), p6 (copy), SendCounter (copy), p7 (copy)
		local v20 = p9[Analytics]

		p8:dispatch(SetItemBeingPurchased(p1, p2))

		if p4 ~= nil and p2 ~= Constants.ItemType.Bundle then
			MarketplaceService:PromptCollectiblesPurchase(Players.LocalPlayer, p1, p3, p5, p4, p6)
			p8:dispatch(SendCounter(Constants.Counters.PromptLimitedCollectiblesPurchase))
		elseif p2 == Constants.ItemType.Bundle then
			MarketplaceService:PromptBundlePurchase(Players.LocalPlayer, p1)
			p8:dispatch(SendCounter(Constants.Counters.PromptBundlePurchase))
		elseif p2 == Constants.ItemType.Asset then
			local v21 = p7

			if p3 ~= nil and not v21 then
				MarketplaceService:PromptPurchase(Players.LocalPlayer, p1, false)
				p8:dispatch(SendCounter(Constants.Counters.PromptUnlimitedCollectiblePurchase))
			else
				MarketplaceService:PromptRobloxPurchase(p1, false)
				p8:dispatch(SendCounter(Constants.Counters.PromptRobloxPurchase))
			end
		else
			p8:dispatch(SendCounter(Constants.Counters.PromptPurchaseUnknownItemType))
		end

		v20.reportPurchaseAttempt(p2, p1)
	end)
end

return PromptPurchase
