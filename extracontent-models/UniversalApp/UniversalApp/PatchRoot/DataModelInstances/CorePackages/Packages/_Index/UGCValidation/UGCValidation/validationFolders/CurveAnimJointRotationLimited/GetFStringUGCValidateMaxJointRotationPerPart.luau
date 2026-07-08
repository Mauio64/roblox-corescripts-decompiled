local GetFStringUGCValidateMaxJointRotation = require(script.Parent.GetFStringUGCValidateMaxJointRotation)

local function getFallbackValue() -- line: 23
	-- upvalues: GetFStringUGCValidateMaxJointRotation (copy)
	return GetFStringUGCValidateMaxJointRotation.asString()
end

game:DefineFastString("UGCValidateMaxJointRotationHead", "")
game:DefineFastString("UGCValidateMaxJointRotationUpperTorso", "")
game:DefineFastString("UGCValidateMaxJointRotationLeftUpperLeg", "")
game:DefineFastString("UGCValidateMaxJointRotationLeftLowerLeg", "")
game:DefineFastString("UGCValidateMaxJointRotationLeftHand", "")
game:DefineFastString("UGCValidateMaxJointRotationRightUpperArm", "")
game:DefineFastString("UGCValidateMaxJointRotationRightLowerArm", "")
game:DefineFastString("UGCValidateMaxJointRotationRightHand", "")
game:DefineFastString("UGCValidateMaxJointRotationLeftUpperArm", "")
game:DefineFastString("UGCValidateMaxJointRotationLeftLowerArm", "")
game:DefineFastString("UGCValidateMaxJointRotationLeftFoot", "")
game:DefineFastString("UGCValidateMaxJointRotationRightUpperLeg", "")
game:DefineFastString("UGCValidateMaxJointRotationRightLowerLeg", "")
game:DefineFastString("UGCValidateMaxJointRotationRightFoot", "")

local t1 = {}
local t2 = {
	Head = function() -- line: 45
		return game:GetFastString("UGCValidateMaxJointRotationHead")
	end,
	UpperTorso = function() -- line: 48
		return game:GetFastString("UGCValidateMaxJointRotationUpperTorso")
	end,
	LeftUpperLeg = function() -- line: 51
		return game:GetFastString("UGCValidateMaxJointRotationLeftUpperLeg")
	end,
	LeftLowerLeg = function() -- line: 54
		return game:GetFastString("UGCValidateMaxJointRotationLeftLowerLeg")
	end,
	LeftHand = function() -- line: 57
		return game:GetFastString("UGCValidateMaxJointRotationLeftHand")
	end,
	RightUpperArm = function() -- line: 60
		return game:GetFastString("UGCValidateMaxJointRotationRightUpperArm")
	end,
	RightLowerArm = function() -- line: 63
		return game:GetFastString("UGCValidateMaxJointRotationRightLowerArm")
	end,
	RightHand = function() -- line: 66
		return game:GetFastString("UGCValidateMaxJointRotationRightHand")
	end,
	LeftUpperArm = function() -- line: 69
		return game:GetFastString("UGCValidateMaxJointRotationLeftUpperArm")
	end,
	LeftLowerArm = function() -- line: 72
		return game:GetFastString("UGCValidateMaxJointRotationLeftLowerArm")
	end,
	LeftFoot = function() -- line: 75
		return game:GetFastString("UGCValidateMaxJointRotationLeftFoot")
	end,
	RightUpperLeg = function() -- line: 78
		return game:GetFastString("UGCValidateMaxJointRotationRightUpperLeg")
	end,
	RightLowerLeg = function() -- line: 81
		return game:GetFastString("UGCValidateMaxJointRotationRightLowerLeg")
	end,
	RightFoot = function() -- line: 84
		return game:GetFastString("UGCValidateMaxJointRotationRightFoot")
	end
}

function t1.asString(s1: string) -- line: 89
	-- upvalues: t2 (copy), getFallbackValue (copy)
	local v6 = t2[s1]

	if not v6 then
		return getFallbackValue()
	end

	local v7 = v6()

	if #v7 == 0 then
		return getFallbackValue()
	end

	return v7
end
function t1.asNumber(s2: string) -- line: 101
	-- upvalues: t1 (copy)
	return (tonumber(t1.asString(s2)))
end

return t1
