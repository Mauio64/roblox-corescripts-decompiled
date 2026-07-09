local Parent = script:FindFirstAncestor("EditProfile").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Snackbar = Foundation.Snackbar
local Enums = Foundation.Enums

local function EditProfileToast(t1: {[any]: any}) -- line: 12
	-- upvalues: React (copy), Snackbar (copy), Enums (copy)
	local v8, v9 = React.useState(true)
	local v10 = React.useRef(nil)

	React.useEffect(function() -- line: 18
		-- upvalues: v10 (copy), v9 (copy)
		if v10.current then
			task.cancel(v10.current)
		end

		v10.current = task.delay(5, function() -- line: 25
			-- upvalues: v9 (copy)
			v9(false)
		end)

		return function() -- line: 30
			-- upvalues: v10 (copy)
			if v10.current then
				task.cancel(v10.current)
				v10.current = nil
			end
		end
	end, {})

	if v8 then
		return React.createElement(Snackbar, {
			title = t1.text,
			icon = {
				name = Enums.IconName.CircleCheck,
				variant = Enums.IconVariant.Filled
			},
			Position = UDim2.new(0.5, 0, 0, 50),
			AnchorPoint = Vector2.new(0.5, 0)
		})
	end

	return nil
end

return EditProfileToast
