local parent = script.Parent.Parent

local APIUtil = require(parent.util.APIUtil)
require(parent.util.Types)
local getFFlagUGCValidateDescendantIdsPublished = require(parent.flags.getFFlagUGCValidateDescendantIdsPublished)

local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")

local formatted = `https://apis.{APIUtil.getBaseDomain()}assets/rcc/v1/assets/`
local UnpublishedDependencies = {}

function UnpublishedDependencies.getVersion(p: string, p2: number?)
	return HttpService:JSONDecode(HttpRbxApiService:GetAsyncFullUrl(`{formatted}{p}/versions/{p2 or HttpService:JSONDecode(HttpRbxApiService:GetAsyncFullUrl(formatted .. p)).revisionId}`))
end

function UnpublishedDependencies.shouldReturnOnLoadFailure(data)
	local v = getFFlagUGCValidateDescendantIdsPublished()

	if v then
		if data.universeId == nil and data.token == nil then
			return not data.allowEditableInstances
		end

		return false
	end

	return v
end

return UnpublishedDependencies
