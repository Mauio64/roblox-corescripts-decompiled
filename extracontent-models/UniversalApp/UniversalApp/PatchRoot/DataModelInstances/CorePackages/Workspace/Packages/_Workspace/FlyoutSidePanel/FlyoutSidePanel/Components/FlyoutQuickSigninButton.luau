local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v8 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local AppEventIngestService = require(Parent.RoactServiceTags).AppEventIngestService
local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)

local function FlyoutQuickSigninButton(p1) -- line: 26
	-- upvalues: useDispatch (copy), useRoactService (copy), AppEventIngestService (copy), React (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v8 (copy), NavigateDown (copy), FlyoutContentSettings (copy), FlyoutAnalytics (copy), useLocalization (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy)
	local v19 = useDispatch()
	local v20 = useRoactService(AppEventIngestService)
	local v21 = React.useCallback(function() -- line: 30
		-- upvalues: p1 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v8 (copy), v19 (copy), NavigateDown (copy), FlyoutContentSettings (copy), FlyoutAnalytics (copy), v20 (copy)
		p1.closeDrawer()

		local t1 = {
			name = AppPage.CrossDeviceLogin
		}

		if FFlagSignalsNavP3Dispatch then
			v8.down(v8.fromLegacyPage(t1))
		else
			v19(NavigateDown(t1))
		end

		local QuickSignin = FlyoutContentSettings.ItemType.QuickSignin

		FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v20, QuickSignin)
	end, {
		v20,
		p1.closeDrawer
	})
	local v22 = useLocalization({
		title = "Authentication.CrossDevice.Heading.QuickLogin"
	})

	return React.createElement(Button, {
		isDisabled = false,
		text = v22.title,
		variant = ButtonVariant.Standard,
		LayoutOrder = p1.layoutOrder,
		onActivated = v21,
		size = ButtonSize.Large,
		width = UDim.new(1, 0)
	})
end

return FlyoutQuickSigninButton
