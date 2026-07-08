local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local EyelashCageUVReferenceValues = require(ParentParent.EyelashCageUVReferenceValues)
local getFIntUGCValidationLeaderVertsNearCageIslandsDistance = require(ParentParent.flags.getFIntUGCValidationLeaderVertsNearCageIslandsDistance)
local t1 = {
	fflag = require(ParentParent.flags.getEngineFeatureEngineUGCValidateLeaderVertsNearCageIslands),
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING },
	requiredData = {
		ValidationEnums.SharedDataMember.renderMeshesData,
		ValidationEnums.SharedDataMember.innerCagesData
	}
}
local v8 = getFIntUGCValidationLeaderVertsNearCageIslandsDistance() / 10000

function t1.run(p1, p2) -- line: 21
	-- upvalues: UGCValidationService (copy), EyelashCageUVReferenceValues (copy), v8 (copy), ErrorSourceStrings (copy)
	if p2.uploadEnum.assetType ~= Enum.AssetType.EyelashAccessory then
		return
	end

	local Handle = p2.renderMeshesData.Handle
	local Handle2 = p2.innerCagesData.Handle

	if Handle == nil or Handle2 == nil then
		error("Schema should have ensured data exists for handle")
	end

	if not UGCValidationService:ValidateLeaderSkinnedVertsNearCageIslands(Handle.editable, Handle2.editable, EyelashCageUVReferenceValues, Handle2.origin, v8) then
		p1:fail(ErrorSourceStrings.Keys.LeaderVertsNearCageIslands)
	end
end

return t1
