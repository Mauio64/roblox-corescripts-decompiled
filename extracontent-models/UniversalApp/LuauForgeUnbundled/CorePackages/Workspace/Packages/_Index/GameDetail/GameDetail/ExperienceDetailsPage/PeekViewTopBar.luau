local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Foundation")
local view = Foundation.View
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local buttonSize = Foundation.Enums.ButtonSize
local buttonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens

local useDeviceInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Responsive").useDeviceInsets
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppEnums").AppPage
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/NavigationRodux")
local selectors = NavigationRodux.Selectors
local navigateBack = NavigationRodux.Thunks.NavigateBack
local peekViewState = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/PeekView").PeekViewState

local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags")
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagFixOverlayTopInsetForDeviceSafeInsets = SharedFlags.FFlagFixOverlayTopInsetForDeviceSafeInsets
local shouldUseDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Display").shouldUseDeviceSafeInsets

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppNavigation").NavigationCommands else nil

local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SignalsReact").useSignalState
local createComputed = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Signals").createComputed
local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/NavigationRodux").GetLegacyNavigationStore

local ExperienceDetailsPageUtils = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/ExperienceDetailsPageUtils")

local function PeekViewTopBar(p2)
	local pageProps = p2.pageProps
	local onClose = p2.onClose

	local v5 = useDispatch()
	local v6 = useDeviceInsets()
	local v7 = useTokens()
	local v8

	if fFlagSignalsNavP3fGameDetails then
		v8 = useSignalState((React.useMemo(function()
			local legacyNavigationStore = getLegacyNavigationStore(false)
			return createComputed(function(p3): boolean
				local currentLegacyRoute = legacyNavigationStore.getCurrentLegacyRoute(p3)
				local count = 0

				if not currentLegacyRoute then
					return false
				end

				for i = 1, #currentLegacyRoute do
					if currentLegacyRoute[i].name ~= appPage.GameDetail then
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
		v8 = useSelector(function(p3): boolean
			local v9

			if fFlagUseNavigationSelectors then
				v9 = selectors.selectLegacyHistory(p3)
			else
				v9 = p3.Navigation.history
			end

			local v10 = v9 and v9[#v9]
			local count = 0

			if not v10 then
				return false
			end

			for i = 1, #v10 do
				if v10[i].name ~= appPage.GameDetail then
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
			if not v8 then
				v5({
					type = "SetGameDetailsPeekViewState",
					viewState = peekViewState.Closed
				})
			end
		end
	end, { v5, v8 })

	local v9 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(pageProps, "showBackButton")

	if v9 == nil then
		v9 = v8
	end

	local v10 = React.useCallback(function()
		if not v9 then
			onClose()
		elseif fFlagSignalsNavP3Dispatch then
			navigationCommands.back()
		else
			v5(navigateBack())
		end
	end, { v9, v5, onClose })

	local createElement = React.createElement
	local v12 = {
		tag = "row align-y-center size-full",
		padding = {
			top = UDim.new(
				0,
				fFlagFixOverlayTopInsetForDeviceSafeInsets and shouldUseDeviceSafeInsets and 0 or v6.top
			),
			left = UDim.new(0, v7.Padding.Large)
		}
	}

	local createElement2 = React.createElement
	local v16 = if v9 then iconName.ChevronLargeLeft else iconName.X
	return createElement(view, v12, {
		NavButton = createElement2(iconButton, {
			icon = v16,
			variant = buttonVariant.Utility,
			size = buttonSize.Medium,
			isCircular = true,
			onActivated = v10,
			testId = "--discovery-edp-iconbutton-peekview-nav"
		})
	})
end

return React.memo(PeekViewTopBar)
