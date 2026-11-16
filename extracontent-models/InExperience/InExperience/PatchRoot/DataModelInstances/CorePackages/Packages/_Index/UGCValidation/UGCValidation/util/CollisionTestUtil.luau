return {
	pointInAxisAlignedBounds = function(vector3: Vector3, vector3_2: Vector3, vector3_3: Vector3): boolean
		local v = vector3 - vector3_2
		return v.X >= -vector3_3.X / 2
			and v.X <= vector3_3.X / 2
			and v.Y >= -vector3_3.Y / 2
			and v.Y <= vector3_3.Y / 2
			and v.Z >= -vector3_3.Z / 2
			and v.Z <= vector3_3.Z / 2
	end
}
