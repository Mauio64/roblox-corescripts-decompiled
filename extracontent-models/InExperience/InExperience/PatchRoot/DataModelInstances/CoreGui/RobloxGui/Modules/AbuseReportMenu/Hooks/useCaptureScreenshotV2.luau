local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Constants = require(AbuseReportMenu.Components.Constants)

require(AbuseReportMenu.Components.Types)

local TnSIXPWrapper = require(AbuseReportMenu.IXP.TnSIXPWrapper)
local runScreenshotCaptureSequence = require(script.Parent.runScreenshotCaptureSequence)

local function emptySnapshot() -- line: 29
	-- upvalues: Constants (copy)
	return {
		screenshotId = "",
		identificationResults = Constants.InitialIdentificationResults
	}
end
local function useCaptureScreenshotV2() -- line: 54
	-- upvalues: React (copy), Constants (copy), TnSIXPWrapper (copy), runScreenshotCaptureSequence (copy)
	local v9 = React.useRef({
		screenshotId = "",
		identificationResults = Constants.InitialIdentificationResults
	})
	local v10, v11 = React.useState(false)
	local v12 = React.useRef("idle")
	local v13 = TnSIXPWrapper.getReportAnythingAvatarEnabled() or TnSIXPWrapper.getReportAnythingExperienceEnabled()
	local v14 = React.useRef(v13)

	v14.current = v13

	local v15 = React.useCallback(function() -- line: 71
		-- upvalues: v9 (copy), Constants (copy), v12 (copy), v11 (copy)
		v9.current = {
			screenshotId = "",
			identificationResults = Constants.InitialIdentificationResults
		}
		v12.current = "idle"
		v11(false)
	end, {})
	local v16 = React.useCallback(function() -- line: 77
		-- upvalues: v12 (copy)
		return v12.current == "capturing"
	end, {})

	return {
		captureIfApplicable = React.useCallback(function(t1: {[any]: any}) -- line: 81
			-- upvalues: v14 (copy), v12 (copy), runScreenshotCaptureSequence (copy), v11 (copy), v9 (copy)
			if not v14.current or v12.current ~= "idle" then
				return
			end

			v12.current = "capturing"
			runScreenshotCaptureSequence({
				hide = t1.hide,
				show = t1.show,
				onScreenshotTaken = function() -- line: 91
					-- upvalues: v11 (copy)
					v11(true)
				end,
				onScreenshotUploaded = function(s1: string) -- line: 94
					-- upvalues: v9 (copy)
					v9.current = {
						screenshotId = s1,
						identificationResults = v9.current.identificationResults
					}
				end,
				onIdentificationCompleted = function(p1) -- line: 100
					-- upvalues: v9 (copy)
					v9.current = {
						screenshotId = v9.current.screenshotId,
						identificationResults = p1
					}
				end,
				onCaptureEnd = function() -- line: 106
					-- upvalues: v12 (copy)
					v12.current = "done"
				end
			})
		end, {}),
		reset = v15,
		getIsCapturing = v16,
		isCaptureApplicable = v13,
		isScreenshotTaken = v10,
		snapshotRef = v9
	}
end

return useCaptureScreenshotV2
