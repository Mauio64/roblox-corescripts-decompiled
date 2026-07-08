local RunService = game:GetService("RunService")
local EngineFeature = game:GetEngineFeature("AvatarJointUpgradeFeature")
local t1 = {}
local t2 = {
	UpperAngle = 45,
	TwistLowerAngle = -40,
	TwistUpperAngle = 40,
	FrictionTorque = 400,
	StrengthTorque = 400,
	ReferenceMass = 1.0249234437943
}
local t3 = {
	UpperAngle = 20,
	TwistLowerAngle = -40,
	TwistUpperAngle = 20,
	FrictionTorque = 750,
	StrengthTorque = 5000,
	ReferenceMass = 2.861558675766
}
local t4 = {
	UpperAngle = 10,
	TwistLowerAngle = -10,
	TwistUpperAngle = 10,
	StrengthTorque = 400,
	ReferenceMass = 0.43671694397926
}
local t5 = {
	UpperAngle = 20,
	TwistLowerAngle = 5,
	TwistUpperAngle = 120,
	StrengthTorque = 1200,
	ReferenceMass = 0.70196455717087
}
local t6 = {
	UpperAngle = 30,
	TwistLowerAngle = -10,
	TwistUpperAngle = 10,
	StrengthTorque = 400,
	ReferenceMass = 0.69132566452026
}
local t7 = {
	UpperAngle = 5,
	TwistLowerAngle = -120,
	TwistUpperAngle = -5,
	StrengthTorque = 2000,
	ReferenceMass = 0.65389388799667
}
local t8 = {
	UpperAngle = 110,
	TwistLowerAngle = -85,
	TwistUpperAngle = 85,
	FrictionTorque = 600,
	StrengthTorque = 4000,
	ReferenceMass = 0.90918225049973
}
local t9 = {
	UpperAngle = 40,
	TwistLowerAngle = -5,
	TwistUpperAngle = 80,
	FrictionTorque = 600,
	StrengthTorque = 4000,
	ReferenceMass = 1.9175016880035
}
local t10 = {
	UpperAngle = 30,
	TwistLowerAngle = -40,
	TwistUpperAngle = 40
}
local t11 = {
	UpperAngle = 110,
	TwistLowerAngle = -85,
	TwistUpperAngle = 85
}
local t12 = {
	UpperAngle = 40,
	TwistLowerAngle = -5,
	TwistUpperAngle = 80
}
local vector3 = Vector3.new()
local t13 = {
	{
		"UpperTorso",
		"RightShoulderRagdollAttachment",
		CFrame.fromMatrix(vector3, Vector3.new(1, 0, 0), (Vector3.new(0, 1, 0))),
		"RightShoulderRigAttachment"
	},
	{
		"RightUpperArm",
		"RightShoulderRagdollAttachment",
		CFrame.fromMatrix(vector3, Vector3.new(0, -1, 0), (Vector3.new(1, 0, 0))),
		"RightShoulderRigAttachment"
	},
	{
		"UpperTorso",
		"LeftShoulderRagdollAttachment",
		CFrame.fromMatrix(vector3, Vector3.new(-1, 0, 0), (Vector3.new(0, 1, 0))),
		"LeftShoulderRigAttachment"
	},
	{
		"LeftUpperArm",
		"LeftShoulderRagdollAttachment",
		CFrame.fromMatrix(vector3, Vector3.new(0, -1, 0), (Vector3.new(-1, 0, 0))),
		"LeftShoulderRigAttachment"
	}
}
local t14 = {
	{
		"UpperTorso",
		"Head",
		"NeckRigAttachment",
		t2
	},
	{
		"LowerTorso",
		"UpperTorso",
		"WaistRigAttachment",
		t3
	},
	{
		"UpperTorso",
		"LeftUpperArm",
		"LeftShoulderRagdollAttachment",
		t8
	},
	{
		"LeftUpperArm",
		"LeftLowerArm",
		"LeftElbowRigAttachment",
		t5
	},
	{
		"LeftLowerArm",
		"LeftHand",
		"LeftWristRigAttachment",
		t6
	},
	{
		"UpperTorso",
		"RightUpperArm",
		"RightShoulderRagdollAttachment",
		t8
	},
	{
		"RightUpperArm",
		"RightLowerArm",
		"RightElbowRigAttachment",
		t5
	},
	{
		"RightLowerArm",
		"RightHand",
		"RightWristRigAttachment",
		t6
	},
	{
		"LowerTorso",
		"LeftUpperLeg",
		"LeftHipRigAttachment",
		t9
	},
	{
		"LeftUpperLeg",
		"LeftLowerLeg",
		"LeftKneeRigAttachment",
		t7
	},
	{
		"LeftLowerLeg",
		"LeftFoot",
		"LeftAnkleRigAttachment",
		t4
	},
	{
		"LowerTorso",
		"RightUpperLeg",
		"RightHipRigAttachment",
		t9
	},
	{
		"RightUpperLeg",
		"RightLowerLeg",
		"RightKneeRigAttachment",
		t7
	},
	{
		"RightLowerLeg",
		"RightFoot",
		"RightAnkleRigAttachment",
		t4
	}
}
local t15 = {
	{
		"LowerTorso",
		"LeftUpperArm"
	},
	{
		"LeftUpperArm",
		"LeftHand"
	},
	{
		"LowerTorso",
		"RightUpperArm"
	},
	{
		"RightUpperArm",
		"RightHand"
	},
	{
		"LeftUpperLeg",
		"RightUpperLeg"
	},
	{
		"UpperTorso",
		"RightUpperLeg"
	},
	{
		"RightUpperLeg",
		"RightFoot"
	},
	{
		"UpperTorso",
		"LeftUpperLeg"
	},
	{
		"LeftUpperLeg",
		"LeftFoot"
	},
	{
		"UpperTorso",
		"LeftLowerLeg"
	},
	{
		"UpperTorso",
		"RightLowerLeg"
	},
	{
		"LowerTorso",
		"LeftLowerLeg"
	},
	{
		"LowerTorso",
		"RightLowerLeg"
	},
	{
		"UpperTorso",
		"LeftLowerArm"
	},
	{
		"UpperTorso",
		"RightLowerArm"
	},
	{
		"Head",
		"LeftUpperArm"
	},
	{
		"Head",
		"RightUpperArm"
	}
}
local t16 = {
	{
		"Waist",
		"UpperTorso"
	},
	{
		"Neck",
		"Head"
	},
	{
		"LeftShoulder",
		"LeftUpperArm"
	},
	{
		"LeftElbow",
		"LeftLowerArm"
	},
	{
		"LeftWrist",
		"LeftHand"
	},
	{
		"RightShoulder",
		"RightUpperArm"
	},
	{
		"RightElbow",
		"RightLowerArm"
	},
	{
		"RightWrist",
		"RightHand"
	},
	{
		"LeftHip",
		"LeftUpperLeg"
	},
	{
		"LeftKnee",
		"LeftLowerLeg"
	},
	{
		"LeftAnkle",
		"LeftFoot"
	},
	{
		"RightHip",
		"RightUpperLeg"
	},
	{
		"RightKnee",
		"RightLowerLeg"
	},
	{
		"RightAnkle",
		"RightFoot"
	}
}
local t17 = {
	{
		"Head",
		"NeckAttachment",
		CFrame.new(0, -0.5, 0)
	},
	{
		"Torso",
		"RightShoulderRagdollAttachment",
		CFrame.fromMatrix(Vector3.new(1, 0.5, 0), Vector3.new(1, 0, 0), (Vector3.new(0, 1, 0)))
	},
	{
		"Right Arm",
		"RightShoulderRagdollAttachment",
		CFrame.fromMatrix(Vector3.new(-0.5, 0.5, 0), Vector3.new(0, -1, 0), (Vector3.new(1, 0, 0)))
	},
	{
		"Torso",
		"LeftShoulderRagdollAttachment",
		CFrame.fromMatrix(Vector3.new(-1, 0.5, 0), Vector3.new(-1, 0, 0), (Vector3.new(0, 1, 0)))
	},
	{
		"Left Arm",
		"LeftShoulderRagdollAttachment",
		CFrame.fromMatrix(Vector3.new(0.5, 0.5, 0), Vector3.new(0, -1, 0), (Vector3.new(-1, 0, 0)))
	},
	{
		"Torso",
		"RightHipAttachment",
		CFrame.new(0.5, -1, 0)
	},
	{
		"Right Leg",
		"RightHipAttachment",
		CFrame.new(0, 1, 0)
	},
	{
		"Torso",
		"LeftHipAttachment",
		CFrame.new(-0.5, -1, 0)
	},
	{
		"Left Leg",
		"LeftHipAttachment",
		CFrame.new(0, 1, 0)
	}
}
local t18 = {
	{
		"Torso",
		"Head",
		"NeckAttachment",
		t10
	},
	{
		"Torso",
		"Left Leg",
		"LeftHipAttachment",
		t12
	},
	{
		"Torso",
		"Right Leg",
		"RightHipAttachment",
		t12
	},
	{
		"Torso",
		"Left Arm",
		"LeftShoulderRagdollAttachment",
		t11
	},
	{
		"Torso",
		"Right Arm",
		"RightShoulderRagdollAttachment",
		t11
	}
}
local t19 = {
	{
		"Left Leg",
		"Right Leg"
	},
	{
		"Head",
		"Right Arm"
	},
	{
		"Head",
		"Left Arm"
	}
}
local t20 = {
	{
		"Neck",
		"Torso"
	},
	{
		"Left Shoulder",
		"Torso"
	},
	{
		"Right Shoulder",
		"Torso"
	},
	{
		"Left Hip",
		"Torso"
	},
	{
		"Right Hip",
		"Torso"
	}
}

local function indexParts(p1) -- line: 238
	local t21 = {}

	for _, child in ipairs(p1:GetChildren()) do
		if child:IsA("BasePart") then
			local name = child.name

			if not t21[name] then
				t21[name] = child
			end
		end
	end

	return t21
end
local function createRigJoints(p2, p3, p4) -- line: 252
	if p4 then
		local AnimationConstraint = Instance.new("AnimationConstraint")

		AnimationConstraint.Name = "Root"
		AnimationConstraint.Attachment0 = p2.HumanoidRootPart.RootRigAttachment
		AnimationConstraint.Attachment1 = p2.LowerTorso.RootRigAttachment
		AnimationConstraint.IsKinematic = true
		p2.LowerTorso.Root:Destroy()
		AnimationConstraint.Parent = p2.LowerTorso
	end

	for _, v in ipairs(p3) do
		local v44, v45, v46, v47 = unpack(v)
		local v48 = p2[v44]
		local v49 = p2[v45]

		if v48 and v49 then
			local v50 = v48:FindFirstChild(v46)
			local v51 = v49:FindFirstChild(v46)

			if v50 and v51 and v50:IsA("Attachment") and v51:IsA("Attachment") then
				local RagdollBallSocket = v49:FindFirstChild("RagdollBallSocket")

				if not RagdollBallSocket then
					RagdollBallSocket = Instance.new("BallSocketConstraint")
					RagdollBallSocket.Name = "RagdollBallSocket"
				end

				RagdollBallSocket.Attachment0 = v50
				RagdollBallSocket.Attachment1 = v51
				RagdollBallSocket.LimitsEnabled = true
				RagdollBallSocket.UpperAngle = v47.UpperAngle
				RagdollBallSocket.TwistLimitsEnabled = true
				RagdollBallSocket.TwistLowerAngle = v47.TwistLowerAngle
				RagdollBallSocket.TwistUpperAngle = v47.TwistUpperAngle

				local v53 = workspace.Gravity / 196.2

				if p4 then
					v53 = math.max(v53, 0.2)
				end

				local ReferenceMass = v47.ReferenceMass
				local v55 = ReferenceMass and v49:GetMass() / ReferenceMass or 1

				RagdollBallSocket.MaxFrictionTorque = (v47.FrictionTorque or 500) * v55 * v53

				if p4 then
					RagdollBallSocket.MaxFrictionTorque = RagdollBallSocket.MaxFrictionTorque / 100
				end

				RagdollBallSocket.Parent = v49

				if p4 then
					local Motor6D = v49:FindFirstChildWhichIsA("Motor6D")

					assert(Motor6D)

					local AnimationConstraint = Instance.new("AnimationConstraint")

					AnimationConstraint.Name = Motor6D.Name
					AnimationConstraint.Attachment0 = Motor6D.Part0:FindFirstChild(Motor6D.Name .. "RigAttachment")
					AnimationConstraint.Attachment1 = Motor6D.Part1:FindFirstChild(Motor6D.Name .. "RigAttachment")
					AnimationConstraint.IsKinematic = true
					AnimationConstraint.MaxTorque = (v47.StrengthTorque or 500) * v55 * v53
					AnimationConstraint.MaxForce = 0
					AnimationConstraint.Parent = Motor6D.parent
					Motor6D:Destroy()
				end
			end
		end
	end
end
local function createAdditionalAttachments(p5, p6) -- line: 320
	for _, v in ipairs(p6) do
		local v62, v63, v64, v65 = unpack(v)
		local v66 = p5[v62]

		if v66 then
			local v67 = v66:FindFirstChild(v63)

			if not v67 or v67:IsA("Attachment") then
				if v65 then
					local v68 = v66:FindFirstChild(v65)

					if v68 and v68:IsA("Attachment") then
						v64 = v68.CFrame * v64
					end
				end

				if not v67 then
					local Attachment = Instance.new("Attachment")

					Attachment.Name = v63
					Attachment.CFrame = v64
					Attachment.Parent = v66
				else
					v67.CFrame = v64
				end
			end
		end
	end
end
local function createNoCollides(p7, p8) -- line: 348
	local t22 = {}

	for _, v in ipairs(p8) do
		local v75, v76 = unpack(v)
		local v77 = p7[v75]
		local v78 = p7[v76]

		if v77 and v78 then
			local v79 = t22[v78]

			if not v79 then
				v79 = {}
				t22[v78] = v79
			end

			v79[v77] = true
		end
	end

	local t23 = {}

	for k, v in pairs(t22) do
		local t24 = {}

		for _, child in ipairs(k:GetChildren()) do
			if child:IsA("NoCollisionConstraint") and child.Name == "RagdollNoCollision" then
				local childPart0 = child.Part0

				if k == child.Part1 and v[childPart0] then
					v[childPart0] = nil
				else
					table.insert(t24, child)
				end
			end
		end

		t23[k] = t24
	end

	for k, v in pairs(t22) do
		local v89 = t23[k]

		for k2, _ in pairs(v) do
			local v92 = table.remove(v89) or Instance.new("NoCollisionConstraint")

			v92.Name = "RagdollNoCollision"
			v92.Part0 = k2
			v92.Part1 = k
			v92.Parent = k
		end
	end
end
local function isAttachmetInPart(p9, p10) -- line: 407
	return not not p9 and (p10 == p9.Parent or false)
end
local function checkValidAttachment(p11, p12, p13, p14) -- line: 411
	if not not p13 and (p11 == p13.Parent or false) and (not not p14 and (p12 == p14.Parent or false)) then
		return true
	end

	if not not p13 and (p12 == p13.Parent or false) and (not not p14 and (p11 == p14.Parent or false)) then
		return true
	end

	return false
end
local function hasValidConstraint(p15, p16) -- line: 423
	for _, child in ipairs(p16:GetChildren()) do
		if not child:IsA("BallSocketConstraint") then
			continue
		end

		local childAttachment0 = child.Attachment0
		local childAttachment1 = child.Attachment1

		if not not childAttachment0 and (p15 == childAttachment0.Parent or false) and not not (not not childAttachment1 and (p16 == childAttachment1.Parent or false)) or not not (not not childAttachment0 and (p16 == childAttachment0.Parent or false)) and not not (not not childAttachment1 and (p15 == childAttachment1.Parent or false)) then
			return true
		end
	end

	return false
end
local function hasRagdollJoint(p17) -- line: 438
	-- upvalues: EngineFeature (copy), hasValidConstraint (copy)
	if EngineFeature and (not p17:IsA("Motor6D") and not p17:IsA("AnimationConstraint")) then
		return false
	end

	local p17Part0 = nil
	local p17Part1 = nil

	if p17:IsA("Motor6D") then
		p17Part0 = p17.Part0
		p17Part1 = p17.Part1
	elseif EngineFeature and p17:IsA("AnimationConstraint") then
		local p17Attachment0 = p17.Attachment0
		local p17Attachment1 = p17.Attachment1

		p17Part0 = p17Attachment0 and p17Attachment0.Parent
		p17Part1 = p17Attachment1 and p17Attachment1.Parent
	end

	if not p17Part0 or not p17Part1 then
		return false
	end

	if hasValidConstraint(p17Part0, p17Part1) then
		return true
	end

	if hasValidConstraint(p17Part1, p17Part0) then
		return true
	end

	return false
end
local function disableMotorSet(p18, p19) -- line: 470
	-- upvalues: EngineFeature (copy), hasRagdollJoint (copy)
	local t25 = {}

	for _, v in ipairs(p19) do
		local v115 = p18:FindFirstChild(v[2])

		if v115 then
			local v116 = v115:FindFirstChild(v[1])

			if v116 and ((EngineFeature or v116:IsA("Motor6D")) and hasRagdollJoint(v116)) then
				table.insert(t25, v116)
				v116.Enabled = false
			end
		end
	end

	return t25
end

function t1.createRagdollJoints(p20, p21, p22) -- line: 486
	-- upvalues: indexParts (copy), createAdditionalAttachments (copy), t17 (copy), createRigJoints (copy), t18 (copy), createNoCollides (copy), t19 (copy), t13 (copy), t14 (copy), t15 (copy)
	local v120 = indexParts(p20)

	if p21 == Enum.HumanoidRigType.R6 then
		createAdditionalAttachments(v120, t17)
		createRigJoints(v120, t18, false)
		createNoCollides(v120, t19)

		return
	end

	if p21 == Enum.HumanoidRigType.R15 then
		createAdditionalAttachments(v120, t13)
		createRigJoints(v120, t14, p22)
		createNoCollides(v120, t15)

		return
	end

	error("unknown rig type", 2)
end
function t1.disableMotors(p23, p24) -- line: 501
	-- upvalues: disableMotorSet (copy), t20 (copy), t16 (copy)
	local v123 = nil

	if p24 == Enum.HumanoidRigType.R6 then
		v123 = disableMotorSet(p23, t20)
	elseif p24 == Enum.HumanoidRigType.R15 then
		v123 = disableMotorSet(p23, t16)
	else
		error("unknown rig type", 2)
	end

	local v124 = p23.PrimaryPart or p23:FindFirstChild("HumanoidRootPart")

	if v124 and v124:IsA("BasePart") then
		v124.CanCollide = false
	end

	local Head = p23:FindFirstChild("Head")

	if Head and Head:IsA("BasePart") then
		Head.CanCollide = true
	end

	return v123
end
function t1.disableParticleEmittersAndFadeOut(p25, p26) -- line: 530
	-- upvalues: RunService (copy)
	if RunService:IsServer() then
		error("disableParticleEmittersAndFadeOut should not be called on the server.", 2)
	end

	local descendants = p25:GetDescendants()
	local t26 = {}

	for _, v in pairs(descendants) do
		if v:IsA("BasePart") or v:IsA("Decal") then
			t26[v] = v.Transparency
		elseif v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
	end

	local n1 = 0

	while n1 < p26 do
		n1 += RunService.Heartbeat:Wait()

		local v133 = math.min(n1 / p26, 1)

		for k, v in pairs(t26) do
			k.Transparency = (1 - v133) * v + v133
		end
	end
end
function t1.easeNongraphicJointFriction(p27, p28) -- line: 558
	-- upvalues: RunService (copy)
	local descendants = p27:GetDescendants()
	local t27 = {}

	for _, v in pairs(descendants) do
		if v:IsA("BallSocketConstraint") and v.Name == "RagdollBallSocket" then
			v.MaxFrictionTorque = v.MaxFrictionTorque * 100

			local MaxFrictionTorque = v.MaxFrictionTorque
			local ParentName = v.Parent.Name

			t27[v] = {
				v,
				MaxFrictionTorque,
				MaxFrictionTorque * (ParentName ~= "UpperTorso" and ParentName ~= "Head" and 0.05 or 0.5)
			}
		end
	end

	local n2 = 0

	while n2 < p28 do
		local _, dt = RunService.Stepped:Wait()

		n2 += dt

		local v147 = math.min(n2 / p28, 1)

		for _, v in pairs(t27) do
			local v150, v151, v152 = unpack(v)

			v150.MaxFrictionTorque = (1 - v147) * v151 + v147 * v152
		end
	end
end
function t1.easeJointFriction_OLD(p29, p30) -- line: 587
	-- upvalues: RunService (copy)
	local descendants = p29:GetDescendants()
	local t28 = {}

	for _, v in pairs(descendants) do
		if v:IsA("BallSocketConstraint") and v.Name == "RagdollBallSocket" then
			local MaxFrictionTorque = v.MaxFrictionTorque
			local ParentName = v.Parent.Name

			t28[v] = {
				v,
				MaxFrictionTorque,
				MaxFrictionTorque * (ParentName ~= "UpperTorso" and ParentName ~= "Head" and 0.05 or 0.5)
			}
		end
	end

	local n3 = 0

	while n3 < p30 do
		local _, dt = RunService.Stepped:Wait()

		n3 += dt

		local v164 = math.min(n3 / p30, 1)

		for _, v in pairs(t28) do
			local v167, v168, v169 = unpack(v)

			v167.MaxFrictionTorque = (1 - v164) * v168 + v164 * v169
		end
	end
end

return t1
