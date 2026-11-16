local HttpService = game:GetService("HttpService")
local SessionService = game:GetService("SessionService")

local UserSignals = script:FindFirstAncestor("UserSignals")
local parent = UserSignals.Parent

local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SessionType = RobloxAppSessionization.SessionType

local Http = require(parent.Http)
require(parent.RobloxAppEnums)

local Url = Http.Url
require(UserSignals.UserSignalTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddSessionIdToUserSignals = SharedFlags.FFlagLuaAppAddSessionIdToUserSignals

return function(callback, signalValue, signalEntity, signalValueType, signalType)
	local metadata

	if FFlagLuaAppAddSessionIdToUserSignals then
		metadata = SessionService:GetMetadata(
			SessionType.StructuralIdentifier.HomePageSessionInfo,
			SessionType.Metadata.HomePageSessionInfo.OmniSessionId
		)
	end

	local unixTimestampMillis = tostring(DateTime.now().UnixTimestampMillis)
	local v = string.format("%suser-signal-http-gateway/v1/user-signal/ingest", Url.APIS_URL)

	if not FFlagLuaAppAddSessionIdToUserSignals then
		metadata = nil
	end

	return callback(v, "POST", {
		postBody = HttpService:JSONEncode({
			userSignalEvents = {
				{
					signalValue = signalValue,
					timestampMs = unixTimestampMillis,
					signalValueType = signalValueType,
					signalEntity = signalEntity,
					signalType = signalType,
					omniSessionId = metadata
				}
			}
		})
	})
end
