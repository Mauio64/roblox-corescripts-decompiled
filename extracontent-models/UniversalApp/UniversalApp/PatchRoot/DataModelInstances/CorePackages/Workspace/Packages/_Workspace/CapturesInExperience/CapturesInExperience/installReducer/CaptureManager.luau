local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local Cryo = require(ParentParentParent.Cryo)

require(ParentParent.Types)

local CapturesRetrieved = require(ParentParent.Actions.CapturesRetrieved)
local CaptureManagerClosed = require(ParentParent.Actions.CaptureManagerClosed)
local CaptureManagerOpened = require(ParentParent.Actions.CaptureManagerOpened)
local UpdateSelectedCaptures = require(ParentParent.Actions.UpdateSelectedCaptures)
local t1 = {
	IsOpen = false,
	SelectedCaptures = {}
}

return Rodux.createReducer(t1, {
	[CaptureManagerClosed.name] = function(t2: {[any]: any}, _: {[any]: any}) -- line: 24
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t2, {
			IsOpen = false,
			SelectedCaptures = {}
		})
	end,
	[CaptureManagerOpened.name] = function(t4: {[any]: any}, _: {[any]: any}) -- line: 31
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t4, {
			IsOpen = true
		})
	end,
	[CapturesRetrieved.name] = function(t6: {[any]: any}, p1) -- line: 37
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t6, {
			IsOpen = t6.IsOpen and #p1.captures > 0,
			SelectedCaptures = {}
		})
	end,
	[UpdateSelectedCaptures.name] = function(t7: {[any]: any}, p2) -- line: 44
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t7, {
			SelectedCaptures = p2.selectedCaptures
		})
	end
})
