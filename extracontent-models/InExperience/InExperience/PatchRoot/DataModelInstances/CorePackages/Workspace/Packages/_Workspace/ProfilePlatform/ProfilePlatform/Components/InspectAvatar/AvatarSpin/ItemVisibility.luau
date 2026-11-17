local Easing = require(script.Parent.Easing)
require(script.Parent.ItemAnchors)
local ViewportProjection = require(script.Parent.ViewportProjection)

local ItemVisibility = {}

function ItemVisibility.anchorPosition(p)
	return p.part.CFrame:PointToWorldSpace(p.offset)
end

function ItemVisibility.facingWeight(data, cframe: CFrame, vector3: Vector3, vector3_2: Vector3)
	local normal = data.normal

	if not normal then
		return data.weight
	end

	local dot = cframe:VectorToWorldSpace(normal):Dot((vector3 - vector3_2).Unit)
	return Easing.smoothstep(math.cos((math.rad(data.zeroDegrees))), math.cos((math.rad(data.fullDegrees))), dot) * data.weight
end

function ItemVisibility.evaluate(items, data, callback)
	local position = data.cameraCFrame.Position
	local result = {}

	for _, item in items do
		local v = nil

		for _, anchor in item.anchors do
			local anchorPosition = ItemVisibility.anchorPosition(anchor)
			local facingWeight = ItemVisibility.facingWeight(anchor, data.rootCFrame, position, anchorPosition)
			local worldToViewport, v2 = ViewportProjection.worldToViewport(
				data.cameraCFrame,
				data.fieldOfView,
				data.viewportSize,
				anchorPosition
			)

			local weight = not (facingWeight > 0 and v2 > 0 and ViewportProjection.isInsideViewport(
					worldToViewport,
					data.viewportSize,
					-4
				) and callback(position, anchorPosition, anchor))
				and 0
				or facingWeight

			if v == nil or v.weight < weight then
				v = {
					itemId = item.itemId,
					position = worldToViewport,
					facing = facingWeight,
					weight = weight
				}
			end
		end

		if v then
			table.insert(result, v)
		end
	end

	return result
end

function ItemVisibility.visibleCharacterParams(instance, folder)
	local filterDescendantsInstances = {}

	for _, child in instance:GetChildren() do
		if child ~= folder then
			table.insert(filterDescendantsInstances, child)
		end
	end

	for _, part in folder:GetDescendants() do
		if part:IsA("BasePart") and part.Transparency >= 1 then
			table.insert(filterDescendantsInstances, part)
		end
	end

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = filterDescendantsInstances
	return raycastParams
end

function ItemVisibility.createRaycastCheck(object, p)
	local visibleCharacterParams = ItemVisibility.visibleCharacterParams(object, p)
	return function(origin: Vector3, vector3: Vector3, p2): boolean
		local v = vector3 - origin
		local raycastResult = object:Raycast(origin, v * 1.02, visibleCharacterParams)

		if
			raycastResult == nil
			or (raycastResult.Instance == p2.target or raycastResult.Instance:IsDescendantOf(p2.target))
		then
			return true
		end

		return raycastResult.Distance >= v.Magnitude - 0.08
	end
end

return ItemVisibility
