local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = CoreGui.RobloxGui.Modules
local SetCurrentSort = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetCurrentSort)
local ClearCurrentSort = require(Modules.AvatarExperience.LayeredClothingSort.Actions.ClearCurrentSort)
local AddRemovedItem = require(Modules.AvatarExperience.LayeredClothingSort.Actions.AddRemovedItem)
local ClearRemovedItems = require(Modules.AvatarExperience.LayeredClothingSort.Actions.ClearRemovedItems)
local t1 = {
	OrderedList = {},
	RemovedList = {}
}

return Rodux.createReducer(t1, {
	[SetCurrentSort.name] = function(p1, p2) -- line: 40
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			OrderedList = p2.currentSort
		})
	end,
	[ClearCurrentSort.name] = function(p3, _) -- line: 45
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			OrderedList = {},
			RemovedList = {}
		})
	end,
	[AddRemovedItem.name] = function(p5, p6) -- line: 51
		-- upvalues: Cryo (copy)
		local v17 = p5.RemovedList or {}

		return Cryo.Dictionary.join(p5, {
			RemovedList = Cryo.Dictionary.join(v17, {
				[p6.removedAssetId] = p6.removedAssetTypeId
			})
		})
	end,
	[ClearRemovedItems.name] = function(p7, _) -- line: 59
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p7, {
			RemovedList = {}
		})
	end
})
