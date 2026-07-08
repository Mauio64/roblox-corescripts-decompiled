local t1 = {
	InstanceIsAParticleEffect = function(p1) -- line: 10
		return p1:IsA("ParticleEmitter") or (p1:IsA("Fire") or (p1:IsA("Smoke") or p1:IsA("Sparkles")))
	end
}

local function recurFastForwardParticles(p2) -- line: 14
	-- upvalues: t1 (copy), recurFastForwardParticles (copy)
	if t1.InstanceIsAParticleEffect(p2) then
		p2:FastForward(240)
	end

	for _, child in (p2:GetChildren()) do
		recurFastForwardParticles(child)
	end
end

function t1.FastForwardParticles(p3) -- line: 25
	-- upvalues: recurFastForwardParticles (copy)
	recurFastForwardParticles(p3)
end

local function findNearestBasePart(p4) -- line: 30
	local p4Parent = p4.Parent

	while p4Parent do
		if p4Parent:IsA("BasePart") then
			return p4Parent
		end

		if p4Parent:IsA("Tool") then
			local Handle = p4Parent:FindFirstChild("Handle")

			if Handle and Handle:IsA("BasePart") then
				return Handle
			end
		end

		if p4Parent:IsA("Model") then
			local PrimaryPart = p4Parent.PrimaryPart

			if PrimaryPart then
				return PrimaryPart
			end
		end

		p4Parent = p4Parent.Parent
	end

	return nil
end
local function recurReparentOrphanedEffects(p5) -- line: 60
	-- upvalues: t1 (copy), findNearestBasePart (copy), recurReparentOrphanedEffects (copy)
	if t1.InstanceIsAParticleEffect(p5) then
		local p5Parent = p5.Parent

		if p5Parent and not p5Parent:IsA("BasePart") and not p5Parent:IsA("Attachment") then
			local v16 = findNearestBasePart(p5)

			if v16 then
				p5.Parent = v16
			end
		end

		return
	end

	for _, child in p5:GetChildren() do
		recurReparentOrphanedEffects(child)
	end
end

function t1.ReparentOrphanedParticleEffects(p6) -- line: 77
	-- upvalues: recurReparentOrphanedEffects (copy)
	recurReparentOrphanedEffects(p6)
end

return t1
