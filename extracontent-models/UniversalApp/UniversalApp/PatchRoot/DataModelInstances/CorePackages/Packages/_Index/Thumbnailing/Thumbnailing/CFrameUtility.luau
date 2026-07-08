local t1 = {
	CalculateTargetCFrame = function(cFrame: CFrame) -- line: 9
		local v3 = if not (math.abs(cFrame.LookVector.Y) > 0.9) then cFrame.LookVector else cFrame.UpVector
		local Unit = Vector3.new(v3.X, 0, v3.Z).Unit

		return CFrame.lookAt(cFrame.Position, cFrame.Position + Unit)
	end,
	AdjustTargetCFrameWithExtents = function(cFrame: CFrame, vector3: Vector3, vector3_2: Vector3) -- line: 24
		local v8 = (vector3 + vector3_2) / 2

		return cFrame + (cFrame - cFrame.Position) * v8
	end
}

function t1.CalculateTargetCFrameWithExtents(cFrame: CFrame, vector3: Vector3, vector3_3: Vector3) -- line: 47
	-- upvalues: t1 (copy)
	local v12 = t1.CalculateTargetCFrame(cFrame)

	return t1.AdjustTargetCFrameWithExtents(v12, vector3, vector3_3)
end

return t1
