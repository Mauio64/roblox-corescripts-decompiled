local MessageBusService = game:GetService("MessageBusService")
local TelemetryService = game:GetService("TelemetryService")

local module = require("@luauforge/bundled/icw")

local module2 = require("@luauforge/bundled/icH")
local roactRodux = module.RoactRodux
local react = module.React

local loggingProtocol = module.LoggingProtocol

local useGetFriendsCountByUserId = require("@luauforge/bundled/icI").useGetFriendsCountByUserId

local callOnce = module.AppCommonLib.callOnce

local v5 = nil
pcall(function()
	local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
	v5 = AppLifecycleObserverService
end)

local appRatingPromptService = module2.GetAppRatingPromptService()

local messageId = MessageBusService:GetMessageId("AppRatingPrompt", "leftGame")

local defineFastInt = game:DefineFastInt("RatingPromptEventThrottleHundredthsPercent", 10000)

local defineFastFlag = game:DefineFastFlag("ShowRatingPromptOnGameLeave2", false)
local defineFastFlag2 = game:DefineFastFlag("UseGameEngineEventForGameLeave", false)
local defineFastFlag3 = game:DefineFastFlag("ShowPromptOnAppStart", false)
local defineFastFlag4 = game:DefineFastFlag("EnableStickyParamForGameEndMessage", false)

game:DefineFastFlag("EnableAppRatingPromptLua2", false)

local v6 = { skipFetch = true }

local v7 = {
	recentPlayTimeSeconds = 0,
	friendCount = 0,
	numberOfLaunches = 0,
	daysSinceLastAttempt = 0,
	launchesSinceAttempt = 0,
	timeSinceFirstUseSecs = 0,
	eventTriggeredBy = "unknown"
}

local function AppRatingPromptLauncher(p2): nil
	local v8 = appRatingPromptService
	local v9 = module2

	local v10 = useGetFriendsCountByUserId(tostring(p2.localUserId or ""), v6) or 0
	local ref = react.useRef(v10)
	local ref2 = react.useRef(v7)

	react.useEffect(function()
		if v10 == nil then
			return
		end

		ref.current = v10

		if
			v10 >= v9.GetMinimumNumFriends()
			and not v9.GetAppRatingPromptStats()[v9.kPassedFriendsCheck]
		then
			v9.SetAppRatingPromptStat({ [v9.kPassedFriendsCheck] = true })
		end
	end, { v10 })

	react.useEffect(function()
		local function launchPrompt()
			if v8 ~= nil then
				local v11 = {
					eventName = "ShowNativeRatingPromptAttempted",
					backends = { loggingProtocol.TelemetryBackends.EventIngest },
					throttlingPercentage = defineFastInt,
					lastUpdated = { 2025, 8, 6 },
					description = "Event sent when attemping to show a native rating prompt",
					links = ""
				}

				v8:showAppRatingPrompt()
				v9.PromptTriggered()
				TelemetryService:LogEvent(v11, { customFields = ref2.current })
			end
		end

		local function considerRatingPrompt()
			local appRatingPromptStats = v9.GetAppRatingPromptStats()
			local unixTimestamp = DateTime.now().UnixTimestamp

			if
				not appRatingPromptStats[v9.kFirstUseDay]
				or type(appRatingPromptStats[v9.kFirstUseDay]) ~= "number"
				or unixTimestamp - appRatingPromptStats[v9.kFirstUseDay] < v9.GetMinDaysSinceFirstUse() * 86400
			then
				return
			end

			if
				not appRatingPromptStats[v9.kLastTriggerTimestamp]
				or type(appRatingPromptStats[v9.kLastTriggerTimestamp]) ~= "number"
				or appRatingPromptStats[v9.kLastTriggerTimestamp] ~= -1
				and unixTimestamp - appRatingPromptStats[v9.kLastTriggerTimestamp] < v9.GetMinNumDaysSinceLastPrompt() * 86400
			then
				return
			end

			if
				not appRatingPromptStats[v9.kLaunchesSinceLastPrompt]
				or type(appRatingPromptStats[v9.kLaunchesSinceLastPrompt]) ~= "number"
				or appRatingPromptStats[v9.kLastTriggerTimestamp] ~= -1
				and appRatingPromptStats[v9.kLaunchesSinceLastPrompt] < v9.GetMinNumLaunchesSinceLastPrompt()
			then
				return
			end

			if
				not appRatingPromptStats[v9.kNumGamesPlayed]
				or type(appRatingPromptStats[v9.kNumGamesPlayed]) ~= "number"
				or appRatingPromptStats[v9.kNumGamesPlayed] < v9.GetMinNumGamesPlayed()
			then
				return
			end

			if
				not appRatingPromptStats[v9.kNumLaunches]
				or type(appRatingPromptStats[v9.kNumLaunches]) ~= "number"
				or appRatingPromptStats[v9.kNumLaunches] < v9.GetMinNumLaunches()
			then
				return
			end

			if
				appRatingPromptStats[v9.kVersionAlreadyRated] == nil
				or appRatingPromptStats[v9.kVersionAlreadyRated] and v9.GetCheckVersionRated()
				or not appRatingPromptStats[v9.kPassedFriendsCheck]
			then
				return
			end

			ref2.current.daysSinceLastAttempt = appRatingPromptStats[v9.kLastTriggerTimestamp] == -1
				and -1
				or math.floor((unixTimestamp - appRatingPromptStats[v9.kLastTriggerTimestamp]) / 86400)

			ref2.current.launchesSinceAttempt = appRatingPromptStats[v9.kLaunchesSinceLastPrompt]
			ref2.current.numberOfLaunches = appRatingPromptStats[v9.kNumLaunches]
			ref2.current.friendCount = ref.current
			ref2.current.timeSinceFirstUseSecs = unixTimestamp - appRatingPromptStats[v9.kFirstUseDay]
			ref2.current.eventTriggeredBy = "gameLeave"

			launchPrompt()
		end

		v9.onLaunch()

		if defineFastFlag3 then
			callOnce("AppRatingPromptOnAppStart", function()
				considerRatingPrompt()
			end)
		end

		local function onGameLeft(gameTime)
			if gameTime < v9.GetMinGameDurationSec() then
				return
			end

			v9.IncrementValues({ v9.kNumGamesPlayed })

			if defineFastFlag then
				ref2.current.recentPlayTimeSeconds = gameTime
				considerRatingPrompt()
			end
		end

		local v11 = {}

		if defineFastFlag2 and v8 ~= nil then
			v11.gameEngineEvent = v8.OnGameLeft:Connect(onGameLeft)
		else
			v11.messageBusEvent = MessageBusService:Subscribe(messageId, function(p3)
				onGameLeft(p3.gameTime)
			end, false, defineFastFlag4)
		end

		if v5 then
			v11.enteredForegroundEvent = v5.OnUnhide:Connect(function()
				v9.IncrementValues({ v9.kNumLaunches, v9.kLaunchesSinceLastPrompt })

				if defineFastFlag3 then
					considerRatingPrompt()
				end
			end)
		end

		return function()
			for k, v12 in pairs(v11) do
				v12:disconnect()
			end
		end
	end, {})

	return nil
end

local v8 = roactRodux.connect(function(p2)
	return { localUserId = p2.LocalUserId }
end)(AppRatingPromptLauncher)

local function AppRatingPromptEventReceiver(p2)
	if module2.GetAppRatingPromptEnabled() then
		return react.createElement(v8, p2)
	end

	return react.createElement(react.Fragment)
end

return AppRatingPromptEventReceiver
