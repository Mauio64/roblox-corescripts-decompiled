local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local FocusNavigationUtilsParent = FocusNavigationUtils.Parent
local React = require(FocusNavigationUtilsParent.React)

require(FocusNavigationUtilsParent.ReactFocusNavigation)

local Cryo = require(FocusNavigationUtilsParent.Cryo)
local Navigation = require(FocusNavigationUtilsParent.Navigation)
local useAppFocusRoot = require(script.Parent.useAppFocusRoot)
local BaseFocusRoot = require(FocusNavigationUtils.BaseFocusRoot)
local FFlagFocusRootUseHooks = require(script.Parent.FFlagFocusRootUseHooks)
local FocusRoot = require(FocusNavigationUtils.FocusRoot)
local useDefaultAppEventHandlers = require(FocusNavigationUtils.useDefaultAppEventHandlers)
local FocusNavigationDefaultEventMap = require(FocusNavigationUtils.FocusNavigationDefaultEventMap)
local t1 = {}

local function AppFocusRoot(p1) -- line: 26
	-- upvalues: FFlagFocusRootUseHooks (copy), useAppFocusRoot (copy), React (copy), BaseFocusRoot (copy), t1 (copy), Navigation (copy), useDefaultAppEventHandlers (copy), Cryo (copy), FocusNavigationDefaultEventMap (copy), FocusRoot (copy)
	if FFlagFocusRootUseHooks then
		local v15 = useAppFocusRoot(p1)

		return React.createElement(BaseFocusRoot, {
			ref = v15,
			isIsolated = p1.isIsolated,
			frameProps = p1.frameProps
		}, p1.children)
	end

	local v16 = p1.customEventHandlers or t1
	local v17 = p1.customEventMap or t1
	local v18 = Navigation.useNavigationFocus()
	local v19 = useDefaultAppEventHandlers()
	local v20 = Cryo.Dictionary.union(v19, v16)
	local v21 = Cryo.Dictionary.union(FocusNavigationDefaultEventMap, v17)
	local v22 = (p1.isFocusable == nil or p1.isFocusable) and (v18 == nil or v18)
	local v23 = p1.isAutoFocusRoot ~= nil and p1.isAutoFocusRoot
	local v24 = Cryo.Dictionary.union(p1, {
		customEventHandlers = Cryo.None,
		eventHandlers = v20,
		eventMap = v21,
		isFocusable = v22,
		isAutoFocusRoot = v23
	})

	return React.createElement(FocusRoot, v24, p1.children)
end

return AppFocusRoot
