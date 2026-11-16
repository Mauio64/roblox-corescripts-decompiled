local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/Cryo")

local useFocusRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useFocusRoot")
local BaseFocusRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/BaseFocusRoot")
local FFlagFocusRootUseHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FFlagFocusRootUseHooks")

local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/ReactFocusNavigation")
require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FocusNavigableSurfaceIdentifierEnum")

local useFocusNavigableSurfaceRegistryConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useFocusNavigableSurfaceRegistryConnection")
local useAutoFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useAutoFocus")
local useDescendantHasFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useDescendantHasFocus")
local useLastInputMode = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useLastInputMode")

local v5 = {
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	SelectionGroup = true
}

local v6 = {}

local v7 = {
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop
}

local function useWrappedFrameProps(p2, p3, p4)
	return React.useMemo(function()
		local joined = p3 or v6

		if p2 then
			joined = Cryo.Dictionary.join(v7, joined)
		end

		return Cryo.Dictionary.join(v5, joined, { ref = p4 })
	end, { p2, p3, p4 })
end

local function FocusRoot(props)
	if FFlagFocusRootUseHooks then
		local v8 = useFocusRoot(props)

		return React.createElement(
			BaseFocusRoot,
			{ ref = v8, isIsolated = props.isIsolated, frameProps = props.frameProps },
			props.children
		)
	end

	local v8 = if props.frameProps and props.frameProps.ref then props.frameProps.ref.current else nil

	local state, setState = React.useState(v8)

	local eventMap = props.eventMap or v6
	local v10 = ReactFocusNavigation.useEventMap(eventMap, setState)
	local eventHandlers = props.eventHandlers or v6
	local v11 = ReactFocusNavigation.useEventHandlerMap(eventHandlers, v10)

	local v12 = props.isFocusable == nil or props.isFocusable
	local v13 = props.shouldRestoreFocus == nil or props.shouldRestoreFocus
	local v14 = ReactFocusNavigation.useMostRecentFocusBehavior(v11)

	if not v13 then
		v14 = v11
	end

	useFocusNavigableSurfaceRegistryConnection(state, props.surfaceIdentifier, v12)

	local v15 = useDescendantHasFocus(state)
	local v16 = useAutoFocus({ state }, 0.1)
	local v17 = useLastInputMode() == "Focus"
	local v18 = props.isAutoFocusRoot and v12 and v17 and state and not v15

	React.useEffect(function()
		local v19 = if v18 then v16() else nil

		return function()
			if v19 then
				v19.cancel()
			end
		end
	end, { v18, v16 })

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

			if
				selectedCoreObject:IsDescendantOf(ref.current)
				or not selectedCoreObject:IsDescendantOf(game)
			then
				GuiService.SelectedCoreObject = nil
			end
		end
	end, {})

	local isIsolated = props.isIsolated
	local frameProps = props.frameProps
	local v19 = React.useMemo(function()
		local joined = frameProps or v6

		if isIsolated then
			joined = Cryo.Dictionary.join(v7, joined)
		end

		return Cryo.Dictionary.join(v5, joined, { ref = v14 })
	end, { isIsolated, frameProps, v14 })

	return React.createElement("Frame", v19, props.children)
end

return FocusRoot
