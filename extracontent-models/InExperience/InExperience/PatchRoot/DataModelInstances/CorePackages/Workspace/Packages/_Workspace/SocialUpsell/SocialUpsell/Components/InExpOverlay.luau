local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local parent = SocialUpsell.Parent

local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)
local Rodux = require(parent.Rodux)
local Foundation = require(parent.Foundation)
local InputHandlers = require(parent.InputHandlers)
local SignalsReact = require(parent.SignalsReact)
local ReactRoblox = require(parent.ReactRoblox)
local RoactRodux = require(parent.RoactRodux)
local RoactUtils = require(parent.RoactUtils)
local createLazyComponent = RoactUtils.Components.createLazyComponent
local InExperienceLocales = require(parent.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local localization = Localization.new(LocalizationService.RobloxLocaleId)
local getOverlayStore = require(SocialUpsell.Store.getOverlayStore)

local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider

local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local FoundationProvider = Foundation.FoundationProvider
local useOverlay = Foundation.Hooks.useOverlay

local Constants = require(SocialUpsell.Constants)
local OVERLAY_TYPES = Constants.OVERLAY_TYPES

require(SocialUpsell.Types)

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

function OverlayContent(_)
	local v = useOverlay()

	local v2 = SignalsReact.useSignalState(getOverlayStore(false).getCurrentOverlay)

	local v3 = React.useMemo(function()
		return {
			[OVERLAY_TYPES.SocialUpsell] = {
				Component = createLazyComponent(function()
					return require(SocialUpsell.Components.InAppSocialUpsellOverlayWrapper)
				end)
			}
		}
	end, {})

	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					getOverlayStore(false).dismissCurrentOverlay()
					object:cancel()
				end)
			}
		}
	end, {})

	if v and v2 and v2.overlayType and v3[v2.overlayType] then
		return ReactRoblox.createPortal(React.createElement(FocusRoot, {
			eventHandlers = eventHandlers,
			eventMap = navigateBacks,
			isAutoFocusRoot = true,
			isIsolated = true,
			shouldRestoreFocus = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
		}, {
			Content = React.createElement(v3[v2.overlayType].Component, v2.overlayProps or {})
		}), v)
	end

	return nil
end

return function(_)
	local v = React.useMemo(function()
		return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	end, {})

	React.useEffect(function()
		return function()
			if v then
				v:teardown()
			end
		end
	end, { v })

	return React.createElement(RoactRodux.StoreProvider, {
		store = Rodux.Store.new(Rodux.createReducer({}, {}), nil, { Rodux.thunkMiddleware })
	}, {
		LocalizationProvider = React.createElement(LocalizationProvider, {
			localization = localization
		}, {
			FoundationProvider = React.createElement(FoundationProvider, nil, {
				FocusProvider = React.createElement(
					ReactFocusNavigation.FocusNavigationContext.Provider,
					{ value = v },
					{
						FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
							Content = React.createElement(OverlayContent)
						})
					}
				)
			})
		})
	})
end
