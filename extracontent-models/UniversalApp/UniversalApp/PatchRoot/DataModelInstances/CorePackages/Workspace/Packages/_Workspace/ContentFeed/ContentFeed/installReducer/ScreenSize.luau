local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local ScreenSizeChanged = require(ParentParent.Actions.ScreenSizeChanged)
local vector2 = Vector2.new(0, 0)

return Rodux.createReducer(vector2, {
	[ScreenSizeChanged.name] = function(_: Vector2, t1: {[any]: any}) -- line: 13
		return t1.screenSize
	end
})
