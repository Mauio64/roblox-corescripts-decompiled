local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator
local parent = script.Parent.Parent
local FFlagAXIaBSinglePurchaseUnifiedEvents = require(parent.Flags.FFlagAXIaBSinglePurchaseUnifiedEvents)

return makeActionCreator(script.Name, function(itemId, itemType, resalePrice)
	if not FFlagAXIaBSinglePurchaseUnifiedEvents then
		resalePrice = nil
	end

	return { itemId = itemId, itemType = itemType, resalePrice = resalePrice }
end)
