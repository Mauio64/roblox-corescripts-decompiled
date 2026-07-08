local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local ReactOtter = require(ParentParent.ReactOtter)
local Foundation = require(ParentParent.Foundation)
local Toast = Foundation.Toast
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local t1 = {
	dampingRatio = 1,
	frequency = 3
}
local uDim = UDim.new(0, 296)

local function ToastController(t2: {[any]: any}) -- line: 36
	-- upvalues: React (copy), ReactOtter (copy), t1 (copy), ButtonVariant (copy), View (copy), Toast (copy), uDim (copy)
	local v12, v13 = React.useState(false)
	local v14 = React.useCallback(function() -- line: 39
		-- upvalues: v12 (copy), t2 (copy)
		if not v12 then
			t2.onDismissed()
		end
	end, {
		v12,
		t2.onDismissed
	})
	local v15, v16 = ReactOtter.useAnimatedBinding(-200, v14)
	local v17 = React.useCallback(function() -- line: 47
		-- upvalues: v13 (copy), v16 (copy), ReactOtter (copy), t1 (copy)
		v13(false)
		v16(ReactOtter.spring(-200, t1))
	end, { v16 })

	React.useEffect(function() -- line: 52
		-- upvalues: t2 (copy), v13 (copy), v16 (copy), ReactOtter (copy), t1 (copy), v17 (copy)
		if t2.show then
			v13(true)
			v16(ReactOtter.spring(20, t1))

			return
		end

		v17()
	end, {
		t2.show,
		v16,
		v17
	})
	React.useEffect(function() -- line: 61
		-- upvalues: t2 (copy), v17 (copy)
		if t2.show and t2.duration > 0 then
			local thread = task.delay(t2.duration, function() -- line: 63
				-- upvalues: v17 (copy)
				v17()
			end)

			return function() -- line: 66
				-- upvalues: thread (copy)
				task.cancel(thread)
			end
		end

		return nil
	end, {
		t2.show,
		t2.duration,
		v17
	})

	local onAction = t2.onAction
	local v19 = React.useMemo(function() -- line: 74
		-- upvalues: t2 (copy), onAction (copy), v17 (copy), ButtonVariant (copy)
		if not t2.actionText then
			return nil
		end

		return {{
			text = t2.actionText,
			onActivated = function() -- line: 81
				-- upvalues: onAction (copy), v17 (copy)
				if onAction then
					onAction()
				end

				v17()
			end,
			variant = ButtonVariant.Emphasis
		}}
	end, {
		t2.actionText,
		onAction,
		v17
	})
	local v20 = v15:map(function(p1) -- line: 92
		return UDim2.new(0.5, 0, 0, p1)
	end)

	return React.createElement(View, {
		tag = "size-full-0 auto-y col align-x-center anchor-top-center",
		Position = v20
	}, {
		Toast = React.createElement(Toast, {
			title = t2.title,
			text = t2.text,
			icon = t2.icon,
			actions = v19,
			width = uDim
		})
	})
end

return ToastController
