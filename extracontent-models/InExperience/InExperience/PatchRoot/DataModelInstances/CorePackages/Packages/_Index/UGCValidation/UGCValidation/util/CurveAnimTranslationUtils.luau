return {
	translationExceedsThreshold = function(instance, p: number)
		local position = instance:FindFirstChild("Position")

		if not (position and position:IsA("Vector3Curve")) then
			return false, 0
		end

		local vector3 = Vector3.new(unpack(position:GetValueAtTime(0)))

		local times = {}

		for _, childName in { "X", "Y", "Z" } do
			local floatCurve = position:FindFirstChild(childName)

			if not (floatCurve and floatCurve:IsA("FloatCurve")) then
				continue
			end

			for _, v in floatCurve:GetKeys() do
				table.insert(times, v.Time)
			end
		end

		local v = 0

		for _, v2 in times do
			local magnitude = (Vector3.new(unpack(position:GetValueAtTime(v2))) - vector3).Magnitude

			if v < magnitude then
				v = magnitude
			end
		end

		return p < v, v
	end
}
