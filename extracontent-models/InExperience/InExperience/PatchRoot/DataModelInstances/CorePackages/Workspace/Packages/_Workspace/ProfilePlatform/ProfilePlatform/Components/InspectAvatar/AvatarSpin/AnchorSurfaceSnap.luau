require(script.Parent.ItemAnchors)

local AnchorSurfaceSnap = {}

local function perpendicularAxes(unit: Vector3) -- 1 equivalent call inferred from this helper
	local unit2 = unit:Cross(math.abs(unit.Y) < 0.9 and Vector3.new(0, 1, 0) or Vector3.new(1, 0, 0)).Unit
	return unit2, unit:Cross(unit2).Unit
end

local function medoid(positions)
	local v = positions[1]
	local v2 = 1e999

	for _, item in positions do
		local total = 0

		for _, item2 in positions do
			total += (item - item2).Magnitude
		end

		if not (total < v2) then
			continue
		end

		v = item
		v2 = total
	end

	return v
end

local function isSnappable(data) -- 1 equivalent call inferred from this helper
	local part = data.part
	return part:IsDescendantOf(data.target) and part:FindFirstChildWhichIsA("SpecialMesh") == nil
end

function AnchorSurfaceSnap.snapAnchor(object, data, cframe: CFrame, vector3: Vector3)
	if not isSnappable(data) then -- inferred equivalent call
		return data
	end

	local part = data.part
	local pointToWorldSpace = part.CFrame:PointToWorldSpace(data.offset)
	local normal = data.normal
	local v

	if normal then
		v = cframe:VectorToWorldSpace(normal)
	else
		v = vector3 - pointToWorldSpace
	end

	if v.Magnitude < 1e-6 then
		return data
	end

	local unit = v.Unit
	local unit2, unit3 = perpendicularAxes(unit) -- inferred equivalent call
	local halfMagnitude = part.Size.Magnitude / 2

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Include
	raycastParams.FilterDescendantsInstances = { data.target }

	local positions = {}

	for i = 0, 6 do
		for j = 0, 6 do
			local v2 = (i / 6 * 2 - 1) * halfMagnitude
			local v3 = (j / 6 * 2 - 1) * halfMagnitude
			local raycastResult = object:Raycast(
				pointToWorldSpace + unit * (halfMagnitude * 2) + unit2 * v2 + unit3 * v3,
				-unit * (halfMagnitude * 4),
				raycastParams
			)

			if raycastResult then
				table.insert(positions, raycastResult.Position)
			end
		end
	end

	if #positions == 0 then
		return data
	end

	local clone = table.clone(data)
	clone.offset = part.CFrame:PointToObjectSpace(medoid(positions) + unit * 0.02)
	return clone
end

function AnchorSurfaceSnap.snap(p, items, cframe: CFrame, vector3: Vector3)
	local result = {}

	for _, item in items do
		local anchors = {}

		for _, anchor in item.anchors do
			table.insert(anchors, AnchorSurfaceSnap.snapAnchor(p, anchor, cframe, vector3))
		end

		table.insert(result, { itemId = item.itemId, anchors = anchors })
	end

	return result
end

return AnchorSurfaceSnap
