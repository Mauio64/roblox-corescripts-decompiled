local parent = script:FindFirstAncestor("FriendsCommon").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local LoggingProtocol = require(parent.LoggingProtocol)

local defineFastInt = game:DefineFastInt("PresenceImpressionLoggingThrottlePerMyriad", 10000)

local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsSignalMigrationTelemetry = SharedFlags.FFlagFriendsSignalMigrationTelemetry

local emitter = SocialLuaAnalytics.Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		throttlingThousandths = defineFastInt,
		links = "https://docs.google.com/document/d/1uj9vb188k-wC2u3U3-UX3fm7xLffIbbvF7BDq3hs2Ak"
	},
	getSharedInfo = function()
		return {}
	end
})

local telemetry = SocialLuaAnalytics.Telemetry.new({
	name = "PresenceImpression",
	description = "Emitted when the presence status of a friend updates on the client",
	lastUpdated = { 2025, 4, 10 },
	backendsList = {
		{
			type = "EventIngest",
			format = function(p, _)
				return p
			end
		}
	}
})

function areEqual(p, p2): boolean
	return p.userPresenceType == p2.userPresenceType and p.placeId == p2.placeId
end

function usePresenceImpressionEvents(items)
	local state, setState = React.useState({})

	React.useEffect(function()
		local presencesById = {}

		for _, item in pairs(items) do
			presencesById[item.id] = item.presence
		end

		local joined = Cryo.Dictionary.join(state, presencesById)
		local flag = false

		for k, v in pairs(joined) do
			if presencesById[k] == nil then
				emitter.emit(telemetry, {
					observedUserId = k,
					presenceType = "Offline",
					lastLocation = "Website",
					implementationVariant = FFlagFriendsSignalMigrationTelemetry and "UniversalAppFriendsStore" or "UniversalAppGraphQL"
				})
				flag = true
			elseif state[k] == nil or not areEqual(state[k], presencesById[k]) then
				local v2 = {
					observedUserId = v.id,
					presenceType = v.userPresenceType,
					placeId = v.placeId,
					universeId = v.universeId,
					gameId = v.gameId,
					lastLocation = v.lastLocation,
					implementationVariant = FFlagFriendsSignalMigrationTelemetry and "UniversalAppFriendsStore" or "UniversalAppGraphQL"
				}

				emitter.emit(telemetry, v2)
				flag = true
			end
		end

		if flag then
			setState(presencesById)
		end
	end, { items })
end

return usePresenceImpressionEvents
