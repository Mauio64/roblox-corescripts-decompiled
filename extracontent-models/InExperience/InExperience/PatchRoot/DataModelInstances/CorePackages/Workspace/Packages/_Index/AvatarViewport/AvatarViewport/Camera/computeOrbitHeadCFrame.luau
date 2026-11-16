local Constants = require(script.Parent.Parent.Constants)

local function computeOrbitHeadCFrame(data)
	local focusPartName = data.focusPartName or Constants.DefaultFocusPartName
	local part = data.character:FindFirstChild(focusPartName)

	if not (part and part:IsA("BasePart")) then
		return nil
	end

	local baseDistance = data.baseDistance or Constants.DefaultOrbitBaseDistance
	local fieldOfViewDeg = data.fieldOfViewDeg or Constants.DefaultOrbitFieldOfViewDeg
	local layout = data.layout

	local position = part.Position

	local fieldOfViewForDistanceScaleDeg = data.fieldOfViewForDistanceScaleDeg or fieldOfViewDeg

	local v = (not (fieldOfViewForDistanceScaleDeg > 0) or not (fieldOfViewDeg > 0) or fieldOfViewForDistanceScaleDeg == fieldOfViewDeg)
		and 1
		or math.tan((math.rad(fieldOfViewForDistanceScaleDeg * 0.5))) / math.tan((math.rad(fieldOfViewDeg * 0.5)))

	local v2 = baseDistance * data.distanceScale * v

	local v3 = position + Vector3.new(
		0,
		-((0.5 - (layout.cutoutTopOffset + layout.cutoutDiameter * 0.5) / math.max(layout.viewportHeight, 1)) * v2 * math.tan((math.rad(fieldOfViewDeg * 0.5))) * 2),
		0
	)

	local position2 = (CFrame.new(position) * CFrame.Angles(0, math.rad(data.yRotDeg), 0) * CFrame.new(0, 0.05, -v2)).Position
	return CFrame.lookAt(position2, v3)
end

return computeOrbitHeadCFrame
