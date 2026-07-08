local RoduxCall = script:FindFirstAncestor("RoduxCall")
local RoduxCallParent = RoduxCall.Parent
local Rodux = require(RoduxCallParent.Rodux)
local SuggestedCalleeModel = require(RoduxCall.Models).SuggestedCalleeModel
local ClearSuggestedCallees = require(RoduxCall.Actions).ClearSuggestedCallees

require(script.Parent.Parent.roduxCallTypes)

local t1 = {
	suggestedCallees = {}
}

return function(p1) -- line: 11
	-- upvalues: Rodux (copy), t1 (copy), SuggestedCalleeModel (copy), ClearSuggestedCallees (copy)
	local NetworkingCall = p1.NetworkingCall

	return Rodux.createReducer(t1, {
		[NetworkingCall.GetSuggestedCallees.Succeeded.name] = function(_, p3) -- line: 14
			-- upvalues: SuggestedCalleeModel (copy)
			local suggestedCallees = p3.responseBody.suggestedCallees
			local t2 = {}

			for _, v in ipairs(suggestedCallees) do
				assert(SuggestedCalleeModel.isValid(v))

				local v15 = SuggestedCalleeModel.format(v)

				t2[#t2 + 1] = v15
			end

			return {
				suggestedCallees = t2
			}
		end,
		[ClearSuggestedCallees.name] = function(_, _) -- line: 29
			-- upvalues: t1 (copy)
			return t1
		end
	})
end
