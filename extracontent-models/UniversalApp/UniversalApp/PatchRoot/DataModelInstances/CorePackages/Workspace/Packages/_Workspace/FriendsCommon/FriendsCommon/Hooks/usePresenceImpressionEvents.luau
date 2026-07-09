local Parent = script:FindFirstAncestor("FriendsCommon").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local LoggingProtocol = require(Parent.LoggingProtocol)
local v6 = game:DefineFastInt("PresenceImpressionLoggingThrottlePerMyriad", 10000)
local FFlagFriendsSignalMigrationTelemetry = require(Parent.SharedFlags).FFlagFriendsSignalMigrationTelemetry
local v8 = SocialLuaAnalytics.Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		links = "https://docs.google.com/document/d/1uj9vb188k-wC2u3U3-UX3fm7xLffIbbvF7BDq3hs2Ak",
		throttlingThousandths = v6
	},
	getSharedInfo = function() -- line: 31
		return {}
	end
})
local v9 = SocialLuaAnalytics.Telemetry.new({
	name = "PresenceImpression",
	description = "Emitted when the presence status of a friend updates on the client",
	lastUpdated = {
		2025,
		4,
		10
	},
	backendsList = {{
		type = "EventIngest",
		format = function(t1: {[any]: any}, _: {[any]: any}) -- line: 43
			return t1
		end
	}}
})

function areEqual(p1, p2) -- line: 50
	return p1.userPresenceType == p2.userPresenceType and p1.placeId == p2.placeId
end
function usePresenceImpressionEvents(p3) -- line: 54
	-- upvalues: React (copy), Cryo (copy), v8 (copy), v9 (copy), FFlagFriendsSignalMigrationTelemetry (copy)
	local v15, v16 = React.useState({})

	React.useEffect(function() -- line: 57
		-- upvalues: p3 (copy), Cryo (copy), v15 (copy), v8 (copy), v9 (copy), FFlagFriendsSignalMigrationTelemetry (copy), v16 (copy)
		local t3 = {}

		for _, v in pairs(p3) do
			t3[v.id] = v.presence
		end

		local v20 = false
		local v21 = Cryo.Dictionary.join(v15, t3)

		for k, v in pairs(v21) do
			if t3[k] == nil then
				v8.emit(v9, {
					presenceType = "Offline",
					lastLocation = "Website",
					observedUserId = k,
					implementationVariant = not FFlagFriendsSignalMigrationTelemetry and "UniversalAppGraphQL" or "UniversalAppFriendsStore"
				})
				v20 = true
			elseif v15[k] == nil or not areEqual(v15[k], t3[k]) then
				local t4 = {
					observedUserId = v.id,
					presenceType = v.userPresenceType,
					placeId = v.placeId,
					universeId = v.universeId,
					gameId = v.gameId,
					lastLocation = v.lastLocation,
					implementationVariant = not FFlagFriendsSignalMigrationTelemetry and "UniversalAppGraphQL" or "UniversalAppFriendsStore"
				}

				v8.emit(v9, t4)
				v20 = true
			end
		end

		if v20 then
			v16(t3)
		end
	end, { p3 })
end

return usePresenceImpressionEvents
