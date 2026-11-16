local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)

local parent = script.Parent.Parent
local SetPlaceInfo = require(parent.Actions.SetPlaceInfo)

return Rodux.createReducer({ name = "", description = "" }, {
	[SetPlaceInfo.name] = function(_, p)
		return { name = p.name, description = p.description }
	end
})
