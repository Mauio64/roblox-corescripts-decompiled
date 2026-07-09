local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local React = require(MomentsParent.React)
local SignalsReact = require(MomentsParent.SignalsReact)
local Toast = Foundation.Toast
local View = Foundation.View
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useScreenSize = MomentsCommon.Hooks.useScreenSize
local useTokens = Foundation.Hooks.useTokens
local GetToastStore = require(Moments.Stores.GetToastStore)
local Constants = require(Moments.Constants)

local function ToastItem(t1: {[any]: any}) -- line: 35
	-- upvalues: React (copy), Toast (copy)
	local entry = t1.entry
	local onDismiss = t1.onDismiss

	React.useEffect(function() -- line: 41
		-- upvalues: onDismiss (copy), entry (copy)
		local thread = task.delay(3, function() -- line: 42
			-- upvalues: onDismiss (copy), entry (copy)
			onDismiss(entry.id)
		end)

		return function() -- line: 45
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {
		entry.id,
		onDismiss
	})

	return React.createElement(Toast, {
		title = entry.data.title,
		text = if entry.data.text == "" then nil else entry.data.text,
		LayoutOrder = entry.id,
		width = t1.toastWidth
	})
end
local function ToastOverlay() -- line: 58
	-- upvalues: GetToastStore (copy), SignalsReact (copy), useDeviceInsets (copy), useScreenSize (copy), useTokens (copy), React (copy), ToastItem (copy), View (copy), Constants (copy)
	local v19 = GetToastStore(false)
	local v20 = SignalsReact.useSignalState(v19.getToasts)
	local v21 = useDeviceInsets()
	local v22 = useScreenSize()
	local v23 = useTokens()
	local v24 = React.useCallback(function(n1: number) -- line: 65
		-- upvalues: v19 (copy)
		v19.dismissToast(n1)
	end, { v19.dismissToast })

	if #v20 == 0 then
		return nil
	end

	local uDim = UDim.new(0, (math.min(400, v22.X - 40)))
	local t2 = {}

	for _, v28 in v20 do
		t2["Toast_" .. tostring(v28.id)] = React.createElement(ToastItem, {
			entry = v28,
			onDismiss = v24,
			toastWidth = uDim
		})
	end

	return React.createElement(View, {
		tag = "col gap-small position-top-center anchor-top-center auto-xy",
		ZIndex = Constants.ZIndex.Toasts,
		padding = {
			top = UDim.new(0, v21.top + v23.Padding.Large),
			left = UDim.new(0, v21.left + v23.Padding.Large),
			right = UDim.new(0, v21.right + v23.Padding.Large)
		}
	}, t2)
end

return ToastOverlay
