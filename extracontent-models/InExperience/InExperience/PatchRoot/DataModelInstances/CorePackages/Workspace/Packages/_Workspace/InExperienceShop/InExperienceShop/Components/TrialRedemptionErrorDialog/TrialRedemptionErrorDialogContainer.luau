local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local ShopErrorDialog = require(InExperienceShop.Components.ShopErrorDialog)
local useTrialRedemptionErrorDialogViewModel = require(script.Parent.useTrialRedemptionErrorDialogViewModel)

local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider

local function FocusNavigableShopErrorDialog(p)
	local v = React.useMemo(function()
		return ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
	end, {})

	React.useEffect(function()
		return function()
			v:teardown()
		end
	end, { v })

	return React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, { value = v }, {
		Registry = React.createElement(Provider, nil, {
			Dialog = React.createElement(ShopErrorDialog, p)
		})
	})
end

local function TrialRedemptionErrorDialogContainer()
	local v = useTrialRedemptionErrorDialogViewModel()

	if v == nil then
		return nil
	end

	return React.createElement(FocusNavigableShopErrorDialog, v)
end

return TrialRedemptionErrorDialogContainer
