local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Stats = game:GetService("Stats")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local InGameMenu = RobloxGui.Modules.InGameMenu
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled)
local SendAnalytics = require(InGameMenu.Utility.SendAnalytics)
local Constants = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Constants
local Constants2 = require(InGameMenu.Resources.Constants)
local v11 = require(script.Parent.Flags.GetFFlagEnableInGameMenuDurationLogger)()
local v12 = if not Stats then nil else Stats:FindFirstChild("FrameRateManager")
local v13 = if not v12 then nil else v12:FindFirstChild("RenderAverage")

local function getCurrentMenuVersion() -- line: 26
	-- upvalues: isNewInGameMenuEnabled (copy)
	if isNewInGameMenuEnabled() then
		return 2
	end

	return 1
end
local function getMenuAnimationTime(p1) -- line: 33
	-- upvalues: Constants2 (copy)
	if p1 then
		return Constants2.ShieldOpenAnimationTweenTime
	end

	return Constants2.ShieldCloseAnimationTweenTime
end
local function getMonoTimeSec() -- line: 40
	return os.clock()
end

local guid = HttpService:GenerateGUID()
local elapsed = os.clock()
local elapsed2 = os.clock()
local guid2 = nil
local u21 = nil
local u22 = false
local u23 = false
local n1 = 0

local function sendEvent(p2, t1: {[any]: any}) -- line: 63
	-- upvalues: v13 (copy), isNewInGameMenuEnabled (copy), v11 (copy), default (copy), SendAnalytics (copy), Constants (copy)
	t1.fps = if not v13 then nil else 1000 / v13:GetValue()
	t1.menu_version = not isNewInGameMenuEnabled() and 1 or 2

	if v11 then
		p2 ..= "_v" .. t1.menu_version
	end

	if t1.menu_session then
		if v11 then
			default:logEvent(p2, t1)

			return
		end

		SendAnalytics(Constants.AnalyticsInGameMenuName, p2, t1)
	end
end
local function sendMenuOpening() -- line: 89
	-- upvalues: v11 (copy), Constants (copy), guid2 (ref), guid (copy), n1 (ref), u22 (ref), sendEvent (copy)
	local v33 = if not v11 then Constants.AnalyticsPerfMenuOpening else Constants.AnalyticsGameMenuOpenStart
	local t2 = {
		menu_session = guid2,
		game_session = guid,
		count = n1,
		interrupted_closing = u22
	}

	if v11 then
		sendEvent(Constants.AnalyticsGameMenuFlowStart, t2)
	end

	sendEvent(v33, t2)
end
local function sendMenuStarted(p3, p4) -- line: 105
	-- upvalues: v11 (copy), Constants (copy), sendEvent (copy), guid2 (ref)
	local v37 = if not v11 then Constants.AnalyticsPerfMenuStarted else Constants.AnalyticsGameMenuOpenEnd

	sendEvent(v37, {
		menu_session = guid2,
		transition_time_total = p3,
		transition_time_normalized = p4
	})
end
local function sendMenuClosed(p5, p6) -- line: 114
	-- upvalues: v11 (copy), Constants (copy), u21 (ref), sendEvent (copy)
	local v40 = if not v11 then Constants.AnalyticsPerfMenuClosed else Constants.AnalyticsGameMenuCloseEnd
	local t3 = {
		menu_session = u21,
		transition_time_total = p5,
		transition_time_normalized = p6
	}

	sendEvent(v40, t3)

	if v11 then
		sendEvent(Constants.AnalyticsGameMenuFlowEnd, t3)
	end
end
local function sendMenuEnding(p7, b1: boolean?) -- line: 128
	-- upvalues: v11 (copy), Constants (copy), sendEvent (copy), guid2 (ref), u23 (ref)
	local v44 = not b1 and "resume" or "leaving"
	local v45 = if not v11 then Constants.AnalyticsPerfMenuEnding else Constants.AnalyticsGameMenuCloseStart

	sendEvent(v45, {
		menu_session = guid2,
		session_time = p7,
		reason = v44,
		interrupted_opening = u23
	})
end

return {
	menuOpenBegin = function() -- line: 140
		-- upvalues: guid2 (ref), n1 (ref), elapsed (ref), HttpService (copy), sendMenuOpening (copy), u23 (ref), u22 (ref)
		if guid2 then
			return
		end

		n1 += 1
		elapsed = os.clock()
		guid2 = HttpService:GenerateGUID()
		sendMenuOpening()
		u23 = true
		u22 = false
	end,
	menuOpenComplete = function() -- line: 152
		-- upvalues: elapsed (ref), Constants2 (copy), v11 (copy), Constants (copy), sendEvent (copy), guid2 (ref), u23 (ref)
		local v46 = os.clock() - elapsed
		local v47 = v46 - Constants2.ShieldOpenAnimationTweenTime
		local v48 = if not v11 then Constants.AnalyticsPerfMenuStarted else Constants.AnalyticsGameMenuOpenEnd

		sendEvent(v48, {
			menu_session = guid2,
			transition_time_total = v46,
			transition_time_normalized = v47
		})
		u23 = false
	end,
	menuClose = function() -- line: 159
		-- upvalues: elapsed2 (ref), elapsed (ref), v11 (copy), Constants (copy), sendEvent (copy), guid2 (ref), u23 (ref), u21 (ref), u22 (ref)
		elapsed2 = os.clock()

		local v49 = elapsed2 - elapsed
		local v50 = if not v11 then Constants.AnalyticsPerfMenuEnding else Constants.AnalyticsGameMenuCloseStart

		sendEvent(v50, {
			reason = "resume",
			menu_session = guid2,
			session_time = v49,
			interrupted_opening = u23
		})
		u21 = guid2
		guid2 = nil
		u23 = false
		u22 = true
	end,
	menuCloseComplete = function() -- line: 168
		-- upvalues: elapsed2 (ref), Constants2 (copy), sendMenuClosed (copy), u21 (ref), u22 (ref)
		local v51 = os.clock() - elapsed2
		local v52 = v51 - Constants2.ShieldCloseAnimationTweenTime

		sendMenuClosed(v51, v52)
		u21 = nil
		u22 = false
	end,
	leavingGame = function() -- line: 176
		-- upvalues: elapsed (ref), v11 (copy), Constants (copy), sendEvent (copy), guid2 (ref), u23 (ref)
		local v53 = os.clock() - elapsed
		local v54 = if not v11 then Constants.AnalyticsPerfMenuEnding else Constants.AnalyticsGameMenuCloseStart

		sendEvent(v54, {
			reason = "leaving",
			menu_session = guid2,
			session_time = v53,
			interrupted_opening = u23
		})
		guid2 = nil
	end,
	getFps = function() -- line: 44
		-- upvalues: v13 (copy)
		if v13 then
			return 1000 / v13:GetValue()
		end

		return nil
	end
}
