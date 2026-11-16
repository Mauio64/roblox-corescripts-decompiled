local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local AdGuiInteractivity = script:FindFirstAncestor("AdGuiInteractivity")
local parent = AdGuiInteractivity.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local LinkingProtocol = require(parent.LinkingProtocol)
local Foundation = require(parent.Foundation)
local ColorMode = Foundation.Enums.ColorMode
local Localization = require(parent.Localization)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local Http = require(parent.Http)
local RoactServices = require(parent.RoactServices)
local RoactServiceTags = require(parent.RoactServiceTags)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local Screenshot = require(parent.Screenshot)
local LoggingProtocol = require(parent.LoggingProtocol)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local AdsInteractivityTelemetry = require(AdGuiInteractivity.AdsInteractivityTelemetry)

local useRoactService = RobloxAppHooks.useRoactService
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Constants = UIBlox.App.Style.Constants
local DefaultTwoStepReportFlow = require(parent.GenericAbuseReporting.DefaultTwoStepReportFlow)
local Button = Foundation.Button
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useLocalization = Localization.Hooks.useLocalization
local default = LinkingProtocol.LinkingProtocol.default
local default2 = LoggingProtocol.default
local Url = Http.Url

local reportCategories = {
	{
		localizationKey = "CoreScripts.Ads.Label.InappropriateAd",
		value = "ABUSE_CATEGORY_INAPPROPRIATE_AD"
	}
}

local v = urlBuilder.new({ base = Url.BASE_URL, path = "illegal-content-reporting" })

local v2 = urlBuilder.new({ base = Url.CREATOR_HUB_URL, path = "store/asset/{assetId}" })

local v3 = urlBuilder.new({ base = Url.APIS_URL, path = "abuse-reporting/v1/abuse-report" })

local v4 = {
	eventName = "ReportImmersiveBrandedAdTotalCounter",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 26, 3, 11 },
	description = "This event is fired when the user initiates submitting an immersive branded ad abuse report (before success or failure is known)."
}

local v5 = {
	eventName = "ReportImmersiveBrandedAdSuccessCounter",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 26, 3, 11 },
	description = "This event is fired when an immersive branded ad abuse report is successfully submitted to the server."
}

local v6 = {
	eventName = "ReportImmersiveBrandedAdFailureCounter",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = { 26, 3, 11 },
	description = "This event is fired when submitting an immersive branded ad abuse report fails."
}

local v7 = {
	eventName = "ReportImmersiveBrandedAdHttpFaulreEvent",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	throttlingPercentage = game:DefineFastInt("ReportImmersiveBrandedAdHttpFaulreEventThrottleHundredthsPercent", 0),
	lastUpdated = { 26, 11, 3 },
	description = "This event is fired when the HTTP request to submit an immersive branded ad abuse report fails."
}

local function logReportImmersiveBrandedAdTotalCounter() -- 1 equivalent call inferred from this helper
	default2:logRobloxTelemetryCounter(v4)
end

local function logReportImmersiveBrandedAdSuccessCounter() -- 1 equivalent call inferred from this helper
	default2:logRobloxTelemetryCounter(v5)
end

local function logReportImmersiveBrandedAdFailureCounter(reason: string) -- 4 equivalent calls inferred from this helper
	default2:logRobloxTelemetryCounter(v6, 1, { reason = reason })
end

local function logReportImmersiveBrandedAdHttpFailureEvent(value)
	local v8 = {}

	if type(value) == "string" then
		v8.error = value:sub(1, 500)
	elseif type(value) == "table" then
		if value.Body and type(value.Body) == "string" then
			v8.body = value.Body:sub(1, 500)
		end

		if value.StatusCode and type(value.StatusCode) == "number" then
			v8.statusCode = tostring(value.StatusCode)
		end
	end

	default2:logRobloxTelemetryEvent(v7, nil, v8)
end

local function sendImmersiveBrandedAdAbuseReport(callback, data): boolean
	local v8 = {
		abuseVector = "ad_v2",
		targetType = "ad_v2",
		category = data.reason,
		comment = data.comment,
		custom = { SCREENSHOT_ID = data.screenshotId, PLACE_ID = data.placeId },
		submitterId = data.userId,
		targetIdStr = `immersiveBrandedAd/{data.immersiveBrandedAdId}`
	}

	local success, result = pcall(function()
		return HttpService:JSONEncode(v8)
	end)

	if success then
		task.spawn(function()
			callback(v3(), "POST", { postBody = result }):andThen(function(_)
				logReportImmersiveBrandedAdSuccessCounter() -- inferred equivalent call
			end, function(p)
				logReportImmersiveBrandedAdFailureCounter("http") -- inferred equivalent call
				logReportImmersiveBrandedAdHttpFailureEvent(p)
			end)
		end)

		return true
	end

	logReportImmersiveBrandedAdFailureCounter("jsonEncode") -- inferred equivalent call
	return false
end

local function ImmersiveBrandedAdReportAdDialog(p)
	local immersiveBrandedAdId = p.immersiveBrandedAdId
	local v8 = useRoactService(RoactServiceTags.RoactNetworking)
	local ref = React.useRef(nil)
	local state, setState = React.useState(false)

	local v9 = useLocalization({ LinkText = "CoreScripts.Ads.Label.IllegalContentReportingLink" })

	local v10 = useAppPolicy(function(p2)
		return p2.getShowIllegalContentReportingUI()
	end)

	local onActivated = React.useCallback(function()
		local contentURL = v2({ assetId = immersiveBrandedAdId })
		default:openURL((urlBuilder.addQueryString(v(), { contentURL = contentURL }))):catch(function(_)
			AdsInteractivityTelemetry.logImmersiveBrandedAdLinkingFailedCounter("reportAd.eudsaIllegalContent")
			p.onDismiss()
		end)
	end, { immersiveBrandedAdId, p.onDismiss })

	local footerContent = React.useCallback(function()
		return React.createElement(View, {
			tag = "col margin-x-medium padding-top-medium size-full-0 auto-y"
		}, {
			linkButton = React.createElement(Button, {
				text = v9.LinkText,
				variant = ButtonVariant.Link,
				onActivated = onActivated,
				icon = "icons/navigation/externallink",
				size = InputSize.Small
			})
		})
	end, { onActivated, v9.LinkText })

	local onSubmit = React.useCallback(function(reason, comment)
		if RunService:IsStudio() or _G.__TESTEZ_RUNNING_TEST__ or _G.__TEST_SUITE_PACKAGE__ then
			return true
		end

		logReportImmersiveBrandedAdTotalCounter() -- inferred equivalent call
		local localPlayer = game.Players.LocalPlayer

		if not localPlayer then
			logReportImmersiveBrandedAdFailureCounter("noPlayer") -- inferred equivalent call
			return false
		end

		if ref.current then
			return sendImmersiveBrandedAdAbuseReport(v8, {
				reason = reason,
				comment = comment,
				immersiveBrandedAdId = immersiveBrandedAdId,
				screenshotId = ref.current,
				userId = localPlayer.UserId,
				placeId = game.PlaceId
			})
		end

		logReportImmersiveBrandedAdFailureCounter("noScreenshot") -- inferred equivalent call
		return false
	end, { immersiveBrandedAdId, v8 })

	React.useEffect(function()
		if not (RunService:IsStudio() or _G.__TESTEZ_RUNNING_TEST__ or _G.__TEST_SUITE_PACKAGE__) then
			Screenshot.ScreenshotManager:TakeScreenshotWithCallback(function(current)
				ref.current = current
			end, nil)
		end

		task.defer(function()
			setState(true)
		end)
	end, {})

	if not state then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v11 = {
		modal = React.createElement("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, 0),
			Modal = true
		}),
		abuseReportFlow = 0
	}

	local createElement2 = React.createElement
	local v12 = {
		analyticsContext = "Ad",
		onCloseProps = { hasPreviousSteps = false, onAbandon = p.onDismiss },
		onSubmitProps = { hasNextSteps = false, onSubmit = onSubmit },
		onComplete = p.onDismiss,
		reportCategories = reportCategories,
		reportCategoryDefaultKey = reportCategories[1].value,
		isReportCategoryReadonly = true,
		localizationKeys = {
			formTitle = "CoreScripts.Ads.Label.ReportAd",
			completeTitle = "Feature.ReportAbuse.Title.SelectInSceneThankYou",
			completeDescription = "Feature.ReportAbuse.Label.SelectInSceneComplete"
		},
		footerContent = 0
	}

	if not v10 then
		footerContent = nil
	end

	v12.footerContent = footerContent
	v11.abuseReportFlow = createElement2(DefaultTwoStepReportFlow, v12)
	return createElement(fragment, {}, v11)
end

return function(p)
	return React.createElement(RoactServices.RoactServices.ServiceProvider, {
		services = {
			[RoactServiceTags.RoactNetworking] = Http.NetworkLayers.requestInternalWrapper(HttpService)
		}
	}, {
		policyProvider = React.createElement(UniversalAppPolicy.RoactAppPolicy.Provider, {
			policy = { UniversalAppPolicy.AppFeaturePolicies }
		}, {
			appStyleProvider = React.createElement(AppStyleProvider, {
				style = { themeName = ColorMode.Dark, fontName = Constants.FontName.Gotham }
			}, {
				resizeFrame = React.createElement("Frame", {
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromScale(1, 0.6),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				}, {
					reportAdDialog = React.createElement(ImmersiveBrandedAdReportAdDialog, p)
				})
			})
		})
	})
end
