local TelemetryService = game:GetService("TelemetryService")

local appPage = require("@luauforge/deferred/gIS").AppPage
local experienceService = require("@luauforge/deferred/gIT").ExperienceService
local module = require("@luauforge/deferred/gIU")
local module2 = require("@luauforge/deferred/gIV")
local useDispatch = require("@luauforge/deferred/gIW").Hooks.RoactRodux.useDispatch
local useLocalization = require("@luauforge/deferred/gIX").Hooks.useLocalization

local module3 = require("@luauforge/deferred/gIY")
local view = module3.View
local button = module3.Button
local image = module3.Image
local text = module3.Text
local buttonVariant = module3.Enums.ButtonVariant
local inputSize = module3.Enums.InputSize
local useTokens = module3.Hooks.useTokens

local module4 = require("@luauforge/deferred/gIZ")
local module5 = require("@luauforge/deferred/gJa")
local setDarkThemeOverride = module5.Utils.SetDarkThemeOverride
local clearThemeOverride = module5.Utils.ClearThemeOverride

local defineFastInt = game:DefineFastInt("TutorialUpsellEventThrottleHundredthsPercent", 0)

local defineFastString = game:DefineFastString(
	"TutorialUpsellPlaceId",
	(tostring(module4.TUTORIAL_EXPERIENCE_DEFAULT_PLACE_ID))
)

local defineFastString2 = game:DefineFastString(
	"TutorialUpsellImageAssetId",
	(tostring(module4.TUTORIAL_EXPERIENCE_DEFAULT_IMAGE_ASSET_ID))
)

return function(p2)
	local v5 = useDispatch()
	local v6 = useTokens()
	local state, setState = module2.useState(false)
	local large = inputSize.Large

	local v7 = string.format(module4.IMAGE_ASSET_URL_TEMPLATE, defineFastString2)

	local v8 = useLocalization({
		titleLabel = "MobilePlatform.TutorialUpsell.Label.StartWithATutorial",
		descriptionLabel = "MobilePlatform.TutorialUpsell.Label.TutorialDescription",
		beginTutorialAction = "MobilePlatform.TutorialUpsell.Action.BeginTutorial",
		skipAction = "MobilePlatform.TutorialUpsell.Action.Skip"
	})

	local function fn(p3)
		return {
			eventName = p3,
			backends = { module.TelemetryBackends.EventIngest },
			throttlingPercentage = defineFastInt,
			lastUpdated = { 2025, 8, 20 },
			description = "Tutorial upsell screen event",
			links = "https://roblox.atlassian.net/browse/MOBAPP-1201"
		}
	end

	local function fn2(p3)
		TelemetryService:LogEvent(fn(module4.EVENT_BUTTON_CLICK_EVENT), {
			customFields = { buttonName = p3 }
		})
	end

	module2.useEffect(function()
		TelemetryService:LogEvent(fn(module4.EVENT_SCREEN_IMPRESSION_EVENT), {})
	end, {})

	module2.useEffect(function()
		if not state then
			setDarkThemeOverride()
		end
	end, { v6 })

	local function onActivated()
		fn2(module4.EVENT_BUTTON_CLICK_EVENT_BTN.SKIP)
		v5(p2.resetNavigationHistory({
			{ name = appPage.Home }
		}))
		setState(true)
		clearThemeOverride()
	end

	local function onActivated2()
		fn2(module4.EVENT_BUTTON_CLICK_EVENT_BTN.START)
		experienceService:LaunchExperience(
			{ placeId = tonumber(defineFastString) },
			"TutorialUpsell",
			function()
				v5(p2.resetNavigationHistory({
					{ name = appPage.Home }
				}))
			end
		)
		setState(true)
		clearThemeOverride()
	end

	return module2.createElement(
		view,
		{
			tag = "size-full-full padding-xlarge",
			backgroundStyle = v6.DarkMode.Surface.Surface_0
		},
		{
			Contents = module2.createElement(
				view,
				{
					tag = "col gap-large auto-xy size-full-full padding-y-xlarge",
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 1
				},
				{
					SplashImage = module2.createElement(image, {
						tag = "size-full-0 auto-xy fill radius-large",
						Image = v7,
						ScaleType = Enum.ScaleType.Crop,
						LayoutOrder = 1
					}),
					TextContainer = module2.createElement(
						view,
						{
							tag = "col gap-small auto-y size-full-0 align-x-center",
							LayoutOrder = 2
						},
						{
							Title = module2.createElement(text, {
								tag = "text-heading-large text-wrap text-align-x-left size-full-0 auto-y",
								Text = v8.titleLabel
							}),
							Body = module2.createElement(text, {
								tag = "text-body-large text-wrap text-align-x-left size-full-0 auto-y",
								Text = v8.descriptionLabel
							})
						}
					),
					ButtonContainer = module2.createElement(
						view,
						{
							tag = "col gap-small auto-y size-full-0 align-x-center position-bottom-center",
							LayoutOrder = 3
						},
						{
							TutorialButton = module2.createElement(button, {
								text = v8.beginTutorialAction,
								variant = buttonVariant.Emphasis,
								onActivated = onActivated2,
								size = large,
								width = UDim.new(1, 0)
							}),
							SkipButton = module2.createElement(button, {
								text = v8.skipAction,
								variant = buttonVariant.Standard,
								onActivated = onActivated,
								size = large,
								width = UDim.new(1, 0)
							})
						}
					)
				}
			)
		}
	)
end
