local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local FoundationProvider = Foundation.FoundationProvider
local Snackbar = Foundation.Snackbar
local Toast = Foundation.Toast
local View = Foundation.View

local ColorMode = Foundation.Enums.ColorMode

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useScreenSize = MomentsCommon.Hooks.useScreenSize
local useTokens = Foundation.Hooks.useTokens

local GetToastStore = require(Moments.Stores.GetToastStore)
require(Moments.Stores.GetToastStore.createToastStore)

local Constants = require(Moments.Constants)
local momentLayout = require(Moments.Components.Feed.Items.Moment.momentLayout)
local useScreenBottomInset = require(Moments.Hooks.useScreenBottomInset)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsPostFeedback = SharedFlags.FFlagMomentsPostFeedback

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
		return React.createElement(Snackbar, { title = entry.data.title, LayoutOrder = entry.id })
	end

	local createElement = React.createElement
	local v = { title = entry.data.title, text = 0, LayoutOrder = 0, width = 0 }
	local text

	if entry.data.text ~= "" then
		text = entry.data.text
	end

	v.text = text
	v.LayoutOrder = entry.id
	v.width = props.toastWidth
	return createElement(Toast, v)
end

local function BottomToastStack(p)
	local v = useDeviceInsets()
	local v2 = useTokens()

	local v3 = useScreenBottomInset()

	local v4 = v3 + momentLayout.getInfoBottomGap(v2, v3, v.bottom) + v2.Padding.Large - v2.Padding.Medium

	return React.createElement(View, {
		tag = "position-bottom-center anchor-bottom-center size-full-0 auto-y",
		ZIndex = Constants.ZIndex.Toasts,
		padding = {
			bottom = UDim.new(0, v4),
			left = UDim.new(0, v.left + v2.Padding.Large),
			right = UDim.new(0, v.right + v2.Padding.Large)
		}
	}, {
		DarkScope = React.createElement(FoundationProvider, { colorMode = ColorMode.Dark }, {
			Stack = React.createElement(View, {
				tag = "col align-x-center gap-small size-full-0 auto-y"
			}, p.children)
		})
	})
end

local function PlacedToastStacks(props)
	local v = useDeviceInsets()
	local v2 = useTokens()

	local elements = {}
	local elements2 = {}
	local flag = false

	for _, toast in props.toasts do
		local element = React.createElement(ToastItem, {
			entry = toast,
			onDismiss = props.onDismiss,
			toastWidth = props.toastWidth
		})

		if toast.data.placement == "bottom" then
			elements2["Toast_" .. tostring(toast.id)] = element
			flag = true
		else
			elements["Toast_" .. tostring(toast.id)] = element
		end
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v3 = {
		Top = React.createElement(View, {
			tag = "col gap-small position-top-center anchor-top-center auto-xy",
			ZIndex = Constants.ZIndex.Toasts,
			padding = {
				top = UDim.new(0, v.top + v2.Padding.Large),
				left = UDim.new(0, v.left + v2.Padding.Large),
				right = UDim.new(0, v.right + v2.Padding.Large)
			}
		}, elements),
		Bottom = 0
	}
	local bottom

	if flag then
		bottom = React.createElement(BottomToastStack, { children = elements2 })
	end

	v3.Bottom = bottom
	return createElement(fragment, nil, v3)
end

local function ToastOverlay()
	local toastStore = GetToastStore(false)
	local toasts = SignalsReact.useSignalState(toastStore.getToasts)
	local v = useDeviceInsets()
	local v2 = useScreenSize()
	local v3 = useTokens()

	local onDismiss = React.useCallback(function(p: number)
		toastStore.dismissToast(p)
	end, { toastStore.dismissToast })

	if #toasts == 0 then
		return nil
	end

	local udim = UDim.new(0, (math.min(400, v2.X - 40)))

	if FFlagMomentsPostFeedback then
		return React.createElement(PlacedToastStacks, {
			toasts = toasts,
			onDismiss = onDismiss,
			toastWidth = udim
		})
	end

	local children = {}

	for _, entry in toasts do
		children["Toast_" .. tostring(entry.id)] = React.createElement(ToastItem, {
			entry = entry,
			onDismiss = onDismiss,
			toastWidth = udim
		})
	end

	return React.createElement(View, {
		tag = "col gap-small position-top-center anchor-top-center auto-xy",
		ZIndex = Constants.ZIndex.Toasts,
		padding = {
			top = UDim.new(0, v.top + v3.Padding.Large),
			left = UDim.new(0, v.left + v3.Padding.Large),
			right = UDim.new(0, v.right + v3.Padding.Large)
		}
	}, children)
end

return ToastOverlay
