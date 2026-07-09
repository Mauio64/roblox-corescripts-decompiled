local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local FocusNavigationUtilsParent = FocusNavigationUtils.Parent
local GuiService = game:GetService("GuiService")
local React = require(FocusNavigationUtilsParent.React)
local Cryo = require(FocusNavigationUtilsParent.Cryo)
local useFocusRoot = require(script.Parent.useFocusRoot)
local BaseFocusRoot = require(FocusNavigationUtils.BaseFocusRoot)
local FFlagFocusRootUseHooks = require(script.Parent.FFlagFocusRootUseHooks)
local ReactFocusNavigation = require(FocusNavigationUtilsParent.ReactFocusNavigation)

require(FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum)

local useFocusNavigableSurfaceRegistryConnection = require(FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection)
local useAutoFocus = require(FocusNavigationUtils.useAutoFocus)
local useDescendantHasFocus = require(FocusNavigationUtils.useDescendantHasFocus)
local useLastInputMode = require(FocusNavigationUtils.useLastInputMode)
local t1 = {
	BackgroundTransparency = 1,
	SelectionGroup = true,
	Size = UDim2.fromScale(1, 1)
}
local t2 = {}
local t3 = {
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop
}

local function useWrappedFrameProps(b1: boolean?, p1, p2) -- line: 43
	-- upvalues: React (copy), t2 (copy), Cryo (copy), t3 (copy), t1 (copy)
	return React.useMemo(function() -- line: 45
		-- upvalues: p1 (copy), t2 (copy), b1 (copy), Cryo (copy), t3 (copy), t1 (copy), p2 (copy)
		local v44 = p1 or t2

		if b1 then
			v44 = Cryo.Dictionary.join(t3, v44)
		end

		return Cryo.Dictionary.join(t1, v44, {
			ref = p2
		})
	end, {
		b1,
		p1,
		p2
	})
end
local function FocusRoot(p3) -- line: 74
	-- upvalues: FFlagFocusRootUseHooks (copy), useFocusRoot (copy), React (copy), BaseFocusRoot (copy), t2 (copy), ReactFocusNavigation (copy), useFocusNavigableSurfaceRegistryConnection (copy), useDescendantHasFocus (copy), useAutoFocus (copy), useLastInputMode (copy), GuiService (copy), Cryo (copy), t3 (copy), t1 (copy)
	if FFlagFocusRootUseHooks then
		local v23 = useFocusRoot(p3)

		return React.createElement(BaseFocusRoot, {
			ref = v23,
			isIsolated = p3.isIsolated,
			frameProps = p3.frameProps
		}, p3.children)
	end

	local v24 = if not p3.frameProps or not p3.frameProps.ref then nil else p3.frameProps.ref.current
	local v25, v26 = React.useState(v24)
	local u27 = v25
	local v28 = p3.eventMap or t2
	local v29 = ReactFocusNavigation.useEventMap(v28, v26)
	local v30 = p3.eventHandlers or t2
	local v31 = ReactFocusNavigation.useEventHandlerMap(v30, v29)
	local v32 = p3.isFocusable == nil or p3.isFocusable
	local v33 = p3.shouldRestoreFocus == nil or p3.shouldRestoreFocus
	local v34 = ReactFocusNavigation.useMostRecentFocusBehavior(v31)
	local v35 = if not v33 then v31 else v34

	useFocusNavigableSurfaceRegistryConnection(u27, p3.surfaceIdentifier, v32)

	local v36 = useDescendantHasFocus(u27)
	local v37 = useAutoFocus({ u27 }, 0.1)
	local v38 = useLastInputMode() == "Focus"
	local v39 = p3.isAutoFocusRoot and (v32 and (v38 and (u27 and not v36)))

	React.useEffect(function() -- line: 113
		-- upvalues: v39 (copy), v37 (copy)
		local u45 = nil

		if v39 then
			u45 = v37()
		end

		return function() -- line: 118
			-- upvalues: u45 (ref)
			if u45 then
				u45.cancel()
			end
		end
	end, {
		v39,
		v37
	})

	local v40 = React.useRef(u27)

	React.useEffect(function() -- line: 126
		-- upvalues: u27 (ref), v40 (copy)
		if u27 then
			v40.current = u27
		end
	end, { u27 })
	React.useEffect(function() -- line: 132
		-- upvalues: v40 (copy), GuiService (copy)
		return function() -- line: 133
			-- upvalues: v40 (copy), GuiService (copy)
			if not v40.current then
				return
			end

			local SelectedCoreObject = GuiService.SelectedCoreObject

			if not SelectedCoreObject then
				return
			end

			if SelectedCoreObject:IsDescendantOf(v40.current) or not SelectedCoreObject:IsDescendantOf(game) then
				GuiService.SelectedCoreObject = nil
			end
		end
	end, {})

	local isIsolated = p3.isIsolated
	local frameProps = p3.frameProps
	local v43 = React.useMemo(function() -- line: 45
		-- upvalues: frameProps (copy), t2 (copy), isIsolated (copy), Cryo (copy), t3 (copy), t1 (copy), v35 (copy)
		local v46 = frameProps or t2

		if isIsolated then
			v46 = Cryo.Dictionary.join(t3, v46)
		end

		return Cryo.Dictionary.join(t1, v46, {
			ref = v35
		})
	end, {
		isIsolated,
		frameProps,
		v35
	})

	return React.createElement("Frame", v43, p3.children)
end

return FocusRoot
