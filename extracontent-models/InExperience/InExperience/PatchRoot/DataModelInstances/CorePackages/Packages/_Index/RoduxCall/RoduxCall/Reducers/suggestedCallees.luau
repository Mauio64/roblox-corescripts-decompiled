local RoduxCall = script:FindFirstAncestor("RoduxCall")
local parent = RoduxCall.Parent
local Rodux = require(parent.Rodux)
local Models = require(RoduxCall.Models)
local SuggestedCalleeModel = Models.SuggestedCalleeModel
local Actions = require(RoduxCall.Actions)
local ClearSuggestedCallees = Actions.ClearSuggestedCallees

require(script.Parent.Parent.roduxCallTypes)

local v = { suggestedCallees = {} }

return function(p)
	local networkingCall = p.NetworkingCall
	return Rodux.createReducer(v, {
		[networkingCall.GetSuggestedCallees.Succeeded.name] = function(_, p2)
			local suggestedCallees = p2.responseBody.suggestedCallees

			local values = {}

			for _, suggestedCallee in ipairs(suggestedCallees) do
				assert(SuggestedCalleeModel.isValid(suggestedCallee))
				local formatted = SuggestedCalleeModel.format(suggestedCallee)
				values[#values + 1] = formatted
			end

			return { suggestedCallees = values }
		end,
		[ClearSuggestedCallees.name] = function(_, _)
			return v
		end
	})
end
