local HttpService = game:GetService("HttpService")
local SessionService = game:GetService("SessionService")

local sessionType = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSignals/RobloxAppSessionization").SessionType

local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSignals/Http")
require("@game/CorePackages/Workspace/Packages/_Workspace/UserSignals/RobloxAppEnums")

local url = Http.Url
require("@game/CorePackages/Workspace/Packages/_Index/UserSignals/UserSignals/UserSignalTypes")

local fFlagLuaAppAddSessionIdToUserSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSignals/SharedFlags").FFlagLuaAppAddSessionIdToUserSignals

return function(callback, p2, p3, p4, p5)
	local metadata

	if fFlagLuaAppAddSessionIdToUserSignals then
		metadata = SessionService:GetMetadata(
			sessionType.StructuralIdentifier.HomePageSessionInfo,
			sessionType.Metadata.HomePageSessionInfo.OmniSessionId
		)
	end

	local unixTimestampMillis = tostring(DateTime.now().UnixTimestampMillis)
	local v5 = string.format("%suser-signal-http-gateway/v1/user-signal/ingest", url.APIS_URL)

	if not fFlagLuaAppAddSessionIdToUserSignals then
		metadata = nil
	end

	return callback(v5, "POST", {
		postBody = HttpService:JSONEncode({
			userSignalEvents = {
				{
					signalValue = p2,
					timestampMs = unixTimestampMillis,
					signalValueType = p4,
					signalEntity = p3,
					signalType = p5,
					omniSessionId = metadata
				}
			}
		})
	})
end
