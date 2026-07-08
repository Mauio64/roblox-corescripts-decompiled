local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFFlagUGCValidateCheckDescendantIdsLoadable = require(ParentParent.flags.getFFlagUGCValidateCheckDescendantIdsLoadable)
local getFFlagUGCValidateAllowEmissives = require(ParentParent.flags.getFFlagUGCValidateAllowEmissives)

local function hasEditableBacking(p1, s1: string) -- line: 14
	-- upvalues: Constants (copy)
	local v12 = Constants.CONTENT_ID_EDITABLE_PROPERTY[p1.ClassName]
	local v13 = v12 and v12[s1]

	if not v13 then
		return false
	end

	return p1[v13].SourceType == Enum.ContentSourceType.Object
end

return {
	categories = Constants.AllAssetUploadCategories,
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.consumerConfig,
		ValidationEnums.SharedDataMember.contentIds
	},
	fflag = getFFlagUGCValidateMigrateSchemaProperties,
	expectedFailures = {},
	run = function(p2, p3) -- line: 34
		-- upvalues: ValidationEnums (copy), Constants (copy), ErrorSourceStrings (copy), getFFlagUGCValidateAllowEmissives (copy), getFFlagUGCValidateCheckDescendantIdsLoadable (copy), UGCValidationService (copy)
		local v16 = p3.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.IEC
		local t1 = {}

		for _, v19 in p3.contentIds do
			for _, v21 in v19 do
				local v22 = t1[v21.instance]

				if not v22 then
					v22 = {}
					t1[v21.instance] = v22
				end

				v22[v21.fieldName] = true
			end
		end

		local descendants = p3.rootInstance:GetDescendants()

		table.insert(descendants, p3.rootInstance)

		for _, v25 in descendants do
			local v26 = Constants.CONTENT_ID_FIELDS[v25.ClassName]

			if v26 then
				local v27 = Constants.CONTENT_ID_REQUIRED_FIELDS[v25.ClassName]
				local v28 = t1[v25]

				for _, v30 in v26 do
					local v31 = v25[v30]
					local v32 = v27 ~= nil and v27[v30] == true

					if v31 == "" then
						if not v32 then
							continue
						end

						if v16 then
							local v33 = Constants.CONTENT_ID_EDITABLE_PROPERTY[v25.ClassName]
							local v34 = v33 and v33[v30]

							if if v34 then v25[v34].SourceType == Enum.ContentSourceType.Object else false then
								continue
							end
						end

						p2:fail(ErrorSourceStrings.Keys.DescendantIdMissing, {
							InstanceFullName = v25:GetFullName(),
							FieldName = v30
						})

						continue
					end

					if not v28 or not v28[v30] then
						p2:fail(ErrorSourceStrings.Keys.DescendantIdMalformed, {
							InstanceFullName = v25:GetFullName(),
							FieldName = v30
						})
					end
				end

				if getFFlagUGCValidateAllowEmissives() then
					local v35 = Constants.CONTENT_FIELDS_WITHOUT_CONTENTID[v25.ClassName]

					if v35 then
						for _, v37 in v35 do
							local v38 = v25[v37]

							if v38.SourceType == Enum.ContentSourceType.Uri and v38.Uri ~= "" and (not v28 or not v28[v37]) then
								p2:fail(ErrorSourceStrings.Keys.DescendantIdMalformed, {
									InstanceFullName = v25:GetFullName(),
									FieldName = v37
								})
							end
						end
					end
				end
			end
		end

		local v39 = p3.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.Backend

		if v39 or getFFlagUGCValidateCheckDescendantIdsLoadable() then
			for v40, v41 in p3.contentIds do
				local v42 = v41[1]
				local ok, result = pcall(function() -- line: 112
					-- upvalues: UGCValidationService (copy), v40 (copy)
					return UGCValidationService:CanLoadAsset("rbxassetid://" .. v40)
				end)

				if not ok or not result then
					if v39 then
						p2:fetchError(string.format("Failed to load asset referenced by %s.%s. Make sure the asset exists and try again.", v42.instance:GetFullName(), v42.fieldName))
					else
						p2:fail(ErrorSourceStrings.Keys.AssetDoesNotExist, {
							AssetId = v40,
							InstancePath = v42.instance:GetFullName()
						})
					end
				end
			end
		end
	end
}
