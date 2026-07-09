local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local Localization = require(CorePackages.Workspace.Packages.RobloxAppLocales).Localization
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useEffect = React.useEffect
local useMemo = React.useMemo
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useCallback = React.useCallback
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local IAPExperience = require(CorePackages.Workspace.Packages.IAPExperience)
local addEconomicRestrictionKeysToLocalization = IAPExperience.Utility.addEconomicRestrictionKeysToLocalization
local formatEconomicRestrictionText = IAPExperience.Utility.formatEconomicRestrictionText
local EconomicRestrictionsCounter = IAPExperience.Counters.EconomicRestrictionsCounter
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local AlertWindow = require(Modules.LuaApp.Components.AlertWindow)

local function v21(t1: {[any]: any}) -- line: 51
	-- upvalues: useMemo (copy), formatEconomicRestrictionText (copy), useDispatch (copy), useCallback (copy), CloseCentralOverlay (copy), React (copy), AlertWindow (copy)
	local v23 = useMemo(function() -- line: 52
		-- upvalues: formatEconomicRestrictionText (copy), t1 (copy)
		return formatEconomicRestrictionText(t1.locMap, {
			violationType = t1.failureReason,
			timeoutMinutes = t1.expirationTimeInMinutes
		}, true)
	end, {
		t1.failureReason,
		t1.expirationTimeInMinutes
	})
	local v24 = useDispatch()
	local v25 = useCallback(function() -- line: 60
		-- upvalues: v24 (copy), CloseCentralOverlay (copy)
		v24(CloseCentralOverlay())
	end, {})

	return React.createElement(AlertWindow, {
		hasCancelButton = false,
		containerWidth = t1.containerWidth,
		titleText = t1.locMap.titleText,
		titleFont = t1.style.Font.Header1.Font,
		messageText = v23,
		messageFont = t1.style.Font.Body.Font,
		buttonFont = t1.style.Font.Header2.Font,
		confirmButtonText = t1.locMap.okButtonText,
		onConfirm = v25
	})
end

return React.memo(function(t2: {[any]: any}) -- line: 78
	-- upvalues: useMemo (copy), addEconomicRestrictionKeysToLocalization (copy), useEffect (copy), default (copy), EconomicRestrictionsCounter (copy), React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), withLocalization (copy), withStyle (copy), v21 (copy)
	local v27 = useMemo(function() -- line: 79
		-- upvalues: addEconomicRestrictionKeysToLocalization (copy)
		local t3 = {
			titleText = "IAPExperience.PurchaseError.Text.EconomicRestrictionPromptTitle"
		}

		addEconomicRestrictionKeysToLocalization(t3)

		return t3
	end, {
		t2.failureReason,
		t2.expirationTimeInMinutes
	})

	useEffect(function() -- line: 87
		-- upvalues: default (copy), EconomicRestrictionsCounter (copy), t2 (copy)
		default:logRobloxTelemetryCounter(EconomicRestrictionsCounter.EconomicRestrictionsPromptCounter, 1, {
			failureReason = t2.failureReason
		})
	end, {
		t2.failureReason,
		t2.expirationTimeInMinutes
	})

	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		Alert = withLocalization(v27)(function(p1) -- line: 96
			-- upvalues: withStyle (copy), React (copy), v21 (copy), t2 (copy)
			return withStyle(function(p2) -- line: 97
				-- upvalues: React (copy), v21 (copy), p1 (copy), t2 (copy)
				return React.createElement(v21, {
					style = p2,
					locMap = p1,
					failureReason = t2.failureReason,
					expirationTimeInMinutes = t2.expirationTimeInMinutes,
					containerWidth = t2.containerWidth,
					defaultChildRef = t2.defaultChildRef,
					focusController = t2.focusController
				})
			end)
		end)
	})
end)
