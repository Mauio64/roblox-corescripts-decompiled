local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local FocusNavigationUtilsParent = FocusNavigationUtils.Parent

if require(FocusNavigationUtilsParent.SharedFlags).FFlagAppFocusWrapperRefactor then
	return (require(FocusNavigationUtils.AppFocusRoot))
end

local React = require(FocusNavigationUtilsParent.React)
local ReactFocusNavigation = require(FocusNavigationUtilsParent.ReactFocusNavigation)
local Cryo = require(FocusNavigationUtilsParent.Cryo)
local Navigation = require(FocusNavigationUtilsParent.Navigation)

require(FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum)

local useFocusNavigableSurfaceRegistryConnection = require(FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection)
local useDefaultFocusNavigationBindings = require(FocusNavigationUtils.useDefaultFocusNavigationBindings)
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

local function useWrappedFrameProps(b1: boolean?, p1, p2) -- line: 48
	-- upvalues: React (copy), Cryo (copy), t3 (copy), t1 (copy)
	return React.useMemo(function() -- line: 50
		-- upvalues: p1 (copy), b1 (copy), Cryo (copy), t3 (copy), t1 (copy), p2 (copy)
		local v33 = p1 or {}

		if b1 then
			v33 = Cryo.Dictionary.join(t3, v33)
		end

		return Cryo.Dictionary.join(t1, v33, {
			ref = p2
		})
	end, {
		b1,
		p1,
		p2
	})
end
local function FocusNavigableSurfaceWrapper(t4: {[any]: any}) -- line: 72
	-- upvalues: t2 (copy), React (copy), ReactFocusNavigation (copy), useDefaultFocusNavigationBindings (copy), Navigation (copy), useFocusNavigableSurfaceRegistryConnection (copy), Cryo (copy), t3 (copy), t1 (copy)
	local v18 = t4.customEventHandlers or t2
	local v19 = if not t4.frameProps or not t4.frameProps.ref then nil else t4.frameProps.ref.current
	local v20, v21 = React.useState(v19)
	local v22 = ReactFocusNavigation.useEventHandlerMap(v18, v21)
	local v23 = useDefaultFocusNavigationBindings(v22)
	local isFocusable = t4.isFocusable
	local v25 = Navigation.useNavigationFocus()
	local v26 = (isFocusable == nil or isFocusable) and (v25 == nil or v25)
	local v27 = t4.shouldRestoreFocus == nil or t4.shouldRestoreFocus
	local v28 = ReactFocusNavigation.useMostRecentFocusBehavior(v23)

	if v27 then
		v23 = v28
	end

	useFocusNavigableSurfaceRegistryConnection(v20, t4.surfaceIdentifier, v26)

	local isIsolated = t4.isIsolated
	local frameProps = t4.frameProps
	local v31 = v23
	local v32 = React.useMemo(function() -- line: 50
		-- upvalues: frameProps (copy), isIsolated (copy), Cryo (copy), t3 (copy), t1 (copy), v31 (copy)
		local v34 = frameProps or {}

		if isIsolated then
			v34 = Cryo.Dictionary.join(t3, v34)
		end

		return Cryo.Dictionary.join(t1, v34, {
			ref = v31
		})
	end, {
		isIsolated,
		frameProps,
		v31
	})

	return React.createElement("Frame", v32, t4.children)
end

return FocusNavigableSurfaceWrapper
