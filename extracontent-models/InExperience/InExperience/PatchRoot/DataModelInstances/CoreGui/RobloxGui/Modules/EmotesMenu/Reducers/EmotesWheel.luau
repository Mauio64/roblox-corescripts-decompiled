local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)

local Actions = script.Parent.Parent.Actions
local FocusSegment = require(Actions.FocusSegment)
local HideMenu = require(Actions.HideMenu)

local v = { focusedSegmentIndex = 0 }

return Rodux.createReducer(v, {
	[FocusSegment.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { focusedSegmentIndex = p2.segmentIndex })
	end,
	[HideMenu.name] = function(p, _)
		return Cryo.Dictionary.join(p, v)
	end
})
