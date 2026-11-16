require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/ReactFocusNavigation")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/Cryo")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/Navigation")

local useFocusRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useFocusRoot")
local useDefaultAppEventHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useDefaultAppEventHandlers")
local FocusNavigationDefaultEventMap = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FocusNavigationDefaultEventMap")

local v5 = {}

local function useAppFocusRoot(data)
	local customEventHandlers = data.customEventHandlers or v5
	local customEventMap = data.customEventMap or v5
	local v6 = Navigation.useNavigationFocus()

	local v7 = useDefaultAppEventHandlers()
	local union = Cryo.Dictionary.union(v7, customEventHandlers)
	local union2 = Cryo.Dictionary.union(FocusNavigationDefaultEventMap, customEventMap)

	local v8 = (data.isFocusable == nil or data.isFocusable) and (v6 == nil or v6)

	local v9 = not (data.isAutoFocusRoot == nil) and data.isAutoFocusRoot

	return useFocusRoot((Cryo.Dictionary.union(data, {
		customEventHandlers = Cryo.None,
		eventHandlers = union,
		eventMap = union2,
		isFocusable = v8,
		isAutoFocusRoot = v9
	})))
end

return useAppFocusRoot
