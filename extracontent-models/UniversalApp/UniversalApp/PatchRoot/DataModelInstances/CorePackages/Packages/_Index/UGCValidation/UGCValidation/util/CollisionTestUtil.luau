return {
	pointInAxisAlignedBounds = function(vector3: Vector3, vector3_2: Vector3, vector3_3: Vector3) -- line: 7
		local v4 = vector3 - vector3_2

		return v4.X >= -vector3_3.X / 2 and (v4.X <= vector3_3.X / 2 and (v4.Y >= -vector3_3.Y / 2 and (v4.Y <= vector3_3.Y / 2 and (v4.Z >= -vector3_3.Z / 2 and v4.Z <= vector3_3.Z / 2))))
	end
}
