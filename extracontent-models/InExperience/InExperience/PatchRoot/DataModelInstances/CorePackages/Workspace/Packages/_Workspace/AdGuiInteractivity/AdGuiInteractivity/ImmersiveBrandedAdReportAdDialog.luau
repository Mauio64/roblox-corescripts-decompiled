local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local AdGuiInteractivity = script:FindFirstAncestor("AdGuiInteractivity")
local AdGuiInteractivityParent = AdGuiInteractivity.Parent
local React = require(AdGuiInteractivityParent.React)
local UIBlox = require(AdGuiInteractivityParent.UIBlox)
local LinkingProtocol = require(AdGuiInteractivityParent.LinkingProtocol)
local Foundation = require(AdGuiInteractivityParent.Foundation)
local Localization = require(AdGuiInteractivityParent.Localization)
local UniversalAppPolicy = require(AdGuiInteractivityParent.UniversalAppPolicy)
local Http = require(AdGuiInteractivityParent.Http)
local RoactServices = require(AdGuiInteractivityParent.RoactServices)
local RoactServiceTags = require(AdGuiInteractivityParent.RoactServiceTags)
local RobloxAppHooks = require(AdGuiInteractivityParent.RobloxAppHooks)
local Screenshot = require(AdGuiInteractivityParent.Screenshot)
local LoggingProtocol = require(AdGuiInteractivityParent.LoggingProtocol)
local UrlBuilder = require(AdGuiInteractivityParent.UrlBuilder).UrlBuilder
local AdsInteractivityTelemetry = require(AdGuiInteractivity.AdsInteractivityTelemetry)
local useRoactService = RobloxAppHooks.useRoactService
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Constants = UIBlox.App.Style.Constants
local DefaultTwoStepReportFlow = require(AdGuiInteractivityParent.GenericAbuseReporting.DefaultTwoStepReportFlow)
local Button = Foundation.Button
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useLocalization = Localization.Hooks.useLocalization
local default = LinkingProtocol.LinkingProtocol.default
local default2 = LoggingProtocol.default
local Url = Http.Url
local t1 = {{
	localizationKey = "CoreScripts.Ads.Label.InappropriateAd",
	value = "ABUSE_CATEGORY_INAPPROPRIATE_AD"
}}
local v33 = UrlBuilder.new({
	path = "illegal-content-reporting",
	base = Url.BASE_URL
})
local v34 = UrlBuilder.new({
	path = "store/asset/{assetId}",
	base = Url.CREATOR_HUB_URL
})
local v35 = UrlBuilder.new({
	path = "abuse-reporting/v1/abuse-report",
	base = Url.APIS_URL
})
local t2 = {
	eventName = "ReportImmersiveBrandedAdTotalCounter",
	description = "This event is fired when the user initiates submitting an immersive branded ad abuse report (before success or failure is known).",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		26,
		3,
		11
	}
}
local t3 = {
	eventName = "ReportImmersiveBrandedAdSuccessCounter",
	description = "This event is fired when an immersive branded ad abuse report is successfully submitted to the server.",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		26,
		3,
		11
	}
}
local t4 = {
	eventName = "ReportImmersiveBrandedAdFailureCounter",
	description = "This event is fired when submitting an immersive branded ad abuse report fails.",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		26,
		3,
		11
	}
}
local t5 = {
	eventName = "ReportImmersiveBrandedAdHttpFaulreEvent",
	description = "This event is fired when the HTTP request to submit an immersive branded ad abuse report fails.",
	backends = { LoggingProtocol.TelemetryBackends.Points },
	throttlingPercentage = game:DefineFastInt("ReportImmersiveBrandedAdHttpFaulreEventThrottleHundredthsPercent", 0),
	lastUpdated = {
		26,
		11,
		3
	}
}

local function logReportImmersiveBrandedAdTotalCounter() -- line: 92
	-- upvalues: default2 (copy), t2 (copy)
	default2:logRobloxTelemetryCounter(t2)
end
local function logReportImmersiveBrandedAdSuccessCounter() -- line: 96
	-- upvalues: default2 (copy), t3 (copy)
	default2:logRobloxTelemetryCounter(t3)
end
local function logReportImmersiveBrandedAdFailureCounter(s1: string) -- line: 100
	-- upvalues: default2 (copy), t4 (copy)
	default2:logRobloxTelemetryCounter(t4, 1, {
		reason = s1
	})
end
local function logReportImmersiveBrandedAdHttpFailureEvent(p1) -- line: 106
	-- upvalues: default2 (copy), t5 (copy)
	local t6 = {}

	if type(p1) == "string" then
		t6.error = p1:sub(1, 500)
	elseif type(p1) == "table" then
		if p1.Body and type(p1.Body) == "string" then
			t6.body = p1.Body:sub(1, 500)
		end

		if p1.StatusCode and type(p1.StatusCode) == "number" then
			t6.statusCode = tostring(p1.StatusCode)
		end
	end

	default2:logRobloxTelemetryEvent(t5, nil, t6)
end
local function sendImmersiveBrandedAdAbuseReport(p2, t7: {[any]: any}) -- line: 131
	-- upvalues: HttpService (copy), default2 (copy), t4 (copy), v35 (copy), t3 (copy), logReportImmersiveBrandedAdHttpFailureEvent (copy)
	local t8 = {
		abuseVector = "ad_v2",
		targetType = "ad_v2",
		category = t7.reason,
		comment = t7.comment,
		custom = {
			SCREENSHOT_ID = t7.screenshotId,
			PLACE_ID = t7.placeId
		},
		submitterId = t7.userId,
		targetIdStr = `immersiveBrandedAd/{ t7.immersiveBrandedAdId }`
	}
	local ok, result = pcall(function() -- line: 145
		-- upvalues: HttpService (copy), t8 (copy)
		return HttpService:JSONEncode(t8)
	end)

	if not ok then
		default2:logRobloxTelemetryCounter(t4, 1, {
			reason = "jsonEncode"
		})

		return false
	end

	task.spawn(function() -- line: 153
		-- upvalues: v35 (copy), p2 (copy), result (copy), default2 (copy), t3 (copy), t4 (copy), logReportImmersiveBrandedAdHttpFailureEvent (copy)
		local v66 = v35()

		p2(v66, "POST", {
			postBody = result
		}):andThen(function(_) -- line: 155
			-- upvalues: default2 (copy), t3 (copy)
			default2:logRobloxTelemetryCounter(t3)
		end, function(p4) -- line: 157
			-- upvalues: default2 (copy), t4 (copy), logReportImmersiveBrandedAdHttpFailureEvent (copy)
			default2:logRobloxTelemetryCounter(t4, 1, {
				reason = "http"
			})
			logReportImmersiveBrandedAdHttpFailureEvent(p4)
		end)
	end)

	return true
end
local function ImmersiveBrandedAdReportAdDialog(t9: {[any]: any}) -- line: 171
	-- upvalues: useRoactService (copy), RoactServiceTags (copy), React (copy), useLocalization (copy), useAppPolicy (copy), v34 (copy), UrlBuilder (copy), v33 (copy), default (copy), AdsInteractivityTelemetry (copy), View (copy), Button (copy), ButtonVariant (copy), InputSize (copy), RunService (copy), default2 (copy), t2 (copy), t4 (copy), sendImmersiveBrandedAdAbuseReport (copy), Screenshot (copy), DefaultTwoStepReportFlow (copy), t1 (copy)
	local immersiveBrandedAdId = t9.immersiveBrandedAdId
	local v56 = useRoactService(RoactServiceTags.RoactNetworking)
	local v57 = React.useRef(nil)
	local v58, v59 = React.useState(false)
	local v60 = useLocalization({
		LinkText = "CoreScripts.Ads.Label.IllegalContentReportingLink"
	})
	local v61 = useAppPolicy(function(p5) -- line: 181
		return p5.getShowIllegalContentReportingUI()
	end)
	local v62 = React.useCallback(function() -- line: 185
		-- upvalues: v34 (copy), immersiveBrandedAdId (copy), UrlBuilder (copy), v33 (copy), default (copy), AdsInteractivityTelemetry (copy), t9 (copy)
		local v68 = v34({
			assetId = immersiveBrandedAdId
		})
		local v69 = UrlBuilder.addQueryString(v33(), {
			contentURL = v68
		})

		default:openURL(v69):catch(function(_) -- line: 191
			-- upvalues: AdsInteractivityTelemetry (copy), t9 (copy)
			AdsInteractivityTelemetry.logImmersiveBrandedAdLinkingFailedCounter("reportAd.eudsaIllegalContent")
			t9.onDismiss()
		end)
	end, {
		immersiveBrandedAdId,
		t9.onDismiss
	})
	local v63 = React.useCallback(function() -- line: 197
		-- upvalues: React (copy), View (copy), Button (copy), v60 (copy), ButtonVariant (copy), v62 (copy), InputSize (copy)
		return React.createElement(View, {
			tag = "col margin-x-medium padding-top-medium size-full-0 auto-y"
		}, {
			linkButton = React.createElement(Button, {
				icon = "icons/navigation/externallink",
				text = v60.LinkText,
				variant = ButtonVariant.Link,
				onActivated = v62,
				size = InputSize.Small
			})
		})
	end, {
		v62,
		v60.LinkText
	})
	local v64 = React.useCallback(function(p7, p8) -- line: 211
		-- upvalues: RunService (copy), default2 (copy), t2 (copy), t4 (copy), v57 (copy), sendImmersiveBrandedAdAbuseReport (copy), v56 (copy), immersiveBrandedAdId (copy)
		if RunService:IsStudio() or (_G.__TESTEZ_RUNNING_TEST__ or _G.__TEST_SUITE_PACKAGE__) then
			return true
		end

		default2:logRobloxTelemetryCounter(t2)

		local LocalPlayer = game.Players.LocalPlayer

		if not LocalPlayer then
			default2:logRobloxTelemetryCounter(t4, 1, {
				reason = "noPlayer"
			})

			return false
		end

		if not v57.current then
			default2:logRobloxTelemetryCounter(t4, 1, {
				reason = "noScreenshot"
			})

			return false
		end

		return (sendImmersiveBrandedAdAbuseReport(v56, {
			reason = p7,
			comment = p8,
			immersiveBrandedAdId = immersiveBrandedAdId,
			screenshotId = v57.current,
			userId = LocalPlayer.UserId,
			placeId = game.PlaceId
		}))
	end, {
		immersiveBrandedAdId,
		v56
	})

	React.useEffect(function() -- line: 240
		-- upvalues: RunService (copy), Screenshot (copy), v57 (copy), v59 (copy)
		if not RunService:IsStudio() and (not _G.__TESTEZ_RUNNING_TEST__ and not _G.__TEST_SUITE_PACKAGE__) then
			Screenshot.ScreenshotManager:TakeScreenshotWithCallback(function(p9) -- line: 243
				-- upvalues: v57 (copy)
				v57.current = p9
			end, nil)
		end

		task.defer(function() -- line: 249
			-- upvalues: v59 (copy)
			v59(true)
		end)
	end, {})

	if not v58 then
		return nil
	end

	return React.createElement(React.Fragment, {}, {
		modal = React.createElement("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Modal = true,
			Size = UDim2.new(0, 0, 0, 0)
		}),
		abuseReportFlow = React.createElement(DefaultTwoStepReportFlow, {
			analyticsContext = "Ad",
			isReportCategoryReadonly = true,
			onCloseProps = {
				hasPreviousSteps = false,
				onAbandon = t9.onDismiss
			},
			onSubmitProps = {
				hasNextSteps = false,
				onSubmit = v64
			},
			onComplete = t9.onDismiss,
			reportCategories = t1,
			reportCategoryDefaultKey = t1[1].value,
			localizationKeys = {
				formTitle = "CoreScripts.Ads.Label.ReportAd",
				completeTitle = "Feature.ReportAbuse.Title.SelectInSceneThankYou",
				completeDescription = "Feature.ReportAbuse.Label.SelectInSceneComplete"
			},
			footerContent = if not v61 then nil else v63
		})
	})
end

return function(t10: {[any]: any}) -- line: 290
	-- upvalues: React (copy), RoactServices (copy), RoactServiceTags (copy), Http (copy), HttpService (copy), UniversalAppPolicy (copy), AppStyleProvider (copy), Constants (copy), ImmersiveBrandedAdReportAdDialog (copy)
	return React.createElement(RoactServices.RoactServices.ServiceProvider, {
		services = {
			[RoactServiceTags.RoactNetworking] = Http.NetworkLayers.requestInternalWrapper(HttpService)
		}
	}, {
		policyProvider = React.createElement(UniversalAppPolicy.RoactAppPolicy.Provider, {
			policy = { UniversalAppPolicy.AppFeaturePolicies }
		}, {
			appStyleProvider = React.createElement(AppStyleProvider, {
				style = {
					themeName = Constants.ThemeName.Dark,
					fontName = Constants.FontName.Gotham
				}
			}, {
				resizeFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromScale(1, 0.6),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					reportAdDialog = React.createElement(ImmersiveBrandedAdReportAdDialog, t10)
				})
			})
		})
	})
end
