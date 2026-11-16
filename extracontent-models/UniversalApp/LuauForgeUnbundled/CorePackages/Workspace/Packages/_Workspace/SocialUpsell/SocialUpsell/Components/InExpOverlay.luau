local LocalizationService = game:GetService("LocalizationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/React")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Rodux")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Foundation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/InputHandlers")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SignalsReact")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/ReactRoblox")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/RoactRodux")
local createLazyComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/RoactUtils").Components.createLazyComponent
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/InExperienceLocales").Localization
local localizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Localization").LocalizationProvider
local v5 = localization.new(LocalizationService.RobloxLocaleId)
local getOverlayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Store/getOverlayStore")

local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/ReactFocusNavigation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/FocusNavigationUtils")
local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider

local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local foundationProvider = Foundation.FoundationProvider
local useOverlay = Foundation.Hooks.useOverlay

local OVERLAY_TYPES = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Constants").OVERLAY_TYPES

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Types")

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

function LUAUFORGE_MODULE_GLOBALS_cQs_OverlayContent(p2)
	local v6 = useOverlay()

	local v7 = SignalsReact.useSignalState(getOverlayStore(false).getCurrentOverlay)

	local v8 = React.useMemo(function()
		return {
			[OVERLAY_TYPES.SocialUpsell] = {
				Component = createLazyComponent(function()
					return require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Components/InAppSocialUpsellOverlayWrapper")
				end)
			}
		}
	end, {})

	local v9 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					getOverlayStore(false).dismissCurrentOverlay()
					object:cancel()
				end)
			}
		}
	end, {})

	if v6 and v7 and v7.overlayType and v8[v7.overlayType] then
		return ReactRoblox.createPortal(React.createElement(focusRoot, {
			eventHandlers = v9,
			eventMap = navigateBacks,
			isAutoFocusRoot = true,
			isIsolated = true,
			shouldRestoreFocus = true,
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay
		}, {
			Content = React.createElement(v8[v7.overlayType].Component, v7.overlayProps or {})
		}), v6)
	end

	return nil
end

return function(p2)
	local v6 = React.useMemo(function()
		return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	end, {})

	React.useEffect(function()
		return function()
			if v6 then
				v6:teardown()
			end
		end
	end, { v6 })

	return React.createElement(RoactRodux.StoreProvider, {
		store = Rodux.Store.new(Rodux.createReducer({}, {}), nil, { Rodux.thunkMiddleware })
	}, {
		LocalizationProvider = React.createElement(localizationProvider, {
			localization = v5
		}, {
			FoundationProvider = React.createElement(foundationProvider, nil, {
				FocusProvider = React.createElement(
					ReactFocusNavigation.FocusNavigationContext.Provider,
					{ value = v6 },
					{
						FocusNavigationRegistryProvider = React.createElement(provider, nil, {
							Content = React.createElement(LUAUFORGE_MODULE_GLOBALS_cQs_OverlayContent)
						})
					}
				)
			})
		})
	})
end
