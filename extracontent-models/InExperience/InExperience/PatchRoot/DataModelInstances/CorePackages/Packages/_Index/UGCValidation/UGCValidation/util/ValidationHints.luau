local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local BoundsCalculator = require(ParentParent.util.BoundsCalculator)
local BoundsDataUtils = require(ParentParent.util.BoundsDataUtils)
local ParseContentIds = require(ParentParent.util.ParseContentIds)
local getMeshInfo = require(ParentParent.util.getMeshInfo)
local getMeshVerts = require(ParentParent.util.getMeshVerts)
local t1 = {}
local t2 = {
	MeshPart = { "MeshId" }
}
local t3 = {
	MeshPart = {
		MeshId = true
	}
}

local function validateMeshIds(p1, p2) -- line: 34
	-- upvalues: ParseContentIds (copy), t2 (copy), t3 (copy)
	if not ParseContentIds.parseWithErrorCheck({}, {}, p1, t2, t3, p2) then
		return false, { p1.Name .. " does not have a MeshId" }
	end

	return true
end
local function validateAllMeshParts(p3, p4) -- line: 52
	-- upvalues: Constants (copy), validateMeshIds (copy)
	for _, v23 in Constants.ASSET_TYPE_INFO do
		if v23.isBodyPart then
			for k, v in pairs(v23.subParts) do
				local v26 = p3[k]

				if not v26 or v26.ClassName ~= "MeshPart" then
					return false, { k .. " missing" }
				end

				if k ~= v26.Name then
					return false, { k .. " input data is incorrectly set-up" }
				end

				local v27, v28 = validateMeshIds(v26, p4)

				if not v27 then
					return false, v28
				end

				local t4 = {
					[v.rigAttachmentToParent.name] = 0
				}
				local n1 = 1

				for v31 in v.otherAttachments do
					if string.find(v31, "RigAttachment$") ~= nil then
						t4[v31] = 0
						n1 += 1
					end
				end

				local n2 = 0

				for _, child in v26:GetChildren() do
					if child.ClassName ~= "Attachment" or not t4[child.Name] then
						continue
					end

					if t4[child.Name] == 1 then
						return false, { k .. " has duplicate rig attachments: " .. child.Name }
					end

					t4[child.Name] = t4[child.Name] + 1
					n2 += 1
				end

				if n2 ~= n1 then
					return false, { "Missing rig attachments" }
				end
			end
		end
	end

	return true
end
local function isWindowValid(n3: number, n4: number) -- line: 107
	return n3 <= n4
end

local t5 = {
	"X",
	"Y",
	"Z"
}

local function calculateScalingWindow(p5, p6) -- line: 116
	-- upvalues: BoundsDataUtils (copy), t5 (copy)
	local t6 = {}
	local v40, _, v42 = BoundsDataUtils.calculateBoundsDimensions(p5)

	t6.meshSize = v40
	t6.overallSize = v42
	t6.scaleTypes = {}

	for v43, v44 in p6 do
		local t7 = {
			max = 1e999,
			min = -1e999
		}

		for _, v47 in t5 do
			t7[v47] = {
				min = 5E-05 + v44.minSize[v47] / v40[v47],
				max = v44.maxSize[v47] / v42[v47] - 5E-05
			}
			t7[v47].ok = t7[v47].min <= t7[v47].max
			t7.max = math.min(t7.max, t7[v47].max)
			t7.min = math.max(t7.min, t7[v47].min)
		end

		t7.ok = t7.min <= t7.max
		t6.scaleTypes[v43] = t7
	end

	return t6
end
local function combineScalingWindows(p7) -- line: 144
	local t8 = {}

	for _, v51 in p7 do
		for v52, v53 in v51.scaleTypes do
			t8[v52] = t8[v52] or {
				max = 1e999,
				min = -1e999
			}
			t8[v52].max = math.min(t8[v52].max, v53.max)
			t8[v52].min = math.max(t8[v52].min, v53.min)
		end
	end

	return t8
end
local function createFinalResults(p8) -- line: 160
	-- upvalues: t5 (copy)
	local t9 = {
		meshSize = p8.meshSize,
		overallSize = p8.overallSize
	}

	for v56, v57 in p8.scaleTypes do
		local t10 = {}

		for _, v60 in t5 do
			t10[v60] = v57[v60]
		end

		t10.ok = v57.ok
		t10.min = v57.min
		t10.max = v57.max
		t9[v56] = t10
	end

	return t9
end

function t1.preprocessDataAsync(p9, p10) -- line: 180
	-- upvalues: validateAllMeshParts (copy), Constants (copy), getMeshInfo (copy), getMeshVerts (copy)
	local v63, v64 = validateAllMeshParts(p9, p10)

	if not v63 then
		return {
			ok = false,
			errors = v64
		}
	end

	local t11 = {}

	for _, v67 in Constants.ASSET_TYPE_INFO do
		if v67.isBodyPart then
			for v68 in v67.subParts do
				assert(p9[v68].ClassName == "MeshPart")

				local v69 = p9[v68]
				local v70, v71, v72 = getMeshInfo(v69, Constants.MESH_CONTENT_TYPE.RENDER_MESH, p10)

				if not v70 then
					return {
						ok = false,
						errors = v71
					}
				end

				t11[v69.MeshId] = {}

				local v73 = t11[v69.MeshId]
				local v74, v75, v76 = getMeshVerts(v72, p10)

				if not v74 then
					return {
						ok = false,
						errors = v75
					}
				end

				v73.verts = v76
			end
		end
	end

	return {
		ok = true,
		cache = {
			meshData = t11
		}
	}
end
function t1.isPreprocessDataCached(p11, p12) -- line: 232
	-- upvalues: Constants (copy)
	local meshData = p12.meshData

	for _, v81 in Constants.ASSET_TYPE_INFO do
		if v81.isBodyPart then
			for k in pairs(v81.subParts) do
				local v83 = p11[k]

				if not v83 or v83.ClassName ~= "MeshPart" or v83.MeshId == "" then
					continue
				end

				if not meshData then
					return false
				end

				local v84 = meshData[v83.MeshId]

				if not v84 then
					return false
				end

				if not v84.verts then
					return false
				end
			end
		end
	end

	return true
end
function t1.calculateScaleToValidateBoundsAsync(p13, p14, p15) -- line: 268
	-- upvalues: validateAllMeshParts (copy), BoundsCalculator (copy), BoundsDataUtils (copy), calculateScalingWindow (copy), Constants (copy), combineScalingWindows (copy), createFinalResults (copy)
	local v88, v89 = validateAllMeshParts(p13, p14)

	if not v88 then
		return {
			ok = false,
			errors = v89
		}
	end

	local v90, v91, v92 = BoundsCalculator.calculateIndividualFullBodyPartsData(p13, p14, p15, true)

	if not v90 then
		return {
			ok = false,
			errors = v91 or { "Errors calculating parts metrics" }
		}
	end

	local t12 = {}

	for _, v95 in v92 do
		t12 = BoundsDataUtils.combineBounds(t12, v95.boundsData)
	end

	local t13 = {
		FullBody = calculateScalingWindow(t12, Constants.FULL_BODY_BOUNDS)
	}

	for v97, v98 in Constants.ASSET_TYPE_INFO do
		if v98.isBodyPart then
			local t14 = {}

			for v100 in v98.subParts do
				t14 = BoundsDataUtils.combineBounds(t14, v92[v100].boundsData)
			end

			t13[v97.Name] = calculateScalingWindow(t14, Constants.ASSET_TYPE_INFO[v97].bounds)
		end
	end

	local n5 = nil
	local v102 = nil

	for v103, v104 in combineScalingWindows(t13) do
		if not (v104.min <= v104.max) then
			continue
		end

		if v104.min <= 1 and v104.max >= 1 then
			n5 = 1
			v102 = v103

			break
		end

		local v105 = if not (math.abs(1 - v104.min) < math.abs(1 - v104.max)) then v104.max else v104.min

		if not n5 or math.abs(1 - v105) < math.abs(1 - n5) then
			n5 = v105
			v102 = v103
		end
	end

	local t15 = {
		ok = true,
		Overall = {
			ok = n5 ~= nil,
			scale = n5,
			scaleType = v102
		}
	}

	for v107, v108 in t13 do
		t15[v107] = createFinalResults(v108)
	end

	return t15
end

return t1
