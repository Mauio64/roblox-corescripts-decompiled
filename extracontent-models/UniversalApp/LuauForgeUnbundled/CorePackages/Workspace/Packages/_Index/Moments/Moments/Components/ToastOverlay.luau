local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local snackbar = Foundation.Snackbar
local toast = Foundation.Toast
local view = Foundation.View

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useScreenSize = MomentsCommon.Hooks.useScreenSize
local useTokens = Foundation.Hooks.useTokens

local GetToastStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetToastStore")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetToastStore/createToastStore")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")

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
