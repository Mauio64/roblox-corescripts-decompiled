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
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

local defineFastInt = game:DefineFastInt("RapidGameplayPauseIntervalMs", 1000)
local defineFastInt2 = game:DefineFastInt("RapidGameplayPauseMinNotificationDurationMs", 500)
local defineFastInt3 = game:DefineFastInt("GameplayPauseShowDelayMs", 300)

local v = {
	eventName = "StreamingPauseUISessionStats",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("StreamingPauseUIAnalyticsThrottleHP", 0),
	lastUpdated = { 2026, 6, 2 },
	description = "Session stats for streaming pause UI visibility"
}

local lastTime = os.clock()
local count = 0
local total = 0
local lastTime2 = nil

local frozen = table.freeze({
	UNPAUSED = "unpaused",
	PENDING_SHOW = "pendingShow",
	PAUSED = "paused",
	RAPID_PAUSE_PENDING_DISMISS = "rapidPausePendingDismiss"
})

local v2 = true
local v3 = frozen.UNPAUSED
local lastTime3 = -1e999
local v4 = false
local thread = nil
local thread2 = nil

local v5 = NetworkPauseNotification.new()

local v6 = Create("ScreenGui")({
	Name = "RobloxNetworkPauseNotification",
	OnTopOfCoreBlur = true,
	DisplayOrder = 8,
	Parent = CoreGui,
	IgnoreGuiInset = false,
	AutoLocalize = false
})

local function reportPauseSessionAnalytics()
	local totalPauseDurationMs = total

	if lastTime2 ~= nil then
		totalPauseDurationMs += (os.clock() - lastTime2) * 1000
	end

	TelemetryService:LogEvent(v, {
		customFields = {
			sessionDurationMs = (os.clock() - lastTime) * 1000,
			pauseCount = count,
			totalPauseDurationMs = totalPauseDurationMs,
			pauseEnabled = v6.Enabled
		}
	})
end

local function setNotificationVisible(p) -- 2 equivalent calls inferred from this helper
	if p then
		v5:Show()
	else
		v5:Hide()
	end

	RunService:SetRobloxGuiFocused(p)

	if p then
		if lastTime2 == nil then
			lastTime2 = os.clock()
			count += 1
		end
	elseif lastTime2 ~= nil then
		total += (os.clock() - lastTime2) * 1000
		lastTime2 = nil
	end
end

local function cancelTimers() -- 1 equivalent call inferred from this helper
	if thread ~= nil then
		task.cancel(thread)
		thread = nil
	end

	if thread2 ~= nil then
		task.cancel(thread2)
		thread2 = nil
	end
end

local function isRapidRepause(): boolean -- 2 equivalent calls inferred from this helper
	return (os.clock() - lastTime3) * 1000 < defineFastInt
end

local function enterStage(p)
	v3 = p
	cancelTimers() -- inferred equivalent call

	if p == frozen.UNPAUSED then
		v4 = false
		setNotificationVisible(false) -- inferred equivalent call
	elseif p == frozen.PENDING_SHOW then
		thread = task.delay(defineFastInt3 / 1000, function()
			thread = nil

			if v3 == frozen.PENDING_SHOW and LocalPlayer.GameplayPaused and v6.Enabled then
				enterStage(frozen.PAUSED)
			end
		end)
	elseif p == frozen.PAUSED then
		v4 = isRapidRepause() -- inferred equivalent call
		setNotificationVisible(true) -- inferred equivalent call
	elseif p == frozen.RAPID_PAUSE_PENDING_DISMISS then
		thread2 = task.delay(defineFastInt2 / 1000, function()
			thread2 = nil

			if v3 == frozen.RAPID_PAUSE_PENDING_DISMISS and not LocalPlayer.GameplayPaused then
				enterStage(frozen.UNPAUSED)
			end
		end)
	end
end

local function onGameplayPausedChanged()
	local v7 = LocalPlayer.GameplayPaused and v6.Enabled and not v2
	v2 = false

	if v7 then
		if v3 == frozen.RAPID_PAUSE_PENDING_DISMISS or isRapidRepause() then -- inferred equivalent call
			enterStage(frozen.PAUSED)
		else
			enterStage(frozen.PENDING_SHOW)
		end
	else
		if v3 ~= frozen.UNPAUSED then
			lastTime3 = os.clock()
		end

		if v3 == frozen.PENDING_SHOW then
			enterStage(frozen.UNPAUSED)
		elseif v4 then
			enterStage(frozen.RAPID_PAUSE_PENDING_DISMISS)
		else
			enterStage(frozen.UNPAUSED)
		end
	end
end

LocalPlayer:GetPropertyChangedSignal("GameplayPaused"):Connect(onGameplayPausedChanged)

local function enableNotification(enabled)
	assert(type(enabled) == "boolean", "Specified argument 'enabled' must be of type boolean")

	if enabled == v6.Enabled then
		return
	end

	v6.Enabled = enabled

	if enabled then
		onGameplayPausedChanged()
	else
		enterStage(frozen.UNPAUSED)
	end
end

v5:SetParent(v6)

GuiService.NetworkPausedEnabledChanged:Connect(enableNotification)

game.Close:Connect(reportPauseSessionAnalytics)
