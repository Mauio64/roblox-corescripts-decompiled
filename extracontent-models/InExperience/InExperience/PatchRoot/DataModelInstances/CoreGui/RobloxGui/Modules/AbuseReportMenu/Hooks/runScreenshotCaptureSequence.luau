local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

require(AbuseReportMenu.Components.Types)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagIEMTabFocusNav = SharedFlags.FFlagIEMTabFocusNav

local TnSAvatarIdentification = require(CorePackages.Workspace.Packages.TnSAvatarIdentification)
local TnSAdIdentification = require(CorePackages.Workspace.Packages.TnSAdIdentification)
local TnSScreenshot = require(CorePackages.Workspace.Packages.TnSScreenshot)
local ScreenshotManager = TnSScreenshot.ScreenshotManager

local AvatarIdentification = TnSAvatarIdentification.AvatarIdentification
local AdIdentification = TnSAdIdentification.AdIdentification

local defineFastInt = game:DefineFastInt("AbuseReportMenuScreenshotReduceMotionWaitFrames", 20)
local defineFastInt2 = game:DefineFastInt("AbuseReportMenuScreenshotWaitFrames", 10)

local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function defaultGetWaitFrames() -- 1 equivalent call inferred from this helper
	if UserGameSettings.ReducedMotion then
		return defineFastInt
	end

	return defineFastInt2
end

local function defaultGetWaitTime()
	return defaultGetWaitFrames() / 60 -- inferred equivalent call
end

local function defaultDeps()
	return {
		takeScreenshot = function(p)
			return ScreenshotManager:TakeScreenshotWithCallback(p)
		end,
		getVisibleAvatars = function()
			return AvatarIdentification.getVisibleAvatars()
		end,
		getVisibleAds = function()
			return AdIdentification.getVisibleAds()
		end,
		runService = RunService,
		getWaitFrames = defaultGetWaitFrames,
		getWaitTime = defaultGetWaitTime
	}
end

local function runIdentification(p) -- 1 equivalent call inferred from this helper
	local visibleAvatars, avatarIDStats = p.getVisibleAvatars()
	local visibleAds, adIDStats = p.getVisibleAds()
	return {
		identifiedAvatars = visibleAvatars,
		identifiedAds = visibleAds,
		avatarIDStats = avatarIDStats,
		adIDStats = adIDStats
	}
end

local function runScreenshotCaptureSequence(data, p)
	local v = p or defaultDeps()
	local selectedCoreObject

	if FFlagIEMTabFocusNav then
		selectedCoreObject = GuiService.SelectedCoreObject
	else
		selectedCoreObject = nil
	end

	data.hide()

	local count = 0
	local lastTime = os.clock()
	local v2 = false

	local heartbeatConnection = nil
	heartbeatConnection = v.runService.Heartbeat:Connect(function()
		if not v2 and count >= 1 then
			v2 = true
			v.takeScreenshot(data.onScreenshotUploaded)
			data.onScreenshotTaken()
			data.onIdentificationCompleted(runIdentification(v)) -- inferred equivalent call
		end

		local v3 = count >= v.getWaitFrames()
		local v4 = os.clock() - lastTime >= v.getWaitTime()

		if not (v2 and v3 and v4) then
			count += 1
			return
		end

		heartbeatConnection:Disconnect()
		data.show()

		if FFlagIEMTabFocusNav and selectedCoreObject and selectedCoreObject:IsDescendantOf(game) then
			GuiService.SelectedCoreObject = selectedCoreObject
		end

		data.onCaptureEnd()
	end)
end

return runScreenshotCaptureSequence
