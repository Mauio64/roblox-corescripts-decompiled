local ParentParent = script.Parent.Parent
local BoundsDataUtils = require(ParentParent.util.BoundsDataUtils)
local getAttachmentCFrameInPartSpace = require(ParentParent.util.getAttachmentCFrameInPartSpace)
local t1 = {}

local function toWorldSpace(vector3: Vector3, vector3_2: Vector3) -- line: 20
	return vector3 * (vector3_2 / 2)
end
local function calculateLocalSpaceTransform(cFrame: CFrame, cFrame2: CFrame) -- line: 26
	local v12 = cFrame.Rotation:Inverse() * cFrame2.Rotation
	local v13 = cFrame.Rotation:Inverse() * (cFrame2.Position - cFrame.Position)

	return CFrame.new(v13) * v12
end
local function calculateAcceptableBoundsWorldSpace(p1, vector3: Vector3, vector3_3: Vector3) -- line: 34
	local v17 = p1.min * (vector3 / 2)
	local v18 = p1.max * (vector3 / 2)
	local v19 = (v17 + v18) * 0.5
	local v20 = v18 - v17

	return v19 + vector3_3, v20
end

function t1.clampAttachmentToBounds(p2, p3, p4, n1: number?) -- line: 47
	-- upvalues: getAttachmentCFrameInPartSpace (copy), BoundsDataUtils (copy)
	local v25 = n1 or 0.001
	local v26 = p3.cframe * getAttachmentCFrameInPartSpace(p2)
	local v27 = BoundsDataUtils.calculateBoundsCenters(p3.boundsData)
	local v28 = BoundsDataUtils.calculateBoundsDimensions(p3.boundsData)

	assert(v27, "meshCenterPos is nil")
	assert(v28, "meshDimensions is nil")

	local v29 = v26.Position - v27
	local v30 = p4.min * (v28 / 2)
	local v31 = p4.max * (v28 / 2)
	local t2 = {}

	for _, v34 in {
		"X",
		"Y",
		"Z"
	} do
		t2[v34] = {}

		local v35 = t2[v34]
		local v36 = t2[v34]
		local v37 = v30[v34] + v25
		local v38 = v31[v34] - v25

		v35.min = v37
		v36.max = v38

		if t2[v34].min > t2[v34].max then
			local v39 = (v30[v34] + v31[v34]) * 0.5
			local v40 = t2[v34]
			local v41 = t2[v34]

			v40.min = v39
			v41.max = v39
		end
	end

	local v42 = v27 + Vector3.new(math.clamp(v29.X, t2.X.min, t2.X.max), math.clamp(v29.Y, t2.Y.min, t2.Y.max), (math.clamp(v29.Z, t2.Z.min, t2.Z.max)))
	local v43 = v26.Rotation + v42
	local cframe = p3.cframe
	local v45 = cframe.Rotation:Inverse() * v43.Rotation
	local v46 = cframe.Rotation:Inverse() * (v43.Position - cframe.Position)

	return CFrame.new(v46) * v45
end
function t1.calculateAcceptableBoundsLocalSpace(p5, p6, vector3: Vector3, vector3_4: Vector3) -- line: 92
	local v51 = p5.min * (vector3 / 2)
	local v52 = p5.max * (vector3 / 2)
	local v53 = (v51 + v52) * 0.5
	local v54 = v52 - v51
	local v55 = v53 + vector3_4
	local cframe = p6.cframe
	local cFrame = CFrame.new(v55)
	local v58 = cframe.Rotation:Inverse() * cFrame.Rotation
	local v59 = cframe.Rotation:Inverse() * (cFrame.Position - cframe.Position)

	return CFrame.new(v59) * v58, v54
end

return t1
