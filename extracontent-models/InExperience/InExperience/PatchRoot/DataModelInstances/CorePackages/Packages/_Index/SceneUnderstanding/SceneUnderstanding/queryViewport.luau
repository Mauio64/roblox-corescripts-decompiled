local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")
local ViewportQueryOptions = require(SceneUnderstanding.options.ViewportQueryOptions)

local function queryViewport(p1, p2: ((...any) -> ...any), p3) -- line: 8
	-- upvalues: ViewportQueryOptions (copy)
	local v7 = ViewportQueryOptions.new(p3)
	local n1 = 0
	local n2 = 1
	local n3 = 0
	local n4 = 0
	local n5 = 1
	local n6 = 0
	local maxScreenDivisions = v7.maxScreenDivisions
	local v15 = math.ceil(maxScreenDivisions / 2) - 1
	local t1 = {}

	for _ = 1, maxScreenDivisions * maxScreenDivisions do
		local vector2 = Vector2.new((n1 + 0.5 + v15) * (p1.ViewportSize.X / maxScreenDivisions), (n3 + 0.5 + v15) * (p1.ViewportSize.Y / maxScreenDivisions))
		local v19 = p1:ScreenPointToRay(vector2.X, vector2.Y)
		local raycastResult = workspace:Raycast(v19.Origin, v19.Direction * v7.maxDistance, v7.raycastParams)

		if raycastResult and raycastResult.Instance and not table.find(t1, raycastResult.Instance) and p2(raycastResult.Instance) then
			table.insert(t1, raycastResult.Instance)

			if #t1 >= v7.limit then
				return t1
			end
		end

		n1 += n2
		n3 += n4
		n6 += 1

		if n6 == n5 then
			n6 = 0

			local v21 = -n4

			n4 = n2
			n2 = v21

			if n4 == 0 then
				n5 += 1
				n2 = v21
			end
		end
	end

	return t1
end

return queryViewport
