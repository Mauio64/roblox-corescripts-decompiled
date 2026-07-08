local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetItemBeingPurchased = require(ParentParent.Actions.SetItemBeingPurchased)
local t1 = {
	itemType = nil,
	itemId = nil
}

return Rodux.createReducer(t1, {
	[SetItemBeingPurchased.name] = function(_, p2) -- line: 12
		return {
			itemType = p2.itemType,
			itemId = p2.itemId
		}
	end
})
