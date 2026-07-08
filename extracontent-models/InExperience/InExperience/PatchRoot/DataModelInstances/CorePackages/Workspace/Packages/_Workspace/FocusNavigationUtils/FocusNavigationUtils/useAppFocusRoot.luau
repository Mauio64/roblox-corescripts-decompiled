local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local FocusNavigationUtilsParent = FocusNavigationUtils.Parent

require(FocusNavigationUtilsParent.ReactFocusNavigation)

local Cryo = require(FocusNavigationUtilsParent.Cryo)
local Navigation = require(FocusNavigationUtilsParent.Navigation)
local useFocusRoot = require(FocusNavigationUtils.useFocusRoot)
local useDefaultAppEventHandlers = require(FocusNavigationUtils.useDefaultAppEventHandlers)
local FocusNavigationDefaultEventMap = require(FocusNavigationUtils.FocusNavigationDefaultEventMap)
local t1 = {}

local function useAppFocusRoot(p1) -- line: 23
	-- upvalues: t1 (copy), Navigation (copy), useDefaultAppEventHandlers (copy), Cryo (copy), FocusNavigationDefaultEventMap (copy), useFocusRoot (copy)
	local v11 = p1.customEventHandlers or t1
	local v12 = p1.customEventMap or t1
	local v13 = Navigation.useNavigationFocus()
	local v14 = useDefaultAppEventHandlers()
	local v15 = Cryo.Dictionary.union(v14, v11)
	local v16 = Cryo.Dictionary.union(FocusNavigationDefaultEventMap, v12)
	local v17 = (p1.isFocusable == nil or p1.isFocusable) and (v13 == nil or v13)
	local v18 = p1.isAutoFocusRoot ~= nil and p1.isAutoFocusRoot
	local v19 = Cryo.Dictionary.union(p1, {
		customEventHandlers = Cryo.None,
		eventHandlers = v15,
		eventMap = v16,
		isFocusable = v17,
		isAutoFocusRoot = v18
	})

	return useFocusRoot(v19)
end

return useAppFocusRoot
