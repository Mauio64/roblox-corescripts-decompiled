local Parent = script:FindFirstAncestor("BugReporting").Parent
local Dash = require(Parent.Dash)
local React = require(Parent.React)

require(Parent.AppCommonLib)

local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local RobloxLocaleIdKey = require(Parent.Localization).RobloxLocaleIdKey
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useNavigation = require(Parent.Navigation).useNavigation
local getCurrentRouteState = require(Parent.Navigation).getCurrentRouteState
local useCurrentCamera = require(Parent.RobloxAppHooks).useCurrentCamera
local useProperty = require(Parent.GuiObjectUtils).useProperty
local SystemInfoProtocol = require(Parent.SystemInfoProtocol).SystemInfoProtocol
local InfoNames = SystemInfoProtocol.InfoNames
local useStyle = require(Parent.UIBlox).Core.Style.useStyle

require(script.Parent.BugReporterModal)

local BugReporterCounterName = require(script.Parent.BugReporterTypes).BugReporterCounterName
local SharedConstants = require(script.Parent.SharedConstants)
local t1 = {
	[InfoNames.APP_VERSION] = "Feature.InAppBugReporting.Message.AppVersion",
	[InfoNames.DEVICE_NAME] = "Feature.InAppBugReporting.Message.DeviceName",
	[InfoNames.SYSTEM_VERSION] = "Feature.InAppBugReporting.Message.SystemVersion",
	[SharedConstants.SCREEN_SUMMARY_KEY] = "Feature.InAppBugReporting.Message.Screen"
}

local function validateCommentText(t2: {[any]: any}, s1: string, n1: number) -- line: 51
	local v25 = false
	local commmentTooShortError = nil

	if type(s1) ~= "string" or s1 == "" then
		return v25, t2.commentEmptyError
	end

	if n1 > #s1 then
		commmentTooShortError = t2.commmentTooShortError
	end

	if n1 <= #s1 then
		v25 = true
	end

	return v25, commmentTooShortError
end
local function makeDeviceLocalizationKeys(t3: {[any]: any}, t4: {[any]: any}) -- line: 75
	-- upvalues: Dash (copy), SharedConstants (copy), t1 (copy)
	return Dash.reduce(SharedConstants.DEVICE_SUMMARY_ORDERED_KEYS, function(p1, p2) -- line: 76
		-- upvalues: t3 (copy), t4 (copy), t1 (copy)
		local v73 = t3[p2] or (t4[p2] or `Unknown ({ p2 })`)

		p1[p2] = {
			t1[p2],
			value = v73
		}

		return p1
	end, {})
end
local function formatDeviceSummaryString(t5: {[any]: any}) -- line: 83
	-- upvalues: Dash (copy), SharedConstants (copy)
	local v30 = Dash.map(SharedConstants.DEVICE_SUMMARY_ORDERED_KEYS, function(p3) -- line: 84
		-- upvalues: t5 (copy)
		return t5[p3]
	end)

	return table.concat(v30, "\n")
end
local function round(n2: number) -- line: 96
	return (math.floor(n2 or 0.5))
end
local function useBugReporterModalProps(t6: {[any]: any}) -- line: 100
	-- upvalues: useNavigation (copy), useDispatch (copy), useStyle (copy), useCurrentCamera (copy), React (copy), getCurrentRouteState (copy), SystemInfoProtocol (copy), useProperty (copy), makeDeviceLocalizationKeys (copy), SharedConstants (copy), useLocalization (copy), Dash (copy), RobloxLocaleIdKey (copy), BugReporterCounterName (copy)
	local v35 = useNavigation()
	local v36 = useDispatch()
	local Tokens = useStyle().Tokens
	local v38 = useCurrentCamera()
	local v39 = React.useMemo(function() -- line: 105
		-- upvalues: v38 (copy)
		return Vector2.new(math.floor(v38.ViewportSize.X or 0.5), (math.floor(v38.ViewportSize.Y or 0.5)))
	end, {
		v38.ViewportSize.X,
		v38.ViewportSize.Y
	})
	local v40, v41 = React.useState("")
	local v42, v43 = React.useState(0)
	local v44, v45 = React.useState("")
	local v46, v47 = React.useState(nil)
	local v48 = #(v44 or "")
	local v49 = React.useMemo(function() -- line: 116
		-- upvalues: t6 (copy)
		local _, v76 = t6.guiService:GetGuiInset()

		return v76.Y
	end, { t6.guiService })
	local v50 = React.useMemo(function() -- line: 121
		-- upvalues: v35 (copy), getCurrentRouteState (copy)
		local v77 = v35
		local v78 = getCurrentRouteState(v77)

		return v78 and v78.routeName or "Unknown"
	end, { v35 })
	local v51 = React.useMemo(function() -- line: 124
		-- upvalues: t6 (copy), SystemInfoProtocol (copy)
		return (t6.systemInfoProtocol:getSystemInfo(SystemInfoProtocol.ALL_INFO_NAMES))
	end, { t6.systemInfoProtocol })
	local v52 = useProperty(t6.userInputService, "OnScreenKeyboardSize")
	local v53 = React.useMemo(function() -- line: 130
		-- upvalues: makeDeviceLocalizationKeys (copy), v51 (copy), SharedConstants (copy), v50 (copy)
		return makeDeviceLocalizationKeys(v51, {
			[SharedConstants.SCREEN_SUMMARY_KEY] = v50
		})
	end, {
		v51,
		v50
	})
	local v54 = useLocalization(Dash.assign({
		title = "Feature.InAppBugReporting.Message.Title",
		commentLabel = "Feature.InAppBugReporting.Message.CommentLabel",
		commentPlaceholder = "Feature.InAppBugReporting.Message.CommentPlaceholder",
		commentEmptyError = "Feature.InAppBugReporting.Message.CommentEmptyError",
		screenshotAnnotation = "Feature.InAppBugReporting.Message.ScreenshotAnnotation",
		submit = "CommonUI.Controls.Action.Submit",
		commentCharacterCount = {
			"Feature.InAppBugReporting.Message.MinCharacterCount",
			currentCount = v48,
			minCount = t6.minCommentLength
		},
		commentTooShortError = {
			"Feature.InAppBugReporting.Message.CommentTooShortError",
			minLength = t6.minCommentLength
		}
	}, v53))
	local v55 = Dash.map(SharedConstants.DEVICE_SUMMARY_ORDERED_KEYS, function(p4) -- line: 84
		-- upvalues: v54 (copy)
		return v54[p4]
	end)
	local v56 = table.concat(v55, "\n")
	local v57 = v54[RobloxLocaleIdKey]
	local v58 = React.useMemo(function() -- line: 157
		-- upvalues: SharedConstants (copy), v50 (copy), v57 (copy), t6 (copy)
		return {
			[SharedConstants.SCREEN_SUMMARY_KEY] = v50,
			locale = v57,
			clientChannel = t6.runService:GetRobloxClientChannel(),
			coreScriptVersion = t6.runService:GetCoreScriptVersion()
		}
	end, {
		v50,
		v57,
		t6.runService
	})
	local v59 = React.useMemo(function() -- line: 166
		-- upvalues: v54 (copy)
		return {
			commentEmptyError = v54.commentEmptyError,
			commmentTooShortError = v54.commmentTooShortError
		}
	end, {
		v54.commentEmptyError,
		v54.commmentTooShortError
	})
	local minCommentLength = t6.minCommentLength
	local v61 = false

	if type(v44) ~= "string" or v44 == "" then
		local _ = v59.commentEmptyError
	else
		if minCommentLength > #v44 then
			local _ = v59.commmentTooShortError
		end

		if minCommentLength <= #v44 then
			v61 = true
		end
	end

	local v64 = v61
	local v65 = React.useCallback(function() -- line: 175
		-- upvalues: t6 (copy), BugReporterCounterName (copy), v50 (copy)
		t6.logger.reportCounter(BugReporterCounterName.ReportOpened)
		t6.logger.reportMilestone(BugReporterCounterName.ReportOpened, {
			screen = v50
		})
	end, {
		t6.logger,
		v50
	})
	local v66 = React.useCallback(function() -- line: 181
		-- upvalues: v59 (copy), v44 (copy), t6 (copy), v40 (copy), v51 (copy), v58 (copy), v47 (copy), v36 (copy)
		local v80 = v59
		local v81 = v44
		local minCommentLength2 = t6.minCommentLength
		local v83 = false
		local commentEmptyError = nil

		if type(v81) ~= "string" or v81 == "" then
			commentEmptyError = v80.commentEmptyError
		else
			if minCommentLength2 > #v81 then
				commentEmptyError = v80.commmentTooShortError
			end

			if minCommentLength2 <= #v81 then
				v83 = true
			end
		end

		if v83 then
			t6.onSubmitBugReport(t6.logger, {
				screenshotId = v40,
				description = v44,
				systemInfo = v51,
				additionalInfo = v58
			})
			v47(nil)
			v36(t6.closeCentralOverlayThunk())

			return
		end

		v47(commentEmptyError)
	end, {
		v36,
		v59,
		v40,
		v44,
		v51,
		v58,
		t6.minCommentLength,
		t6.closeCentralOverlayThunk,
		t6.onSubmitBugReport,
		t6.logger
	})
	local v67 = React.useCallback(function() -- line: 211
		-- upvalues: t6 (copy), BugReporterCounterName (copy), v50 (copy), v36 (copy)
		t6.logger.reportCounter(BugReporterCounterName.ReportAbandoned)
		t6.logger.reportMilestone(BugReporterCounterName.ReportAbandoned, {
			screen = v50
		})
		v36(t6.closeCentralOverlayThunk())
	end, {
		v36,
		t6.closeCentralOverlayThunk,
		t6.logger,
		v50
	})
	local v68 = React.useCallback(function(p5) -- line: 217
		-- upvalues: v45 (copy)
		v45(p5.Text)
	end, {})
	local v69 = React.useCallback(function(p6) -- line: 221
		-- upvalues: v43 (copy)
		v43(p6.AbsoluteContentSize.Y)
	end, {})

	React.useEffect(function() -- line: 225
		-- upvalues: t6 (copy), v41 (copy)
		local v87 = t6.onScreenshotUploaded:connect(function(p7) -- line: 226
			-- upvalues: v41 (copy)
			v41(p7)
		end)

		return function() -- line: 230
			-- upvalues: v87 (copy)
			v87:disconnect()
		end
	end, { t6.onScreenshotUploaded })

	local v70 = React.useMemo(function() -- line: 236
		-- upvalues: v39 (copy), v49 (copy), v51 (copy), v56 (copy), t6 (copy), v52 (copy), v42 (copy), v69 (copy), v44 (copy), v46 (copy), v68 (copy), v64 (copy), v66 (copy), v65 (copy), v67 (copy)
		return {
			screenSize = v39,
			bottomInset = v49,
			systemInfo = v51,
			localizedDeviceSummary = v56,
			screenshotContentId = t6.screenshotLocalId,
			onScreenKeyboardSize = v52,
			scrollContentHeight = v42,
			onListLayoutSizeChange = v69,
			commentText = v44,
			commentErrorMessage = v46,
			onCommentTextChange = v68,
			canSubmit = v64,
			onSubmit = v66,
			onLoad = v65,
			onClose = v67
		}
	end, {
		v39,
		v49,
		v51,
		v56,
		t6.screenshotLocalId,
		v52,
		v42,
		v69,
		v44,
		v46,
		v68,
		v64,
		v66,
		v65,
		v67
	})

	return Dash.assign(v70, {
		designTokens = Tokens,
		localizedStrings = v54
	})
end

return useBugReporterModalProps
