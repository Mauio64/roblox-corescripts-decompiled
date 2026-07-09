local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Cryo = require(ParentParentParent.Cryo)
local Rodux = require(ParentParentParent.Rodux)
local InspectClosed = require(ParentParent.Actions.InspectClosed)
local InspectOpened = require(ParentParent.Actions.InspectOpened)
local t1 = {
	IsOpen = false,
	AssetIds = {}
}

return Rodux.createReducer(t1, {
	[InspectClosed.name] = function(t2: {[any]: any}, _: {[any]: any}) -- line: 21
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t2, {
			IsOpen = false
		})
	end,
	[InspectOpened.name] = function(t4: {[any]: any}, t5: {[any]: any}) -- line: 27
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t4, {
			IsOpen = true,
			AssetIds = t5.assetIds
		})
	end
})
