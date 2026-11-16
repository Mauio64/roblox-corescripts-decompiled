local RunService = game:GetService("RunService")

local engineFeature = game:GetEngineFeature("AvatarJointUpgradeFeature")

local v = {
	UpperAngle = 10,
	TwistLowerAngle = -10,
	TwistUpperAngle = 10,
	StrengthTorque = 400,
	ReferenceMass = 0.43671694397926
}

local v2 = {
	UpperAngle = 20,
	TwistLowerAngle = 5,
	TwistUpperAngle = 120,
	StrengthTorque = 1200,
	ReferenceMass = 0.70196455717087
}

local v3 = {
	UpperAngle = 30,
	TwistLowerAngle = -10,
	TwistUpperAngle = 10,
	StrengthTorque = 400,
	ReferenceMass = 0.69132566452026
}

local v4 = {
	UpperAngle = 5,
	TwistLowerAngle = -120,
	TwistUpperAngle = -5,
	StrengthTorque = 2000,
	ReferenceMass = 0.65389388799667
}

local v5 = {
	UpperAngle = 110,
	TwistLowerAngle = -85,
	TwistUpperAngle = 85,
	FrictionTorque = 600,
	StrengthTorque = 4000,
	ReferenceMass = 0.90918225049973
}

local v6 = {
	UpperAngle = 40,
	TwistLowerAngle = -5,
	TwistUpperAngle = 80,
	FrictionTorque = 600,
	StrengthTorque = 4000,
	ReferenceMass = 1.9175016880035
}

local v7 = { UpperAngle = 110, TwistLowerAngle = -85, TwistUpperAngle = 85 }

local v8 = { UpperAngle = 40, TwistLowerAngle = -5, TwistUpperAngle = 80 }

local vector3 = Vector3.new()

local v9 = {
	{
		"UpperTorso",
		"RightShoulderRagdollAttachment",
		CFrame.fromMatrix(vector3, Vector3.new(1, 0, 0), Vector3.new(0, 1, 0)),
		"RightShoulderRigAttachment"
	},
	{
		"RightUpperArm",
		"RightShoulderRagdollAttachment",
		CFrame.fromMatrix(vector3, Vector3.new(0, -1, 0), Vector3.new(1, 0, 0)),
		"RightShoulderRigAttachment"
	},
	{
		"UpperTorso",
		"LeftShoulderRagdollAttachment",
		CFrame.fromMatrix(vector3, Vector3.new(-1, 0, 0), Vector3.new(0, 1, 0)),
		"LeftShoulderRigAttachment"
	},
	{
		"LeftUpperArm",
		"LeftShoulderRagdollAttachment",
		CFrame.fromMatrix(vector3, Vector3.new(0, -1, 0), Vector3.new(-1, 0, 0)),
		"LeftShoulderRigAttachment"
	}
}
local v10 = {
	{
		"UpperTorso",
		"Head",
		"NeckRigAttachment",
		{
			UpperAngle = 45,
			TwistLowerAngle = -40,
			TwistUpperAngle = 40,
			FrictionTorque = 400,
			StrengthTorque = 400,
			ReferenceMass = 1.0249234437943
		}
	},
	{
		"LowerTorso",
		"UpperTorso",
		"WaistRigAttachment",
		{
			UpperAngle = 20,
			TwistLowerAngle = -40,
			TwistUpperAngle = 20,
			FrictionTorque = 750,
			StrengthTorque = 5000,
			ReferenceMass = 2.861558675766
		}
	},
	{ "UpperTorso", "LeftUpperArm", "LeftShoulderRagdollAttachment", v5 },
	{ "LeftUpperArm", "LeftLowerArm", "LeftElbowRigAttachment", v2 },
	{ "LeftLowerArm", "LeftHand", "LeftWristRigAttachment", v3 },
	{ "UpperTorso", "RightUpperArm", "RightShoulderRagdollAttachment", v5 },
	{ "RightUpperArm", "RightLowerArm", "RightElbowRigAttachment", v2 },
	{ "RightLowerArm", "RightHand", "RightWristRigAttachment", v3 },
	{ "LowerTorso", "LeftUpperLeg", "LeftHipRigAttachment", v6 },
	{ "LeftUpperLeg", "LeftLowerLeg", "LeftKneeRigAttachment", v4 },
	{ "LeftLowerLeg", "LeftFoot", "LeftAnkleRigAttachment", v },
	{ "LowerTorso", "RightUpperLeg", "RightHipRigAttachment", v6 },
	{ "RightUpperLeg", "RightLowerLeg", "RightKneeRigAttachment", v4 },
	{ "RightLowerLeg", "RightFoot", "RightAnkleRigAttachment", v }
}

local v11 = {
	{ "LowerTorso", "LeftUpperArm" },
	{ "LeftUpperArm", "LeftHand" },
	{ "LowerTorso", "RightUpperArm" },
	{ "RightUpperArm", "RightHand" },
	{ "LeftUpperLeg", "RightUpperLeg" },
	{ "UpperTorso", "RightUpperLeg" },
	{ "RightUpperLeg", "RightFoot" },
	{ "UpperTorso", "LeftUpperLeg" },
	{ "LeftUpperLeg", "LeftFoot" },
	{ "UpperTorso", "LeftLowerLeg" },
	{ "UpperTorso", "RightLowerLeg" },
	{ "LowerTorso", "LeftLowerLeg" },
	{ "LowerTorso", "RightLowerLeg" },
	{ "UpperTorso", "LeftLowerArm" },
	{ "UpperTorso", "RightLowerArm" },
	{ "Head", "LeftUpperArm" },
	{ "Head", "RightUpperArm" }
}

local v12 = {
	{ "Waist", "UpperTorso" },
	{ "Neck", "Head" },
	{ "LeftShoulder", "LeftUpperArm" },
	{ "LeftElbow", "LeftLowerArm" },
	{ "LeftWrist", "LeftHand" },
	{ "RightShoulder", "RightUpperArm" },
	{ "RightElbow", "RightLowerArm" },
	{ "RightWrist", "RightHand" },
	{ "LeftHip", "LeftUpperLeg" },
	{ "LeftKnee", "LeftLowerLeg" },
	{ "LeftAnkle", "LeftFoot" },
	{ "RightHip", "RightUpperLeg" },
	{ "RightKnee", "RightLowerLeg" },
	{ "RightAnkle", "RightFoot" }
}

local v13 = {
	{ "Head", "NeckAttachment", CFrame.new(0, -0.5, 0) },
	{
		"Torso",
		"RightShoulderRagdollAttachment",
		CFrame.fromMatrix(Vector3.new(1, 0.5, 0), Vector3.new(1, 0, 0), Vector3.new(0, 1, 0))
	},
	{
		"Right Arm",
		"RightShoulderRagdollAttachment",
		CFrame.fromMatrix(Vector3.new(-0.5, 0.5, 0), Vector3.new(0, -1, 0), Vector3.new(1, 0, 0))
	},
	{
		"Torso",
		"LeftShoulderRagdollAttachment",
		CFrame.fromMatrix(Vector3.new(-1, 0.5, 0), Vector3.new(-1, 0, 0), Vector3.new(0, 1, 0))
	},
	{
		"Left Arm",
		"LeftShoulderRagdollAttachment",
		CFrame.fromMatrix(Vector3.new(0.5, 0.5, 0), Vector3.new(0, -1, 0), Vector3.new(-1, 0, 0))
	},
	{ "Torso", "RightHipAttachment", CFrame.new(0.5, -1, 0) },
	{ "Right Leg", "RightHipAttachment", CFrame.new(0, 1, 0) },
	{ "Torso", "LeftHipAttachment", CFrame.new(-0.5, -1, 0) },
	{ "Left Leg", "LeftHipAttachment", CFrame.new(0, 1, 0) }
}
local v14 = {
	{
		"Torso",
		"Head",
		"NeckAttachment",
		{ UpperAngle = 30, TwistLowerAngle = -40, TwistUpperAngle = 40 }
	},
	{ "Torso", "Left Leg", "LeftHipAttachment", v8 },
	{ "Torso", "Right Leg", "RightHipAttachment", v8 },
	{ "Torso", "Left Arm", "LeftShoulderRagdollAttachment", v7 },
	{ "Torso", "Right Arm", "RightShoulderRagdollAttachment", v7 }
}

local v15 = {
	{ "Left Leg", "Right Leg" },
	{ "Head", "Right Arm" },
	{ "Head", "Left Arm" }
}

local v16 = {
	{ "Neck", "Torso" },
	{ "Left Shoulder", "Torso" },
	{ "Right Shoulder", "Torso" },
	{ "Left Hip", "Torso" },
	{ "Right Hip", "Torso" }
}

local function indexParts(instance)
	local partsByName = {}

	for _, part in ipairs(instance:GetChildren()) do
		if not part:IsA("BasePart") then
			continue
		end

		local name = part.name

		if not partsByName[name] then
			partsByName[name] = part
		end
	end

	return partsByName
end

local function createRigJoints(p, list, p2)
	if p2 then
		local root = Instance.new("AnimationConstraint")
		root.Name = "Root"
		root.Attachment0 = p.HumanoidRootPart.RootRigAttachment
		root.Attachment1 = p.LowerTorso.RootRigAttachment
		root.IsKinematic = true
		p.LowerTorso.Root:Destroy()
		root.Parent = p.LowerTorso
	end

	for _, list2 in ipairs(list) do
		local v17, v18, v19, v20 = unpack(list2)
		local v21 = p[v17]
		local parent = p[v18]

		if not (v21 and parent) then
			continue
		end

		local attachment = v21:FindFirstChild(v19)
		local attachment2 = parent:FindFirstChild(v19)

		if not (attachment and attachment2 and attachment:IsA("Attachment") and attachment2:IsA("Attachment")) then
			continue
		end

		local ragdollBallSocket = parent:FindFirstChild("RagdollBallSocket")

		if not ragdollBallSocket then
			ragdollBallSocket = Instance.new("BallSocketConstraint")
			ragdollBallSocket.Name = "RagdollBallSocket"
		end

		ragdollBallSocket.Attachment0 = attachment
		ragdollBallSocket.Attachment1 = attachment2
		ragdollBallSocket.LimitsEnabled = true
		ragdollBallSocket.UpperAngle = v20.UpperAngle
		ragdollBallSocket.TwistLimitsEnabled = true
		ragdollBallSocket.TwistLowerAngle = v20.TwistLowerAngle
		ragdollBallSocket.TwistUpperAngle = v20.TwistUpperAngle

		local v22 = workspace.Gravity / 196.2

		if p2 then
			v22 = math.max(v22, 0.2)
		end

		local referenceMass = v20.ReferenceMass
		local v23 = referenceMass and parent:GetMass() / referenceMass or 1
		ragdollBallSocket.MaxFrictionTorque = (v20.FrictionTorque or 500) * v23 * v22

		if p2 then
			ragdollBallSocket.MaxFrictionTorque /= 100
		end

		ragdollBallSocket.Parent = parent

		if not p2 then
			continue
		end

		local motor6D = parent:FindFirstChildWhichIsA("Motor6D")
		assert(motor6D)

		local animationConstraint = Instance.new("AnimationConstraint")
		animationConstraint.Name = motor6D.Name
		animationConstraint.Attachment0 = motor6D.Part0:FindFirstChild(motor6D.Name .. "RigAttachment")
		animationConstraint.Attachment1 = motor6D.Part1:FindFirstChild(motor6D.Name .. "RigAttachment")
		animationConstraint.IsKinematic = true
		animationConstraint.MaxTorque = (v20.StrengthTorque or 500) * v23 * v22
		animationConstraint.MaxForce = 0
		animationConstraint.Parent = motor6D.parent
		motor6D:Destroy()
	end
end

local function createAdditionalAttachments(p, list)
	for _, list2 in ipairs(list) do
		local v17, name, cframe, v18 = unpack(list2)
		local parent = p[v17]

		if not parent then
			continue
		end

		local attachment = parent:FindFirstChild(name)

		if not (not attachment or attachment:IsA("Attachment")) then
			continue
		end

		if v18 then
			local attachment2 = parent:FindFirstChild(v18)

			if attachment2 and attachment2:IsA("Attachment") then
				cframe = attachment2.CFrame * cframe
			end
		end

		if attachment then
			attachment.CFrame = cframe
		else
			local attachment2 = Instance.new("Attachment")
			attachment2.Name = name
			attachment2.CFrame = cframe
			attachment2.Parent = parent
		end
	end
end

local function createNoCollides(p, list)
	local v17 = {}

	for _, list2 in ipairs(list) do
		local v18, v19 = unpack(list2)
		local v20 = p[v18]
		local v21 = p[v19]

		if not (v20 and v21) then
			continue
		end

		local v22 = v17[v21]

		if not v22 then
			v22 = {}
			v17[v21] = v22
		end

		v22[v20] = true
	end

	local v18 = {}

	for k, v19 in pairs(v17) do
		local noCollisionConstraints = {}

		for _, noCollisionConstraint in ipairs(k:GetChildren()) do
			if not (noCollisionConstraint:IsA("NoCollisionConstraint") and noCollisionConstraint.Name == "RagdollNoCollision") then
				continue
			end

			local part0 = noCollisionConstraint.Part0

			if noCollisionConstraint.Part1 == k and v19[part0] then
				v19[part0] = nil
			else
				table.insert(noCollisionConstraints, noCollisionConstraint)
			end
		end

		v18[k] = noCollisionConstraints
	end

	for k, v19 in pairs(v17) do
		local v20 = v18[k]

		for k2, _ in pairs(v19) do
			local ragdollNoCollision = table.remove(v20) or Instance.new("NoCollisionConstraint")

			ragdollNoCollision.Name = "RagdollNoCollision"
			ragdollNoCollision.Part0 = k2
			ragdollNoCollision.Part1 = k
			ragdollNoCollision.Parent = k
		end
	end
end

local function isAttachmetInPart(p, p2)
	return p and p.Parent == p2 and true or false
end

local function checkValidAttachment(p, p2, p3, p4): boolean
	if p3 and p3.Parent == p and p4 and p4.Parent == p2 or p3 and p3.Parent == p2 and p4 and p4.Parent == p then
		return true
	end

	return false
end

local function hasValidConstraint(p, instance): boolean
	for _, ballSocketConstraint in ipairs(instance:GetChildren()) do
		if not ballSocketConstraint:IsA("BallSocketConstraint") then
			continue
		end

		local attachment0 = ballSocketConstraint.Attachment0
		local attachment1 = ballSocketConstraint.Attachment1
		local v17

		if attachment0 and attachment0.Parent == p and attachment1 and attachment1.Parent == instance then
			v17 = true
		elseif attachment0 and attachment0.Parent == instance then
			v17 = attachment1 and attachment1.Parent == p and true or false
		else
			v17 = false
		end

		if v17 then
			return true
		end
	end

	return false
end

local function hasRagdollJoint(motor6D): boolean
	if engineFeature and not (motor6D:IsA("Motor6D") or motor6D:IsA("AnimationConstraint")) then
		return false
	end

	local v17 = nil
	local v18 = nil

	if motor6D:IsA("Motor6D") then
		v17 = motor6D.Part0
		v18 = motor6D.Part1
	elseif engineFeature and motor6D:IsA("AnimationConstraint") then
		local attachment0 = motor6D.Attachment0
		local attachment1 = motor6D.Attachment1
		v17 = attachment0 and attachment0.Parent
		v18 = attachment1 and attachment1.Parent
	end

	if not (v17 and v18) then
		return false
	end

	if hasValidConstraint(v17, v18) or hasValidConstraint(v18, v17) then
		return true
	end

	return false
end

local function disableMotorSet(instance, list)
	local motor6Ds = {}

	for _, item in ipairs(list) do
		local child = instance:FindFirstChild(item[2])

		if not child then
			continue
		end

		local motor6D = child:FindFirstChild(item[1])

		if not (motor6D and (engineFeature or motor6D:IsA("Motor6D")) and hasRagdollJoint(motor6D)) then
			continue
		end

		table.insert(motor6Ds, motor6D)
		motor6D.Enabled = false
	end

	return motor6Ds
end

local RagdollRigging = {}

function RagdollRigging.createRagdollJoints(p, p2, p3)
	local v17 = indexParts(p)

	if p2 == Enum.HumanoidRigType.R6 then
		createAdditionalAttachments(v17, v13)
		createRigJoints(v17, v14, false)
		createNoCollides(v17, v15)
	else
		if p2 ~= Enum.HumanoidRigType.R15 then
			error("unknown rig type", 2)

			return
		end

		createAdditionalAttachments(v17, v9)
		createRigJoints(v17, v10, p3)
		createNoCollides(v17, v11)
	end
end

function RagdollRigging.disableMotors(instance, p)
	local v17 = nil

	if p == Enum.HumanoidRigType.R6 then
		v17 = disableMotorSet(instance, v16)
	elseif p == Enum.HumanoidRigType.R15 then
		v17 = disableMotorSet(instance, v12)
	else
		error("unknown rig type", 2)
	end

	local primaryPart = instance.PrimaryPart or instance:FindFirstChild("HumanoidRootPart")

	if primaryPart and primaryPart:IsA("BasePart") then
		primaryPart.CanCollide = false
	end

	local head = instance:FindFirstChild("Head")

	if head and head:IsA("BasePart") then
		head.CanCollide = true
	end

	return v17
end

function RagdollRigging.disableParticleEmittersAndFadeOut(folder, p)
	if RunService:IsServer() then
		error("disableParticleEmittersAndFadeOut should not be called on the server.", 2)
	end

	local descendants = folder:GetDescendants()
	local transparenciesByInstance = {}

	for _, instance in pairs(descendants) do
		if instance:IsA("BasePart") or instance:IsA("Decal") then
			transparenciesByInstance[instance] = instance.Transparency
		elseif instance:IsA("ParticleEmitter") then
			instance.Enabled = false
		end
	end

	local total = 0

	while total < p do
		total += RunService.Heartbeat:Wait()
		local v17 = math.min(total / p, 1)

		for k, v18 in pairs(transparenciesByInstance) do
			k.Transparency = (1 - v17) * v18 + v17
		end
	end
end

function RagdollRigging.easeNongraphicJointFriction(folder, p)
	local descendants = folder:GetDescendants()

	local v17 = {}

	for _, ballSocketConstraint in pairs(descendants) do
		if not (ballSocketConstraint:IsA("BallSocketConstraint") and ballSocketConstraint.Name == "RagdollBallSocket") then
			continue
		end

		ballSocketConstraint.MaxFrictionTorque *= 100
		local maxFrictionTorque = ballSocketConstraint.MaxFrictionTorque

		local name = ballSocketConstraint.Parent.Name
		v17[ballSocketConstraint] = {
			ballSocketConstraint,
			maxFrictionTorque,
			maxFrictionTorque * ((name == "UpperTorso" or name == "Head") and 0.5 or 0.05)
		}
	end

	local total = 0

	while total < p do
		local _, v18 = RunService.Stepped:Wait()
		total += v18
		local v19 = math.min(total / p, 1)

		for _, list in pairs(v17) do
			local v20, v21, v22 = unpack(list)
			v20.MaxFrictionTorque = (1 - v19) * v21 + v19 * v22
		end
	end
end

function RagdollRigging.easeJointFriction_OLD(folder, p)
	local descendants = folder:GetDescendants()

	local v17 = {}

	for _, ballSocketConstraint in pairs(descendants) do
		if not (ballSocketConstraint:IsA("BallSocketConstraint") and ballSocketConstraint.Name == "RagdollBallSocket") then
			continue
		end

		local maxFrictionTorque = ballSocketConstraint.MaxFrictionTorque

		local name = ballSocketConstraint.Parent.Name
		v17[ballSocketConstraint] = {
			ballSocketConstraint,
			maxFrictionTorque,
			maxFrictionTorque * ((name == "UpperTorso" or name == "Head") and 0.5 or 0.05)
		}
	end

	local total = 0

	while total < p do
		local _, v18 = RunService.Stepped:Wait()
		total += v18
		local v19 = math.min(total / p, 1)

		for _, list in pairs(v17) do
			local v20, v21, v22 = unpack(list)
			v20.MaxFrictionTorque = (1 - v19) * v21 + v19 * v22
		end
	end
end

return RagdollRigging
