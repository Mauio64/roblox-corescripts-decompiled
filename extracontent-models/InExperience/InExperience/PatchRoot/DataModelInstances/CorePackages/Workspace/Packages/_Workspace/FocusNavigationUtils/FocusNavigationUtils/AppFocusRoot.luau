local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local parent = FocusNavigationUtils.Parent
local React = require(parent.React)
require(parent.ReactFocusNavigation)
local Cryo = require(parent.Cryo)
local Navigation = require(parent.Navigation)

local useAppFocusRoot = require(script.Parent.useAppFocusRoot)
local BaseFocusRoot = require(FocusNavigationUtils.BaseFocusRoot)
local FFlagFocusRootUseHooks = require(script.Parent.FFlagFocusRootUseHooks)

local FocusRoot = require(FocusNavigationUtils.FocusRoot)
local useDefaultAppEventHandlers = require(FocusNavigationUtils.useDefaultAppEventHandlers)
local FocusNavigationDefaultEventMap = require(FocusNavigationUtils.FocusNavigationDefaultEventMap)

local v = {}

local function AppFocusRoot(props)
	if FFlagFocusRootUseHooks then
		local ref = useAppFocusRoot(props)

		return React.createElement(
			BaseFocusRoot,
			{ ref = ref, isIsolated = props.isIsolated, frameProps = props.frameProps },
			props.children
		)
	end

	local customEventHandlers = props.customEventHandlers or v
	local customEventMap = props.customEventMap or v
	local v2 = Navigation.useNavigationFocus()

	local v3 = useDefaultAppEventHandlers()
	local union = Cryo.Dictionary.union(v3, customEventHandlers)
	local union2 = Cryo.Dictionary.union(FocusNavigationDefaultEventMap, customEventMap)

	local isFocusable = (props.isFocusable == nil or props.isFocusable) and (v2 == nil or v2)
	local isAutoFocusRoot

	if props.isAutoFocusRoot == nil then
		isAutoFocusRoot = false
	else
		isAutoFocusRoot = props.isAutoFocusRoot
	end

	local union3 = Cryo.Dictionary.union(props, {
		customEventHandlers = Cryo.None,
		eventHandlers = union,
		eventMap = union2,
		isFocusable = isFocusable,
		isAutoFocusRoot = isAutoFocusRoot
	})

	return React.createElement(FocusRoot, union3, props.children)
end

return AppFocusRoot
