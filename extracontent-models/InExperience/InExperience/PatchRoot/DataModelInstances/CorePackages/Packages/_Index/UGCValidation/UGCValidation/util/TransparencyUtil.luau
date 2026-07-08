return {
	transformTriangleToWorld = function(vector3: Vector3, vector3_2: Vector3, vector3_3: Vector3, cFrame: CFrame, vector3_4: Vector3) -- line: 10
		local v6 = cFrame * (vector3 * vector3_4)
		local v7 = cFrame * (vector3_2 * vector3_4)
		local v8 = cFrame * (vector3_3 * vector3_4)

		return v6, v7, v8, (v7 - v6):Cross(v8 - v6).Unit
	end
}
