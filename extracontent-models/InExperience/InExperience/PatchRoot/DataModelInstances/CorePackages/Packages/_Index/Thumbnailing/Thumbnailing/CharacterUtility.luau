local CharacterUtility = {}

local function getHeadAttachments(instance)
	local nameSet = {}
	local head = instance:FindFirstChild("Head")

	if head then
		for _, attachment in pairs(head:GetChildren()) do
			if attachment:IsA("Attachment") then
				nameSet[attachment.Name] = true
			end
		end
	end

	return nameSet
end

local function makeRotatedCorner(i: number, i2: number, i3: number, vector3: Vector3, cframe: CFrame) -- 1 equivalent call inferred from this helper
	return cframe * Vector3.new(i * vector3.X, i2 * vector3.Y, i3 * vector3.Z)
end

local function growExtentsToIncludePoint(vector3: Vector3, vector3_2: Vector3, vector3_3: Vector3)
	return
		Vector3.new(
			math.min(vector3_3.X, vector3.X),
			math.min(vector3_3.Y, vector3.Y),
			(math.min(vector3_3.Z, vector3.Z))
		),
		(Vector3.new(
			math.max(vector3_3.X, vector3_2.X),
			math.max(vector3_3.Y, vector3_2.Y),
			(math.max(vector3_3.Z, vector3_2.Z))
		))
end

local function growExtentsToInclude(vector3: Vector3, vector3_2: Vector3, instance, cframe: CFrame, cframe2: CFrame?, p: number?)
	local halfSize = instance.Size / 2

	for i = -1, 1, 2 do
		for j = -1, 1, 2 do
			for k = -1, 1, 2 do
				local rotatedCorner = makeRotatedCorner(i, j, k, halfSize, instance.CFrame) -- inferred equivalent call

				if cframe2 and p then
					local v = cframe2:Inverse() * rotatedCorner

					rotatedCorner = cframe2 * Vector3.new(v.X, math.max(p, v.Y), v.Z)
				end

				vector3, vector3_2 = growExtentsToIncludePoint(vector3, vector3_2, cframe * rotatedCorner)
			end
		end
	end

	return vector3, vector3_2
end

local function initExtents() -- 2 equivalent calls inferred from this helper
	return Vector3.new(1e999, 1e999, 1e999), Vector3.new(-1e999, -1e999, -1e999)
end

local function recursiveCalculateExtents(vector3: Vector3, vector3_2: Vector3, instance, inverse: CFrame, value: string?)
	value = value or ""
	assert(value, "indent is non-nil. Silence type checker.")
	local v = value .. "  "

	for _, part in pairs(instance:GetChildren()) do
		if part:IsA("BasePart") then
			vector3, vector3_2 = growExtentsToInclude(vector3, vector3_2, part, inverse)
		end

		vector3, vector3_2 = recursiveCalculateExtents(vector3, vector3_2, part, inverse, v)
	end

	return vector3, vector3_2
end

function CharacterUtility.CalculateModelExtents(p, cframe: CFrame)
	local inverse = cframe:Inverse()
	local v, v2 = recursiveCalculateExtents(
		Vector3.new(1e999, 1e999, 1e999),
		Vector3.new(-1e999, -1e999, -1e999),
		p,
		inverse,
		"  "
	)
	return v, v2
end

function CharacterUtility.CalculateHeadExtents(instance, cframe: CFrame)
	local v, v2 = initExtents() -- inferred equivalent call
	local head = instance:FindFirstChild("Head")

	if not head then
		return v, v2
	end

	local inverse = cframe:Inverse()

	local v3 = -head.Size.Y / 2

	local v4, v5 = growExtentsToInclude(v, v2, head, inverse)

	local headAttachments = getHeadAttachments(instance)

	for _, accoutrement in pairs(instance:GetChildren()) do
		if not accoutrement:IsA("Accoutrement") then
			continue
		end

		local handle = accoutrement:FindFirstChild("Handle")

		if not handle then
			continue
		end

		local attachment = handle:FindFirstChildWhichIsA("Attachment")

		if not attachment or headAttachments[attachment.Name] then
			v4, v5 = growExtentsToInclude(v4, v5, handle, inverse, head.CFrame, v3)
		end
	end

	return v4, v5
end

function CharacterUtility.CalculateBodyPartsExtents(cframe: CFrame, items)
	local inverse = cframe:Inverse()
	local v, v2 = initExtents() -- inferred equivalent call

	for _, item in pairs(items) do
		v, v2 = growExtentsToInclude(v, v2, item, inverse, cframe)
	end

	return v, v2
end

function CharacterUtility.AllocateDebugExtentParts()
	local result = {}

	for i = 1, 8 do
		local part = Instance.new("Part")
		part.Parent = workspace
		part.Name = "DebugExtentPart" .. tostring(i)
		part.Shape = Enum.PartType.Ball
		part.Size = Vector3.new(0.25, 0.25, 0.25)
		part.Anchored = true
		part.CanCollide = false
		result[#result + 1] = part
	end

	return result
end

function CharacterUtility.PositionDebugExtentParts(p, vector3: Vector3, vector3_2: Vector3, cframe: CFrame)
	for i = 0, 1 do
		for j = 0, 1 do
			for k = 0, 1 do
				local v = i + j * 2 + k * 4 + 1
				local vector3_3 = Vector3.new(
					i == 0 and vector3.X or vector3_2.X,
					j == 0 and vector3.Y or vector3_2.Y,
					k == 0 and vector3.Z or vector3_2.Z
				)
				p[v].Position = cframe * vector3_3
			end
		end
	end
end

return CharacterUtility
