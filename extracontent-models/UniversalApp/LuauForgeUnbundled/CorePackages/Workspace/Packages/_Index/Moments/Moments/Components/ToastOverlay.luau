local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local foundationProvider = Foundation.FoundationProvider
local snackbar = Foundation.Snackbar
local toast = Foundation.Toast
local view = Foundation.View

local colorMode = Foundation.Enums.ColorMode

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useScreenSize = MomentsCommon.Hooks.useScreenSize
local useTokens = Foundation.Hooks.useTokens

local GetToastStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetToastStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetToastStore/createToastStore")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")
local momentLayout = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/momentLayout")
local useScreenBottomInset = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useScreenBottomInset")
local fFlagMomentsPostFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsPostFeedback

local function ToastItem(props)
	local entry = props.entry
	local onDismiss = props.onDismiss

	React.useEffect(function()
		local thread = task.delay(3, function()
			onDismiss(entry.id)
		end)
		return function()
			task.cancel(thread)
		end
	end, { entry.id, onDismiss })

	if entry.data.variant == "snackbar" then
		return React.createElement(snackbar, {
			title = entry.data.title,
			LayoutOrder = entry.id
		})
	end

	local createElement = React.createElement
	local v6 = { title = entry.data.title, text = 0, LayoutOrder = 0, width = 0 }
	local v7 = if entry.data.text ~= "" then entry.data.text else nil
	v6.text = v7
	v6.LayoutOrder = entry.id
	v6.width = props.toastWidth
	return createElement(toast, v6)
end

local function BottomToastStack(p2)
	local v5 = useDeviceInsets()
	local v6 = useTokens()

	local v7 = useScreenBottomInset()

	local v8 = v7 + momentLayout.getInfoBottomGap(v6, v7, v5.bottom) + v6.Padding.Large - v6.Padding.Medium

	return React.createElement(view, {
		tag = "position-bottom-center anchor-bottom-center size-full-0 auto-y",
		ZIndex = Constants.ZIndex.Toasts,
		padding = {
			bottom = UDim.new(0, v8),
			left = UDim.new(0, v5.left + v6.Padding.Large),
			right = UDim.new(0, v5.right + v6.Padding.Large)
		}
	}, {
		DarkScope = React.createElement(foundationProvider, {
			colorMode = colorMode.Dark
		}, {
			Stack = React.createElement(
				view,
				{ tag = "col align-x-center gap-small size-full-0 auto-y" },
				p2.children
			)
		})
	})
end

local function PlacedToastStacks(props)
	local v5 = useDeviceInsets()
	local v6 = useTokens()

	local elements = {}
	local elements2 = {}
	local flag = false

	for k, toast2 in props.toasts do
		local element = React.createElement(ToastItem, {
			entry = toast2,
			onDismiss = props.onDismiss,
			toastWidth = props.toastWidth
		})

		if toast2.data.placement == "bottom" then
			elements2["Toast_" .. tostring(toast2.id)] = element
			flag = true
		else
			elements["Toast_" .. tostring(toast2.id)] = element
		end
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v8 = {
		Top = React.createElement(view, {
			tag = "col gap-small position-top-center anchor-top-center auto-xy",
			ZIndex = Constants.ZIndex.Toasts,
			padding = {
				top = UDim.new(0, v5.top + v6.Padding.Large),
				left = UDim.new(0, v5.left + v6.Padding.Large),
				right = UDim.new(0, v5.right + v6.Padding.Large)
			}
		}, elements),
		Bottom = 0
	}

	local v9 = if flag then React.createElement(BottomToastStack, {
		children = elements2
	}) else nil
	v8.Bottom = v9
	return createElement(fragment, nil, v8)
end

local function ToastOverlay()
	local v5 = GetToastStore(false)
	local v6 = SignalsReact.useSignalState(v5.getToasts)
	local v7 = useDeviceInsets()
	local v8 = useScreenSize()
	local v9 = useTokens()

	local v10 = React.useCallback(function(p2)
		v5.dismissToast(p2)
	end, { v5.dismissToast })

	if #v6 == 0 then
		return nil
	end

	local udim = UDim.new(0, (math.min(400, v8.X - 40)))

	if fFlagMomentsPostFeedback then
		return React.createElement(PlacedToastStacks, {
			toasts = v6,
			onDismiss = v10,
			toastWidth = udim
		})
	end

	local children = {}

	for k, v11 in v6 do
		children["Toast_" .. tostring(v11.id)] = React.createElement(ToastItem, {
			entry = v11,
			onDismiss = v10,
			toastWidth = udim
		})
	end

	return React.createElement(view, {
		tag = "col gap-small position-top-center anchor-top-center auto-xy",
		ZIndex = Constants.ZIndex.Toasts,
		padding = {
			top = UDim.new(0, v7.top + v9.Padding.Large),
			left = UDim.new(0, v7.left + v9.Padding.Large),
			right = UDim.new(0, v7.right + v9.Padding.Large)
		}
	}, children)
end

return ToastOverlay
