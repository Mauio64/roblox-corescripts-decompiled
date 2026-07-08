local Parent = script:FindFirstAncestor("AppBlox").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local RoactUtils = require(Parent.RoactUtils)
local Snackbar = Foundation.Snackbar
local useScaledValue = Foundation.Hooks.useScaledValue
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function SnackbarWrapper(t1: {[any]: any}) -- line: 39
	-- upvalues: React (copy), useSelector (copy), useScaledValue (copy), Snackbar (copy)
	React.useEffect(function() -- line: 41
		-- upvalues: t1 (copy)
		local thread = nil

		if t1.autoDismissDelaySeconds then
			thread = task.delay(t1.autoDismissDelaySeconds, t1.closeSnackbar)
		end

		return function() -- line: 48
			-- upvalues: thread (ref)
			if thread then
				task.cancel(thread)
				thread = nil
			end
		end
	end, {
		t1.closeSnackbar,
		t1.autoDismissDelaySeconds
	})

	local v10 = React.useCallback(function(_, p2) -- line: 56
		-- upvalues: t1 (copy)
		if p2 == Enum.SwipeDirection.Up then
			t1.closeSnackbar()
		end
	end, { t1.closeSnackbar })
	local v11 = if not t1.buttonText or not t1.onButtonActivated then nil else {
		text = t1.buttonText,
		onActivated = t1.onButtonActivated
	}
	local v12 = useSelector(function(p3) -- line: 68
		return p3.GlobalGuiInset or {
			left = 0,
			top = 0,
			right = 0,
			bottom = 0
		}
	end)
	local v13 = useSelector(function(p4) -- line: 77
		return p4.TopBar.statusBarHeight
	end)
	local v14 = useScaledValue(20)
	local v15 = t1.Position or UDim2.new(0.5, 0, 0, v14 + v12.top + v13)

	return React.createElement("Frame", {
		AnchorPoint = t1.AnchorPoint or Vector2.new(0.5, 0),
		Position = v15,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Selectable = false,
		Active = true,
		[React.Event.TouchSwipe] = v10
	}, { React.createElement(Snackbar, {
		title = t1.titleText,
		icon = t1.icon,
		action = v11,
		onClose = if not t1.hideCloseAffordance then t1.closeSnackbar else nil
	}) })
end

return React.memo(SnackbarWrapper)
