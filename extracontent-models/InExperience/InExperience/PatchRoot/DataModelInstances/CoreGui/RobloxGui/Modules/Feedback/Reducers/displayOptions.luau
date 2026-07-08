local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local ParentParent = script.Parent.Parent
local SetScreenSize = require(ParentParent.Actions.SetScreenSize)

return Rodux.createReducer({
	inputType = nil,
	screenSize = Vector2.new(0, 0)
}, {
	[SetScreenSize.name] = function(p1, p2) -- line: 18
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			screenSize = p2.screenSize
		})
	end
})
