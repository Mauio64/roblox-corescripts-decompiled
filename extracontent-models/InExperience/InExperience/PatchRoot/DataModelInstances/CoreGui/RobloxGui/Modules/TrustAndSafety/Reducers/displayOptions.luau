local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local ParentParent = script.Parent.Parent
local SetScreenSize = require(ParentParent.Actions.SetScreenSize)
local Hide = require(ParentParent.Actions.Hide)
local Show = require(ParentParent.Actions.Show)

return Rodux.createReducer({
	inputType = nil,
	visible = true,
	screenSize = Vector2.new(0, 0)
}, {
	[SetScreenSize.name] = function(p1, p2) -- line: 16
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			screenSize = p2.screenSize
		})
	end,
	[Hide.name] = function(p3) -- line: 21
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			visible = false
		})
	end,
	[Show.name] = function(p4) -- line: 26
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p4, {
			visible = true
		})
	end
})
