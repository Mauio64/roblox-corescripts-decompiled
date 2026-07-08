return {
	isInRange = function(vector3: Vector3, vector3_2: Vector3, vector3_3: Vector3, b1: boolean?) -- line: 3
		if b1 == true then
			return vector3.X > vector3_2.X and (vector3.X < vector3_3.X and (vector3.Y > vector3_2.Y and (vector3.Y < vector3_3.Y and (vector3.Z > vector3_2.Z and vector3.Z < vector3_3.Z))))
		end

		return vector3.X >= vector3_2.X and (vector3.X <= vector3_3.X and (vector3.Y >= vector3_2.Y and (vector3.Y <= vector3_3.Y and (vector3.Z >= vector3_2.Z and vector3.Z <= vector3_3.Z))))
	end,
	isFirstLessOrEqual = function(vector3: Vector3, vector3_4: Vector3) -- line: 10
		return vector3.X <= vector3_4.X and (vector3.Y <= vector3_4.Y and vector3.Z <= vector3_4.Z)
	end
}
