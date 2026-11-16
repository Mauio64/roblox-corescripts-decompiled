local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local ExpChatShared = require(parent.ExpChatShared)

local Actions = ExpChat.Actions
local AdorneeAdded = require(Actions.AdorneeAdded)
local PlayerRemoved = ExpChatShared.Actions.PlayerRemoved
local HumanoidDied = require(Actions.HumanoidDied)

local function findFirstChildByNameAndClass(instance, p: string, className: string)
	for _, child in ipairs(instance:GetChildren()) do
		if child.Name == p and child:IsA(className) then
			return child
		end
	end

	return nil
end

return Rodux.createReducer({}, {
	[AdorneeAdded.name] = function(p, data)
		local v = findFirstChildByNameAndClass(data.character, "Head", "BasePart")

		if data.humanoid.Health ~= 0 then
			v = data.character
		end

		return dictionary.join(p, { [data.userId] = v })
	end,
	[HumanoidDied.name] = function(p, p2)
		local v = p[p2.userId]
		local v2

		if v then
			v2 = findFirstChildByNameAndClass(v, "Head", "BasePart") or v
		end

		return dictionary.join(p, { [p2.userId] = v2 })
	end,
	[PlayerRemoved.name] = function(p, p2)
		return dictionary.removeKey(p, p2.userId)
	end
})
