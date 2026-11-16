local parent = script.Parent.Parent
local Thunk = require(parent.Thunk)
local Analytics = require(parent.Services.Analytics)
local SetTryingOnInfo = require(parent.Actions.SetTryingOnInfo)
local SendCounter = require(parent.Thunks.SendCounter)
local Constants = require(parent.Constants)

local v = { Analytics }

local function TryOnItem(p, p2, p3, p4, p5)
	return Thunk.new(script.Name, v, function(object, p6)
		local v2 = p6[Analytics]
		local v3, v4

		if p4 then
			v3 = p5
			v4 = "Bundle"
		else
			v3 = p2
			v4 = "Asset"
		end

		v2.reportTryOnButtonClicked(v4, v3)
		object:dispatch(SetTryingOnInfo(p, p2, p3))
		object:dispatch(SendCounter(Constants.Counters.TryOnButtonClicked))
	end)
end

return TryOnItem
