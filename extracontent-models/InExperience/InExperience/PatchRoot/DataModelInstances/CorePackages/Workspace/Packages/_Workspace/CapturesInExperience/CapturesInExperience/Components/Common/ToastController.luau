local parent = script.Parent.Parent.Parent.Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local Foundation = require(parent.Foundation)

local Toast = Foundation.Toast
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant

local ToastWithIconAction = require(script.Parent.ToastWithIconAction)

local v = { dampingRatio = 1, frequency = 3 }

local udim = UDim.new(0, 296)

local function ToastController(props)
	local state, setState = React.useState(false)

	local v2 = React.useCallback(function()
		if not state then
			props.onDismissed()
		end
	end, { state, props.onDismissed })

	local v3, v4 = ReactOtter.useAnimatedBinding(-200, v2)

	local v5 = React.useCallback(function()
		setState(false)
		v4(ReactOtter.spring(-200, v))
	end, { v4 })

	React.useEffect(function()
		if not props.show then
			v5()

			return
		end

		setState(true)
		v4(ReactOtter.spring(20, v))
	end, { props.show, v4, v5 })

	React.useEffect(function()
		if props.show and props.duration > 0 then
			local thread = task.delay(props.duration, function()
				v5()
			end)
			return function()
				task.cancel(thread)
			end
		end

		return nil
	end, { props.show, props.duration, v5 })

	local onAction = props.onAction
	local actions = React.useMemo(function()
		if props.actionText then
			return {
				{
					text = props.actionText,
					onActivated = function()
						if onAction then
							onAction()
						end

						v5()
					end,
					variant = ButtonVariant.Emphasis
				}
			}
		end

		return nil
	end, { props.actionText, onAction, v5 })

	local iconAction = props.iconAction

	local mapped = v3:map(function(p)
		return UDim2.new(0.5, 0, 0, p)
	end)

	local createElement = React.createElement
	local toast

	if iconAction and actions then
		toast = React.createElement(ToastWithIconAction, {
			title = props.title,
			text = props.text,
			icon = props.icon,
			actionText = actions[1].text,
			onAction = actions[1].onActivated,
			iconActionIcon = iconAction.icon,
			onIconAction = function()
				iconAction.onActivated()
				v5()
			end,
			width = udim
		})
	else
		toast = React.createElement(Toast, {
			title = props.title,
			text = props.text,
			icon = props.icon,
			actions = actions,
			width = udim
		})
	end

	return createElement(View, {
		tag = "size-full-0 auto-y col align-x-center anchor-top-center",
		Position = mapped
	}, {
		Toast = toast
	})
end

return ToastController
