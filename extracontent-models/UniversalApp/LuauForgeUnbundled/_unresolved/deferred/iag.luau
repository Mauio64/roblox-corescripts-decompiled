local CorePackages = game:GetService("CorePackages")

local LocalizationService = game:GetService("LocalizationService")
local localizationProvider = require("@game/CorePackages/Workspace/Packages/Localization").LocalizationProvider
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local localization = require("@game/CorePackages/Workspace/Packages/RobloxAppLocales").Localization

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useEffect = React.useEffect
local useMemo = React.useMemo
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useCallback = React.useCallback
local module2 = require("@luauforge/bundled/fCM")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle

local module3 = require("@luauforge/deferred/gKv")
local addEconomicRestrictionKeysToLocalization = module3.Utility.addEconomicRestrictionKeysToLocalization
local formatEconomicRestrictionText = module3.Utility.formatEconomicRestrictionText
local economicRestrictionsCounter = module3.Counters.EconomicRestrictionsCounter

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default

local module4 = require("@luauforge/deferred/hWp")

local function fn(props)
	local v5 = useMemo(function()
		return formatEconomicRestrictionText(
			props.locMap,
			{
				violationType = props.failureReason,
				timeoutMinutes = props.expirationTimeInMinutes
			},
			true
		)
	end, { props.failureReason, props.expirationTimeInMinutes })

	local v6 = useDispatch()
	local v7 = useCallback(function()
		v6(module2())
	end, {})

	return React.createElement(module4, {
		containerWidth = props.containerWidth,
		titleText = props.locMap.titleText,
		titleFont = props.style.Font.Header1.Font,
		messageText = v5,
		messageFont = props.style.Font.Body.Font,
		buttonFont = props.style.Font.Header2.Font,
		confirmButtonText = props.locMap.okButtonText,
		onConfirm = v7,
		hasCancelButton = false
	})
end

return React.memo(function(props)
	local v5 = useMemo(function()
		local v6 = {
			titleText = "IAPExperience.PurchaseError.Text.EconomicRestrictionPromptTitle"
		}

		addEconomicRestrictionKeysToLocalization(v6)
		return v6
	end, { props.failureReason, props.expirationTimeInMinutes })

	useEffect(function()
		default:logRobloxTelemetryCounter(
			economicRestrictionsCounter.EconomicRestrictionsPromptCounter,
			1,
			{ failureReason = props.failureReason }
		)
	end, { props.failureReason, props.expirationTimeInMinutes })

	return React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			Alert = withLocalization(v5)(function(p2)
				return withStyle(function(p3)
					return React.createElement(fn, {
						style = p3,
						locMap = p2,
						failureReason = props.failureReason,
						expirationTimeInMinutes = props.expirationTimeInMinutes,
						containerWidth = props.containerWidth,
						defaultChildRef = props.defaultChildRef,
						focusController = props.focusController
					})
				end)
			end)
		}
	)
end)
