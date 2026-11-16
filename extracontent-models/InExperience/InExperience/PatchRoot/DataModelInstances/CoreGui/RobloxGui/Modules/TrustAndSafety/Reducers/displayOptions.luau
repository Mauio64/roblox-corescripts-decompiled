local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local parent = script.Parent.Parent
local SetScreenSize = require(parent.Actions.SetScreenSize)

return Rodux.createReducer({ inputType = nil, screenSize = Vector2.new(0, 0) }, {
	[SetScreenSize.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { screenSize = p2.screenSize })
	end
})
