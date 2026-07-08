local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local React = require(scriptParentParent.React)
local Roact = require(scriptParentParent.Roact)
local UIBlox = require(scriptParentParent.UIBlox)
local AdsDisplayOrder = require(scriptParent.AdsDisplayOrder)
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local LocalizationService = game:GetService("LocalizationService")
local LocalizationProvider = require(scriptParentParent.Localization).LocalizationProvider
local Localization = require(scriptParentParent.RobloxAppLocales).Localization
local DefaultTwoStepReportFlow = require(scriptParentParent.GenericAbuseReporting.DefaultTwoStepReportFlow)
local Players = game:GetService("Players")
local ScreenshotManager = require(scriptParentParent.Screenshot).ScreenshotManager
local HttpService = game:GetService("HttpService")
local getAppFeaturePolicies = require(scriptParentParent.UniversalAppPolicy).getAppFeaturePolicies
local LoggingProtocol = require(scriptParentParent.LoggingProtocol)
local default = LoggingProtocol.default
local ReportAdFooter = require(scriptParent.ReportAdFooter)
local Flags = require(script.Parent.Flags)
local v20 = Flags.GetEnableHideReportAdModalDuringScreenshot()
local AdsInteractivityTelemetry = require(scriptParent.AdsInteractivityTelemetry)
local t1 = {{
	localizationKey = "CoreScripts.Ads.Label.InappropriateAd",
	value = "ABUSE_CATEGORY_INAPPROPRIATE_AD"
}}

function buildReport(n1: number, s1: string, s2: string, s3: string, s4: string) -- line: 54
	-- upvalues: HttpService (copy)
	local t2 = {
		tags = {
			ENTRY_POINT = {
				valueList = {{
					data = "in-experience"
				}}
			},
			SUBMITTER_USER_ID = {
				valueList = {{
					data = tostring(n1)
				}}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {{
					data = s2
				}}
			},
			PLACE_ID = {
				valueList = {{
					data = tostring(game.PlaceId)
				}}
			},
			REPORTER_COMMENT = {
				valueList = {{
					data = s3
				}}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {{
					data = "ad"
				}}
			},
			SCREENSHOT_ID = {
				valueList = {{
					data = s1
				}}
			},
			IDENTIFIED_ADS = {
				valueList = {{
					data = s4
				}}
			}
		}
	}

	return HttpService:JSONEncode(t2)
end
function ReportAdPopup(t3: {[any]: any}) -- line: 109
	-- upvalues: HttpService (copy), getAppFeaturePolicies (copy), default (copy), LoggingProtocol (copy), Flags (copy), React (copy), v20 (copy), ScreenshotManager (copy), Players (copy), AdsInteractivityTelemetry (copy), Roact (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), AppStyleProvider (copy), DefaultTwoStepReportFlow (copy), t1 (copy), ReportAdFooter (copy), AdsDisplayOrder (copy)
	local s5 = ""
	local t4 = { table.clone(t3.adInfo) }
	local json = HttpService:JSONEncode(t4)
	local u33 = true
	local v34 = getAppFeaturePolicies()

	if v34 ~= nil then
		local v35 = v34.getShowIllegalContentReportingUI()

		u33 = v35 ~= nil and v35
	else
		default:logRobloxTelemetryEvent({
			eventName = "UniversalAppPolicyCallFailed",
			description = "Call to UniversalAppPolicy (GUAC) failed in Report Ad popup",
			backends = { LoggingProtocol.TelemetryBackends.Points },
			throttlingPercentage = Flags.GetFIntUniversalAppPolicyFailureTelemetryThrottleHundredthsPercent(),
			lastUpdated = {
				24,
				8,
				22
			}
		}, nil, {
			assetId = t4[1].assetId,
			encryptedAdTrackingData = t4[1].encryptedAdTrackingData,
			encryptionMetadata = t4[1].encryptionMetadata
		})
	end

	local v36 = React.useCallback(function(p1, p2) -- line: 139
		-- upvalues: v20 (copy), t3 (copy), ScreenshotManager (copy), Players (copy), s5 (ref), json (copy), AdsInteractivityTelemetry (copy)
		if v20 then
			t3.onClose()
		end

		ScreenshotManager:TakeScreenshotWithCallback(function(p3) -- line: 143
			-- upvalues: Players (copy), s5 (ref), p1 (copy), p2 (copy), json (copy), AdsInteractivityTelemetry (copy)
			local LocalPlayer = Players.LocalPlayer

			if LocalPlayer ~= nil then
				s5 = buildReport(LocalPlayer.UserId, p3, p1, p2, json)
				Players:ReportAbuseV3(LocalPlayer, s5)
				AdsInteractivityTelemetry.logReportAdEvent("submit")
			end
		end, nil)

		if v20 and t3.onOpen then
			t3.onOpen()
		end

		return true
	end, {})
	local v37 = Roact.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 20)
		}),
		Roact.createElement(AppStyleProvider, {
			style = {
				themeName = "Dark",
				fontName = "Gotham"
			}
		}, {
			AbuseReportFlow = Roact.createElement(DefaultTwoStepReportFlow, {
				analyticsContext = "Ad",
				isReportCategoryReadonly = true,
				onCloseProps = {
					hasPreviousSteps = false,
					onAbandon = function() -- line: 175
						-- upvalues: AdsInteractivityTelemetry (copy), t3 (copy)
						AdsInteractivityTelemetry.logReportAdEvent("close")
						t3.onClose()
					end
				},
				onSubmitProps = {
					hasNextSteps = false,
					onSubmit = v36
				},
				onComplete = t3.onClose,
				reportCategories = t1,
				reportCategoryDefaultKey = t1[1].value,
				localizationKeys = {
					formTitle = "CoreScripts.Ads.Label.ReportAd",
					completeTitle = "Feature.ReportAbuse.Title.SelectInSceneThankYou",
					completeDescription = "Feature.ReportAbuse.Label.SelectInSceneComplete"
				},
				scaleDialog = {
					X = 0.8,
					Y = 1
				},
				footerContent = function() -- line: 198
					-- upvalues: u33 (ref), Roact (copy), ReportAdFooter (copy), t4 (copy)
					if u33 then
						return Roact.createElement(ReportAdFooter, {
							assetId = t4[1].assetId
						})
					end

					return nil
				end
			})
		})
	})

	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		AutoLocalize = false,
		DisplayOrder = AdsDisplayOrder.Modal,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Enabled = t3.showReportAdPopup
	}, Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 0),
		AnchorPoint = Vector2.new(0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.XY
	}, { Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0.8, 0, 0.6, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, { v37 }) }))
end

return ReportAdPopup
