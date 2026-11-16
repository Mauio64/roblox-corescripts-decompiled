local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RoactUtils")
local useDeviceInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Responsive").useDeviceInsets
local shouldUseDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Display").shouldUseDeviceSafeInsets

local fFlagFixOverlayTopInsetForDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").FFlagFixOverlayTopInsetForDeviceSafeInsets

local snackbar = Foundation.Snackbar
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

	local v5 = React.useCallback(function(p2, p3)
		if p3 == Enum.SwipeDirection.Up then
			props.closeSnackbar()
		end
	end, { props.closeSnackbar })

	local v6 = props.buttonText
		and props.onButtonActivated
		and { text = props.buttonText, onActivated = props.onButtonActivated }
		or nil

	local v7 = useSelector(function(p2)
		return p2.GlobalGuiInset or { left = 0, top = 0, right = 0, bottom = 0 }
	end)

	local v8 = useSelector(function(p2)
		return p2.TopBar.statusBarHeight
	end)
	local v9

	if fFlagFixOverlayTopInsetForDeviceSafeInsets then
		local v10 = useDeviceInsets()
		v9 = not shouldUseDeviceSafeInsets and 0 or v10.top
	else
		v9 = 0
	end

	local v10 = useScaledValue(20)
	local position = props.Position or UDim2.new(0.5, 0, 0, v10 + v7.top + v8 + v9)

	local createElement = React.createElement
	local v12 = {
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0),
		Position = position,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Selectable = false,
		Active = true,
		[React.Event.TouchSwipe] = v5
	}

	local createElement2 = React.createElement
	local v15 = { title = props.titleText, icon = props.icon, action = v6, onClose = 0 }

	local v16 = if not props.hideCloseAffordance then props.closeSnackbar else nil
	v15.onClose = v16
	return createElement("Frame", v12, { createElement2(snackbar, v15) })
end

return React.memo(SnackbarWrapper)
