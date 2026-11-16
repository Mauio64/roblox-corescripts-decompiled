local RoduxCall = script:FindFirstAncestor("RoduxCall")
local parent = RoduxCall.Parent
local Rodux = require(parent.Rodux)
local Models = require(RoduxCall.Models)
local CallStateModel = Models.CallStateModel
local Actions = require(RoduxCall.Actions)
local UpdateCall = Actions.UpdateCall

require(script.Parent.Parent.roduxCallTypes)

return function()
	return Rodux.createReducer(nil, {
		[UpdateCall.name] = function(_, p)
			local call = p.payload.call
			return CallStateModel.format(call)
		end
	})
end
