local VectorUtility = {}

function VectorUtility.Vector3FromXYRotPlusDistance(p: number, p2: number, p3: number)
	return CFrame.fromEulerAnglesXYZ(math.rad(p), math.rad(p2), 0).LookVector * p3
end

function VectorUtility.Vector3FromJson(value: string)
	local v, v2, v3 = unpack(value:split("/"))
	local v4 = tonumber(v)
	local v5 = tonumber(v2)
	local v6 = tonumber(v3)

	if v4 and v5 and v6 then
		return VectorUtility.Vector3FromXYRotPlusDistance(v4, v5, v6)
	end

	return Vector3.new(0, 0, 0)
end

return VectorUtility
