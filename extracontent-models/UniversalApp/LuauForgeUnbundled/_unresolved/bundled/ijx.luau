local CorePackages = game:GetService("CorePackages")

local TelemetryService = game:GetService("TelemetryService")

local Roact = require(CorePackages.Packages.Roact)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local llama = LuaSocialLibrariesDeps.llama

local module = require("@luauforge/bundled/dzD")
local module2 = require("@luauforge/bundled/ijy")
local setUserPresences = require("@luauforge/bundled/ciE").Thunks.SetUserPresences
local module3 = require("@luauforge/bundled/ecq")
local module4 = require("@luauforge/bundled/ecr")
local module5 = require("@luauforge/bundled/ijz")
local module6 = require("@luauforge/bundled/igR")

local module7 = require("@luauforge/bundled/cio")
local networkStatus = module7.RoduxNetworking.Enum.NetworkStatus
local networkingPresence = module7.NetworkingPresence
local module8 = require("@luauforge/bundled/hPZ")
local useHandlePresenceEvent = require("@luauforge/bundled/iiG").Hooks.useHandlePresenceEvent

local fireFriendsSortFeRtnMessageReceived = require("@luauforge/bundled/iiG").Analytics.fireFriendsSortFeRtnMessageReceived

local module9 = require("@luauforge/bundled/ijC")

local module10 = require("@luauforge/bundled/ijD")
local module11 = require("@luauforge/bundled/ijE")

local appAppLifecycleObserverService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppAppLifecycleObserverService

local defineFastString = game:DefineFastString(
	"PresencePropagationDelayMetricName",
	"PresencePropagationDelay"
)

local module12 = require("@luauforge/bundled/dSY")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagFriendSortedByPresenceSignalsImplementation = SharedFlags.FFlagFriendSortedByPresenceSignalsImplementation
local fFlagFriendsSignalMigrationTelemetry = SharedFlags.FFlagFriendsSignalMigrationTelemetry

local v5 = module12.Friends.FriendsStore.get()

game:DefineFastInt("PresenceEventReceiverErrorEventThrottleHundrethsPercent", 10000)
local v6 = {
	eventName = "PresenceEventReceiverErrorEvent",
	backends = { "EventIngest" },
	throttlingPercentage = game:GetFastInt("PresenceEventReceiverErrorEventThrottleHundrethsPercent"),
	lastUpdated = { 25, 9, 5 },
	description = "Report errors in presence event receiver"
}

local v7 = {
	eventName = "PresenceEventReceiverErrorEvent",
	description = "Counter to track errors in PresenceEventReceiver",
	lastUpdated = { 2025, 9, 4 },
	backends = { "RobloxTelemetryCounter" }
}

local v8 = { Offline = 0, Online = 1, InGame = 2, InStudio = 3 }

local function handleSignalFriendsPresenceEvent(p2, p3, p4)
	v5._updateFriendsPresences(p2, p3)

	fireFriendsSortFeRtnMessageReceived(p4, p2)
end

local extended = Roact.PureComponent:extend("PresenceEventReceiver")

extended.defaultProps = {
	networkImpl = module7.networkImpl,
	presenceRefetchTelemetryService = module5.get()
}

function extended:init()
	local robloxEventReceiver = self.props.RobloxEventReceiver
	local analytics = self.props.analytics
	local eventIngestService = self.props.eventIngestService

	self._experienceEventReceiver = module6.new()
	self._isAppBackgrounded = false
	self._wasRealtimeDisconnected = false
	self._staleUsers = {}
	self._presenceComparisonPending = false
	self.state = {
		inExperience = false,
		staleUsers = {},
		lastUpdatedTimesByUserId = {}
	}

	local now = self.props.dateTimeOverride and self.props.dateTimeOverride.now or DateTime.now

	self.tokens = {
		robloxEventReceiver:observeEvent("PresenceBulkNotifications", function(items)
			local mapped = llama.List.map(items, function(p2)
				return (tostring(p2.UserId))
			end)
			local v9

			if module9 then
				v9 = self.state.inExperience or self._isAppBackgrounded
			else
				v9 = self.state.inExperience
			end

			if v9 then
				local set = {}

				for k, v10 in pairs(mapped) do
					set[v10] = true
				end

				if module9 then
					self._staleUsers = llama.Dictionary.join(self._staleUsers, set)
				else
					self:setState({
						staleUsers = llama.Dictionary.join(self.state.staleUsers, set)
					})
				end
			else
				local presenceReports = {}

				local unixTimestampMillisesByUserId = {}
				local sortScoresByUserId = {}
				local userIds = {}
				local rtnMessageId = nil

				for k, item in pairs(items) do
					local dateTime = if item.SessionStarted ~= nil then DateTime.fromIsoDate(item.SessionStarted) else nil

					local lastUpdatedTime = self.state.lastUpdatedTimesByUserId[tostring(item.UserId)]

					if
						item.PresenceReport
						and dateTime
						and item.SortScore
						and (lastUpdatedTime == nil or lastUpdatedTime < dateTime.UnixTimestampMillis)
					then
						table.insert(presenceReports, item.PresenceReport)
						unixTimestampMillisesByUserId[tostring(item.UserId)] = dateTime.UnixTimestampMillis
						sortScoresByUserId[tostring(item.UserId)] = item.SortScore

						if item.RtnMessageId then
							rtnMessageId = item.RtnMessageId
						end
					else
						table.insert(userIds, (tostring(item.UserId)))
					end
				end

				if #userIds > 0 then
					self.props.updateUserPresences(userIds):andThen(function(p2)
						self.props.refetchOnlineFriends()
						self.props.updateActivePresenceGamesDetails(self.props.networkImpl, p2)
					end)
				else
					self.props.setUserPresences(presenceReports)
					self.props.handlePresenceEvent(presenceReports, sortScoresByUserId, rtnMessageId)
					self.props.updateActivePresenceGamesDetails(self.props.networkImpl, presenceReports)
				end

				self:setState({
					lastUpdatedTimesByUserId = llama.Dictionary.join(
						self.state.lastUpdatedTimesByUserId,
						unixTimestampMillisesByUserId
					)
				})

				for k, item in items do
					local kind = item.Type
					local userId = tostring(item.UserId)

					if kind == module.PresenceSignal.EventType and userId ~= self.props.localUserId then
						module8:Fire()
						return
					end

					if item.SessionStarted == nil then
						continue
					end

					local dateTime = DateTime.fromIsoDate(item.SessionStarted)

					if dateTime == nil then
						continue
					end

					local unixTimestampMillis = now().UnixTimestampMillis
					local unixTimestampMillis2 = dateTime.UnixTimestampMillis
					local v10 = unixTimestampMillis - unixTimestampMillis2
					analytics.Diag:reportStats(defineFastString, v10)

					eventIngestService:sendEventDeferred(
						"PresenceEventReceiver",
						"PresencePropagationDelay",
						{
							deviceCurrentTimestampEpochMs = unixTimestampMillis,
							sessionChangedTimestampEpochMs = unixTimestampMillis2
						}
					)
				end
			end
		end),
		self._experienceEventReceiver:onLaunched(function()
			self:onExperienceJoin()
		end),
		self._experienceEventReceiver:onLeft(function()
			self:onExperienceLeave()
		end)
	}

	if module9 then
		local appLifecycleObserverService = self.props.appLifecycleObserverService

		if
			appLifecycleObserverService
			and appLifecycleObserverService.OnHide
			and appLifecycleObserverService.OnUnhide
		then
			local onHideConnection = appLifecycleObserverService.OnHide:Connect(function()
				self:onAppHide()
			end)
			local onUnhideConnection = appLifecycleObserverService.OnUnhide:Connect(function()
				self:onAppUnhide()
			end)
			table.insert(self.tokens, {
				disconnect = function()
					onHideConnection:Disconnect()
				end
			})

			table.insert(self.tokens, {
				disconnect = function()
					onUnhideConnection:Disconnect()
				end
			})
		end
	end

	if module10 then
		local v9 = robloxEventReceiver:observeEvent("signalR", function(p2)
			self:onRealtimeConnectionChanged(p2)
		end)
		table.insert(self.tokens, v9)
	end
end

function extended.render(p2): nil
	return nil
end

function extended:didMount()
	if module11 then
		local presenceRefetchTelemetryService = self.props.presenceRefetchTelemetryService
		local connection = presenceRefetchTelemetryService:subscribe(function()
			if
				self.state.inExperience
				or not module9
				or self._isAppBackgrounded
				or self._presenceComparisonPending
			then
				return
			end

			self._presenceComparisonPending = true
			local fetchedFriendIds = v5._getFetchedFriendIds()

			local snapshotPresences = presenceRefetchTelemetryService:snapshotPresences(v5._getCachedFriendsPresences())

			v5._fetchOnlineFriendsAsync():andThen(function()
				presenceRefetchTelemetryService:reportComparison(
					snapshotPresences,
					presenceRefetchTelemetryService:snapshotPresences(v5._getCachedFriendsPresences()),
					module5.countKnownFriendsUnion(fetchedFriendIds, v5._getFetchedFriendIds())
				)

				self._presenceComparisonPending = false
			end):catch(function()
				self._presenceComparisonPending = false
			end)
		end)
		table.insert(self.tokens, {
			disconnect = function()
				connection:Disconnect()
			end
		})

		presenceRefetchTelemetryService:start()
	end
end

function extended:willUnmount()
	for k, token in pairs(self.tokens) do
		token:disconnect()
	end

	self._experienceEventReceiver:UnsubscribeFromAllMessages()
end

function extended.onExperienceJoin(object)
	object:setState({ inExperience = true })
end

function extended:onAppHide()
	self._isAppBackgrounded = true
end

function extended:onRealtimeConnectionChanged(p2)
	if p2 == Enum.ConnectionState.Disconnected then
		self._wasRealtimeDisconnected = true
		return
	end

	if p2 ~= Enum.ConnectionState.Connected or module9 and self._isAppBackgrounded then
		return
	end

	local wasRealtimeDisconnected = self._wasRealtimeDisconnected
	self._wasRealtimeDisconnected = false

	if wasRealtimeDisconnected then
		self.props.refetchSignalOnlineFriends()
	end
end

function extended:onAppUnhide()
	local isAppBackgrounded = self._isAppBackgrounded
	self._isAppBackgrounded = false

	local localUserId = tonumber(self.props.localUserId)

	if isAppBackgrounded and not self.state.inExperience and localUserId and localUserId > 0 then
		if module10 then
			self._wasRealtimeDisconnected = false
		end

		self:refetchOnlineFriendsAndReconcileStaleUsers()
	end
end

local function fn(p2, staleUsers)
	local v9

	if fFlagFriendSortedByPresenceSignalsImplementation then
		v9 = p2 and p2.data or {}
	else
		v9 = p2 and p2.data and p2.data.onlineFriendsByUserId or {}
	end

	local v10 = {}

	for k, item in pairs(staleUsers) do
		v10[k] = {
			userId = tonumber(k),
			userPresenceType = 0,
			lastLocation = "Website"
		}
	end

	for k, v11 in pairs(v9) do
		if v11.presence and not fFlagFriendSortedByPresenceSignalsImplementation then
			v10[v11.id] = {
				userId = tonumber(v11.id),
				userPresenceType = v8[v11.presence.userPresenceType] or 0,
				lastLocation = v11.presence.lastLocation or "",
				gameId = v11.presence.gameId,
				placeId = tonumber(v11.presence.placeId),
				rootPlaceId = tonumber(v11.presence.rootPlaceId),
				universeId = tonumber(v11.presence.universeId),
				lastOnline = v11.presence.lastOnline
			}
		elseif fFlagFriendSortedByPresenceSignalsImplementation then
			local userPresence = v11.userPresence
			local id = tostring(v11.id)

			if userPresence then
				v10[id] = {
					userId = v11.id,
					userPresenceType = v8[userPresence.UserPresenceType] or 0,
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

	return llama.Dictionary.values(v10)
end

function extended:refetchOnlineFriendsAndReconcileStaleUsers()
	self.props.refetchOnlineFriends():andThen(function(p2)
		local v9 = fn(p2, self._staleUsers)

		self.props.setUserPresences(v9)
		self.props.updateActivePresenceGamesDetails(self.props.networkImpl, v9)

		self._staleUsers = {}
	end):catch(function(p2)
		warn("Failed to refetch online friends:", p2.error)
		TelemetryService:LogCounter(v7)
		TelemetryService:LogEvent(v6, { errorMessage = p2.error })
	end)
end

function extended:onExperienceLeave()
	self:setState({ inExperience = false })

	if not module9 then
		self.props.refetchOnlineFriends():andThen(function(p2)
			local v9 = fn(p2, self.state.staleUsers)

			self.props.setUserPresences(v9)
			self.props.updateActivePresenceGamesDetails(self.props.networkImpl, v9)

			self:setState({ staleUsers = {} })
		end):catch(function(p2)
			warn("Failed to refetch online friends after leaving experience:", p2.error)
			TelemetryService:LogCounter(v7)
			TelemetryService:LogEvent(v6, { errorMessage = p2.error })
		end)

		return
	end

	self._isAppBackgrounded = false
	self:refetchOnlineFriendsAndReconcileStaleUsers()
end

local connect = roactServices.connect

if not module9 then
	appAppLifecycleObserverService = nil
end

local v10 = connect({
	analytics = module3,
	eventIngestService = module4,
	appLifecycleObserverService = appAppLifecycleObserverService
})(extended)

local v11 = RoactRodux.connect(function(p2, p3)
	return { localUserId = p2.LocalUserId }
end, function(callback)
	return {
		updateUserPresences = function(p2)
			return callback(function(object)
				local state = object:getState()
				local filtered = llama.List.filter(p2, function(p3): boolean
					return networkingPresence.GetPresencesFromUserIds.getStatus(state, p3) ~= networkStatus.Fetching
				end)

				return object:dispatch(networkingPresence.GetPresencesFromUserIds.API(filtered)):andThen(function(p3)
					return p3.responseBody.userPresences or {}
				end)
			end):andThen(function(p3)
				callback(setUserPresences(p3))
				return p3
			end)
		end,
		setUserPresences = function(p2)
			callback(setUserPresences(p2))
		end,
		updateActivePresenceGamesDetails = function(p2, p3)
			callback(module2(p2, p3))
		end
	}
end)(v10)

return function(p2)
	local v12

	if not fFlagFriendSortedByPresenceSignalsImplementation then
		v12 = useHandlePresenceEvent()
	end

	local createElement = Roact.createElement

	local join = llama.Dictionary.join
	local v15

	if fFlagFriendSortedByPresenceSignalsImplementation then
		if fFlagFriendsSignalMigrationTelemetry then
			v15 = handleSignalFriendsPresenceEvent
		else
			v15 = v5._updateFriendsPresences
		end
	else
		v15 = v12.handleNewEvent
	end

	local v16 = if fFlagFriendSortedByPresenceSignalsImplementation then v5._fetchOnlineFriendsAsync else v12.refetchOnlineFriends

	local v17 = if module10 then v5.RefetchOnlineFriends else nil
	return createElement(
		v11,
		join(p2, {
			handlePresenceEvent = v15,
			refetchOnlineFriends = v16,
			refetchSignalOnlineFriends = v17
		})
	)
end
