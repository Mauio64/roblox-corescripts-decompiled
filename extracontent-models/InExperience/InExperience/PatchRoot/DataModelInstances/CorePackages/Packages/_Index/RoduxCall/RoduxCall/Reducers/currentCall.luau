local RoduxCall = script:FindFirstAncestor("RoduxCall")
local RoduxCallParent = RoduxCall.Parent
local Rodux = require(RoduxCallParent.Rodux)
local CallStateModel = require(RoduxCall.Models).CallStateModel
local UpdateCall = require(RoduxCall.Actions).UpdateCall

require(script.Parent.Parent.roduxCallTypes)

return function() -- line: 11
	-- upvalues: Rodux (copy), UpdateCall (copy), CallStateModel (copy)
	return Rodux.createReducer(nil, {
		[UpdateCall.name] = function(_, p2) -- line: 13
			-- upvalues: CallStateModel (copy)
			local call = p2.payload.call

			return CallStateModel.format(call)
		end
	})
end
