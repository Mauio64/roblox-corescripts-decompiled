local ParentParent = script.Parent.Parent.Parent
local Rodux = require(ParentParent.Rodux)
local Inspect = require(script.Parent.Inspect)
local ItemDetails = require(script.Parent.ItemDetails)

return function() -- line: 14
	-- upvalues: Rodux (copy), Inspect (copy), ItemDetails (copy)
	return Rodux.combineReducers({
		Inspect = Inspect,
		ItemAssets = ItemDetails
	})
end
