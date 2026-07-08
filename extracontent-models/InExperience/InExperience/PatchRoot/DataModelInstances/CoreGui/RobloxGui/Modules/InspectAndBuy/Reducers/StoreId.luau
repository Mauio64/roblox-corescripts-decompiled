local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local UpdateStoreId = require(ParentParent.Actions.UpdateStoreId)
local n1 = 0

return Rodux.createReducer("0", {
	[UpdateStoreId.name] = function(_, _) -- line: 11
		-- upvalues: n1 (ref)
		n1 += 1

		return (tostring(n1))
	end
})
