local parent = script.Parent.Parent
require(parent.util.Types)

local calculateMinMax = require(parent.util.calculateMinMax)

local BoundsDataUtils = {}

function BoundsDataUtils.combineBounds(data, data2)
	local minMeshCorner, maxMeshCorner = calculateMinMax(
		data.minMeshCorner,
		data.maxMeshCorner,
		data2.minMeshCorner,
		data2.maxMeshCorner
	)

	local minRigAttachment, maxRigAttachment = calculateMinMax(
		data.minRigAttachment,
		data.maxRigAttachment,
		data2.minRigAttachment,
		data2.maxRigAttachment
	)
	local v = {
		["minMeshCorner"] = minMeshCorner,
		maxMeshCorner = maxMeshCorner,
		minRigAttachment = minRigAttachment,
		maxRigAttachment = maxRigAttachment
	}

	BoundsDataUtils.setOverallBounds(v)
	return v
end

function BoundsDataUtils:expandMeshBounds(vector3: Vector3)
	local minMeshCorner, maxMeshCorner = calculateMinMax(self.minMeshCorner, self.maxMeshCorner, vector3, vector3)
	self.minMeshCorner = minMeshCorner
	self.maxMeshCorner = maxMeshCorner
end

function BoundsDataUtils:expandRigAttachmentBounds(vector3: Vector3)
	local minRigAttachment, maxRigAttachment = calculateMinMax(
		self.minRigAttachment,
		self.maxRigAttachment,
		vector3,
		vector3
	)
	self.minRigAttachment = minRigAttachment
	self.maxRigAttachment = maxRigAttachment
end

function BoundsDataUtils:setOverallBounds()
	local minOverall, maxOverall = calculateMinMax(
		self.minMeshCorner,
		self.maxMeshCorner,
		self.minRigAttachment,
		self.maxRigAttachment
	)
	self.minOverall = minOverall
	self.maxOverall = maxOverall
end

function BoundsDataUtils.calculateBoundsCenters(data)
	local v

	if data.minMeshCorner and data.maxMeshCorner then
		v = (data.minMeshCorner + data.maxMeshCorner) / 2
	end

	local v2

	if data.minRigAttachment and data.maxRigAttachment then
		v2 = (data.minRigAttachment + data.maxRigAttachment) / 2
	end

	if data.minOverall and data.maxOverall then
		return v, v2, (data.minOverall + data.maxOverall) / 2
	end

	return v, v2, nil
end

function BoundsDataUtils.calculateBoundsDimensions(data)
	local v

	if data.minMeshCorner and data.maxMeshCorner then
		v = data.maxMeshCorner - data.minMeshCorner
	end

	local v2

	if data.minRigAttachment and data.maxRigAttachment then
		v2 = data.maxRigAttachment - data.minRigAttachment
	end

	if data.minOverall and data.maxOverall then
		return v, v2, data.maxOverall - data.minOverall
	end

	return v, v2, nil
end

return BoundsDataUtils
