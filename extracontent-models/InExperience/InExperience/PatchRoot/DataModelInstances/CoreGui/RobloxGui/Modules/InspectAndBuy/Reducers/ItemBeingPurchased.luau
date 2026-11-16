local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent
local SetItemBeingPurchased = require(parent.Actions.SetItemBeingPurchased)
local FFlagAXIaBSinglePurchaseUnifiedEvents = require(parent.Flags.FFlagAXIaBSinglePurchaseUnifiedEvents)

return Rodux.createReducer({ itemType = nil, itemId = nil, resalePrice = nil }, {
	[SetItemBeingPurchased.name] = function(_, data)
		local v = { itemType = data.itemType, itemId = data.itemId, resalePrice = 0 }
		local resalePrice

		if FFlagAXIaBSinglePurchaseUnifiedEvents then
			resalePrice = data.resalePrice
		end

		v.resalePrice = resalePrice

		return v
	end
})
