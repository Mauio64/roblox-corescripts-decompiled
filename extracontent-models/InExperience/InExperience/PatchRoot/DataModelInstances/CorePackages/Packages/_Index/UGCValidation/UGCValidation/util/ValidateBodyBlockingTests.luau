local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local util = ParentParent.util

require(util.Types)

local floatEquals = require(util.floatEquals)
local getExpectedPartSize = require(util.getExpectedPartSize)
local FailureReasonsAccumulator = require(util.FailureReasonsAccumulator)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local t1 = {
	validateMeshMin = function(vector3: Vector3, s1: string) -- line: 21
		-- upvalues: floatEquals (copy)
		local v12 = true
		local s2 = ""

		for _, v15 in {
			"X",
			"Y",
			"Z"
		} do
			local v16 = vector3[v15]

			if floatEquals(v16, 0, 0.0001) then
				s2 = (not (#s2 > 0) and "" or s2 .. ". ") .. "Size on " .. v15 .. " axis is zero"
				v12 = false
			end
		end

		if not v12 then
			return false, { "Render mesh for " .. s1 .. ": " .. s2 .. ". Increase the size of the mesh" }
		end

		return true
	end
}

function t1.validateInternal(p1, p2, b1: boolean) -- line: 40
	-- upvalues: FailureReasonsAccumulator (copy), getExpectedPartSize (copy), t1 (copy), Analytics (copy), R15plusUtils (copy)
	local v20 = FailureReasonsAccumulator.new()
	local v21 = getExpectedPartSize(p1, p2, true)
	local v22, v23 = t1.validateMeshMin(v21, p1.Name)

	v20:updateReasons(v22, v23)

	if not v22 and b1 then
		Analytics.reportFailure(Analytics.ErrorType.validateBodyBlockingTests_ZeroMeshSize, nil, p2)
	end

	if R15plusUtils.checkFlagEnabledForAllowHrd() then
		local v24 = R15plusUtils.getAvatarBoneSchema(p1.Name)

		for v25, v26 in (R15plusUtils.getNameWhitelistOfClassInSchema(v24, "Attachment")) do
			if v26 and not p1:FindFirstChild(v25, true) then
				v20:updateReasons(false, { `Missing Required attachment { v25 }` })
			end
		end
	end

	return v20:getFinalResults()
end
function t1.validateAll(p3, p4) -- line: 68
	-- upvalues: t1 (copy), Analytics (copy)
	local timestamp = tick()
	local v30 = true

	for _, v32 in p3 do
		assert(v32:IsA("MeshPart"))

		if not t1.validateInternal(v32, p4, false) then
			v30 = false

			break
		end
	end

	Analytics.recordScriptTime(script.Name, timestamp, p4)

	return v30
end
function t1.validate(p5, p6) -- line: 88
	-- upvalues: FailureReasonsAccumulator (copy), Constants (copy), t1 (copy), Analytics (copy)
	local timestamp = tick()
	local assetTypeEnum = p6.assetTypeEnum
	local v37 = FailureReasonsAccumulator.new()
	local v38 = Constants.ASSET_TYPE_INFO[assetTypeEnum]

	if assetTypeEnum == Enum.AssetType.DynamicHead then
		v37:updateReasons(t1.validateInternal(p5, p6, true))
	else
		for k in pairs(v38.subParts) do
			local k2 = p5:FindFirstChild(k)

			assert(k2)
			v37:updateReasons(t1.validateInternal(k2, p6, true))
		end
	end

	Analytics.recordScriptTime(script.Name, timestamp, p6)

	return v37:getFinalResults()
end

return t1
