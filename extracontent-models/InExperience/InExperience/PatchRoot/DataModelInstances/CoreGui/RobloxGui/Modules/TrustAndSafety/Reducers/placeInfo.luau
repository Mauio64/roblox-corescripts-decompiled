local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.Cryo)

local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetPlaceInfo = require(ParentParent.Actions.SetPlaceInfo)

return Rodux.createReducer({
	name = "",
	description = ""
}, {
	[SetPlaceInfo.name] = function(_, p2) -- line: 13
		return {
			name = p2.name,
			description = p2.description
		}
	end
})
