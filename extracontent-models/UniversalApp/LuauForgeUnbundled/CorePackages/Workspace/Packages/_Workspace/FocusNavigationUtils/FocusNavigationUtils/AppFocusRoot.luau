local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/ReactFocusNavigation")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/Cryo")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/Navigation")

local useAppFocusRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useAppFocusRoot")
local BaseFocusRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/BaseFocusRoot")
local FFlagFocusRootUseHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FFlagFocusRootUseHooks")

local FocusRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FocusRoot")
local useDefaultAppEventHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useDefaultAppEventHandlers")
local FocusNavigationDefaultEventMap = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FocusNavigationDefaultEventMap")

local v5 = {}

local function AppFocusRoot(props)
	if FFlagFocusRootUseHooks then
		local v6 = useAppFocusRoot(props)

		return React.createElement(
			BaseFocusRoot,
			{ ref = v6, isIsolated = props.isIsolated, frameProps = props.frameProps },
			props.children
		)
	end

	local customEventHandlers = props.customEventHandlers or v5
	local customEventMap = props.customEventMap or v5
	local v6 = Navigation.useNavigationFocus()

	local v7 = useDefaultAppEventHandlers()
	local union = Cryo.Dictionary.union(v7, customEventHandlers)
	local union2 = Cryo.Dictionary.union(FocusNavigationDefaultEventMap, customEventMap)

	local v8 = (props.isFocusable == nil or props.isFocusable) and (v6 == nil or v6)

	local v9 = not (props.isAutoFocusRoot == nil) and props.isAutoFocusRoot

	local union3 = Cryo.Dictionary.union(props, {
		customEventHandlers = Cryo.None,
		eventHandlers = union,
		eventMap = union2,
		isFocusable = v8,
		isAutoFocusRoot = v9
	})

	return React.createElement(FocusRoot, union3, props.children)
end

return AppFocusRoot
