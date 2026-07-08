local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

require(AbuseReportMenu.Components.Types)

local FFlagIEMTabFocusNav = require(CorePackages.Workspace.Packages.SharedFlags).FFlagIEMTabFocusNav
local TnSAvatarIdentification = require(CorePackages.Workspace.Packages.TnSAvatarIdentification)
local TnSAdIdentification = require(CorePackages.Workspace.Packages.TnSAdIdentification)
local ScreenshotManager = require(CorePackages.Workspace.Packages.TnSScreenshot).ScreenshotManager
local AvatarIdentification = TnSAvatarIdentification.AvatarIdentification
local AdIdentification = TnSAdIdentification.AdIdentification
local v11 = game:DefineFastInt("AbuseReportMenuScreenshotReduceMotionWaitFrames", 20)
local v12 = game:DefineFastInt("AbuseReportMenuScreenshotWaitFrames", 10)
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function defaultGetWaitFrames() -- line: 62
	-- upvalues: UserGameSettings (copy), v11 (copy), v12 (copy)
	if UserGameSettings.ReducedMotion then
		return v11
	end

	return v12
end
local function defaultGetWaitTime() -- line: 69
	-- upvalues: UserGameSettings (copy), v11 (copy), v12 (copy)
	return ((if not UserGameSettings.ReducedMotion then v12 else v11)) / 60
end
local function defaultDeps() -- line: 73
	-- upvalues: ScreenshotManager (copy), AvatarIdentification (copy), AdIdentification (copy), RunService (copy), defaultGetWaitFrames (copy), defaultGetWaitTime (copy)
	return {
		takeScreenshot = function(p1) -- line: 75
			-- upvalues: ScreenshotManager (copy)
			return ScreenshotManager:TakeScreenshotWithCallback(p1)
		end,
		getVisibleAvatars = function() -- line: 78
			-- upvalues: AvatarIdentification (copy)
			return AvatarIdentification.getVisibleAvatars()
		end,
		getVisibleAds = function() -- line: 81
			-- upvalues: AdIdentification (copy)
			return AdIdentification.getVisibleAds()
		end,
		runService = RunService,
		getWaitFrames = defaultGetWaitFrames,
		getWaitTime = defaultGetWaitTime
	}
end
local function runIdentification(t1: {[any]: any}) -- line: 90
	local v20, v21 = t1.getVisibleAvatars()
	local v22, v23 = t1.getVisibleAds()

	return {
		identifiedAvatars = v20,
		identifiedAds = v22,
		avatarIDStats = v21,
		adIDStats = v23
	}
end
local function runScreenshotCaptureSequence(t2: {[any]: any}, t3: {[any]: any}?) -- line: 101
	-- upvalues: defaultDeps (copy), FFlagIEMTabFocusNav (copy), GuiService (copy)
	local v26 = t3 or defaultDeps()
	local SelectedCoreObject = nil

	if FFlagIEMTabFocusNav then
		SelectedCoreObject = GuiService.SelectedCoreObject
	end

	t2.hide()

	local n1 = 0
	local elapsed = os.clock()
	local u30 = false
	local connection = nil

	connection = v26.runService.Heartbeat:Connect(function() -- line: 116
		-- upvalues: u30 (ref), n1 (ref), v26 (copy), t2 (copy), elapsed (copy), connection (ref), FFlagIEMTabFocusNav (copy), SelectedCoreObject (ref), GuiService (copy)
		if not u30 and n1 >= 1 then
			u30 = true
			v26.takeScreenshot(t2.onScreenshotUploaded)
			t2.onScreenshotTaken()

			local onIdentificationCompleted = t2.onIdentificationCompleted
			local v34 = v26
			local v35, v36 = v34.getVisibleAvatars()
			local v37, v38 = v34.getVisibleAds()

			onIdentificationCompleted({
				identifiedAvatars = v35,
				identifiedAds = v37,
				avatarIDStats = v36,
				adIDStats = v38
			})
		end

		local v39 = n1 >= v26.getWaitFrames()
		local v40 = os.clock() - elapsed >= v26.getWaitTime()

		if u30 and v39 and v40 then
			connection:Disconnect()
			t2.show()

			if FFlagIEMTabFocusNav and SelectedCoreObject and SelectedCoreObject:IsDescendantOf(game) then
				GuiService.SelectedCoreObject = SelectedCoreObject
			end

			t2.onCaptureEnd()

			return
		end

		n1 += 1
	end)
end

return runScreenshotCaptureSequence
