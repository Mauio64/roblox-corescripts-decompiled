local parent = script.Parent.Parent

local getCageMeshInfos = require(parent.validation.getCageMeshInfos)

local getFStringLCCageQualityDocumentationLink = require(parent.flags.getFStringLCCageQualityDocumentationLink)
local validateLCCagingRelevancy = require(parent.validation.validateLCCagingRelevancy)
local validateRenderMeshInsideOuterCageMesh = require(parent.validation.validateRenderMeshInsideOuterCageMesh)

require(parent.util.Types)

local function validateLCCageQuality(instance, p, p2)
	local flag = true
	local result = {}
	local wrapLayer = instance:FindFirstChild("Handle"):FindFirstChildOfClass("WrapLayer")
	assert(wrapLayer, "calling validateInstanceTree() means we would not get this far if there was no WrapLayer")

	local cageMeshInfos, v, v2 = getCageMeshInfos(instance, p2)

	if not cageMeshInfos or v2 == nil then
		return false, v
	end

	local v3, v4 = unpack({ v2[1], v2[2] })

	local v5, v6 = validateLCCagingRelevancy(
		v3,
		v4,
		p,
		wrapLayer.ReferenceOrigin.Position,
		wrapLayer.CageOrigin.Position,
		p2
	)

	if not v5 and v6 ~= nil then
		flag = false

		for _, v7 in v6 do
			table.insert(result, v7)
		end
	end

	local v7, v8 = validateRenderMeshInsideOuterCageMesh(wrapLayer, v4, p, p2)

	if not v7 then
		table.insert(result, table.concat(v8, "\n"))
		flag = false
	end

	if flag then
		return true
	end

	if getFStringLCCageQualityDocumentationLink() ~= "" then
		table.insert(result, (string.format("[Caging best practices](%s)", getFStringLCCageQualityDocumentationLink())))
	end

	return false, result
end

return validateLCCageQuality
