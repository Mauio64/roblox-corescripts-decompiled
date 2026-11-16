local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local parent = FocusNavigationUtils.Parent

local GuiService = game:GetService("GuiService")

local React = require(parent.React)
local Cryo = require(parent.Cryo)

local useFocusRoot = require(script.Parent.useFocusRoot)
local BaseFocusRoot = require(FocusNavigationUtils.BaseFocusRoot)
local FFlagFocusRootUseHooks = require(script.Parent.FFlagFocusRootUseHooks)

local ReactFocusNavigation = require(parent.ReactFocusNavigation)
require(FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum)

local useFocusNavigableSurfaceRegistryConnection = require(FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection)
local useAutoFocus = require(FocusNavigationUtils.useAutoFocus)
local useDescendantHasFocus = require(FocusNavigationUtils.useDescendantHasFocus)
local useLastInputMode = require(FocusNavigationUtils.useLastInputMode)

local v = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, SelectionGroup = true }

local v2 = {}

local v3 = {
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop
}

local function useWrappedFrameProps(isIsolated: boolean?, frameProps, ref) -- 1 equivalent call inferred from this helper
	return React.useMemo(function()
		local joined = frameProps or v2

		if isIsolated then
			joined = Cryo.Dictionary.join(v3, joined)
		end

		return Cryo.Dictionary.join(v, joined, { ref = ref })
	end, { isIsolated, frameProps, ref })
end

local function FocusRoot(props)
	if FFlagFocusRootUseHooks then
		local ref = useFocusRoot(props)

		return React.createElement(
			BaseFocusRoot,
			{ ref = ref, isIsolated = props.isIsolated, frameProps = props.frameProps },
			props.children
		)
	end

	local v4

	if props.frameProps and props.frameProps.ref then
		v4 = props.frameProps.ref.current
	end

	local state, setState = React.useState(v4)

	local eventMap = props.eventMap or v2
	local v5 = ReactFocusNavigation.useEventMap(eventMap, setState)
	local eventHandlers = props.eventHandlers or v2
	local v6 = ReactFocusNavigation.useEventHandlerMap(eventHandlers, v5)

	local v7 = props.isFocusable == nil or props.isFocusable
	local v8 = props.shouldRestoreFocus == nil or props.shouldRestoreFocus
	local v9 = ReactFocusNavigation.useMostRecentFocusBehavior(v6)

	if not v8 then
		v9 = v6
	end

	useFocusNavigableSurfaceRegistryConnection(state, props.surfaceIdentifier, v7)

	local v10 = useDescendantHasFocus(state)
	local v11 = useAutoFocus({ state }, 0.1)
	local v12 = useLastInputMode() == "Focus"
	local v13 = props.isAutoFocusRoot and v7 and v12 and state and not v10

	React.useEffect(function()
		local v14

		if v13 then
			v14 = v11()
		else
			v14 = nil
		end

		return function()
			if v14 then
				v14.cancel()
			end
		end
	end, { v13, v11 })

	local ref = React.useRef(state)
	React.useEffect(function()
		if state then
			ref.current = state
		end
	end, { state })

	React.useEffect(function()
		return function()
			if not ref.current then
				return
			end

			local selectedCoreObject = GuiService.SelectedCoreObject

			if not selectedCoreObject then
				return
			end

			if selectedCoreObject:IsDescendantOf(ref.current) or not selectedCoreObject:IsDescendantOf(game) then
				GuiService.SelectedCoreObject = nil
			end
		end
	end, {})

	local v14 = useWrappedFrameProps(props.isIsolated, props.frameProps, v9) -- inferred equivalent call
	return React.createElement("Frame", v14, props.children)
end

return FocusRoot
