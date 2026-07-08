local ParentParent = script.Parent.Parent.Parent
local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local FetchEditables = require(ParentParent.validationSystem.dataFetchModules.FetchEditables)
local FetchCurveAnimations = require(ParentParent.validationSystem.dataFetchModules.FetchCurveAnimations)
local FetchCurveAnimComputedFrames = require(ParentParent.validationSystem.dataFetchModules.FetchCurveAnimComputedFrames)
local FetchContentIds = require(ParentParent.validationSystem.dataFetchModules.FetchContentIds)
local FetchHSRAssets = require(ParentParent.validationSystem.dataFetchModules.FetchHSRAssets)
local FetchCurveAnimBoneData = require(ParentParent.validationSystem.dataFetchModules.FetchCurveAnimBoneData)

require(ParentParent.util.Types)

local SharedDataMember = ValidationEnums.SharedDataMember
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFFlagUGCValidateMigrateBodyPartBounds = require(ParentParent.flags.getFFlagUGCValidateMigrateBodyPartBounds)
local resetPhysicsData = require(ParentParent.util.resetPhysicsData)
local t1 = {
	SharedDataMember.renderMeshesData,
	SharedDataMember.innerCagesData,
	SharedDataMember.outerCagesData,
	SharedDataMember.meshTextures
}
local t2 = {
	InExpServer = true,
	InExpClient = true
}
local t3 = {
	DATA_FETCH_FAILURE = {}
}

function t3.storeDesiredData(p1, t4: {[any]: any}) -- line: 36
	-- upvalues: getFFlagUGCValidateMigrateBodyPartBounds (copy), ValidationEnums (copy), resetPhysicsData (copy), getFFlagUGCValidateMigrateSchemaProperties (copy), t2 (copy), t1 (copy), FetchEditables (copy), t3 (copy), SharedDataMember (copy), FetchCurveAnimations (copy), FetchCurveAnimComputedFrames (copy), FetchContentIds (copy), FetchHSRAssets (copy), FetchCurveAnimBoneData (copy)
	local rootInstance = p1.rootInstance
	local v19 = p1.consumerConfig.preloadedEditableMeshes or {}
	local v20 = p1.consumerConfig.preloadedEditableImages or {}

	if getFFlagUGCValidateMigrateBodyPartBounds() and p1.consumerConfig.consumerEnv ~= ValidationEnums.ConsumerEnv.IEC then
		local v21 = p1.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend

		pcall(resetPhysicsData, { rootInstance }, {
			isServer = v21,
			bypassFlags = {}
		})
	end

	local u22 = if not getFFlagUGCValidateMigrateSchemaProperties() then t2[p1.consumerConfig.source] == true else p1.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.IEC

	for _, v24 in t1 do
		if t4[v24] then
			local ok, result = pcall(function() -- line: 57
				-- upvalues: FetchEditables (copy), rootInstance (copy), v24 (copy), u22 (ref), v19 (copy), v20 (copy)
				return (FetchEditables.getDatas(rootInstance, v24, u22, v19, v20))
			end)

			if ok and result then
				p1[v24] = result
			else
				p1[v24] = t3.DATA_FETCH_FAILURE
			end
		end
	end

	if t4[SharedDataMember.curveAnimations] then
		p1.curveAnimations = FetchCurveAnimations.getData(rootInstance) or t3.DATA_FETCH_FAILURE
	end

	if t4[SharedDataMember.curveAnimComputedFrames] then
		if p1.curveAnimations and p1.curveAnimations ~= t3.DATA_FETCH_FAILURE then
			p1.curveAnimComputedFrames = FetchCurveAnimComputedFrames.getData(p1.curveAnimations) or t3.DATA_FETCH_FAILURE
		else
			p1.curveAnimComputedFrames = t3.DATA_FETCH_FAILURE
		end
	end

	if getFFlagUGCValidateMigrateSchemaProperties() then
		if t4[SharedDataMember.contentIds] then
			p1.contentIds = FetchContentIds.getData(p1)
		end

		if t4[SharedDataMember.hsrAssets] then
			p1.hsrAssets = FetchHSRAssets.getData(rootInstance, p1.consumerConfig) or t3.DATA_FETCH_FAILURE
		end
	end

	if t4[SharedDataMember.curveAnimBoneData] then
		local v27 = FetchCurveAnimBoneData.getData(p1[SharedDataMember.curveAnimations])

		p1[SharedDataMember.curveAnimBoneData] = v27
	end
end

return t3
