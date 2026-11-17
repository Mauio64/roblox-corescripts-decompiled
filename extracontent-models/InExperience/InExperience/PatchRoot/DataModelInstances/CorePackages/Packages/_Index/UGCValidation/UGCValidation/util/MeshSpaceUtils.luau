local parent = script.Parent.Parent

local BoundsDataUtils = require(parent.util.BoundsDataUtils)
local getAttachmentCFrameInPartSpace = require(parent.util.getAttachmentCFrameInPartSpace)

local function toWorldSpace(vector3: Vector3, boundsDimensions: Vector3) -- 2 equivalent calls inferred from this helper
	return vector3 * (boundsDimensions / 2)
end

local function calculateLocalSpaceTransform(cframe: CFrame, cframe2: CFrame) -- 1 equivalent call inferred from this helper
	local v = cframe.Rotation:Inverse() * cframe2.Rotation
	local v2 = cframe.Rotation:Inverse() * (cframe2.Position - cframe.Position)

	return CFrame.new(v2) * v
end

return {
	clampAttachmentToBounds = function(p, p2, p3, value: number?)
		local v = p2.cframe * getAttachmentCFrameInPartSpace(p)

		local boundsCenters = BoundsDataUtils.calculateBoundsCenters(p2.boundsData)
		local boundsDimensions = BoundsDataUtils.calculateBoundsDimensions(p2.boundsData)
		assert(boundsCenters, "meshCenterPos is nil")
		assert(boundsDimensions, "meshDimensions is nil")

		local v2 = v.Position - boundsCenters
		local worldSpace = toWorldSpace(p3.min, boundsDimensions) -- inferred equivalent call
		local worldSpace2 = toWorldSpace(p3.max, boundsDimensions) -- inferred equivalent call

		local v3 = {}
		local v4 = value or 0.001

		for _, v5 in { "X", "Y", "Z" } do
			v3[v5] = {}
			local v6 = v3[v5]
			local v7 = v3[v5]
			local min = worldSpace[v5] + v4
			local max = worldSpace2[v5] - v4
			v6.min = min
			v7.max = max

			if not (v3[v5].min > v3[v5].max) then
				continue
			end

			local v8 = (worldSpace[v5] + worldSpace2[v5]) * 0.5
			local v9 = v3[v5]
			local v10 = v3[v5]
			v9.min = v8
			v10.max = v8
		end

		local v5 = boundsCenters + Vector3.new(
			math.clamp(v2.X, v3.X.min, v3.X.max),
			math.clamp(v2.Y, v3.Y.min, v3.Y.max),
			(math.clamp(v2.Z, v3.Z.min, v3.Z.max))
		)
		local v6 = v.Rotation + v5
		return calculateLocalSpaceTransform(p2.cframe, v6) -- inferred equivalent call
	end
}
