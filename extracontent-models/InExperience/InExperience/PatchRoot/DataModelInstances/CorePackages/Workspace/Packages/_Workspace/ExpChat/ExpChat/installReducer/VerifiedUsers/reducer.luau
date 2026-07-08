local Parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(Parent.Rodux)
local Dictionary = require(Parent.llama).Dictionary
local Actions = require(Parent.ExpChatShared).Actions
local PlayerAdded = Actions.PlayerAdded
local PlayerRemoved = Actions.PlayerRemoved

return Rodux.createReducer({}, {
	[PlayerAdded.name] = function(t1: {[any]: any}, p1) -- line: 16
		-- upvalues: Dictionary (copy)
		if not p1.hasVerifiedBadge then
			return t1
		end

		return Dictionary.join(t1, {
			[p1.userId] = p1.hasVerifiedBadge
		})
	end,
	[PlayerRemoved.name] = function(t2: {[any]: any}, p2) -- line: 25
		-- upvalues: Dictionary (copy)
		if t2[p2.userId] == nil then
			return t2
		end

		return Dictionary.removeKey(t2, p2.userId)
	end
})
