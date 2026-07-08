local ParentParent = script.Parent.Parent
local GetFStringUGCValidateMaxAnimationMovement = require(ParentParent.flags.GetFStringUGCValidateMaxAnimationMovement)

local function getFallbackValue() -- line: 25
	-- upvalues: GetFStringUGCValidateMaxAnimationMovement (copy)
	return GetFStringUGCValidateMaxAnimationMovement.asString()
end

game:DefineFastString("UGCValidateMaxAnimationMovementHead", "")
game:DefineFastString("UGCValidateMaxAnimationMovementUpperTorso", "")
game:DefineFastString("UGCValidateMaxAnimationMovementLeftUpperLeg", "")
game:DefineFastString("UGCValidateMaxAnimationMovementLeftLowerLeg", "")
game:DefineFastString("UGCValidateMaxAnimationMovementLeftHand", "")
game:DefineFastString("UGCValidateMaxAnimationMovementRightUpperArm", "")
game:DefineFastString("UGCValidateMaxAnimationMovementRightLowerArm", "")
game:DefineFastString("UGCValidateMaxAnimationMovementRightHand", "")
game:DefineFastString("UGCValidateMaxAnimationMovementLeftUpperArm", "")
game:DefineFastString("UGCValidateMaxAnimationMovementLeftLowerArm", "")
game:DefineFastString("UGCValidateMaxAnimationMovementLeftFoot", "")
game:DefineFastString("UGCValidateMaxAnimationMovementRightUpperLeg", "")
game:DefineFastString("UGCValidateMaxAnimationMovementRightLowerLeg", "")
game:DefineFastString("UGCValidateMaxAnimationMovementRightFoot", "")

local t1 = {}
local t2 = {
	Head = function() -- line: 47
		return game:GetFastString("UGCValidateMaxAnimationMovementHead")
	end,
	UpperTorso = function() -- line: 50
		return game:GetFastString("UGCValidateMaxAnimationMovementUpperTorso")
	end,
	LeftUpperLeg = function() -- line: 53
		return game:GetFastString("UGCValidateMaxAnimationMovementLeftUpperLeg")
	end,
	LeftLowerLeg = function() -- line: 56
		return game:GetFastString("UGCValidateMaxAnimationMovementLeftLowerLeg")
	end,
	LeftHand = function() -- line: 59
		return game:GetFastString("UGCValidateMaxAnimationMovementLeftHand")
	end,
	RightUpperArm = function() -- line: 62
		return game:GetFastString("UGCValidateMaxAnimationMovementRightUpperArm")
	end,
	RightLowerArm = function() -- line: 65
		return game:GetFastString("UGCValidateMaxAnimationMovementRightLowerArm")
	end,
	RightHand = function() -- line: 68
		return game:GetFastString("UGCValidateMaxAnimationMovementRightHand")
	end,
	LeftUpperArm = function() -- line: 71
		return game:GetFastString("UGCValidateMaxAnimationMovementLeftUpperArm")
	end,
	LeftLowerArm = function() -- line: 74
		return game:GetFastString("UGCValidateMaxAnimationMovementLeftLowerArm")
	end,
	LeftFoot = function() -- line: 77
		return game:GetFastString("UGCValidateMaxAnimationMovementLeftFoot")
	end,
	RightUpperLeg = function() -- line: 80
		return game:GetFastString("UGCValidateMaxAnimationMovementRightUpperLeg")
	end,
	RightLowerLeg = function() -- line: 83
		return game:GetFastString("UGCValidateMaxAnimationMovementRightLowerLeg")
	end,
	RightFoot = function() -- line: 86
		return game:GetFastString("UGCValidateMaxAnimationMovementRightFoot")
	end
}

function t1.asString(s1: string) -- line: 91
	-- upvalues: t2 (copy), getFallbackValue (copy)
	local v7 = t2[s1]

	if not v7 then
		return getFallbackValue()
	end

	local v8 = v7()

	if #v8 == 0 then
		return getFallbackValue()
	end

	return v8
end
function t1.asNumber(s2: string) -- line: 103
	-- upvalues: t1 (copy)
	return (tonumber(t1.asString(s2)))
end

return t1
