local UGCValidationService = game:GetService("UGCValidationService")
local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local EyelashCageUVReferenceValues = require(parent.EyelashCageUVReferenceValues)

local getFIntUGCValidationLeaderVertsNearCageIslandsDistance = require(parent.flags.getFIntUGCValidationLeaderVertsNearCageIslandsDistance)
local LeaderSkinnedVertsNearCageIslands = {
	["fflag"] = require(parent.flags.getEngineFeatureEngineUGCValidateLeaderVertsNearCageIslands),
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING, ValidationEnums.UploadCategory.EYEBROW_EYELASH },
	requiredData = {
		ValidationEnums.SharedDataMember.renderMeshesData,
		ValidationEnums.SharedDataMember.innerCagesData
	}
}

local v = getFIntUGCValidationLeaderVertsNearCageIslandsDistance() / 10000

function LeaderSkinnedVertsNearCageIslands.run(object, data)
	if data.uploadEnum.assetType ~= Enum.AssetType.EyelashAccessory then
		return
	end

	local handle = data.renderMeshesData.Handle
	local handle2 = data.innerCagesData.Handle

	if handle == nil or handle2 == nil then
		error("Schema should have ensured data exists for handle")
	end

	if not UGCValidationService:ValidateLeaderSkinnedVertsNearCageIslands(
		handle.editable,
		handle2.editable,
		EyelashCageUVReferenceValues,
		handle2.origin,
		v
	) then
		object:fail(ErrorSourceStrings.Keys.LeaderVertsNearCageIslands)
	end
end

return LeaderSkinnedVertsNearCageIslands
