local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Modules = CoreGui.RobloxGui.Modules
local SetLastSavedSort = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetLastSavedSort)

return Rodux.createReducer({}, {
	[SetLastSavedSort.name] = function(_, p2) -- line: 21
		return p2.savedAccessories
	end
})
