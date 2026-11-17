local ViewportProjection = {
	worldToViewport = function(cframe: CFrame, p: number, vector2: Vector2, vector3: Vector3)
		local pointToObjectSpace = cframe:PointToObjectSpace(vector3)
		local v = -pointToObjectSpace.Z

		if v <= 0.001 or vector2.X <= 0 or vector2.Y <= 0 then
			return Vector2.zero, (math.min(v, 0))
		end

		local v2 = math.tan(math.rad(p) / 2)
		local v3 = v2 * vector2.X / vector2.Y
		local v4 = pointToObjectSpace.X / v / v3
		local v5 = pointToObjectSpace.Y / v / v2
		return Vector2.new((v4 + 1) * 0.5 * vector2.X, (1 - v5) * 0.5 * vector2.Y), v
	end,
	viewportToRay = function(cframe: CFrame, p: number, vector2: Vector2, vector2_2: Vector2)
		if vector2.X <= 0 or vector2.Y <= 0 then
			return cframe.LookVector
		end

		local v = math.tan(math.rad(p) / 2)
		local v2 = v * vector2.X / vector2.Y
		local v3 = vector2_2.X / vector2.X * 2 - 1
		local v4 = 1 - vector2_2.Y / vector2.Y * 2
		return cframe:VectorToWorldSpace((Vector3.new(v3 * v2, v4 * v, -1))).Unit
	end,
	isInsideViewport = function(vector2: Vector2, vector2_2: Vector2, p: number): boolean
		return vector2.X >= -p and vector2.Y >= -p and vector2.X <= vector2_2.X + p and vector2.Y <= vector2_2.Y + p
	end
}

function ViewportProjection.projectBounds(instance, data)
	local boundingBox, v = instance:GetBoundingBox()
	local minX = 1e999
	local minY = 1e999
	local maxX = -1e999
	local maxY = -1e999

	for _, v2 in { -0.5, 0.5 } do
		for _, v3 in { -0.5, 0.5 } do
			for _, v4 in { -0.5, 0.5 } do
				local pointToWorldSpace = boundingBox:PointToWorldSpace((Vector3.new(v2 * v.X, v3 * v.Y, v4 * v.Z)))
				local worldToViewport, v5 = ViewportProjection.worldToViewport(
					data.cameraCFrame,
					data.fieldOfView,
					data.viewportSize,
					pointToWorldSpace
				)

				if not (v5 > 0) then
					continue
				end

				minX = math.min(minX, worldToViewport.X)
				minY = math.min(minY, worldToViewport.Y)
				maxX = math.max(maxX, worldToViewport.X)
				maxY = math.max(maxY, worldToViewport.Y)
			end
		end
	end

	if minX == 1e999 then
		return nil
	end

	return {
		x = minX,
		y = minY,
		width = maxX - minX,
		height = maxY - minY
	}
end

return ViewportProjection
