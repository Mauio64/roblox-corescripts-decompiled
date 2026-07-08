local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local Dictionary = require(ExpChatParent.llama).Dictionary
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local Actions = ExpChat.Actions
local AdorneeAdded = require(Actions.AdorneeAdded)
local PlayerRemoved = ExpChatShared.Actions.PlayerRemoved
local HumanoidDied = require(Actions.HumanoidDied)

local function findFirstChildByNameAndClass(p1, s1: string, s2: string) -- line: 16
	for _, child in ipairs(p1:GetChildren()) do
		if s1 == child.Name and child:IsA(s2) then
			return child
		end
	end

	return nil
end

return Rodux.createReducer({}, {
	[AdorneeAdded.name] = function(t1: {[any]: any}, p2) -- line: 27
		-- upvalues: findFirstChildByNameAndClass (copy), Dictionary (copy)
		local v18 = findFirstChildByNameAndClass(p2.character, "Head", "BasePart")
		local v19 = if p2.humanoid.Health ~= 0 then p2.character else v18

		return Dictionary.join(t1, {
			[p2.userId] = v19
		})
	end,
	[HumanoidDied.name] = function(t2: {[any]: any}, p3) -- line: 36
		-- upvalues: findFirstChildByNameAndClass (copy), Dictionary (copy)
		local v22 = t2[p3.userId]
		local v23 = nil

		if v22 then
			v23 = findFirstChildByNameAndClass(v22, "Head", "BasePart") or v22
		end

		return Dictionary.join(t2, {
			[p3.userId] = v23
		})
	end,
	[PlayerRemoved.name] = function(t3: {[any]: any}, p4) -- line: 48
		-- upvalues: Dictionary (copy)
		return Dictionary.removeKey(t3, p4.userId)
	end
})
