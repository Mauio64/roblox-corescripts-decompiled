local Vector3Utils = {}

function Vector3Utils.isInRange(vector3: Vector3, vector3_2: Vector3, vector3_3: Vector3, flag: boolean?): boolean
	if flag == true then
		return vector3.X > vector3_2.X
			and vector3.X < vector3_3.X
			and vector3.Y > vector3_2.Y
			and vector3.Y < vector3_3.Y
			and vector3.Z > vector3_2.Z
			and vector3.Z < vector3_3.Z
	end

	return vector3.X >= vector3_2.X
		and vector3.X <= vector3_3.X
		and vector3.Y >= vector3_2.Y
		and vector3.Y <= vector3_3.Y
		and vector3.Z >= vector3_2.Z
		and vector3.Z <= vector3_3.Z
end

function Vector3Utils.isFirstLessOrEqual(vector3: Vector3, vector3_2: Vector3): boolean
	return vector3.X <= vector3_2.X and vector3.Y <= vector3_2.Y and vector3.Z <= vector3_2.Z
end

return Vector3Utils
