local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local Actions = script.Parent.Parent.Actions
local FocusSegment = require(Actions.FocusSegment)
local HideMenu = require(Actions.HideMenu)
local t1 = {
	focusedSegmentIndex = 0
}

return Rodux.createReducer(t1, {
	[FocusSegment.name] = function(p1, p2) -- line: 18
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			focusedSegmentIndex = p2.segmentIndex
		})
	end,
	[HideMenu.name] = function(p3, _) -- line: 25
		-- upvalues: Cryo (copy), t1 (copy)
		return Cryo.Dictionary.join(p3, t1)
	end
})
