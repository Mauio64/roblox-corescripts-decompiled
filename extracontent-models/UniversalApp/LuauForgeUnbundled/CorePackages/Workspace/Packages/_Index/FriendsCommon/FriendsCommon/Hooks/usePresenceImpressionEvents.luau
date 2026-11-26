local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/Cryo")

local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/SocialLuaAnalytics")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCommon/LoggingProtocol")

local defineFastInt = game:DefineFastInt("PresenceImpressionLoggingThrottlePerMyriad", 10000)

local fFlagFriendsSignalMigrationTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCommon/SharedFlags").FFlagFriendsSignalMigrationTelemetry

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
			format = function(p2, p3)
				return p2
			end
		}
	}
})

function LUAUFORGE_MODULE_GLOBALS_cnj_areEqual(p2, p3): boolean
	return p2.userPresenceType == p3.userPresenceType and p2.placeId == p3.placeId
end

function LUAUFORGE_MODULE_GLOBALS_cnj_usePresenceImpressionEvents(items)
	local state, setState = React.useState({})

	React.useEffect(function()
		local presencesById = {}

		for k, item in pairs(items) do
			presencesById[item.id] = item.presence
		end

		local joined = Cryo.Dictionary.join(state, presencesById)
		local flag = false

		for k, v5 in pairs(joined) do
			if presencesById[k] == nil then
				emitter.emit(telemetry, {
					observedUserId = k,
					presenceType = "Offline",
					lastLocation = "Website",
					implementationVariant = fFlagFriendsSignalMigrationTelemetry and "UniversalAppFriendsStore" or "UniversalAppGraphQL"
				})
				flag = true
			elseif
				state[k] == nil
				or not LUAUFORGE_MODULE_GLOBALS_cnj_areEqual(state[k], presencesById[k])
			then
				local v6 = {
					observedUserId = v5.id,
					presenceType = v5.userPresenceType,
					placeId = v5.placeId,
					universeId = v5.universeId,
					gameId = v5.gameId,
					lastLocation = v5.lastLocation,
					implementationVariant = fFlagFriendsSignalMigrationTelemetry and "UniversalAppFriendsStore" or "UniversalAppGraphQL"
				}

				emitter.emit(telemetry, v6)
				flag = true
			end
		end

		if flag then
			setState(presencesById)
		end
	end, { items })
end

return LUAUFORGE_MODULE_GLOBALS_cnj_usePresenceImpressionEvents
