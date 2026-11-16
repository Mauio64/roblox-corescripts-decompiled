local parent = script.Parent.Parent.Parent
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local FetchEditables = require(parent.validationSystem.dataFetchModules.FetchEditables)
local FetchCurveAnimations = require(parent.validationSystem.dataFetchModules.FetchCurveAnimations)
local FetchCurveAnimComputedFrames = require(parent.validationSystem.dataFetchModules.FetchCurveAnimComputedFrames)
local FetchContentIds = require(parent.validationSystem.dataFetchModules.FetchContentIds)
local FetchHSRAssets = require(parent.validationSystem.dataFetchModules.FetchHSRAssets)
local FetchCurveAnimBoneData = require(parent.validationSystem.dataFetchModules.FetchCurveAnimBoneData)
local FetchFullBodyPartsMetrics = require(parent.validationSystem.dataFetchModules.FetchFullBodyPartsMetrics)
require(parent.util.Types)
local SharedDataMember = ValidationEnums.SharedDataMember

local getFFlagUGCValidationAllowFullVaas = require(parent.flags.getFFlagUGCValidationAllowFullVaas)
local getFFlagUGCValidateHeadAboveTorso = require(parent.flags.getFFlagUGCValidateHeadAboveTorso)
local resetPhysicsData = require(parent.util.resetPhysicsData)

local v = {
	SharedDataMember.renderMeshesData,
	SharedDataMember.innerCagesData,
	SharedDataMember.outerCagesData,
	SharedDataMember.meshTextures
}

local FetchAllDesiredData = {}
FetchAllDesiredData.DATA_FETCH_FAILURE = {}

function FetchAllDesiredData:storeDesiredData(p)
	local rootInstance = self.rootInstance
	local preloadedEditableMeshes = self.consumerConfig.preloadedEditableMeshes or {}
	local preloadedEditableImages = self.consumerConfig.preloadedEditableImages or {}

	if
		not getFFlagUGCValidationAllowFullVaas()
		and self.consumerConfig.consumerEnv ~= ValidationEnums.ConsumerEnv.IEC
	then
		local isServer = self.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend
		pcall(resetPhysicsData, { rootInstance }, { isServer = isServer, bypassFlags = {} })
	end

	local v2 = self.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.IEC

	for _, v3 in v do
		if not p[v3] then
			continue
		end

		local success, result = pcall(function()
			return (FetchEditables.getDatas(rootInstance, v3, v2, preloadedEditableMeshes, preloadedEditableImages))
		end)

		if success and result then
			self[v3] = result
		else
			self[v3] = FetchAllDesiredData.DATA_FETCH_FAILURE
		end
	end

	if p[SharedDataMember.curveAnimations] then
		self.curveAnimations = FetchCurveAnimations.getData(rootInstance, self.consumerConfig)
			or FetchAllDesiredData.DATA_FETCH_FAILURE
	end

	if p[SharedDataMember.curveAnimComputedFrames] then
		if self.curveAnimations and self.curveAnimations ~= FetchAllDesiredData.DATA_FETCH_FAILURE then
			self.curveAnimComputedFrames = FetchCurveAnimComputedFrames.getData(self.curveAnimations)
				or FetchAllDesiredData.DATA_FETCH_FAILURE
		else
			self.curveAnimComputedFrames = FetchAllDesiredData.DATA_FETCH_FAILURE
		end
	end

	if p[SharedDataMember.contentIds] then
		self.contentIds = FetchContentIds.getData(self)
	end

	if p[SharedDataMember.hsrAssets] then
		self.hsrAssets = FetchHSRAssets.getData(rootInstance, self.consumerConfig)
			or FetchAllDesiredData.DATA_FETCH_FAILURE
	end

	if p[SharedDataMember.curveAnimBoneData] then
		local data = FetchCurveAnimBoneData.getData(self[SharedDataMember.curveAnimations])
		self[SharedDataMember.curveAnimBoneData] = data
	end

	if getFFlagUGCValidateHeadAboveTorso() and p[SharedDataMember.fullBodyPartsMetrics] then
		if
			self.uploadCategory == ValidationEnums.UploadCategory.FULL_BODY
			and self.renderMeshesData
			and self.renderMeshesData ~= FetchAllDesiredData.DATA_FETCH_FAILURE
		then
			local success, result = pcall(FetchFullBodyPartsMetrics.getData, self)

			if success and result then
				self.fullBodyPartsMetrics = result
			else
				self.fullBodyPartsMetrics = {}
			end
		else
			self.fullBodyPartsMetrics = {}
		end
	end
end

return FetchAllDesiredData
