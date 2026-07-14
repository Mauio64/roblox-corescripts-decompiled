local Parent = script:FindFirstAncestor("GameDetail").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens
local useDeviceInsets = require(Parent.Responsive).useDeviceInsets
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigationRodux = require(Parent.NavigationRodux)
local Selectors = NavigationRodux.Selectors
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local PeekViewState = require(Parent.PeekView).PeekViewState
local RoactUtils = require(Parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local SharedFlags = require(Parent.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3fGameDetails = SharedFlags.FFlagSignalsNavP3fGameDetails
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v23 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local useSignalState = require(Parent.SignalsReact).useSignalState
local createComputed = require(Parent.Signals).createComputed
local GetLegacyNavigationStore = require(Parent.NavigationRodux).GetLegacyNavigationStore
local ExperienceDetailsPageUtils = require(script.Parent.ExperienceDetailsPageUtils)

local function PeekViewTopBar(t1: {[any]: any}) -- line: 43
	-- upvalues: useDispatch (copy), useDeviceInsets (copy), useTokens (copy), FFlagSignalsNavP3fGameDetails (copy), React (copy), GetLegacyNavigationStore (copy), createComputed (copy), AppPage (copy), useSignalState (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), PeekViewState (copy), ExperienceDetailsPageUtils (copy), FFlagSignalsNavP3Dispatch (copy), v23 (copy), NavigateBack (copy), View (copy), IconButton (copy), IconName (copy), ButtonVariant (copy), ButtonSize (copy)
	local pageProps = t1.pageProps
	local onClose = t1.onClose
	local v32 = useDispatch()
	local v33 = useDeviceInsets()
	local v34 = useTokens()
	local u36

	if FFlagSignalsNavP3fGameDetails then
		local v35 = React.useMemo(function() -- line: 53
			-- upvalues: GetLegacyNavigationStore (copy), createComputed (copy), AppPage (copy)
			local v40 = GetLegacyNavigationStore(false)

			return createComputed(function(p1) -- line: 55
				-- upvalues: v40 (copy), AppPage (copy)
				local v47 = v40.getCurrentLegacyRoute(p1)
				local n1 = 0

				if v47 then
					for i = 1, #v47 do
						if v47[i].name ~= AppPage.GameDetail then
							continue
						end

						n1 += 1

						if n1 > 1 then
							return true
						end
					end
				end

				return false
			end)
		end, {})

		u36 = useSignalState(v35)
	else
		u36 = useSelector(function(p2) -- line: 73
			-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), AppPage (copy)
			local v42 = if not FFlagUseNavigationSelectors then p2.Navigation.history else Selectors.selectLegacyHistory(p2)
			local v43 = v42 and v42[#v42]
			local n2 = 0

			if v43 then
				for i = 1, #v43 do
					if v43[i].name ~= AppPage.GameDetail then
						continue
					end

					n2 += 1

					if n2 > 1 then
						return true
					end
				end
			end

			return false
		end)
	end

	React.useEffect(function() -- line: 93
		-- upvalues: u36 (ref), v32 (copy), PeekViewState (copy)
		return function() -- line: 94
			-- upvalues: u36 (ref), v32 (copy), PeekViewState (copy)
			if not u36 then
				v32({
					type = "SetGameDetailsPeekViewState",
					viewState = PeekViewState.Closed
				})
			end
		end
	end, {
		v32,
		u36
	})

	local v37 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(pageProps, "showBackButton")
	local v38 = if v37 == nil then u36 else v37
	local v39 = React.useCallback(function() -- line: 108
		-- upvalues: v38 (copy), FFlagSignalsNavP3Dispatch (copy), v23 (copy), v32 (copy), NavigateBack (copy), onClose (copy)
		if v38 then
			if FFlagSignalsNavP3Dispatch then
				v23.back()

				return
			end

			v32(NavigateBack())

			return
		end

		onClose()
	end, {
		v38,
		v32,
		onClose
	})

	return React.createElement(View, {
		tag = "row align-y-center size-full",
		padding = {
			top = UDim.new(0, v33.top),
			left = UDim.new(0, v34.Padding.Large)
		}
	}, {
		NavButton = React.createElement(IconButton, {
			isCircular = true,
			icon = if not v38 then IconName.X else IconName.ChevronLargeLeft,
			variant = ButtonVariant.Utility,
			size = ButtonSize.Medium,
			onActivated = v39
		})
	})
end

return React.memo(PeekViewTopBar)
