local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local Snackbar = Foundation.Snackbar
local Toast = Foundation.Toast
local View = Foundation.View

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useScreenSize = MomentsCommon.Hooks.useScreenSize
local useTokens = Foundation.Hooks.useTokens

local GetToastStore = require(Moments.Stores.GetToastStore)
require(Moments.Stores.GetToastStore.createToastStore)

local Constants = require(Moments.Constants)

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

local function ToastOverlay()
	local toastStore = GetToastStore(false)
	local v = SignalsReact.useSignalState(toastStore.getToasts)
	local v2 = useDeviceInsets()
	local v3 = useScreenSize()
	local v4 = useTokens()

	local onDismiss = React.useCallback(function(p: number)
		toastStore.dismissToast(p)
	end, { toastStore.dismissToast })

	if #v == 0 then
		return nil
	end

	local udim = UDim.new(0, (math.min(400, v3.X - 40)))

	local children = {}

	for _, entry in v do
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
			top = UDim.new(0, v2.top + v4.Padding.Large),
			left = UDim.new(0, v2.left + v4.Padding.Large),
			right = UDim.new(0, v2.right + v4.Padding.Large)
		}
	}, children)
end

return ToastOverlay
