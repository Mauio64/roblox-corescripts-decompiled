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
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v22 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local ExperienceDetailsPageUtils = require(script.Parent.ExperienceDetailsPageUtils)

local function PeekViewTopBar(t1: {[any]: any}) -- line: 39
	-- upvalues: useDispatch (copy), useDeviceInsets (copy), useTokens (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AppPage (copy), React (copy), PeekViewState (copy), ExperienceDetailsPageUtils (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), NavigateBack (copy), View (copy), IconButton (copy), IconName (copy), ButtonVariant (copy), ButtonSize (copy)
	local pageProps = t1.pageProps
	local onClose = t1.onClose
	local v28 = useDispatch()
	local v29 = useDeviceInsets()
	local v30 = useTokens()
	local v31 = useSelector(function(p1) -- line: 47
		-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), AppPage (copy)
		local v36 = if not FFlagUseNavigationSelectors then p1.Navigation.history else Selectors.selectLegacyHistory(p1)
		local v37 = v36 and v36[#v36]
		local n1 = 0

		if v37 then
			for i = 1, #v37 do
				if v37[i].name ~= AppPage.GameDetail then
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

	React.useEffect(function() -- line: 66
		-- upvalues: v31 (copy), v28 (copy), PeekViewState (copy)
		return function() -- line: 67
			-- upvalues: v31 (copy), v28 (copy), PeekViewState (copy)
			if not v31 then
				v28({
					type = "SetGameDetailsPeekViewState",
					viewState = PeekViewState.Closed
				})
			end
		end
	end, {
		v28,
		v31
	})

	local v32 = ExperienceDetailsPageUtils.getFromPropsOrNavigationParams(pageProps, "showBackButton")
	local v33 = if v32 == nil then v31 else v32
	local v34 = React.useCallback(function() -- line: 81
		-- upvalues: v33 (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), v28 (copy), NavigateBack (copy), onClose (copy)
		if v33 then
			if FFlagSignalsNavP3Dispatch then
				v22.back()

				return
			end

			v28(NavigateBack())

			return
		end

		onClose()
	end, {
		v33,
		v28,
		onClose
	})

	return React.createElement(View, {
		tag = "row align-y-center size-full",
		padding = {
			top = UDim.new(0, v29.top),
			left = UDim.new(0, v30.Padding.Large)
		}
	}, {
		NavButton = React.createElement(IconButton, {
			isCircular = true,
			icon = if not v33 then IconName.X else IconName.ChevronLargeLeft,
			variant = ButtonVariant.Utility,
			size = ButtonSize.Medium,
			onActivated = v34
		})
	})
end

return React.memo(PeekViewTopBar)
