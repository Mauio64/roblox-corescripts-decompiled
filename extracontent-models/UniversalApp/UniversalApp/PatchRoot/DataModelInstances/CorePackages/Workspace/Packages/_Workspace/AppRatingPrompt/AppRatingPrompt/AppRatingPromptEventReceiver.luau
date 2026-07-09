local MessageBusService = game:GetService("MessageBusService")
local TelemetryService = game:GetService("TelemetryService")
local scriptParent = script.Parent
local dependencies = require(scriptParent.dependencies)
local AppRatingPromptFeature = require(scriptParent.AppRatingPromptFeature)
local RoactRodux = dependencies.RoactRodux
local React = dependencies.React
local v8 = dependencies.LuaSocialLibrariesDeps.SocialLibraries.config({})
local LoggingProtocol = dependencies.LoggingProtocol
local callOnce = dependencies.AppCommonLib.callOnce
local AppLifecycleObserverService = nil

pcall(function() -- line: 17
	-- upvalues: AppLifecycleObserverService (ref)
	AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
end)

local v12 = AppRatingPromptFeature.GetAppRatingPromptService()
local MessageId = MessageBusService:GetMessageId("AppRatingPrompt", "leftGame")
local v14 = game:DefineFastInt("RatingPromptEventThrottleHundredthsPercent", 10000)
local v15 = game:DefineFastFlag("ShowRatingPromptOnGameLeave2", false)
local v16 = game:DefineFastFlag("UseGameEngineEventForGameLeave", false)
local v17 = game:DefineFastFlag("ShowPromptOnAppStart", false)
local v18 = game:DefineFastFlag("EnableStickyParamForGameEndMessage", false)

game:DefineFastFlag("EnableAppRatingPromptLua2", false)

local t1 = {
	recentPlayTimeSeconds = 0,
	friendCount = 0,
	numberOfLaunches = 0,
	daysSinceLastAttempt = 0,
	launchesSinceAttempt = 0,
	timeSinceFirstUseSecs = 0,
	eventTriggeredBy = "unknown"
}

local function AppRatingPromptLauncher(p1) -- line: 48
	-- upvalues: v12 (copy), AppRatingPromptFeature (copy), React (copy), t1 (copy), LoggingProtocol (copy), v14 (copy), TelemetryService (copy), v17 (copy), callOnce (copy), v15 (copy), v16 (copy), MessageBusService (copy), MessageId (copy), v18 (copy), AppLifecycleObserverService (ref)
	local v24 = v12
	local v25 = AppRatingPromptFeature
	local friendCount = p1.friendCount
	local v27 = React.useRef(friendCount)
	local v28 = React.useRef(t1)

	React.useEffect(function() -- line: 56
		-- upvalues: friendCount (copy), v27 (copy), v25 (copy)
		if friendCount == nil then
			return
		end

		v27.current = friendCount

		if friendCount >= v25.GetMinimumNumFriends() and not v25.GetAppRatingPromptStats()[v25.kPassedFriendsCheck] then
			v25.SetAppRatingPromptStat({
				[v25.kPassedFriendsCheck] = true
			})
		end
	end, { friendCount })
	React.useEffect(function() -- line: 70
		-- upvalues: v24 (copy), LoggingProtocol (copy), v14 (copy), v25 (copy), TelemetryService (copy), v28 (copy), v27 (copy), v17 (copy), callOnce (copy), v15 (copy), v16 (copy), MessageBusService (copy), MessageId (copy), v18 (copy), AppLifecycleObserverService (ref)
		local function launchPrompt() -- line: 71
			-- upvalues: v24 (copy), LoggingProtocol (copy), v14 (copy), v25 (copy), TelemetryService (copy), v28 (copy)
			if v24 ~= nil then
				local t2 = {
					eventName = "ShowNativeRatingPromptAttempted",
					description = "Event sent when attemping to show a native rating prompt",
					links = "",
					backends = { LoggingProtocol.TelemetryBackends.EventIngest },
					throttlingPercentage = v14,
					lastUpdated = {
						2025,
						8,
						6
					}
				}

				v24:showAppRatingPrompt()
				v25.PromptTriggered()
				TelemetryService:LogEvent(t2, {
					customFields = v28.current
				})
			end
		end
		local function considerRatingPrompt() -- line: 89
			-- upvalues: v25 (copy), v28 (copy), v27 (copy), launchPrompt (copy)
			local v37 = v25.GetAppRatingPromptStats()
			local UnixTimestamp = DateTime.now().UnixTimestamp

			if not v37[v25.kFirstUseDay] or (type(v37[v25.kFirstUseDay]) ~= "number" or UnixTimestamp - v37[v25.kFirstUseDay] < v25.GetMinDaysSinceFirstUse() * 86400) then
				return
			end

			if not v37[v25.kLastTriggerTimestamp] or type(v37[v25.kLastTriggerTimestamp]) ~= "number" or v37[v25.kLastTriggerTimestamp] ~= -1 and UnixTimestamp - v37[v25.kLastTriggerTimestamp] < v25.GetMinNumDaysSinceLastPrompt() * 86400 then
				return
			end

			if not v37[v25.kLaunchesSinceLastPrompt] or type(v37[v25.kLaunchesSinceLastPrompt]) ~= "number" or v37[v25.kLastTriggerTimestamp] ~= -1 and v37[v25.kLaunchesSinceLastPrompt] < v25.GetMinNumLaunchesSinceLastPrompt() then
				return
			end

			if not v37[v25.kNumGamesPlayed] or type(v37[v25.kNumGamesPlayed]) ~= "number" or v37[v25.kNumGamesPlayed] < v25.GetMinNumGamesPlayed() then
				return
			end

			if not v37[v25.kNumLaunches] or type(v37[v25.kNumLaunches]) ~= "number" or v37[v25.kNumLaunches] < v25.GetMinNumLaunches() then
				return
			end

			if v37[v25.kVersionAlreadyRated] == nil or v37[v25.kVersionAlreadyRated] and v25.GetCheckVersionRated() then
				return
			end

			if not v37[v25.kPassedFriendsCheck] then
				return
			end

			v28.current.daysSinceLastAttempt = if v37[v25.kLastTriggerTimestamp] ~= -1 then math.floor((UnixTimestamp - v37[v25.kLastTriggerTimestamp]) / 86400) else -1
			v28.current.launchesSinceAttempt = v37[v25.kLaunchesSinceLastPrompt]
			v28.current.numberOfLaunches = v37[v25.kNumLaunches]
			v28.current.friendCount = v27.current
			v28.current.timeSinceFirstUseSecs = UnixTimestamp - v37[v25.kFirstUseDay]
			v28.current.eventTriggeredBy = "gameLeave"
			launchPrompt()
		end

		v25.onLaunch()

		if v17 then
			callOnce("AppRatingPromptOnAppStart", function() -- line: 174
				-- upvalues: considerRatingPrompt (copy)
				considerRatingPrompt()
			end)
		end

		local function onGameLeft(p2) -- line: 179
			-- upvalues: v25 (copy), v15 (copy), v28 (copy), considerRatingPrompt (copy)
			if p2 < v25.GetMinGameDurationSec() then
				return
			end

			v25.IncrementValues({ v25.kNumGamesPlayed })

			if v15 then
				v28.current.recentPlayTimeSeconds = p2
				considerRatingPrompt()
			end
		end

		local t3 = {}

		if v16 and v24 ~= nil then
			t3.gameEngineEvent = v24.OnGameLeft:Connect(onGameLeft)
		else
			t3.messageBusEvent = MessageBusService:Subscribe(MessageId, function(p3) -- line: 197
				-- upvalues: onGameLeft (copy)
				onGameLeft(p3.gameTime)
			end, false, v18)
		end

		if AppLifecycleObserverService then
			t3.enteredForegroundEvent = AppLifecycleObserverService.OnUnhide:Connect(function() -- line: 203
				-- upvalues: v25 (copy), v17 (copy), considerRatingPrompt (copy)
				v25.IncrementValues({
					v25.kNumLaunches,
					v25.kLaunchesSinceLastPrompt
				})

				if v17 then
					considerRatingPrompt()
				end
			end)
		end

		return function() -- line: 214
			-- upvalues: t3 (copy)
			for _, v in pairs(t3) do
				v:disconnect()
			end
		end
	end, {})

	return nil
end

local v21 = RoactRodux.connect(function(p4) -- line: 224
	-- upvalues: v8 (copy)
	local LocalUserId = p4.LocalUserId

	return {
		friendCount = v8.Dictionary.getDeepValue(p4, string.format("FriendsCarousel.Friends.countsByUserId.%s", LocalUserId)) or 0
	}
end)(AppRatingPromptLauncher)

local function AppRatingPromptEventReceiver(p5) -- line: 234
	-- upvalues: AppRatingPromptFeature (copy), React (copy), v21 (copy)
	if AppRatingPromptFeature.GetAppRatingPromptEnabled() then
		return React.createElement(v21, p5)
	end

	return React.createElement(React.Fragment)
end

return AppRatingPromptEventReceiver
