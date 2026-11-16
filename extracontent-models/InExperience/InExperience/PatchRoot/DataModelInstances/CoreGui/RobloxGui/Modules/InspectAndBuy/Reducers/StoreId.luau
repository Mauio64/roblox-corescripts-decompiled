local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local parent = script.Parent.Parent
local UpdateStoreId = require(parent.Actions.UpdateStoreId)

local count = 0

return Rodux.createReducer("0", {
	[UpdateStoreId.name] = function(_, _)
		count += 1
		return (tostring(count))
	end
})
