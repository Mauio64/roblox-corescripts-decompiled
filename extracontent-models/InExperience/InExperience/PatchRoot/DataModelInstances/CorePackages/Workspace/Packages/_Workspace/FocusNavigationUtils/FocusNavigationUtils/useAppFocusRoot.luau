local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local parent = FocusNavigationUtils.Parent

require(parent.ReactFocusNavigation)
local Cryo = require(parent.Cryo)
local Navigation = require(parent.Navigation)

local useFocusRoot = require(FocusNavigationUtils.useFocusRoot)
local useDefaultAppEventHandlers = require(FocusNavigationUtils.useDefaultAppEventHandlers)
local FocusNavigationDefaultEventMap = require(FocusNavigationUtils.FocusNavigationDefaultEventMap)

local v = {}

local function useAppFocusRoot(data)
	local customEventHandlers = data.customEventHandlers or v
	local customEventMap = data.customEventMap or v
	local v2 = Navigation.useNavigationFocus()

	local v3 = useDefaultAppEventHandlers()
	local union = Cryo.Dictionary.union(v3, customEventHandlers)
	local union2 = Cryo.Dictionary.union(FocusNavigationDefaultEventMap, customEventMap)

	local isFocusable = (data.isFocusable == nil or data.isFocusable) and (v2 == nil or v2)
	local isAutoFocusRoot

	if data.isAutoFocusRoot == nil then
		isAutoFocusRoot = false
	else
		isAutoFocusRoot = data.isAutoFocusRoot
	end

	return useFocusRoot((Cryo.Dictionary.union(data, {
		customEventHandlers = Cryo.None,
		eventHandlers = union,
		eventMap = union2,
		isFocusable = isFocusable,
		isAutoFocusRoot = isAutoFocusRoot
	})))
end

return useAppFocusRoot
