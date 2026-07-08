local ParentParent = script.Parent.Parent
local Promise = require(ParentParent.Parent.Promise)

game:DefineFastInt("UGCValidationCanPublishRequestPageSize", 50)
game:DefineFastInt("UGCValidationMaxAssetSizeAllowed", 500)

local APIUtil = require(ParentParent.util.APIUtil)
local Constants = require(ParentParent.Constants)
local getFStringUGCValidationReferenceMeshIdWhitelistForIEC = require(ParentParent.flags.getFStringUGCValidationReferenceMeshIdWhitelistForIEC)

require(ParentParent.util.Types)

local HttpService = game:GetService("HttpService")
local v7 = APIUtil.getBaseDomain()
local v8 = string.format("https://apis.%s", v7)

local function getWhitelistIds() -- line: 35
	-- upvalues: getFStringUGCValidationReferenceMeshIdWhitelistForIEC (copy)
	local t1 = {}
	local v13 = getFStringUGCValidationReferenceMeshIdWhitelistForIEC()

	if #v13 == 0 then
		return t1
	end

	for match in string.gmatch(v13, "([^,%s]+)") do
		t1[match] = true
	end

	return t1
end
local function createCanPublishPromise(s1: string, t2: {[any]: any}, p1, s2: string, n1: number?) -- line: 49
	-- upvalues: Promise (copy), HttpService (copy), Constants (copy)
	if #t2 == 0 then
		return Promise.resolve()
	end

	return Promise.new(function(resolve, reject) -- line: 59
		-- upvalues: HttpService (copy), t2 (copy), p1 (copy), n1 (copy), s1 (copy), Constants (copy), s2 (copy)
		local json = HttpService:JSONEncode({
			assetIds = t2,
			restrictedEntities = p1,
			universeId = n1
		})

		HttpService:RequestInternal({
			Method = "POST",
			Url = s1,
			Body = json,
			Headers = {
				[Constants.ExperienceAuthHeaderKey] = s2,
				[Constants.ContentType] = Constants.ApplicationJson
			}
		}):Start(function(p2, p3) -- line: 76
			-- upvalues: resolve (copy), HttpService (copy), reject (copy)
			if p2 and p3.StatusCode == 200 then
				resolve(HttpService:JSONDecode(p3.Body))

				return
			end

			reject()
		end)
	end)
end
local function canPublishAssets(p4, p5, s3: string, n2: number?, b1: boolean) -- line: 86
	-- upvalues: v8 (copy), createCanPublishPromise (copy), Promise (copy), getFStringUGCValidationReferenceMeshIdWhitelistForIEC (copy), getWhitelistIds (copy)
	local FastInt = game:GetFastInt("UGCValidationCanPublishRequestPageSize")
	local FastInt2 = game:GetFastInt("UGCValidationMaxAssetSizeAllowed")
	local v27 = v8 .. (not b1 and "packages-api/v1/canPublish" or "packages-api/v1/rcc/canPublish")
	local t3 = {}
	local t4 = {}

	for v30, _ in p4 do
		if not t3[v30] then
			t3[v30] = true
			table.insert(t4, v30)
		end
	end

	if FastInt2 < #t4 then
		return {
			status = "tooManyAssets"
		}
	end

	local t5 = {}
	local t6 = {}

	for _, v35 in t4 do
		table.insert(t6, v35)

		if FastInt <= #t6 then
			table.insert(t5, createCanPublishPromise(v27, t6, p5, s3, n2))
			t6 = {}
		end
	end

	if #t6 > 0 then
		table.insert(t5, createCanPublishPromise(v27, t6, p5, s3, n2))
	end

	local v36, v37 = Promise.all(t5):await()

	if not v36 then
		return {
			status = "loadFailed"
		}
	end

	local v38 = getFStringUGCValidationReferenceMeshIdWhitelistForIEC() ~= ""
	local v39 = if not v38 then {} else getWhitelistIds()
	local t7 = {}

	for _, v42 in v37 do
		for v43, v44 in v42.result do
			local v45 = p4[v43]

			if v45 then
				local v46 = v44

				if v38 and not v44 and v39[v43] then
					v46 = true
				end

				table.insert(t7, {
					assetId = v43,
					allowed = v46,
					entry = v45[1]
				})
			end
		end
	end

	return {
		status = "ok",
		verdicts = t7
	}
end

return canPublishAssets
