local ParticleUtility = {}

function ParticleUtility.InstanceIsAParticleEffect(instance)
	return instance:IsA("ParticleEmitter") or instance:IsA("Fire") or instance:IsA("Smoke") or instance:IsA("Sparkles")
end

local function recurFastForwardParticles(instance)
	if ParticleUtility.InstanceIsAParticleEffect(instance) then
		instance:FastForward(240)
	end

	local children = instance:GetChildren()

	for _, child in children do
		recurFastForwardParticles(child)
	end
end

function ParticleUtility.FastForwardParticles(p)
	recurFastForwardParticles(p)
end

local function findNearestBasePart(instance)
	local parent = instance.Parent

	while parent do
		if parent:IsA("BasePart") then
			return parent
		end

		if parent:IsA("Tool") then
			local handle = parent:FindFirstChild("Handle")

			if handle and handle:IsA("BasePart") then
				return handle
			end
		end

		local primaryPart = parent:IsA("Model") and parent.PrimaryPart

		if primaryPart then
			return primaryPart
		end

		parent = parent.Parent
	end

	return nil
end

local function recurReparentOrphanedEffects(instance)
	if ParticleUtility.InstanceIsAParticleEffect(instance) then
		local parent = instance.Parent
		local parent2 = parent
			and not parent:IsA("BasePart")
			and not parent:IsA("Attachment")
			and findNearestBasePart(instance)

		if parent2 then
			instance.Parent = parent2
		end
	else
		for _, child in instance:GetChildren() do
			recurReparentOrphanedEffects(child)
		end
	end
end

function ParticleUtility.ReparentOrphanedParticleEffects(p)
	recurReparentOrphanedEffects(p)
end

return ParticleUtility
