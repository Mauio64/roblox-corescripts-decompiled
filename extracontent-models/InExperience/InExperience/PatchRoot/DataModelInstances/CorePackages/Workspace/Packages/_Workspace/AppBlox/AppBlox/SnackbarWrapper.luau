local parent = script:FindFirstAncestor("AppBlox").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local Responsive = require(parent.Responsive)
local useDeviceInsets = Responsive.useDeviceInsets
local Display = require(parent.Display)
local shouldUseDeviceSafeInsets = Display.shouldUseDeviceSafeInsets

local SharedFlags = require(parent.SharedFlags)
local FFlagFixOverlayTopInsetForDeviceSafeInsets = SharedFlags.FFlagFixOverlayTopInsetForDeviceSafeInsets

local Snackbar = Foundation.Snackbar
local useScaledValue = Foundation.Hooks.useScaledValue
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function SnackbarWrapper(props)
	React.useEffect(function()
		local thread

		if props.autoDismissDelaySeconds then
			thread = task.delay(props.autoDismissDelaySeconds, props.closeSnackbar)
		else
			thread = nil
		end

		return function()
			if thread then
				task.cancel(thread)
				thread = nil
			end
		end
	end, { props.closeSnackbar, props.autoDismissDelaySeconds })

	local v = React.useCallback(function(_, p)
		if p == Enum.SwipeDirection.Up then
			props.closeSnackbar()
		end
	end, { props.closeSnackbar })

	local action = props.buttonText
		and props.onButtonActivated
		and { text = props.buttonText, onActivated = props.onButtonActivated }
		or nil

	local v2 = useSelector(function(p)
		return p.GlobalGuiInset or { left = 0, top = 0, right = 0, bottom = 0 }
	end)

	local v3 = useSelector(function(p)
		return p.TopBar.statusBarHeight
	end)
	local v4

	if FFlagFixOverlayTopInsetForDeviceSafeInsets then
		local v5 = useDeviceInsets()
		v4 = not shouldUseDeviceSafeInsets and 0 or v5.top
	else
		v4 = 0
	end

	local v5 = useScaledValue(20)
	local position = props.Position or UDim2.new(0.5, 0, 0, v5 + v2.top + v3 + v4)

	local createElement = React.createElement
	local v6 = {
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0),
		Position = position,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Selectable = false,
		Active = true,
		[React.Event.TouchSwipe] = v
	}

	local createElement2 = React.createElement
	local v7 = { title = props.titleText, icon = props.icon, action = action, onClose = 0 }
	local onClose

	if not props.hideCloseAffordance then
		onClose = props.closeSnackbar
	end

	v7.onClose = onClose
	return createElement("Frame", v6, { createElement2(Snackbar, v7) })
end

return React.memo(SnackbarWrapper)
