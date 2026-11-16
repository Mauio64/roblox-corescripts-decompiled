local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local ParseContentIds = require(parent.util.ParseContentIds)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)

local getFFlagUGCValidateCheckDescendantIdsLoadable = require(parent.flags.getFFlagUGCValidateCheckDescendantIdsLoadable)
local getFFlagUGCValidateVersionedContentIds = require(parent.flags.getFFlagUGCValidateVersionedContentIds)

local function hasEditableBacking(descendant, p: string): boolean -- 1 equivalent call inferred from this helper
	local v = Constants.CONTENT_ID_EDITABLE_PROPERTY[descendant.ClassName]
	local v2 = v and v[p]

	if v2 then
		return descendant[v2].SourceType == Enum.ContentSourceType.Object
	end

	return false
end

local function canLoadAsset(p: string) -- 2 equivalent calls inferred from this helper
	local success, result = pcall(function()
		return UGCValidationService:CanLoadAsset(p)
	end)

	return success and result
end

local function reportUnloadable(object, flag: boolean, assetId: string, p)
	if flag then
		object:fetchError(string.format(
			"Failed to load asset referenced by %s.%s. Make sure the asset exists and try again.",
			p.instance:GetFullName(),
			p.fieldName
		))
	else
		object:fail(ErrorSourceStrings.Keys.AssetDoesNotExist, {
			AssetId = assetId,
			InstancePath = p.instance:GetFullName()
		})
	end
end

return {
	["categories"] = Constants.AllAssetUploadCategories,
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.consumerConfig,
		ValidationEnums.SharedDataMember.contentIds
	},
	expectedFailures = {},
	run = function(object, data)
		local v = data.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.IEC

		local v2 = {}

		for _, contentId in data.contentIds do
			for _, v3 in contentId do
				local v4 = v2[v3.instance]

				if not v4 then
					v4 = {}
					v2[v3.instance] = v4
				end

				v4[v3.fieldName] = true
			end
		end

		local descendants = data.rootInstance:GetDescendants()
		table.insert(descendants, data.rootInstance)

		for _, descendant in descendants do
			local v3 = Constants.CONTENT_ID_FIELDS[descendant.ClassName]

			if not v3 then
				continue
			end

			local v4 = Constants.CONTENT_ID_REQUIRED_FIELDS[descendant.ClassName]
			local v5 = v2[descendant]

			for _, fieldName in v3 do
				local v6 = descendant[fieldName]
				local v7

				if v4 == nil then
					v7 = false
				else
					v7 = v4[fieldName] == true
				end

				if v6 == "" then
					if v7 then
						if v and hasEditableBacking(descendant, fieldName) then -- inferred equivalent call
							continue
						end

						object:fail(ErrorSourceStrings.Keys.DescendantIdMissing, {
							InstanceFullName = descendant:GetFullName(),
							FieldName = fieldName
						})
					end
				elseif not (v5 and v5[fieldName]) then
					object:fail(ErrorSourceStrings.Keys.DescendantIdMalformed, {
						InstanceFullName = descendant:GetFullName(),
						FieldName = fieldName
					})
				end
			end

			local v6 = Constants.CONTENT_FIELDS_WITHOUT_CONTENTID[descendant.ClassName]

			if not v6 then
				continue
			end

			for _, fieldName in v6 do
				local v7 = descendant[fieldName]

				if v7.SourceType ~= Enum.ContentSourceType.Uri or v7.Uri == "" or v5 and v5[fieldName] then
					continue
				end

				object:fail(ErrorSourceStrings.Keys.DescendantIdMalformed, {
					InstanceFullName = descendant:GetFullName(),
					FieldName = fieldName
				})
			end
		end

		if getFFlagUGCValidateVersionedContentIds() then
			for k, contentId in data.contentIds do
				for _, v3 in contentId do
					if v3.version == nil then
						continue
					end

					local v4 = {
						InstanceFullName = v3.instance:GetFullName(),
						FieldName = v3.fieldName,
						Version = tostring(v3.version),
						AssetId = k
					}

					if v3.fieldName == "AnimationId" then
						object:fail(ErrorSourceStrings.Keys.DescendantIdAnimationVersionNotSupported, v4)
					elseif v3.version ~= 1 then
						object:fail(ErrorSourceStrings.Keys.DescendantIdVersionNotSupported, v4)
					end
				end
			end
		end

		local v3 = data.consumerConfig.validationEnv == ValidationEnums.ValidationEnv.Backend

		if v3 or getFFlagUGCValidateCheckDescendantIdsLoadable() then
			if getFFlagUGCValidateVersionedContentIds() then
				for _, v4 in ParseContentIds.getDistinctReferences(data.contentIds) do
					if not canLoadAsset(v4.uri) then -- inferred equivalent call
						reportUnloadable(object, v3, v4.key, v4.entry)
					end
				end
			else
				for k, contentId in data.contentIds do
					if not canLoadAsset("rbxassetid://" .. k) then -- inferred equivalent call
						reportUnloadable(object, v3, k, contentId[1])
					end
				end
			end
		end
	end
}
