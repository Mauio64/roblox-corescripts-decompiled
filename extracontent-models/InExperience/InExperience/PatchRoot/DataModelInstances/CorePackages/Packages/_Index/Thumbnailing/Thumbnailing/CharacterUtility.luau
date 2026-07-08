local t1 = {}

local function getHeadAttachments(p1) -- line: 11
	local t2 = {}
	local Head = p1:FindFirstChild("Head")

	if Head then
		for _, child in pairs(Head:GetChildren()) do
			if child:IsA("Attachment") then
				t2[child.Name] = true
			end
		end
	end

	return t2
end
local function makeRotatedCorner(n1: number, n2: number, n3: number, vector3: Vector3, cFrame: CFrame) -- line: 32
	return cFrame * Vector3.new(n1 * vector3.X, n2 * vector3.Y, n3 * vector3.Z)
end
local function growExtentsToIncludePoint(vector3: Vector3, vector3_2: Vector3, vector3_3: Vector3) -- line: 41
	return Vector3.new(math.min(vector3_3.X, vector3.X), math.min(vector3_3.Y, vector3.Y), (math.min(vector3_3.Z, vector3.Z))), (Vector3.new(math.max(vector3_3.X, vector3_2.X), math.max(vector3_3.Y, vector3_2.Y), (math.max(vector3_3.Z, vector3_2.Z))))
end
local function growExtentsToInclude(vector3: Vector3, vector3_4: Vector3, p2, cFrame: CFrame, cFrame2: CFrame?, n4: number?) -- line: 68
	-- upvalues: growExtentsToIncludePoint (copy)
	local v27 = p2.Size / 2

	for i = -1, 1, 2 do
		for j = -1, 1, 2 do
			for k = -1, 1, 2 do
				local v31 = p2.CFrame * Vector3.new(i * v27.X, j * v27.Y, k * v27.Z)

				if cFrame2 and n4 then
					local v32 = cFrame2:Inverse() * v31

					v31 = cFrame2 * Vector3.new(v32.X, math.max(n4, v32.Y), v32.Z)
				end

				local v33 = cFrame * v31

				vector3, vector3_4 = growExtentsToIncludePoint(vector3, vector3_4, v33)
			end
		end
	end

	return vector3, vector3_4
end
local function initExtents() -- line: 103
	return Vector3.new(1e999, 1e999, 1e999), (Vector3.new(-1e999, -1e999, -1e999))
end
local function recursiveCalculateExtents(vector3: Vector3, vector3_5: Vector3, p3, cFrame: CFrame, s1: string?) -- line: 118
	-- upvalues: growExtentsToInclude (copy), recursiveCalculateExtents (copy)
	if not s1 then
		s1 = ""
	end

	assert(s1, "indent is non-nil. Silence type checker.")

	local v39 = s1 .. "  "

	for _, child in pairs(p3:GetChildren()) do
		if child:IsA("BasePart") then
			vector3, vector3_5 = growExtentsToInclude(vector3, vector3_5, child, cFrame)
		end

		vector3, vector3_5 = recursiveCalculateExtents(vector3, vector3_5, child, cFrame, v39)
	end

	return vector3, vector3_5
end

function t1.CalculateModelExtents(p4, cFrame: CFrame) -- line: 145
	-- upvalues: recursiveCalculateExtents (copy)
	local vector3 = Vector3.new(1e999, 1e999, 1e999)
	local vector3_6 = Vector3.new(-1e999, -1e999, -1e999)
	local v46 = cFrame:Inverse()
	local v47, v48 = recursiveCalculateExtents(vector3, vector3_6, p4, v46, "  ")

	return v47, v48
end
function t1.CalculateHeadExtents(p5, cFrame: CFrame) -- line: 160
	-- upvalues: growExtentsToInclude (copy), getHeadAttachments (copy)
	local vector3 = Vector3.new(1e999, 1e999, 1e999)
	local vector3_7 = Vector3.new(-1e999, -1e999, -1e999)
	local Head = p5:FindFirstChild("Head")

	if not Head then
		return vector3, vector3_7
	end

	local v54 = cFrame:Inverse()
	local v55 = -Head.Size.Y / 2
	local v56, v57 = growExtentsToInclude(vector3, vector3_7, Head, v54)
	local v58 = getHeadAttachments(p5)

	for _, child in pairs(p5:GetChildren()) do
		if child:IsA("Accoutrement") then
			local Handle = child:FindFirstChild("Handle")

			if Handle then
				local Attachment = Handle:FindFirstChildWhichIsA("Attachment")

				if not Attachment or v58[Attachment.Name] then
					v56, v57 = growExtentsToInclude(v56, v57, Handle, v54, Head.CFrame, v55)
				end
			end
		end
	end

	return v56, v57
end
function t1.CalculateBodyPartsExtents(cFrame: CFrame, t3: {[any]: any}) -- line: 201
	-- upvalues: growExtentsToInclude (copy)
	local vector3 = Vector3.new(1e999, 1e999, 1e999)
	local vector3_8 = Vector3.new(-1e999, -1e999, -1e999)
	local v67 = cFrame:Inverse()

	for _, v in pairs(t3) do
		vector3, vector3_8 = growExtentsToInclude(vector3, vector3_8, v, v67, cFrame)
	end

	return vector3, vector3_8
end
function t1.AllocateDebugExtentParts() -- line: 217
	local t4 = {}

	for i = 1, 8 do
		local Part = Instance.new("Part")

		Part.Parent = workspace
		Part.Name = "DebugExtentPart" .. tostring(i)
		Part.Shape = Enum.PartType.Ball
		Part.Size = Vector3.new(0.25, 0.25, 0.25)
		Part.Anchored = true
		Part.CanCollide = false
		t4[#t4 + 1] = Part
	end

	return t4
end
function t1.PositionDebugExtentParts(t5: {[any]: any}, vector3: Vector3, vector3_9: Vector3, cFrame: CFrame) -- line: 237
	for i = 0, 1 do
		for j = 0, 1 do
			for k = 0, 1 do
				local v80 = i + j * 2 + k * 4 + 1
				local vector3_10 = Vector3.new(i == 0 and vector3.X or vector3_9.X, j == 0 and vector3.Y or vector3_9.Y, k == 0 and vector3.Z or vector3_9.Z)

				t5[v80].Position = cFrame * vector3_10
			end
		end
	end
end

return t1
