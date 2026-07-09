local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local TelemetryService = game:GetService("TelemetryService")
local Roact = require(CorePackages.Packages.Roact)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local llama = require(CorePackages.Packages.LuaSocialLibrariesDeps).llama
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.LuaApp.Constants)
local UpdateActivePresenceGamesDetails = require(Modules.LuaApp.Thunks.Games.UpdateActivePresenceGamesDetails)
local SetUserPresences = require(CorePackages.Workspace.Packages.UserLib).Thunks.SetUserPresences
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local ExperienceEventReceiver = require(Modules.LuaApp.ExperienceEventReceiver)
local EventNetworking = require(script.Parent.EventNetworking)
local NetworkStatus = EventNetworking.RoduxNetworking.Enum.NetworkStatus
local NetworkingPresence = EventNetworking.NetworkingPresence
local JoinYourFriendsRefreshEvent = require(Modules.LuaApp.Components.EventReceivers.JoinYourFriendsRefreshEvent)
local useHandlePresenceEvent = require(CorePackages.Workspace.Packages.FriendsCommon).Hooks.useHandlePresenceEvent
local fireFriendsSortFeRtnMessageReceived = require(CorePackages.Workspace.Packages.FriendsCommon).Analytics.fireFriendsSortFeRtnMessageReceived
local getFFlagLuaAppHomeJoinYourFriendsPresenceFix = require(Modules.Personalization.Flags.getFFlagLuaAppHomeJoinYourFriendsPresenceFix)
local FFlagPresencePropagationDelayMonitoringEnabledV2 = require(Modules.LuaApp.Flags.FFlagPresencePropagationDelayMonitoringEnabledV2)
local v23 = game:DefineFastString("PresencePropagationDelayMetricName", "PresencePropagationDelay")
local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagFriendSortedByPresenceSignalsImplementation = SharedFlags.FFlagFriendSortedByPresenceSignalsImplementation
local FFlagFriendsSignalMigrationTelemetry = SharedFlags.FFlagFriendsSignalMigrationTelemetry
local v28 = if not FFlagFriendSortedByPresenceSignalsImplementation then nil else DataHydration.Friends.FriendsStore.get()

game:DefineFastInt("PresenceEventReceiverErrorEventThrottleHundrethsPercent", 10000)

local t1 = {
	eventName = "PresenceEventReceiverErrorEvent",
	description = "Report errors in presence event receiver",
	backends = { "EventIngest" },
	throttlingPercentage = game:GetFastInt("PresenceEventReceiverErrorEventThrottleHundrethsPercent"),
	lastUpdated = {
		25,
		9,
		5
	}
}
local t2 = {
	eventName = "PresenceEventReceiverErrorEvent",
	description = "Counter to track errors in PresenceEventReceiver",
	lastUpdated = {
		2025,
		9,
		4
	},
	backends = { "RobloxTelemetryCounter" }
}
local t3 = {
	Offline = 0,
	Online = 1,
	InGame = 2,
	InStudio = 3
}

local function handleSignalFriendsPresenceEvent(t4: {[any]: any}?, t5: {[any]: any}?, s1: string?) -- line: 92
	-- upvalues: v28 (copy), fireFriendsSortFeRtnMessageReceived (copy)
	v28._updateFriendsPresences(t4, t5)
	fireFriendsSortFeRtnMessageReceived(s1, t4)
end

local v33 = Roact.PureComponent:extend("PresenceEventReceiver")

v33.defaultProps = {
	networkImpl = EventNetworking.networkImpl
}

function v33.init(p1) -- line: 108
	-- upvalues: ExperienceEventReceiver (copy), llama (copy), getFFlagLuaAppHomeJoinYourFriendsPresenceFix (copy), Constants (copy), JoinYourFriendsRefreshEvent (copy), FFlagPresencePropagationDelayMonitoringEnabledV2 (copy), v23 (copy)
	local RobloxEventReceiver = p1.props.RobloxEventReceiver
	local analytics = p1.props.analytics
	local eventIngestService = p1.props.eventIngestService

	p1._experienceEventReceiver = ExperienceEventReceiver.new()
	p1.state = {
		inExperience = false,
		staleUsers = {},
		lastUpdatedTimesByUserId = {}
	}

	local v44 = p1.props.dateTimeOverride and p1.props.dateTimeOverride.now or DateTime.now

	p1.tokens = {
		RobloxEventReceiver:observeEvent("PresenceBulkNotifications", function(t6: {[any]: any}) -- line: 128
			-- upvalues: llama (copy), p1 (copy), getFFlagLuaAppHomeJoinYourFriendsPresenceFix (copy), Constants (copy), JoinYourFriendsRefreshEvent (copy), FFlagPresencePropagationDelayMonitoringEnabledV2 (copy), v44 (copy), analytics (copy), v23 (copy), eventIngestService (copy)
			local v70 = llama.List.map(t6, function(p2) -- line: 129
				return (tostring(p2.UserId))
			end)

			if p1.state.inExperience then
				local t7 = {}

				for _, v in pairs(v70) do
					t7[v] = true
				end

				p1:setState({
					staleUsers = llama.Dictionary.join(p1.state.staleUsers, t7)
				})

				return
			end

			local t8 = {}
			local t9 = {}
			local t10 = {}
			local t11 = {}
			local RtnMessageId = nil

			for _, v in pairs(t6) do
				local v81 = if v.SessionStarted == nil then nil else DateTime.fromIsoDate(v.SessionStarted)
				local v82 = p1.state.lastUpdatedTimesByUserId[tostring(v.UserId)]

				if v.PresenceReport and v81 and v.SortScore and (v82 == nil or v82 < v81.UnixTimestampMillis) then
					table.insert(t8, v.PresenceReport)
					t11[tostring(v.UserId)] = v81.UnixTimestampMillis
					t9[tostring(v.UserId)] = v.SortScore

					if v.RtnMessageId then
						RtnMessageId = v.RtnMessageId
					end
				else
					table.insert(t10, (tostring(v.UserId)))
				end
			end

			if #t10 > 0 then
				p1.props.updateUserPresences(t10):andThen(function(p3) -- line: 179
					-- upvalues: p1 (copy)
					p1.props.refetchOnlineFriends()
					p1.props.updateActivePresenceGamesDetails(p1.props.networkImpl, p3)
				end)
			else
				p1.props.setUserPresences(t8)
				p1.props.handlePresenceEvent(t8, t9, RtnMessageId)
				p1.props.updateActivePresenceGamesDetails(p1.props.networkImpl, t8)
			end

			p1:setState({
				lastUpdatedTimesByUserId = llama.Dictionary.join(p1.state.lastUpdatedTimesByUserId, t11)
			})

			for _, v84 in t6 do
				local Type = v84.Type

				if getFFlagLuaAppHomeJoinYourFriendsPresenceFix() then
					local str = tostring(v84.UserId)

					if Type == Constants.PresenceSignal.EventType and str ~= p1.props.localUserId then
						JoinYourFriendsRefreshEvent:Fire()

						return
					end
				elseif Type == Constants.PresenceSignal.EventType then
					JoinYourFriendsRefreshEvent:Fire()

					return
				end

				if FFlagPresencePropagationDelayMonitoringEnabledV2 and v84.SessionStarted ~= nil then
					local dateTime = DateTime.fromIsoDate(v84.SessionStarted)

					if dateTime ~= nil then
						local UnixTimestampMillis = v44().UnixTimestampMillis
						local UnixTimestampMillis2 = dateTime.UnixTimestampMillis
						local v90 = UnixTimestampMillis - UnixTimestampMillis2

						analytics.Diag:reportStats(v23, v90)
						eventIngestService:sendEventDeferred("PresenceEventReceiver", "PresencePropagationDelay", {
							deviceCurrentTimestampEpochMs = UnixTimestampMillis,
							sessionChangedTimestampEpochMs = UnixTimestampMillis2
						})
					end
				end
			end
		end),
		p1._experienceEventReceiver:onLaunched(function() -- line: 236
			-- upvalues: p1 (copy)
			p1:onExperienceJoin()
		end),
		p1._experienceEventReceiver:onLeft(function() -- line: 239
			-- upvalues: p1 (copy)
			p1:onExperienceLeave()
		end)
	}
end
function v33.render(_) -- line: 245
	return nil
end
function v33.willUnmount(p5) -- line: 249
	for _, v in pairs(p5.tokens) do
		v:disconnect()
	end

	p5._experienceEventReceiver:UnsubscribeFromAllMessages()
end
function v33.onExperienceJoin(p6) -- line: 257
	p6:setState({
		inExperience = true
	})
end

local function v34(p7, p8) -- line: 263
	-- upvalues: FFlagFriendSortedByPresenceSignalsImplementation (copy), t3 (copy), llama (copy)
	local v52 = if not FFlagFriendSortedByPresenceSignalsImplementation then p7 and (not not p7.data and p7.data.onlineFriendsByUserId) or {} else p7 and p7.data or {}
	local t12 = {}

	for k, _ in pairs(p8) do
		t12[k] = {
			lastLocation = "Website",
			userId = tonumber(k),
			userPresenceType = t3.Offline
		}
	end

	for _, v in pairs(v52) do
		if v.presence and not FFlagFriendSortedByPresenceSignalsImplementation then
			t12[v.id] = {
				userId = tonumber(v.id),
				userPresenceType = t3[v.presence.userPresenceType] or 0,
				lastLocation = v.presence.lastLocation or "",
				gameId = v.presence.gameId,
				placeId = tonumber(v.presence.placeId),
				rootPlaceId = tonumber(v.presence.rootPlaceId),
				universeId = tonumber(v.presence.universeId),
				lastOnline = v.presence.lastOnline
			}
		elseif FFlagFriendSortedByPresenceSignalsImplementation then
			local userPresence = v.userPresence
			local str = tostring(v.id)

			if userPresence then
				t12[str] = {
					userId = v.id,
					userPresenceType = t3[userPresence.UserPresenceType] or 0,
					lastLocation = userPresence.lastLocation or "",
					gameId = userPresence.gameInstanceId,
					placeId = userPresence.placeId,
					rootPlaceId = userPresence.rootPlaceId,
					universeId = userPresence.universeId,
					lastOnline = userPresence.lastOnline
				}
			end
		end
	end

	return llama.Dictionary.values(t12)
end

function v33.onExperienceLeave(p9) -- line: 317
	-- upvalues: v34 (copy), TelemetryService (copy), t2 (copy), t1 (copy)
	p9:setState({
		inExperience = false
	})
	p9.props.refetchOnlineFriends():andThen(function(p10) -- line: 324
		-- upvalues: v34 (copy), p9 (copy)
		local v92 = v34(p10, p9.state.staleUsers)

		p9.props.setUserPresences(v92)
		p9.props.updateActivePresenceGamesDetails(p9.props.networkImpl, v92)
		p9:setState({
			staleUsers = {}
		})
	end):catch(function(p11) -- line: 334
		-- upvalues: TelemetryService (copy), t2 (copy), t1 (copy)
		warn("Failed to refetch online friends after leaving experience:", p11.error)
		TelemetryService:LogCounter(t2)
		TelemetryService:LogEvent(t1, {
			errorMessage = p11.error
		})
	end)
end

local v35 = RoactServices.connect({
	analytics = RoactAnalytics,
	eventIngestService = AppEventIngestService
})(v33)
local u36 = RoactRodux.connect(function(p12, _) -- line: 365
	-- upvalues: getFFlagLuaAppHomeJoinYourFriendsPresenceFix (copy)
	return {
		localUserId = if not getFFlagLuaAppHomeJoinYourFriendsPresenceFix() then nil else p12.LocalUserId
	}
end, function(p14) -- line: 369
	-- upvalues: llama (copy), NetworkingPresence (copy), NetworkStatus (copy), SetUserPresences (copy), UpdateActivePresenceGamesDetails (copy)
	return {
		updateUserPresences = function(p15) -- line: 371
			-- upvalues: p14 (copy), llama (copy), NetworkingPresence (copy), NetworkStatus (copy), SetUserPresences (copy)
			return p14(function(p16) -- line: 350
				-- upvalues: p15 (copy), llama (copy), NetworkingPresence (copy), NetworkStatus (copy)
				local v108 = p16:getState()
				local v109 = p15
				local v110 = llama.List.filter(v109, function(p17) -- line: 344
					-- upvalues: NetworkingPresence (copy), v108 (copy), NetworkStatus (copy)
					return NetworkingPresence.GetPresencesFromUserIds.getStatus(v108, p17) ~= NetworkStatus.Fetching
				end)

				return p16:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(v110)):andThen(function(p18) -- line: 354
					return p18.responseBody.userPresences or {}
				end)
			end):andThen(function(p19) -- line: 372
				-- upvalues: p14 (copy), SetUserPresences (copy)
				p14(SetUserPresences(p19))

				return p19
			end)
		end,
		setUserPresences = function(p20) -- line: 377
			-- upvalues: p14 (copy), SetUserPresences (copy)
			p14(SetUserPresences(p20))
		end,
		updateActivePresenceGamesDetails = function(p21, p22) -- line: 380
			-- upvalues: p14 (copy), UpdateActivePresenceGamesDetails (copy)
			p14(UpdateActivePresenceGamesDetails(p21, p22))
		end
	}
end)(v35)

return function(p23) -- line: 386
	-- upvalues: FFlagFriendSortedByPresenceSignalsImplementation (copy), useHandlePresenceEvent (copy), Roact (copy), u36 (ref), llama (copy), FFlagFriendsSignalMigrationTelemetry (copy), handleSignalFriendsPresenceEvent (copy), v28 (copy)
	local v68 = if not FFlagFriendSortedByPresenceSignalsImplementation then useHandlePresenceEvent() else nil

	return Roact.createElement(u36, llama.Dictionary.join(p23, {
		handlePresenceEvent = if not FFlagFriendSortedByPresenceSignalsImplementation then v68.handleNewEvent else if not FFlagFriendsSignalMigrationTelemetry then v28._updateFriendsPresences else handleSignalFriendsPresenceEvent,
		refetchOnlineFriends = if not FFlagFriendSortedByPresenceSignalsImplementation then v68.refetchOnlineFriends else v28._fetchOnlineFriendsAsync
	}))
end
