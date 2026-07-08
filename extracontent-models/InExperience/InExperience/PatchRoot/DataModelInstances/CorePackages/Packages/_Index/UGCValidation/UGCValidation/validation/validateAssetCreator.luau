local ParentParent = script.Parent.Parent
local Promise = require(ParentParent.Parent.Promise)

game:DefineFastInt("UGCValidationCanPublishRequestPageSize", 50)
game:DefineFastInt("UGCValidationMaxAssetSizeAllowed", 500)

local Analytics = require(ParentParent.Analytics)
local APIUtil = require(ParentParent.util.APIUtil)

require(ParentParent.util.Types)

local HttpService = game:GetService("HttpService")
local v6 = APIUtil.getBaseDomain()
local v7 = string.format("https://apis.%s", v6)
local FastInt = game:GetFastInt("UGCValidationCanPublishRequestPageSize")
local FastInt2 = game:GetFastInt("UGCValidationMaxAssetSizeAllowed")
local Constants = require(ParentParent.Constants)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local getFStringUGCValidationReferenceMeshIdWhitelistForIEC = require(ParentParent.flags.getFStringUGCValidationReferenceMeshIdWhitelistForIEC)

local function getWhitelistIds() -- line: 34
	-- upvalues: getFStringUGCValidationReferenceMeshIdWhitelistForIEC (copy)
	local t1 = {}
	local v17 = getFStringUGCValidationReferenceMeshIdWhitelistForIEC()

	if #v17 == 0 then
		return t1
	end

	for match in string.gmatch(v17, "([^,%s]+)") do
		t1[match] = true
	end

	return t1
end
local function createCanPublishPromise(p1, p2, p3, p4, p5) -- line: 48
	-- upvalues: Promise (copy), HttpService (copy), Constants (copy)
	if #p2 == 0 then
		return Promise.resolve()
	end

	return Promise.new(function(resolve, reject) -- line: 52
		-- upvalues: HttpService (copy), p2 (copy), p3 (copy), p5 (copy), p1 (copy), Constants (copy), p4 (copy)
		local json = HttpService:JSONEncode({
			assetIds = p2,
			restrictedEntities = p3,
			universeId = p5
		})

		HttpService:RequestInternal({
			Method = "POST",
			Url = p1,
			Body = json,
			Headers = {
				[Constants.ExperienceAuthHeaderKey] = p4,
				[Constants.ContentType] = Constants.ApplicationJson
			}
		}):Start(function(p6, p7) -- line: 69
			-- upvalues: HttpService (copy), resolve (copy), reject (copy)
			if p6 and p7.StatusCode == 200 then
				local data = HttpService:JSONDecode(p7.Body)

				resolve(data)

				return
			end

			reject()
		end)
	end)
end
local function validateAssetCreator(p8, p9) -- line: 81
	-- upvalues: v7 (copy), FailureReasonsAccumulator (copy), FastInt2 (copy), Analytics (copy), FastInt (copy), Promise (copy), HttpService (copy), Constants (copy), getFStringUGCValidationReferenceMeshIdWhitelistForIEC (copy), getWhitelistIds (copy)
	local isServer = p9.isServer
	local v27 = if not p9.restrictedUserIds then {} else p9.restrictedUserIds
	local token = p9.token
	local universeId = p9.universeId
	local v30 = v7 .. (not isServer and "packages-api/v1/canPublish" or "packages-api/v1/rcc/canPublish")
	local t2 = {
		User = {},
		Group = {}
	}
	local v32 = FailureReasonsAccumulator.new()
	local t3 = {}
	local t4 = {}
	local n1 = 0

	for _, v in ipairs(v27) do
		t2[v.creatorType][tonumber(v.id)] = true
	end

	for v38, _ in p8 do
		if not t3[v38] then
			n1 += 1
			t3[v38] = true
		end
	end

	if n1 > FastInt2 then
		Analytics.reportFailure(Analytics.ErrorType.validateAssetCreator_TooManyDependencies, nil, p9)

		return false, { "Upload of model has too many children assets (Meshes, Textures, etc.) and cannot be processed as is. You need to rearrange the model." }
	end

	local t5 = {}

	for v41, _ in t3 do
		table.insert(t5, v41)

		if #t5 >= FastInt then
			local v43 = t5

			table.insert(t4, if #v43 ~= 0 then Promise.new(function(resolve, reject) -- line: 52
				-- upvalues: HttpService (copy), v43 (copy), v27 (copy), universeId (copy), v30 (copy), Constants (copy), token (copy)
				local json = HttpService:JSONEncode({
					assetIds = v43,
					restrictedEntities = v27,
					universeId = universeId
				})

				HttpService:RequestInternal({
					Method = "POST",
					Url = v30,
					Body = json,
					Headers = {
						[Constants.ExperienceAuthHeaderKey] = token,
						[Constants.ContentType] = Constants.ApplicationJson
					}
				}):Start(function(p10, p11) -- line: 69
					-- upvalues: HttpService (copy), resolve (copy), reject (copy)
					if p10 and p11.StatusCode == 200 then
						local data = HttpService:JSONDecode(p11.Body)

						resolve(data)

						return
					end

					reject()
				end)
			end) else Promise.resolve())
			t5 = {}
		end
	end

	if #t5 > 0 then
		local v44 = t5

		table.insert(t4, if #v44 ~= 0 then Promise.new(function(resolve, reject) -- line: 52
			-- upvalues: HttpService (copy), v44 (copy), v27 (copy), universeId (copy), v30 (copy), Constants (copy), token (copy)
			local json = HttpService:JSONEncode({
				assetIds = v44,
				restrictedEntities = v27,
				universeId = universeId
			})

			HttpService:RequestInternal({
				Method = "POST",
				Url = v30,
				Body = json,
				Headers = {
					[Constants.ExperienceAuthHeaderKey] = token,
					[Constants.ContentType] = Constants.ApplicationJson
				}
			}):Start(function(p12, p13) -- line: 69
				-- upvalues: HttpService (copy), resolve (copy), reject (copy)
				if p12 and p13.StatusCode == 200 then
					local data = HttpService:JSONDecode(p13.Body)

					resolve(data)

					return
				end

				reject()
			end)
		end) else Promise.resolve())
	end

	local v45, v46 = Promise.all(t4):await()

	if not v45 then
		Analytics.reportFailure(Analytics.ErrorType.validateAssetCreator_FailedToLoad, nil, p9)

		return false, { "Failed to load detailed information for model assets. Make sure all model assets exist and try again." }
	end

	local v47 = getFStringUGCValidationReferenceMeshIdWhitelistForIEC() ~= ""
	local v48 = if not v47 then {} else getWhitelistIds()

	for _, v50 in v46 do
		local result = v50.result

		for k, v in pairs(result) do
			local v54 = v

			if v47 then
				v54 = v or v48[k]
			end

			if not v54 then
				Analytics.reportFailure(Analytics.ErrorType.validateAssetCreator_DependencyNotOwnedByCreator, nil, p9)
			end

			local v55 = p8[k]

			v32:updateReasons(v54, { (string.format("%s.%s ( %s ) being used is not owned by the experience creator or player. You can only publish assets that you own.", v55.instance:GetFullName(), v55.fieldName, k)) })
		end
	end

	return v32:getFinalResults()
end

return validateAssetCreator
