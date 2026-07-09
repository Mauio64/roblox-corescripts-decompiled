local TutorialUpsell = script:FindFirstAncestor("TutorialUpsell")
local TutorialUpsellParent = TutorialUpsell.Parent
local TelemetryService = game:GetService("TelemetryService")
local AppPage = require(TutorialUpsellParent.RobloxAppEnums).AppPage
local ExperienceService = require(TutorialUpsellParent.ExperienceService).ExperienceService
local LoggingProtocol = require(TutorialUpsellParent.LoggingProtocol)
local React = require(TutorialUpsellParent.React)
local useDispatch = require(TutorialUpsellParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(TutorialUpsellParent.Localization).Hooks.useLocalization
local Foundation = require(TutorialUpsellParent.Foundation)
local View = Foundation.View
local Button = Foundation.Button
local FoundationImage = Foundation.Image
local FoundationText = Foundation.Text
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local Constants = require(TutorialUpsell.Constants)
local SystemTheme = require(TutorialUpsellParent.SystemTheme)
local SetDarkThemeOverride = SystemTheme.Utils.SetDarkThemeOverride
local ClearThemeOverride = SystemTheme.Utils.ClearThemeOverride
local v22 = game:DefineFastInt("TutorialUpsellEventThrottleHundredthsPercent", 0)
local v23 = game:DefineFastString("TutorialUpsellPlaceId", (tostring(Constants.TUTORIAL_EXPERIENCE_DEFAULT_PLACE_ID)))
local v24 = game:DefineFastString("TutorialUpsellImageAssetId", (tostring(Constants.TUTORIAL_EXPERIENCE_DEFAULT_IMAGE_ASSET_ID)))

return function(t1: {[any]: any}) -- line: 45
	-- upvalues: useDispatch (copy), useTokens (copy), React (copy), InputSize (copy), Constants (copy), v24 (copy), useLocalization (copy), LoggingProtocol (copy), v22 (copy), TelemetryService (copy), SetDarkThemeOverride (copy), ClearThemeOverride (copy), AppPage (copy), ExperienceService (copy), v23 (copy), View (copy), FoundationImage (copy), FoundationText (copy), Button (copy), ButtonVariant (copy)
	local v26 = useDispatch()
	local v27 = useTokens()
	local v28, v29 = React.useState(false)
	local Large = InputSize.Large
	local v31 = string.format(Constants.IMAGE_ASSET_URL_TEMPLATE, v24)
	local v32 = useLocalization({
		titleLabel = "MobilePlatform.TutorialUpsell.Label.StartWithATutorial",
		descriptionLabel = "MobilePlatform.TutorialUpsell.Label.TutorialDescription",
		beginTutorialAction = "MobilePlatform.TutorialUpsell.Action.BeginTutorial",
		skipAction = "MobilePlatform.TutorialUpsell.Action.Skip"
	})

	local function v33(s1: string) -- line: 62
		-- upvalues: LoggingProtocol (copy), v22 (copy)
		return {
			description = "Tutorial upsell screen event",
			links = "https://roblox.atlassian.net/browse/MOBAPP-1201",
			eventName = s1,
			backends = { LoggingProtocol.TelemetryBackends.EventIngest },
			throttlingPercentage = v22,
			lastUpdated = {
				2025,
				8,
				20
			}
		}
	end
	local function v34(s2: string) -- line: 75
		-- upvalues: TelemetryService (copy), v33 (copy), Constants (copy)
		TelemetryService:LogEvent(v33(Constants.EVENT_BUTTON_CLICK_EVENT), {
			customFields = {
				buttonName = s2
			}
		})
	end

	React.useEffect(function() -- line: 83
		-- upvalues: TelemetryService (copy), v33 (copy), Constants (copy)
		TelemetryService:LogEvent(v33(Constants.EVENT_SCREEN_IMPRESSION_EVENT), {})
	end, {})
	React.useEffect(function() -- line: 97
		-- upvalues: v28 (copy), SetDarkThemeOverride (copy)
		if not v28 then
			SetDarkThemeOverride()
		end
	end, { v27 })

	return React.createElement(View, {
		tag = "size-full-full padding-xlarge",
		backgroundStyle = v27.DarkMode.Surface.Surface_0
	}, {
		Contents = React.createElement(View, {
			tag = "col gap-large auto-xy size-full-full padding-y-xlarge",
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			SplashImage = React.createElement(FoundationImage, {
				tag = "size-full-0 auto-xy fill radius-large",
				LayoutOrder = 1,
				Image = v31,
				ScaleType = Enum.ScaleType.Crop
			}),
			TextContainer = React.createElement(View, {
				tag = "col gap-small auto-y size-full-0 align-x-center",
				LayoutOrder = 2
			}, {
				Title = React.createElement(FoundationText, {
					tag = "text-heading-large text-wrap text-align-x-left size-full-0 auto-y",
					Text = v32.titleLabel
				}),
				Body = React.createElement(FoundationText, {
					tag = "text-body-large text-wrap text-align-x-left size-full-0 auto-y",
					Text = v32.descriptionLabel
				})
			}),
			ButtonContainer = React.createElement(View, {
				tag = "col gap-small auto-y size-full-0 align-x-center position-bottom-center",
				LayoutOrder = 3
			}, {
				TutorialButton = React.createElement(Button, {
					text = v32.beginTutorialAction,
					variant = ButtonVariant.Emphasis,
					onActivated = function() -- line: 115
						-- upvalues: v34 (copy), Constants (copy), ExperienceService (copy), v23 (copy), v26 (copy), t1 (copy), AppPage (copy), v29 (copy), ClearThemeOverride (copy)
						v34(Constants.EVENT_BUTTON_CLICK_EVENT_BTN.START)
						ExperienceService:LaunchExperience({
							placeId = tonumber(v23)
						}, "TutorialUpsell", function() -- line: 122
							-- upvalues: v26 (copy), t1 (copy), AppPage (copy)
							v26(t1.resetNavigationHistory({{
								name = AppPage.Home
							}}))
						end)
						v29(true)
						ClearThemeOverride()
					end,
					size = Large,
					width = UDim.new(1, 0)
				}),
				SkipButton = React.createElement(Button, {
					text = v32.skipAction,
					variant = ButtonVariant.Standard,
					onActivated = function() -- line: 109
						-- upvalues: v34 (copy), Constants (copy), v26 (copy), t1 (copy), AppPage (copy), v29 (copy), ClearThemeOverride (copy)
						v34(Constants.EVENT_BUTTON_CLICK_EVENT_BTN.SKIP)
						v26(t1.resetNavigationHistory({{
							name = AppPage.Home
						}}))
						v29(true)
						ClearThemeOverride()
					end,
					size = Large,
					width = UDim.new(1, 0)
				})
			})
		})
	})
end
