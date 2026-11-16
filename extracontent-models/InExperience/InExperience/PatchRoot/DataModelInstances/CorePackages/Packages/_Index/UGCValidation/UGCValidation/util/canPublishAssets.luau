local parent = script.Parent.Parent

local Promise = require(parent.Parent.Promise)

game:DefineFastInt("UGCValidationCanPublishRequestPageSize", 50)
game:DefineFastInt("UGCValidationMaxAssetSizeAllowed", 500)

local APIUtil = require(parent.util.APIUtil)
local Constants = require(parent.Constants)

local getFStringUGCValidationReferenceMeshIdWhitelistForIEC = require(parent.flags.getFStringUGCValidationReferenceMeshIdWhitelistForIEC)
require(parent.util.Types)

local HttpService = game:GetService("HttpService")

local baseDomain = APIUtil.getBaseDomain()
local v = string.format("https://apis.%s", baseDomain)

local function getWhitelistIds()
	local whitelistIds = {}
	local fStringUGCValidationReferenceMeshIdWhitelistForIEC = getFStringUGCValidationReferenceMeshIdWhitelistForIEC()

	if #fStringUGCValidationReferenceMeshIdWhitelistForIEC == 0 then
		return whitelistIds
	end

	for k in string.gmatch(fStringUGCValidationReferenceMeshIdWhitelistForIEC, "([^,%s]+)") do
		whitelistIds[k] = true
	end

	return whitelistIds
end

local function createCanPublishPromise(url: string, assetIds, restrictedEntities, p: string?, universeId: number?)
	if #assetIds == 0 then
		return Promise.resolve()
	end

	return Promise.new(function(callback, callback2)
		HttpService:RequestInternal({
			Url = url,
			Method = "POST",
			Body = HttpService:JSONEncode({
				assetIds = assetIds,
				restrictedEntities = restrictedEntities,
				universeId = universeId
			}),
			Headers = {
				[Constants.ExperienceAuthHeaderKey] = p,
				[Constants.ContentType] = Constants.ApplicationJson
			}
		}):Start(function(p2, p3)
			if p2 and p3.StatusCode == 200 then
				callback(HttpService:JSONDecode(p3.Body))
			else
				callback2()
			end
		end)
	end)
end

local function canPublishAssets(items, restrictedEntities, p: string?, universeId: number?, flag: boolean)
	local fastInt = game:GetFastInt("UGCValidationCanPublishRequestPageSize")
	local fastInt2 = game:GetFastInt("UGCValidationMaxAssetSizeAllowed")

	local url = v .. (flag and "packages-api/v1/rcc/canPublish" or "packages-api/v1/canPublish")
	local set = {}
	local v2 = {}

	for k, _ in items do
		if set[k] then
			continue
		end

		set[k] = true
		table.insert(v2, k)
	end

	if fastInt2 < #v2 then
		return { status = "tooManyAssets" }
	end

	local v3 = {}
	local v4 = {}

	for _, v5 in v2 do
		table.insert(v3, v5)

		if not (fastInt <= #v3) then
			continue
		end

		table.insert(v4, createCanPublishPromise(url, v3, restrictedEntities, p, universeId))
		v3 = {}
	end

	if #v3 > 0 then
		table.insert(v4, createCanPublishPromise(url, v3, restrictedEntities, p, universeId))
	end

	local v5, v6 = Promise.all(v4):await()

	if not v5 then
		return { status = "loadFailed" }
	end

	local v7 = getFStringUGCValidationReferenceMeshIdWhitelistForIEC() ~= ""
	local v8 = not v7 and {} or getWhitelistIds()

	local verdicts = {}

	for _, v9 in v6 do
		for k, v10 in v9.result do
			local item = items[k]

			if item then
				table.insert(verdicts, {
					assetId = k,
					allowed = v7 and not v10 and v8[k] and true or v10,
					entry = item[1]
				})
			end
		end
	end

	return { status = "ok", verdicts = verdicts }
end

return canPublishAssets
