local parent = script.Parent.Parent

local GetFStringUGCValidateMaxAnimationMovement = require(parent.flags.GetFStringUGCValidateMaxAnimationMovement)

local function getFallbackValue()
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

local GetFStringUGCValidateMaxAnimationMovementPerPart = {}

local v = {
	Head = function()
		return game:GetFastString("UGCValidateMaxAnimationMovementHead")
	end,
	UpperTorso = function()
		return game:GetFastString("UGCValidateMaxAnimationMovementUpperTorso")
	end,
	LeftUpperLeg = function()
		return game:GetFastString("UGCValidateMaxAnimationMovementLeftUpperLeg")
	end,
	LeftLowerLeg = function()
		return game:GetFastString("UGCValidateMaxAnimationMovementLeftLowerLeg")
	end,
	LeftHand = function()
		return game:GetFastString("UGCValidateMaxAnimationMovementLeftHand")
	end,
	RightUpperArm = function()
		return game:GetFastString("UGCValidateMaxAnimationMovementRightUpperArm")
	end,
	RightLowerArm = function()
		return game:GetFastString("UGCValidateMaxAnimationMovementRightLowerArm")
	end,
	RightHand = function()
		return game:GetFastString("UGCValidateMaxAnimationMovementRightHand")
	end,
	LeftUpperArm = function()
		return game:GetFastString("UGCValidateMaxAnimationMovementLeftUpperArm")
	end,
	LeftLowerArm = function()
		return game:GetFastString("UGCValidateMaxAnimationMovementLeftLowerArm")
	end,
	LeftFoot = function()
		return game:GetFastString("UGCValidateMaxAnimationMovementLeftFoot")
	end,
	RightUpperLeg = function()
		return game:GetFastString("UGCValidateMaxAnimationMovementRightUpperLeg")
	end,
	RightLowerLeg = function()
		return game:GetFastString("UGCValidateMaxAnimationMovementRightLowerLeg")
	end,
	RightFoot = function()
		return game:GetFastString("UGCValidateMaxAnimationMovementRightFoot")
	end
}

function GetFStringUGCValidateMaxAnimationMovementPerPart.asString(p: string)
	local v2 = v[p]

	if not v2 then
		return getFallbackValue()
	end

	local v3 = v2()

	if #v3 == 0 then
		return getFallbackValue()
	end

	return v3
end

function GetFStringUGCValidateMaxAnimationMovementPerPart.asNumber(p: string)
	return (tonumber(GetFStringUGCValidateMaxAnimationMovementPerPart.asString(p)))
end

return GetFStringUGCValidateMaxAnimationMovementPerPart
