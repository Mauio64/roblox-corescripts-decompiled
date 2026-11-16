local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")

local ViewportQueryOptions = require(SceneUnderstanding.options.ViewportQueryOptions)

local function queryViewport(object, callback, p)
	local v = ViewportQueryOptions.new(p)

	local maxScreenDivisions = v.maxScreenDivisions

	local v2 = math.ceil(maxScreenDivisions / 2) - 1
	local total = 0
	local total2 = 0
	local instances = {}
	local v3 = 1
	local v4 = 0
	local count = 0
	local v5 = 1

	for _ = 1, maxScreenDivisions * maxScreenDivisions do
		local vector2 = Vector2.new(
			(total + 0.5 + v2) * (object.ViewportSize.X / maxScreenDivisions),
			(total2 + 0.5 + v2) * (object.ViewportSize.Y / maxScreenDivisions)
		)

		local screenPointToRay = object:ScreenPointToRay(vector2.X, vector2.Y)

		local raycastResult = workspace:Raycast(
			screenPointToRay.Origin,
			screenPointToRay.Direction * v.maxDistance,
			v.raycastParams
		)

		if
			raycastResult
			and raycastResult.Instance
			and not table.find(instances, raycastResult.Instance)
			and callback(raycastResult.Instance)
		then
			table.insert(instances, raycastResult.Instance)

			if #instances >= v.limit then
				return instances
			end
		end

		total += v3
		total2 += v4
		count += 1

		if count ~= v5 then
			continue
		end

		count = 0

		local v6 = -v4

		if v3 == 0 then
			v5 += 1
		end

		v4 = v3
		v3 = v6
	end

	return instances
end

return queryViewport
