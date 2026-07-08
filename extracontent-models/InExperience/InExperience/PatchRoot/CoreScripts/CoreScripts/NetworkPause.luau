local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local TelemetryService = game:GetService("TelemetryService")
local Modules = CoreGui.RobloxGui.Modules
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	wait()
	LocalPlayer = Players.LocalPlayer
end

local NetworkPauseNotification = require(Modules.NetworkPauseNotification)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local v11 = game:DefineFastFlag("GameplayPauseFlickerMitigation", false)
local v12 = game:DefineFastInt("RapidGameplayPauseIntervalMs", 1000)
local v13 = game:DefineFastInt("RapidGameplayPauseMinNotificationDurationMs", 500)
local v14 = game:DefineFastInt("GameplayPauseShowDelayMs", 300)
local v15 = game:DefineFastFlag("StreamingPauseUIAnalyticsEnabled", false)
local v16 = game:DefineFastInt("StreamingPauseUIAnalyticsThrottleHP", 0)
local t1 = {
	eventName = "StreamingPauseUISessionStats",
	description = "Session stats for streaming pause UI visibility",
	backends = { "EventIngest" },
	throttlingPercentage = v16,
	lastUpdated = {
		2026,
		6,
		2
	}
}
local elapsed = os.clock()
local n1 = 0
local n2 = 0
local elapsed2 = nil
local v22 = table.freeze({
	UNPAUSED = "unpaused",
	PENDING_SHOW = "pendingShow",
	PAUSED = "paused",
	RAPID_PAUSE_PENDING_DISMISS = "rapidPausePendingDismiss"
})
local u23 = true
local UNPAUSED = v22.UNPAUSED
local n3 = -1e999
local u26 = false
local u27 = nil
local u28 = nil
local v29 = NetworkPauseNotification.new()
local v30 = Create("ScreenGui")({
	Name = "RobloxNetworkPauseNotification",
	OnTopOfCoreBlur = true,
	DisplayOrder = 8,
	IgnoreGuiInset = false,
	AutoLocalize = false,
	Parent = CoreGui
})

local function reportPauseSessionAnalytics() -- line: 85
	-- upvalues: n2 (ref), elapsed2 (ref), TelemetryService (copy), t1 (copy), elapsed (copy), n1 (ref), v30 (copy)
	local v39 = n2

	if elapsed2 ~= nil then
		v39 += (os.clock() - elapsed2) * 1000
	end

	TelemetryService:LogEvent(t1, {
		customFields = {
			sessionDurationMs = (os.clock() - elapsed) * 1000,
			pauseCount = n1,
			totalPauseDurationMs = v39,
			pauseEnabled = v30.Enabled
		}
	})
end
local function setNotificationVisible(p1) -- line: 101
	-- upvalues: v29 (copy), RunService (copy), v15 (copy), elapsed2 (ref), n1 (ref), n2 (ref)
	if p1 then
		v29:Show()
	else
		v29:Hide()
	end

	RunService:SetRobloxGuiFocused(p1)

	if v15 then
		if p1 then
			if elapsed2 == nil then
				elapsed2 = os.clock()
				n1 += 1

				return
			end
		elseif elapsed2 ~= nil then
			n2 += (os.clock() - elapsed2) * 1000
			elapsed2 = nil
		end
	end
end
local function cancelTimers() -- line: 125
	-- upvalues: u27 (ref), u28 (ref)
	if u27 ~= nil then
		task.cancel(u27)
		u27 = nil
	end

	if u28 ~= nil then
		task.cancel(u28)
		u28 = nil
	end
end
local function isRapidRepause() -- line: 136
	-- upvalues: n3 (ref), v12 (copy)
	return (os.clock() - n3) * 1000 < v12
end
local function enterStage(p2) -- line: 140
	-- upvalues: UNPAUSED (ref), u27 (ref), u28 (ref), v22 (copy), u26 (ref), v29 (copy), RunService (copy), v15 (copy), elapsed2 (ref), n2 (ref), v14 (copy), LocalPlayer (ref), v30 (copy), enterStage (copy), n3 (ref), v12 (copy), n1 (ref), v13 (copy)
	UNPAUSED = p2

	if u27 ~= nil then
		task.cancel(u27)
		u27 = nil
	end

	if u28 ~= nil then
		task.cancel(u28)
		u28 = nil
	end

	if p2 == v22.UNPAUSED then
		u26 = false
		v29:Hide()
		RunService:SetRobloxGuiFocused(false)

		if v15 and elapsed2 ~= nil then
			n2 += (os.clock() - elapsed2) * 1000
			elapsed2 = nil

			return
		end
	else
		if p2 == v22.PENDING_SHOW then
			u27 = task.delay(v14 / 1000, function() -- line: 149
				-- upvalues: u27 (ref), UNPAUSED (ref), v22 (copy), LocalPlayer (ref), v30 (copy), enterStage (copy)
				u27 = nil

				if UNPAUSED == v22.PENDING_SHOW and (LocalPlayer.GameplayPaused and v30.Enabled) then
					enterStage(v22.PAUSED)
				end
			end)

			return
		end

		if p2 == v22.PAUSED then
			u26 = (os.clock() - n3) * 1000 < v12
			v29:Show()
			RunService:SetRobloxGuiFocused(true)

			if v15 and elapsed2 == nil then
				elapsed2 = os.clock()
				n1 += 1

				return
			end
		elseif p2 == v22.RAPID_PAUSE_PENDING_DISMISS then
			u28 = task.delay(v13 / 1000, function() -- line: 162
				-- upvalues: u28 (ref), UNPAUSED (ref), v22 (copy), LocalPlayer (ref), enterStage (copy)
				u28 = nil

				if UNPAUSED == v22.RAPID_PAUSE_PENDING_DISMISS and not LocalPlayer.GameplayPaused then
					enterStage(v22.UNPAUSED)
				end
			end)
		end
	end
end
local function onGameplayPausedChanged() -- line: 172
	-- upvalues: LocalPlayer (ref), v30 (copy), u23 (ref), UNPAUSED (ref), v22 (copy), n3 (ref), v12 (copy), enterStage (copy), u26 (ref)
	local v42 = LocalPlayer.GameplayPaused and (v30.Enabled and not u23)

	u23 = false

	if v42 then
		if UNPAUSED == v22.RAPID_PAUSE_PENDING_DISMISS or (os.clock() - n3) * 1000 < v12 then
			enterStage(v22.PAUSED)

			return
		end

		enterStage(v22.PENDING_SHOW)

		return
	end

	if UNPAUSED ~= v22.UNPAUSED then
		n3 = os.clock()
	end

	if UNPAUSED == v22.PENDING_SHOW then
		enterStage(v22.UNPAUSED)

		return
	end

	if u26 then
		enterStage(v22.RAPID_PAUSE_PENDING_DISMISS)

		return
	end

	enterStage(v22.UNPAUSED)
end
local function togglePauseState() -- line: 201
	-- upvalues: LocalPlayer (ref), v30 (copy), u23 (ref), v29 (copy), RunService (copy)
	local v43 = LocalPlayer.GameplayPaused and (v30.Enabled and not u23)

	u23 = false

	if v43 then
		v29:Show()
	else
		v29:Hide()
	end

	RunService:SetRobloxGuiFocused(v43)
end

if v11 then
	LocalPlayer:GetPropertyChangedSignal("GameplayPaused"):Connect(onGameplayPausedChanged)
else
	LocalPlayer:GetPropertyChangedSignal("GameplayPaused"):Connect(togglePauseState)
end

local function enableNotification(p3) -- line: 218
	-- upvalues: v30 (copy), v11 (copy), onGameplayPausedChanged (copy), enterStage (copy), v22 (copy), LocalPlayer (ref), u23 (ref), v29 (copy), RunService (copy)
	assert(type(p3) == "boolean", "Specified argument 'enabled' must be of type boolean")

	if p3 == v30.Enabled then
		return
	end

	v30.Enabled = p3

	if v11 then
		if p3 then
			onGameplayPausedChanged()

			return
		end

		enterStage(v22.UNPAUSED)

		return
	end

	local v45 = LocalPlayer.GameplayPaused and (v30.Enabled and not u23)

	u23 = false

	if v45 then
		v29:Show()
	else
		v29:Hide()
	end

	RunService:SetRobloxGuiFocused(v45)
end

v29:SetParent(v30)
GuiService.NetworkPausedEnabledChanged:Connect(enableNotification)

if v11 and v15 then
	game.Close:Connect(reportPauseSessionAnalytics)
end
