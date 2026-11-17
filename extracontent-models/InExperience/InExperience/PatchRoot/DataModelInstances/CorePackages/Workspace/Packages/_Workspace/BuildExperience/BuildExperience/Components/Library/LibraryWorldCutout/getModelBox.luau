local function getModelBox(instance)
	local boundingBox, v = instance:GetBoundingBox()

	if v == Vector3.new(0, 0, 0) then
		return nil
	end

	local minimum = nil
	local maximum = nil

	for i = -1, 1, 2 do
		for j = -1, 1, 2 do
			for k = -1, 1, 2 do
				local pointToWorldSpace = boundingBox:PointToWorldSpace(v * Vector3.new(i, j, k) / 2)

				if minimum == nil then
					minimum = pointToWorldSpace
				else
					minimum = minimum:Min(pointToWorldSpace)
				end

				if maximum == nil then
					maximum = pointToWorldSpace
				else
					maximum = maximum:Max(pointToWorldSpace)
				end
			end
		end
	end

	return { center = boundingBox.Position, minimum = minimum, maximum = maximum }
end

return getModelBox
