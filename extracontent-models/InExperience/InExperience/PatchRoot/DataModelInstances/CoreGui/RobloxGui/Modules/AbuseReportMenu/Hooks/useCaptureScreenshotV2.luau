local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local Constants = require(AbuseReportMenu.Components.Constants)
require(AbuseReportMenu.Components.Types)
local TnSIXPWrapper = require(AbuseReportMenu.IXP.TnSIXPWrapper)
local runScreenshotCaptureSequence = require(script.Parent.runScreenshotCaptureSequence)

local function emptySnapshot() -- 2 equivalent calls inferred from this helper
	return { screenshotId = "", identificationResults = Constants.InitialIdentificationResults }
end

local function useCaptureScreenshotV2()
	local ref = React.useRef(emptySnapshot()) -- inferred equivalent call

	local state, setState = React.useState(false)

	local ref2 = React.useRef("idle")

	local v = TnSIXPWrapper.getReportAnythingAvatarEnabled() or TnSIXPWrapper.getReportAnythingExperienceEnabled()

	local ref3 = React.useRef(v)
	ref3.current = v

	local reset = React.useCallback(function()
		ref.current = emptySnapshot() -- inferred equivalent call
		ref2.current = "idle"
		setState(false)
	end, {})

	local getIsCapturing = React.useCallback(function(): boolean
		return ref2.current == "capturing"
	end, {})

	return {
		captureIfApplicable = React.useCallback(function(p)
			if not ref3.current or ref2.current ~= "idle" then
				return
			end

			ref2.current = "capturing"

			runScreenshotCaptureSequence({
				hide = p.hide,
				show = p.show,
				onScreenshotTaken = function()
					setState(true)
				end,
				onScreenshotUploaded = function(screenshotId: string)
					ref.current = {
						screenshotId = screenshotId,
						identificationResults = ref.current.identificationResults
					}
				end,
				onIdentificationCompleted = function(identificationResults)
					ref.current = {
						screenshotId = ref.current.screenshotId,
						identificationResults = identificationResults
					}
				end,
				onCaptureEnd = function()
					ref2.current = "done"
				end
			})
		end, {}),
		reset = reset,
		getIsCapturing = getIsCapturing,
		isCaptureApplicable = v,
		isScreenshotTaken = state,
		snapshotRef = ref
	}
end

return useCaptureScreenshotV2
