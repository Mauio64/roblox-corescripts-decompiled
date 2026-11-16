local parent = script:FindFirstAncestor("EditProfile").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Snackbar = Foundation.Snackbar
local Enums = Foundation.Enums

local function EditProfileToast(p)
	local state, setState = React.useState(true)

	local ref = React.useRef(nil)
	React.useEffect(function()
		if ref.current then
			task.cancel(ref.current)
		end

		ref.current = task.delay(5, function()
			setState(false)
		end)

		return function()
			if ref.current then
				task.cancel(ref.current)
				ref.current = nil
			end
		end
	end, {})

	if state then
		return React.createElement(Snackbar, {
			title = p.text,
			icon = { name = Enums.IconName.CircleCheck, variant = Enums.IconVariant.Filled },
			Position = UDim2.new(0.5, 0, 0, 50),
			AnchorPoint = Vector2.new(0.5, 0)
		})
	end

	return nil
end

return EditProfileToast
