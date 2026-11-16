local parent = script:FindFirstAncestor("GameDetail").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens

local Responsive = require(parent.Responsive)
local useDeviceInsets = Responsive.useDeviceInsets
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local Selectors = NavigationRodux.Selectors
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local PeekView = require(parent.PeekView)
local PeekViewState = PeekView.PeekViewState

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local SharedFlags = require(parent.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local FFlagFixOverlayTopInsetForDeviceSafeInsets = SharedFlags.FFlagFixOverlayTopInsetForDeviceSafeInsets
local Display = require(parent.Display)
local shouldUseDeviceSafeInsets = Display.shouldUseDeviceSafeInsets
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Signals = require(parent.Signals)
local createComputed = Signals.createComputed
local NavigationRodux2 = require(parent.NavigationRodux)
local GetLegacyNavigationStore = NavigationRodux2.GetLegacyNavigationStore

local ExperienceDetailsPageUtils = require(script.Parent.ExperienceDetailsPageUtils)

local function PeekViewTopBar(p)
	local pageProps = p.pageProps
	local onClose = p.onClose

	local v = useDispatch()
	local v2 = useDeviceInsets()
	local v3 = useTokens()
	local v4

	if FFlagSignalsNavP3fGameDetails then
		v4 = useSignalState((React.useMemo(function()
			local legacyNavigationStore = GetLegacyNavigationStore(false)
			return createComputed(function(p2): boolean
				local currentLegacyRoute = legacyNavigationStore.getCurrentLegacyRoute(p2)
				local count = 0

				if not currentLegacyRoute then
					return false
				end

				for i = 1, #currentLegacyRoute do
					if currentLegacyRoute[i].name ~= AppPage.GameDetail then
						continue
					end

					count += 1

					if count > 1 then
						return true
					end
				end

				return false
			end)
		end, {})))
	else
		v4 = useSelector(function(p2): boolean
			local v5

			if FFlagUseNavigationSelectors then
				v5 = Selectors.selectLegacyHistory(p2)
			else
				v5 = p2.Navigation.history
			end

			local v6 = v5 and v5[#v5]
			local count = 0

			if not v6 then
				return false
			end

			for i = 1, #v6 do
				if v6[i].name ~= AppPage.GameDetail then
					continue
				end

				count += 1

				if count > 1 then
					return true
				end
			end

			return false
		end)
	end

	React.useEffect(function()
		return function()
			if not v4 then
				v({ type = "SetGameDetailsPeekViewState", viewState = PeekViewState.Closed })
			end
		end
	end, { v, v4 })

	local v5 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(pageProps, "showBackButton")

	if v5 == nil then
		v5 = v4
	end

	local onActivated = React.useCallback(function()
		if not v5 then
			onClose()
		elseif FFlagSignalsNavP3Dispatch then
			navigationCommands.back()
		else
			v(NavigateBack())
		end
	end, { v5, v, onClose })

	local createElement = React.createElement
	local v6 = {
		tag = "row align-y-center size-full",
		padding = {
			top = UDim.new(0, FFlagFixOverlayTopInsetForDeviceSafeInsets and shouldUseDeviceSafeInsets and 0 or v2.top),
			left = UDim.new(0, v3.Padding.Large)
		}
	}

	local createElement2 = React.createElement
	local icon = if v5 then IconName.ChevronLargeLeft else IconName.X
	return createElement(View, v6, {
		NavButton = createElement2(IconButton, {
			icon = icon,
			variant = ButtonVariant.Utility,
			size = ButtonSize.Medium,
			isCircular = true,
			onActivated = onActivated,
			testId = "--discovery-edp-iconbutton-peekview-nav"
		})
	})
end

return React.memo(PeekViewTopBar)
