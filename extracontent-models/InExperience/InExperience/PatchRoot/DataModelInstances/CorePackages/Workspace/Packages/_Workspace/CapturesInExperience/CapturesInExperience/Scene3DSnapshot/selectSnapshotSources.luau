local v = {
	Vector3.new(1, 1, 1),
	Vector3.new(1, 1, -1),
	Vector3.new(1, -1, 1),
	Vector3.new(1, -1, -1),
	Vector3.new(-1, 1, 1),
	Vector3.new(-1, 1, -1),
	Vector3.new(-1, -1, 1),
	Vector3.new(-1, -1, -1)
}

local function isCharacter(model) -- 1 equivalent call inferred from this helper
	return model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") ~= nil
end

local function selectSnapshotSources(data)
	local position = data.cameraCFrame.Position
	local inverse = data.cameraCFrame:Inverse()
	local fovMargin = math.rad(data.fovMargin)
	local v2 = math.rad(data.fieldOfView * 0.5)
	local v3 = math.atan(math.tan(v2) * data.aspect)
	local v4 = math.tan((math.min(v2 + fovMargin, 1.53588974175501)))
	local v5 = math.tan((math.min(v3 + fovMargin, 1.53588974175501)))

	local function isInView(descendant): boolean
		local v6 = descendant.Size * 0.5
		local cframe = descendant.CFrame
		local count = 0
		local count2 = 0
		local count3 = 0
		local count4 = 0
		local count5 = 0
		local count6 = 0

		for _, v7 in v do
			local v8 = inverse * (cframe * (v6 * v7))
			local v9 = -v8.Z
			local v10 = v9 * v5
			local v11 = v9 * v4

			if v9 <= 0 then
				count += 1
			end

			if data.maxDepth < v9 then
				count2 += 1
			end

			if v10 < v8.X then
				count3 += 1
			end

			if v10 < -v8.X then
				count4 += 1
			end

			if v11 < v8.Y then
				count5 += 1
			end

			if v11 < -v8.Y then
				count6 += 1
			end
		end

		local count7 = #v

		return count ~= count7
			and count2 ~= count7
			and count3 ~= count7
			and count4 ~= count7
			and count5 ~= count7
			and count6 ~= count7
			or (descendant.Position - position).Magnitude - v6.Magnitude <= data.nearRadius
	end

	local function nearestCharacter(descendant)
		local parent = descendant.Parent

		while parent ~= nil and parent ~= data.root do
			if isCharacter(parent) then -- inferred equivalent call
				return parent
			end

			parent = parent.Parent
		end

		return nil
	end

	local descendants = {}
	local v6 = {}
	local set = {}

	local function addCharacter(p) -- 2 equivalent calls inferred from this helper
		if not set[p] then
			set[p] = true
			table.insert(v6, p)
		end
	end

	if data.localCharacter ~= nil then
		addCharacter(data.localCharacter) -- inferred equivalent call
	end

	for _, descendant in data.root:GetDescendants() do
		if not descendant:IsA("BasePart") or descendant:IsA("Terrain") or not isInView(descendant) then
			continue
		end

		local v7 = nearestCharacter(descendant)

		if v7 == nil then
			set[descendant] = true
			table.insert(descendants, descendant)
		else
			addCharacter(v7) -- inferred equivalent call
		end
	end

	local function isUnderCandidate(p): boolean
		local parent = p.Parent

		while parent ~= nil and parent ~= data.root do
			if set[parent] then
				return true
			end

			parent = parent.Parent
		end

		return false
	end

	local looseParts = {}

	for _, v7 in descendants do
		local parent = v7.Parent
		local v8

		while true do
			if parent == nil or parent == data.root then
				v8 = false
				break
			end

			if set[parent] then
				v8 = true
				break
			end

			parent = parent.Parent
		end

		if not v8 then
			table.insert(looseParts, v7)
		end
	end

	local characters = {}

	for _, v7 in v6 do
		local parent = v7.Parent
		local v8

		while true do
			if parent == nil or parent == data.root then
				v8 = false
				break
			end

			if set[parent] then
				v8 = true
				break
			end

			parent = parent.Parent
		end

		if not v8 then
			table.insert(characters, v7)
		end
	end

	return { looseParts = looseParts, characters = characters }
end

return selectSnapshotSources
