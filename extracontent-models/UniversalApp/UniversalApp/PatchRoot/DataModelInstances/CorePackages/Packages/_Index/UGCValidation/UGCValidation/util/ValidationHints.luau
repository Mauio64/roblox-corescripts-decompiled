local parent = script.Parent.Parent

local Constants = require(parent.Constants)

require(parent.util.Types)
local BoundsCalculator = require(parent.util.BoundsCalculator)
local BoundsDataUtils = require(parent.util.BoundsDataUtils)
local ParseContentIds = require(parent.util.ParseContentIds)
local getMeshInfo = require(parent.util.getMeshInfo)
local getMeshVerts = require(parent.util.getMeshVerts)

local v = {
	MeshPart = { "MeshId" }
}

local v2 = {
	MeshPart = { MeshId = true }
}

local function validateMeshIds(p, p2)
	if ParseContentIds.parseWithErrorCheck({}, {}, p, v, v2, p2) then
		return true
	end

	return false, { p.Name .. " does not have a MeshId" }
end

local function validateAllMeshParts(p, p2)
	for _, v3 in Constants.ASSET_TYPE_INFO do
		if not v3.isBodyPart then
			continue
		end

		for k, subPart in pairs(v3.subParts) do
			local v4 = p[k]

			if not v4 or v4.ClassName ~= "MeshPart" then
				return false, { k .. " missing" }
			end

			if v4.Name ~= k then
				return false, { k .. " input data is incorrectly set-up" }
			end

			local v5, v6 = validateMeshIds(v4, p2)

			if not v5 then
				return false, v6
			end

			local v7 = { [subPart.rigAttachmentToParent.name] = 0 }
			local v8 = 1

			for k2 in subPart.otherAttachments do
				if string.find(k2, "RigAttachment$") == nil then
					continue
				end

				v7[k2] = 0
				v8 += 1
			end

			local count = 0

			for _, child in v4:GetChildren() do
				if not (child.ClassName == "Attachment" and v7[child.Name]) then
					continue
				end

				if v7[child.Name] == 1 then
					return false, { k .. " has duplicate rig attachments: " .. child.Name }
				end

				v7[child.Name] = v7[child.Name] + 1
				count += 1
			end

			if count ~= v8 then
				return false, { "Missing rig attachments" }
			end
		end
	end

	return true
end

local function isWindowValid(p: number, p2: number): boolean -- 2 equivalent calls inferred from this helper
	return p <= p2
end

local v3 = { "X", "Y", "Z" }
local function calculateScalingWindow(p, items)
	local boundsDimensions, _, overallSize = BoundsDataUtils.calculateBoundsDimensions(p)
	local scalingWindow = {
		["meshSize"] = boundsDimensions,
		overallSize = overallSize,
		scaleTypes = {}
	}

	for k, item in items do
		local v4 = { max = 1e999, min = -1e999 }

		for _, v5 in v3 do
			v4[v5] = {
				min = 0.00005 + item.minSize[v5] / boundsDimensions[v5],
				max = item.maxSize[v5] / overallSize[v5] - 0.00005
			}

			v4[v5].ok = isWindowValid(v4[v5].min, v4[v5].max) -- inferred equivalent call
			v4.max = math.min(v4.max, v4[v5].max)
			v4.min = math.max(v4.min, v4[v5].min)
		end

		v4.ok = isWindowValid(v4.min, v4.max) -- inferred equivalent call
		scalingWindow.scaleTypes[k] = v4
	end

	return scalingWindow
end

local function combineScalingWindows(items)
	local result = {}

	for _, item in items do
		for k, scaleType in item.scaleTypes do
			result[k] = result[k] or { max = 1e999, min = -1e999 }

			result[k].max = math.min(result[k].max, scaleType.max)
			result[k].min = math.max(result[k].min, scaleType.min)
		end
	end

	return result
end

local function createFinalResults(data)
	local finalResults = { meshSize = data.meshSize, overallSize = data.overallSize }

	for k, scaleType in data.scaleTypes do
		local v4 = {}

		for _, v5 in v3 do
			v4[v5] = scaleType[v5]
		end

		v4.ok = scaleType.ok
		v4.min = scaleType.min
		v4.max = scaleType.max

		finalResults[k] = v4
	end

	return finalResults
end

local ValidationHints = {}

function ValidationHints.preprocessDataAsync(p, p2)
	local v4, errors = validateAllMeshParts(p, p2)

	if not v4 then
		return { ok = false, errors = errors }
	end

	local meshData = {}

	for _, v5 in Constants.ASSET_TYPE_INFO do
		if not v5.isBodyPart then
			continue
		end

		for k in v5.subParts do
			assert(p[k].ClassName == "MeshPart")
			local v6 = p[k]

			local meshInfo, errors2, v7 = getMeshInfo(v6, Constants.MESH_CONTENT_TYPE.RENDER_MESH, p2)

			if not meshInfo then
				return { ok = false, errors = errors2 }
			end

			meshData[v6.MeshId] = {}
			local v8 = meshData[v6.MeshId]

			local meshVerts, errors3, verts = getMeshVerts(v7, p2)

			if not meshVerts then
				return { ok = false, errors = errors3 }
			end

			v8.verts = verts
		end
	end

	return {
		ok = true,
		cache = { meshData = meshData }
	}
end

function ValidationHints.isPreprocessDataCached(p, p2): boolean
	local meshData = p2.meshData

	for _, v4 in Constants.ASSET_TYPE_INFO do
		if not v4.isBodyPart then
			continue
		end

		for k in pairs(v4.subParts) do
			local v5 = p[k]

			if not (v5 and v5.ClassName == "MeshPart" and v5.MeshId ~= "") then
				continue
			end

			if not meshData then
				return false
			end

			local v6 = meshData[v5.MeshId]

			if not (v6 and v6.verts) then
				return false
			end
		end
	end

	return true
end

function ValidationHints.calculateScaleToValidateBoundsAsync(p, p2, p3)
	local v4, errors = validateAllMeshParts(p, p2)

	if not v4 then
		return { ok = false, errors = errors }
	end

	local individualFullBodyPartsData, v5, v6 = BoundsCalculator.calculateIndividualFullBodyPartsData(p, p2, p3, true)

	if not individualFullBodyPartsData then
		return {
			ok = false,
			errors = v5 or { "Errors calculating parts metrics" }
		}
	end

	local v7 = {}

	for _, v8 in v6 do
		v7 = BoundsDataUtils.combineBounds(v7, v8.boundsData)
	end

	local v8 = {}
	v8.FullBody = calculateScalingWindow(v7, Constants.FULL_BODY_BOUNDS)

	for k, v9 in Constants.ASSET_TYPE_INFO do
		if not v9.isBodyPart then
			continue
		end

		local v10 = {}

		for k2 in v9.subParts do
			v10 = BoundsDataUtils.combineBounds(v10, v6[k2].boundsData)
		end

		v8[k.Name] = calculateScalingWindow(v10, Constants.ASSET_TYPE_INFO[k].bounds)
	end

	local scale = nil
	local scaleType = nil

	for k, v9 in combineScalingWindows(v8) do
		if not (v9.min <= v9.max) then
			continue
		end

		if v9.min <= 1 and v9.max >= 1 then
			scaleType = k
			scale = 1
			break
		else
			local v10

			if math.abs(1 - v9.min) < math.abs(1 - v9.max) then
				v10 = v9.min
			else
				v10 = v9.max
			end

			if not scale or math.abs(1 - v10) < math.abs(1 - scale) then
				scaleType = k
				scale = v10
			end
		end
	end

	local result = { ok = true }

	result.Overall = {
		ok = scale ~= nil,
		scale = scale,
		scaleType = scaleType
	}

	for k, v9 in v8 do
		result[k] = createFinalResults(v9)
	end

	return result
end

return ValidationHints
