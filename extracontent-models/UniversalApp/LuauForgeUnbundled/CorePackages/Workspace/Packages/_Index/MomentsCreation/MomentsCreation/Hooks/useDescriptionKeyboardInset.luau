local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local UserInputService = game:GetService("UserInputService")

local computeKeyboardInset = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/computeKeyboardInset")

local function useDescriptionKeyboardInset(p2)
	local v5, v6 = React.useBinding(0)
	local ref = React.useRef(nil)

	local v7 = React.useCallback(function()
		local current = ref.current
		local v8 = current == nil and 0 or current.AbsolutePosition.Y + current.AbsoluteSize.Y
		v6((computeKeyboardInset(
			p2,
			UserInputService.OnScreenKeyboardVisible,
			UserInputService.OnScreenKeyboardPosition.Y,
			v8,
			UserInputService.OnScreenKeyboardSize.Y
		)))
	end, { p2 })

	local v8 = React.useCallback(function(current)
		ref.current = current
		v7()
	end, { v7 })

	React.useEffect(function()
		v7()

		if not p2 then
			return
		end

		local v9 = {
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(v7),
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(v7),
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(v7)
		}

		return function()
			for k, connection in v9 do
				connection:Disconnect()
			end
		end
	end, { p2, v7 })

	return v5, v8
end

return useDescriptionKeyboardInset
