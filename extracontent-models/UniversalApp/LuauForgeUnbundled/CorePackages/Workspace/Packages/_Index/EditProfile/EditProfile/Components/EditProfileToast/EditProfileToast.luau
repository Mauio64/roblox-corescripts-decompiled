local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Foundation")
local snackbar = Foundation.Snackbar
local enums = Foundation.Enums

local function EditProfileToast(p2)
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
		return React.createElement(snackbar, {
			title = p2.text,
			icon = {
				name = enums.IconName.CircleCheck,
				variant = enums.IconVariant.Filled
			},
			Position = UDim2.new(0.5, 0, 0, 50),
			AnchorPoint = Vector2.new(0.5, 0)
		})
	end

	return nil
end

return EditProfileToast
