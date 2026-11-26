local module = require("@luauforge/bundled/hYU")
local module2 = require("@luauforge/bundled/hYV")
require("@luauforge/bundled/hZf")
local useDispatch = require("@luauforge/bundled/hYW").Hooks.RoactRodux.useDispatch
local robloxLocaleIdKey = require("@luauforge/bundled/hZD").RobloxLocaleIdKey
local useLocalization = require("@luauforge/bundled/hZD").Hooks.useLocalization
local useNavigation = require("@luauforge/bundled/hZE").useNavigation
local getCurrentRouteState = require("@luauforge/bundled/hZE").getCurrentRouteState
local useCurrentCamera = require("@luauforge/bundled/hZF").useCurrentCamera
local useProperty = require("@luauforge/bundled/hZG").useProperty
local systemInfoProtocol = require("@luauforge/bundled/hZg").SystemInfoProtocol
local infoNames = systemInfoProtocol.InfoNames
local useStyle = require("@luauforge/bundled/hZA").Core.Style.useStyle
require("@luauforge/bundled/hZz")
local bugReporterCounterName = require("@luauforge/bundled/hZk").BugReporterCounterName
local module3 = require("@luauforge/bundled/hZs")

local v5 = {
	[infoNames.APP_VERSION] = "Feature.InAppBugReporting.Message.AppVersion",
	[infoNames.DEVICE_NAME] = "Feature.InAppBugReporting.Message.DeviceName",
	[infoNames.SYSTEM_VERSION] = "Feature.InAppBugReporting.Message.SystemVersion",
	[module3.SCREEN_SUMMARY_KEY] = "Feature.InAppBugReporting.Message.Screen"
}

local function validateCommentText(p2, value, p3)
	local v6 = false
	local commmentTooShortError = nil

	if type(value) ~= "string" or value == "" then
		return false, p2.commentEmptyError
	end

	if #value < p3 then
		commmentTooShortError = p2.commmentTooShortError
	end

	return p3 <= #value or v6, commmentTooShortError
end

local function makeDeviceLocalizationKeys(p2, p3)
	return module.reduce(module3.DEVICE_SUMMARY_ORDERED_KEYS, function(p4, p5)
		local v6 = p2[p5] or p3[p5] or `Unknown ({p5})`
		p4[p5] = {
			v5[p5],
			value = v6
		}
		return p4
	end, {})
end

local function formatDeviceSummaryString(p2)
	local mapped = module.map(module3.DEVICE_SUMMARY_ORDERED_KEYS, function(p3)
		return p2[p3]
	end)

	return table.concat(mapped, "\n")
end

local function round(value)
	return (math.floor(value or 0.5))
end

local function useBugReporterModalProps(data)
	local v6 = useNavigation()
	local v7 = useDispatch()
	local tokens = useStyle().Tokens
	local v8 = useCurrentCamera()
	local v9 = module2.useMemo(function()
		return Vector2.new(math.floor(v8.ViewportSize.X or 0.5), (math.floor(v8.ViewportSize.Y or 0.5)))
	end, { v8.ViewportSize.X, v8.ViewportSize.Y })

	local state, setState = module2.useState("")
	local state2, setState2 = module2.useState(0)

	local state3, setState3 = module2.useState("")
	local state4, setState4 = module2.useState(nil)
	local v10 = #(state3 or "")

	local v11 = module2.useMemo(function()
		local guiInset, v12 = data.guiService:GetGuiInset()
		return v12.Y
	end, { data.guiService })

	local v12 = module2.useMemo(function()
		local currentRouteState = getCurrentRouteState(v6)
		return currentRouteState and currentRouteState.routeName or "Unknown"
	end, { v6 })
	local v13 = module2.useMemo(function()
		return data.systemInfoProtocol:getSystemInfo(systemInfoProtocol.ALL_INFO_NAMES)
	end, { data.systemInfoProtocol })

	local v14 = useProperty(data.userInputService, "OnScreenKeyboardSize")

	local v15 = module2.useMemo(function()
		return makeDeviceLocalizationKeys(v13, { [module3.SCREEN_SUMMARY_KEY] = v12 })
	end, { v13, v12 })

	local v16 = useLocalization(module.assign({
		title = "Feature.InAppBugReporting.Message.Title",
		commentLabel = "Feature.InAppBugReporting.Message.CommentLabel",
		commentPlaceholder = "Feature.InAppBugReporting.Message.CommentPlaceholder",
		commentCharacterCount = {
			"Feature.InAppBugReporting.Message.MinCharacterCount",
			currentCount = v10,
			minCount = data.minCommentLength
		},
		commentEmptyError = "Feature.InAppBugReporting.Message.CommentEmptyError",
		commentTooShortError = {
			"Feature.InAppBugReporting.Message.CommentTooShortError",
			minLength = data.minCommentLength
		},
		screenshotAnnotation = "Feature.InAppBugReporting.Message.ScreenshotAnnotation",
		submit = "CommonUI.Controls.Action.Submit"
	}, v15))
	local mapped = module.map(module3.DEVICE_SUMMARY_ORDERED_KEYS, function(p2)
		return v16[p2]
	end)

	local joined = table.concat(mapped, "\n")

	local v17 = v16[robloxLocaleIdKey]
	local v18 = module2.useMemo(function()
		return {
			[module3.SCREEN_SUMMARY_KEY] = v12,
			locale = v17,
			clientChannel = data.runService:GetRobloxClientChannel(),
			coreScriptVersion = data.runService:GetCoreScriptVersion()
		}
	end, { v12, v17, data.runService })

	local v19 = module2.useMemo(function()
		return {
			commentEmptyError = v16.commentEmptyError,
			commmentTooShortError = v16.commmentTooShortError
		}
	end, { v16.commentEmptyError, v16.commmentTooShortError })

	local minCommentLength = data.minCommentLength
	local v20 = false

	if type(state3) == "string" and state3 ~= "" then
		if #state3 < minCommentLength then
			local commmentTooShortError = v19.commmentTooShortError
		end

		v20 = minCommentLength <= #state3 or v20
	else
		local commentEmptyError = v19.commentEmptyError
	end

	local v21 = module2.useCallback(function()
		data.logger.reportCounter(bugReporterCounterName.ReportOpened)
		data.logger.reportMilestone(bugReporterCounterName.ReportOpened, {
			screen = v12
		})
	end, { data.logger, v12 })

	local v22 = module2.useCallback(function()
		local v23 = v19
		local v24 = state3
		local minCommentLength2 = data.minCommentLength
		local v25 = false
		local v26 = nil

		if type(v24) == "string" and v24 ~= "" then
			if #v24 < minCommentLength2 then
				v26 = v23.commmentTooShortError
			end

			v25 = minCommentLength2 <= #v24 or false
		else
			v26 = v23.commentEmptyError
		end

		if not v25 then
			setState4(v26)

			return
		end

		data.onSubmitBugReport(data.logger, {
			screenshotId = state,
			description = state3,
			systemInfo = v13,
			additionalInfo = v18
		})

		setState4(nil)
		v7(data.closeCentralOverlayThunk())
	end, {
		v7,
		v19,
		state,
		state3,
		v13,
		v18,
		data.minCommentLength,
		data.closeCentralOverlayThunk,
		data.onSubmitBugReport,
		data.logger
	})

	local v23 = module2.useCallback(function()
		data.logger.reportCounter(bugReporterCounterName.ReportAbandoned)
		data.logger.reportMilestone(bugReporterCounterName.ReportAbandoned, {
			screen = v12
		})
		v7(data.closeCentralOverlayThunk())
	end, { v7, data.closeCentralOverlayThunk, data.logger, v12 })

	local v24 = module2.useCallback(function(p2)
		setState3(p2.Text)
	end, {})

	local v25 = module2.useCallback(function(p2)
		setState2(p2.AbsoluteContentSize.Y)
	end, {})

	module2.useEffect(function()
		local onScreenshotUploadedConnection = data.onScreenshotUploaded:connect(function(p2)
			setState(p2)
		end)

		return function()
			onScreenshotUploadedConnection:disconnect()
		end
	end, { data.onScreenshotUploaded })

	local v26 = module2.useMemo(function()
		return {
			screenSize = v9,
			bottomInset = v11,
			systemInfo = v13,
			localizedDeviceSummary = joined,
			screenshotContentId = data.screenshotLocalId,
			onScreenKeyboardSize = v14,
			scrollContentHeight = state2,
			onListLayoutSizeChange = v25,
			commentText = state3,
			commentErrorMessage = state4,
			onCommentTextChange = v24,
			canSubmit = v20,
			onSubmit = v22,
			onLoad = v21,
			onClose = v23
		}
	end, {
		v9,
		v11,
		v13,
		joined,
		data.screenshotLocalId,
		v14,
		state2,
		v25,
		state3,
		state4,
		v24,
		v20,
		v22,
		v21,
		v23
	})

	return module.assign(v26, { designTokens = tokens, localizedStrings = v16 })
end

return useBugReporterModalProps
