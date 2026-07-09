local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local LocalizationService = game:GetService("LocalizationService")
local React = require(SocialUpsellParent.React)
local Rodux = require(SocialUpsellParent.Rodux)
local Foundation = require(SocialUpsellParent.Foundation)
local InputHandlers = require(SocialUpsellParent.InputHandlers)
local SignalsReact = require(SocialUpsellParent.SignalsReact)
local ReactRoblox = require(SocialUpsellParent.ReactRoblox)
local RoactRodux = require(SocialUpsellParent.RoactRodux)
local createLazyComponent = require(SocialUpsellParent.RoactUtils).Components.createLazyComponent
local Localization = require(SocialUpsellParent.InExperienceLocales).Localization
local LocalizationProvider = require(SocialUpsellParent.Localization).LocalizationProvider
local v14 = Localization.new(LocalizationService.RobloxLocaleId)
local getOverlayStore = require(SocialUpsell.Store.getOverlayStore)
local ReactFocusNavigation = require(SocialUpsellParent.ReactFocusNavigation)
local FocusNavigationUtils = require(SocialUpsellParent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FoundationProvider = Foundation.FoundationProvider
local useOverlay = Foundation.Hooks.useOverlay
local OVERLAY_TYPES = require(SocialUpsell.Constants).OVERLAY_TYPES

require(SocialUpsell.Types)

local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

function OverlayContent(_: {[any]: any}) -- line: 52
	-- upvalues: useOverlay (copy), SignalsReact (copy), getOverlayStore (copy), React (copy), OVERLAY_TYPES (copy), createLazyComponent (copy), SocialUpsell (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), ReactRoblox (copy), FocusRoot (copy), t1 (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v27 = useOverlay()
	local v28 = SignalsReact.useSignalState(getOverlayStore(false).getCurrentOverlay)
	local v29 = React.useMemo(function() -- line: 57
		-- upvalues: OVERLAY_TYPES (copy), createLazyComponent (copy), SocialUpsell (copy)
		return {
			[OVERLAY_TYPES.SocialUpsell] = {
				Component = createLazyComponent(function() -- line: 60
					-- upvalues: SocialUpsell (copy)
					return require(SocialUpsell.Components.InAppSocialUpsellOverlayWrapper)
				end)
			}
		}
	end, {})
	local v30 = React.useMemo(function() -- line: 67
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), getOverlayStore (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p1) -- line: 70
					-- upvalues: getOverlayStore (copy)
					getOverlayStore(false).dismissCurrentOverlay()
					p1:cancel()
				end)
			}
		}
	end, {})

	if v27 and (v28 and v28.overlayType and v29[v28.overlayType]) then
		return ReactRoblox.createPortal(React.createElement(FocusRoot, {
			isAutoFocusRoot = true,
			isIsolated = true,
			shouldRestoreFocus = true,
			eventHandlers = v30,
			eventMap = t1,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
		}, {
			Content = React.createElement(v29[v28.overlayType].Component, v28.overlayProps or {})
		}), v27)
	end

	return nil
end

return function(_: {[any]: any}) -- line: 99
	-- upvalues: React (copy), ReactFocusNavigation (copy), RoactRodux (copy), Rodux (copy), LocalizationProvider (copy), v14 (copy), FoundationProvider (copy), Provider (copy)
	local v32 = React.useMemo(function() -- line: 108
		-- upvalues: ReactFocusNavigation (copy)
		return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	end, {})

	React.useEffect(function() -- line: 112
		-- upvalues: v32 (copy)
		return function() -- line: 113
			-- upvalues: v32 (copy)
			if v32 then
				v32:teardown()
			end
		end
	end, { v32 })

	return React.createElement(RoactRodux.StoreProvider, {
		store = Rodux.Store.new(Rodux.createReducer({}, {}), nil, { Rodux.thunkMiddleware })
	}, {
		LocalizationProvider = React.createElement(LocalizationProvider, {
			localization = v14
		}, {
			FoundationProvider = React.createElement(FoundationProvider, nil, {
				FocusProvider = React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
					value = v32
				}, {
					FocusNavigationRegistryProvider = React.createElement(Provider, nil, {
						Content = React.createElement(OverlayContent)
					})
				})
			})
		})
	})
end
