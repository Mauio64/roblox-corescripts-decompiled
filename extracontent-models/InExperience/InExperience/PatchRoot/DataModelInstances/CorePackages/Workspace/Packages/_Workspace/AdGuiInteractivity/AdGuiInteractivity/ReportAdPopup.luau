local parent = script.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local Roact = require(parent2.Roact)
local UIBlox = require(parent2.UIBlox)
local AdsDisplayOrder = require(parent.AdsDisplayOrder)
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(parent2.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local RobloxAppLocales = require(parent2.RobloxAppLocales)
local localization = RobloxAppLocales.Localization
local DefaultTwoStepReportFlow = require(parent2.GenericAbuseReporting.DefaultTwoStepReportFlow)
local Players = game:GetService("Players")
local Screenshot = require(parent2.Screenshot)
local ScreenshotManager = Screenshot.ScreenshotManager
local HttpService = game:GetService("HttpService")
local UniversalAppPolicy = require(parent2.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies
local LoggingProtocol = require(parent2.LoggingProtocol)
local default = LoggingProtocol.default

local ReportAdFooter = require(parent.ReportAdFooter)

local Flags = require(script.Parent.Flags)
local enableHideReportAdModalDuringScreenshot = Flags.GetEnableHideReportAdModalDuringScreenshot()

local AdsInteractivityTelemetry = require(parent.AdsInteractivityTelemetry)

local reportCategories = {
	{
		localizationKey = "CoreScripts.Ads.Label.InappropriateAd",
		value = "ABUSE_CATEGORY_INAPPROPRIATE_AD"
	}
}

function buildReport(p: number, p2: string, p3: string, p4: string, p5: string)
	return HttpService:JSONEncode({
		tags = {
			ENTRY_POINT = {
				valueList = {
					{ data = "in-experience" }
				}
			},
			SUBMITTER_USER_ID = {
				valueList = {
					{ data = tostring(p) }
				}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {
					{ data = p3 }
				}
			},
			PLACE_ID = {
				valueList = {
					{ data = tostring(game.PlaceId) }
				}
			},
			REPORTER_COMMENT = {
				valueList = {
					{ data = p4 }
				}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {
					{ data = "ad" }
				}
			},
			SCREENSHOT_ID = {
				valueList = {
					{ data = p2 }
				}
			},
			IDENTIFIED_ADS = {
				valueList = {
					{ data = p5 }
				}
			}
		}
	})
end

function ReportAdPopup(props)
	local v = ""
	local v2 = { table.clone(props.adInfo) }
	local jsonEncode = HttpService:JSONEncode(v2)

	local v3 = true
	local appFeaturePolicies = getAppFeaturePolicies()

	if appFeaturePolicies == nil then
		default:logRobloxTelemetryEvent({
			eventName = "UniversalAppPolicyCallFailed",
			backends = { LoggingProtocol.TelemetryBackends.Points },
			throttlingPercentage = Flags.GetFIntUniversalAppPolicyFailureTelemetryThrottleHundredthsPercent(),
			lastUpdated = { 24, 8, 22 },
			description = "Call to UniversalAppPolicy (GUAC) failed in Report Ad popup"
		}, nil, {
			assetId = v2[1].assetId,
			encryptedAdTrackingData = v2[1].encryptedAdTrackingData,
			encryptionMetadata = v2[1].encryptionMetadata
		})
	else
		v3 = appFeaturePolicies.getShowIllegalContentReportingUI()

		if v3 == nil then
			v3 = false
		end
	end

	local onSubmit = React.useCallback(function(p, p2): boolean
		if enableHideReportAdModalDuringScreenshot then
			props.onClose()
		end

		ScreenshotManager:TakeScreenshotWithCallback(function(p3)
			local localPlayer = Players.LocalPlayer

			if localPlayer ~= nil then
				v = buildReport(localPlayer.UserId, p3, p, p2, jsonEncode)
				Players:ReportAbuseV3(localPlayer, v)
				AdsInteractivityTelemetry.logReportAdEvent("submit")
			end
		end, nil)

		if enableHideReportAdModalDuringScreenshot and props.onOpen then
			props.onOpen()
		end

		return true
	end, {})

	local element = Roact.createElement(
		LocalizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			Roact.createElement("UIPadding", { PaddingBottom = UDim.new(0, 20) }),
			Roact.createElement(AppStyleProvider, {
				style = { themeName = "Dark", fontName = "Gotham" }
			}, {
				AbuseReportFlow = Roact.createElement(DefaultTwoStepReportFlow, {
					analyticsContext = "Ad",
					onCloseProps = {
						hasPreviousSteps = false,
						onAbandon = function()
							AdsInteractivityTelemetry.logReportAdEvent("close")
							props.onClose()
						end
					},
					onSubmitProps = { hasNextSteps = false, onSubmit = onSubmit },
					onComplete = props.onClose,
					reportCategories = reportCategories,
					reportCategoryDefaultKey = reportCategories[1].value,
					isReportCategoryReadonly = true,
					localizationKeys = {
						formTitle = "CoreScripts.Ads.Label.ReportAd",
						completeTitle = "Feature.ReportAbuse.Title.SelectInSceneThankYou",
						completeDescription = "Feature.ReportAbuse.Label.SelectInSceneComplete"
					},
					scaleDialog = { X = 0.8, Y = 1 },
					footerContent = function()
						if v3 then
							return Roact.createElement(ReportAdFooter, { assetId = v2[1].assetId })
						end

						return nil
					end
				})
			})
		}
	)

	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = AdsDisplayOrder.Modal,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		AutoLocalize = false,
		Enabled = props.showReportAdPopup
	}, Roact.createElement("Frame", {
		Position = UDim2.new(0, 0, 0, 0),
		AnchorPoint = Vector2.new(0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1
	}, { Roact.createElement("Frame", {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0.8, 0, 0.6, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		}, { element }) }))
end

return ReportAdPopup
