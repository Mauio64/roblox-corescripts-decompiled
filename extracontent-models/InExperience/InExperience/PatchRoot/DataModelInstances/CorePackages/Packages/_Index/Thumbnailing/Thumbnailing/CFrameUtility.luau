local CFrameUtility = {}

function CFrameUtility.CalculateTargetCFrame(cframe: CFrame)
	local v

	if math.abs(cframe.LookVector.Y) > 0.9 then
		v = cframe.UpVector
	else
		v = cframe.LookVector
	end

	local unit = Vector3.new(v.X, 0, v.Z).Unit

	return CFrame.lookAt(cframe.Position, cframe.Position + unit)
end

function CFrameUtility.AdjustTargetCFrameWithExtents(cframe: CFrame, vector3: Vector3, vector3_2: Vector3)
	local midpoint = (vector3 + vector3_2) / 2
	return cframe + (cframe - cframe.Position) * midpoint
end

function CFrameUtility.CalculateTargetCFrameWithExtents(cframe: CFrame, vector3: Vector3, vector3_2: Vector3)
	local targetCFrame = CFrameUtility.CalculateTargetCFrame(cframe)
	return CFrameUtility.AdjustTargetCFrameWithExtents(targetCFrame, vector3, vector3_2)
end

return CFrameUtility
