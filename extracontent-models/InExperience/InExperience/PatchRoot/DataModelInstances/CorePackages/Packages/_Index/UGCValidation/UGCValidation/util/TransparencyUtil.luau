return {
	transformTriangleToWorld = function(vector3: Vector3, vector3_2: Vector3, vector3_3: Vector3, cframe: CFrame, vector3_4: Vector3)
		local v = cframe * (vector3 * vector3_4)
		local v2 = cframe * (vector3_2 * vector3_4)
		local v3 = cframe * (vector3_3 * vector3_4)

		return v, v2, v3, (v2 - v):Cross(v3 - v).Unit
	end
}
