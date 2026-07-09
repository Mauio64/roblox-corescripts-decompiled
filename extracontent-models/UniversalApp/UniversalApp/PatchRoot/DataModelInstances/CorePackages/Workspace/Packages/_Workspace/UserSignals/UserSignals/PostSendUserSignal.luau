local HttpService = game:GetService("HttpService")
local SessionService = game:GetService("SessionService")
local UserSignals = script:FindFirstAncestor("UserSignals")
local UserSignalsParent = UserSignals.Parent
local SessionType = require(UserSignalsParent.RobloxAppSessionization).SessionType
local Http = require(UserSignalsParent.Http)

require(UserSignalsParent.RobloxAppEnums)

local Url = Http.Url

require(UserSignals.UserSignalTypes)

local FFlagLuaAppAddSessionIdToUserSignals = require(UserSignalsParent.SharedFlags).FFlagLuaAppAddSessionIdToUserSignals

return function(p1, t1: {[any]: any}, t2: {[any]: any}, p2, p3) -- line: 82
	-- upvalues: FFlagLuaAppAddSessionIdToUserSignals (copy), SessionService (copy), SessionType (copy), Url (copy), HttpService (copy)
	local v14 = if not FFlagLuaAppAddSessionIdToUserSignals then nil else SessionService:GetMetadata(SessionType.StructuralIdentifier.HomePageSessionInfo, SessionType.Metadata.HomePageSessionInfo.OmniSessionId)
	local str = tostring(DateTime.now().UnixTimestampMillis)

	return p1(string.format("%suser-signal-http-gateway/v1/user-signal/ingest", Url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({
			userSignalEvents = {{
				signalValue = t1,
				timestampMs = str,
				signalValueType = p2,
				signalEntity = t2,
				signalType = p3,
				omniSessionId = if not FFlagLuaAppAddSessionIdToUserSignals then nil else v14
			}}
		})
	})
end
