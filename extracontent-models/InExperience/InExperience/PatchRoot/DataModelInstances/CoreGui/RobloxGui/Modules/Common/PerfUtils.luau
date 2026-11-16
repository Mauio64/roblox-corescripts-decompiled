local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local InGameMenu = RobloxGui.Modules.InGameMenu

local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local default = LoggingProtocol.default

local isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled)
local SendAnalytics = require(InGameMenu.Utility.SendAnalytics)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Constants = CoreScriptsCommon.Constants
local Constants2 = require(InGameMenu.Resources.Constants)

local GetFFlagEnableInGameMenuDurationLogger = require(script.Parent.Flags.GetFFlagEnableInGameMenuDurationLogger)
local fFlagEnableInGameMenuDurationLogger = GetFFlagEnableInGameMenuDurationLogger()
local frameRateManager

if Stats then
	frameRateManager = Stats:FindFirstChild("FrameRateManager")
end

local renderAverage

if frameRateManager then
	renderAverage = frameRateManager:FindFirstChild("RenderAverage")
else
	renderAverage = nil
end

local function getCurrentMenuVersion(): number -- 1 equivalent call inferred from this helper
	return if isNewInGameMenuEnabled() then 2 else 1
end

local function getMenuAnimationTime(p)
	if p then
		return Constants2.ShieldOpenAnimationTweenTime
	end

	return Constants2.ShieldCloseAnimationTweenTime
end

local function getMonoTimeSec() -- 7 equivalent calls inferred from this helper
	return os.clock()
end

local function getFps() -- 1 equivalent call inferred from this helper
	if renderAverage then
		return 1000 / renderAverage:GetValue()
	end

	return nil
end

local guid = HttpService:GenerateGUID()
local monoTimeSec = getMonoTimeSec() -- inferred equivalent call
local monoTimeSec2 = getMonoTimeSec() -- inferred equivalent call
local menu_session = nil
local menu_session2 = nil
local interrupted_closing = false
local interrupted_opening = false
local count = 0

local function sendEvent(p, state)
	state.fps = getFps() -- inferred equivalent call
	state.menu_version = getCurrentMenuVersion() -- inferred equivalent call

	if fFlagEnableInGameMenuDurationLogger then
		p ..= "_v" .. state.menu_version
	end

	if state.menu_session then
		if fFlagEnableInGameMenuDurationLogger then
			default:logEvent(p, state)
		else
			SendAnalytics(Constants.AnalyticsInGameMenuName, p, state)
		end
	end
end

local function sendMenuOpening()
	local v

	if fFlagEnableInGameMenuDurationLogger then
		v = Constants.AnalyticsGameMenuOpenStart
	else
		v = Constants.AnalyticsPerfMenuOpening
	end

	local v2 = {
		menu_session = menu_session,
		game_session = guid,
		count = count,
		interrupted_closing = interrupted_closing
	}

	if fFlagEnableInGameMenuDurationLogger then
		sendEvent(Constants.AnalyticsGameMenuFlowStart, v2)
	end

	sendEvent(v, v2)
end

local function sendMenuStarted(transition_time_total, transition_time_normalized) -- 1 equivalent call inferred from this helper
	local v

	if fFlagEnableInGameMenuDurationLogger then
		v = Constants.AnalyticsGameMenuOpenEnd
	else
		v = Constants.AnalyticsPerfMenuStarted
	end

	sendEvent(v, {
		menu_session = menu_session,
		transition_time_total = transition_time_total,
		transition_time_normalized = transition_time_normalized
	})
end

local function sendMenuClosed(transition_time_total, transition_time_normalized)
	local v

	if fFlagEnableInGameMenuDurationLogger then
		v = Constants.AnalyticsGameMenuCloseEnd
	else
		v = Constants.AnalyticsPerfMenuClosed
	end

	local v2 = {
		menu_session = menu_session2,
		transition_time_total = transition_time_total,
		transition_time_normalized = transition_time_normalized
	}

	sendEvent(v, v2)

	if fFlagEnableInGameMenuDurationLogger then
		sendEvent(Constants.AnalyticsGameMenuFlowEnd, v2)
	end
end

local function sendMenuEnding(session_time, flag: boolean?)
	local v

	if fFlagEnableInGameMenuDurationLogger then
		v = Constants.AnalyticsGameMenuCloseStart
	else
		v = Constants.AnalyticsPerfMenuEnding
	end

	sendEvent(v, {
		menu_session = menu_session,
		session_time = session_time,
		reason = flag and "leaving" or "resume",
		interrupted_opening = interrupted_opening
	})
end

local PerfUtils = {}

function PerfUtils.menuOpenBegin()
	if menu_session then
		return
	end

	count += 1
	monoTimeSec = getMonoTimeSec() -- inferred equivalent call
	menu_session = HttpService:GenerateGUID()
	sendMenuOpening()
	interrupted_opening = true
	interrupted_closing = false
end
function PerfUtils.menuOpenComplete()
	local transition_time_total = getMonoTimeSec() - monoTimeSec -- inferred equivalent call
	sendMenuStarted(transition_time_total, transition_time_total - Constants2.ShieldOpenAnimationTweenTime) -- inferred equivalent call

	interrupted_opening = false
end
function PerfUtils.menuClose()
	monoTimeSec2 = getMonoTimeSec() -- inferred equivalent call
	local session_time = monoTimeSec2 - monoTimeSec
	local v

	if fFlagEnableInGameMenuDurationLogger then
		v = Constants.AnalyticsGameMenuCloseStart
	else
		v = Constants.AnalyticsPerfMenuEnding
	end

	sendEvent(v, {
		menu_session = menu_session,
		session_time = session_time,
		reason = "resume",
		interrupted_opening = interrupted_opening
	})

	menu_session2 = menu_session
	menu_session = nil
	interrupted_opening = false
	interrupted_closing = true
end
function PerfUtils.menuCloseComplete()
	local transition_time_total = getMonoTimeSec() - monoTimeSec2 -- inferred equivalent call
	sendMenuClosed(transition_time_total, transition_time_total - Constants2.ShieldCloseAnimationTweenTime)
	menu_session2 = nil
	interrupted_closing = false
end
function PerfUtils.leavingGame()
	local session_time = getMonoTimeSec() - monoTimeSec -- inferred equivalent call
	local v

	if fFlagEnableInGameMenuDurationLogger then
		v = Constants.AnalyticsGameMenuCloseStart
	else
		v = Constants.AnalyticsPerfMenuEnding
	end

	sendEvent(v, {
		menu_session = menu_session,
		session_time = session_time,
		reason = "leaving",
		interrupted_opening = interrupted_opening
	})

	menu_session = nil
end

PerfUtils.getFps = getFps
return PerfUtils
