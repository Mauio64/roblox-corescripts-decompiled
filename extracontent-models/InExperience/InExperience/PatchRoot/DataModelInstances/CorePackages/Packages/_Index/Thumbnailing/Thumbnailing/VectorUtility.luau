local t1 = {
	Vector3FromXYRotPlusDistance = function(n1: number, n2: number, n3: number) -- line: 5
		return CFrame.fromEulerAnglesXYZ(math.rad(n1), math.rad(n2), 0).LookVector * n3
	end
}

function t1.Vector3FromJson(s1: string) -- line: 11
	-- upvalues: t1 (copy)
	local v6, v7, v8 = unpack(s1:split("/"))
	local num = tonumber(v6)
	local num2 = tonumber(v7)
	local num3 = tonumber(v8)

	if num and num2 and num3 then
		return t1.Vector3FromXYRotPlusDistance(num, num2, num3)
	end

	return (Vector3.new(0, 0, 0))
end

return t1
