local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local React = require(parent.React)

local UserInputService = game:GetService("UserInputService")

local computeKeyboardInset = require(MomentsCreation.Utils.computeKeyboardInset)

local function useDescriptionKeyboardInset(flag: boolean)
	local v, v2 = React.useBinding(0)
	local ref = React.useRef(nil)

	local v3 = React.useCallback(function()
		local current = ref.current
		local v3 = current == nil and 0 or current.AbsolutePosition.Y + current.AbsoluteSize.Y
		v2((computeKeyboardInset(
			flag,
			UserInputService.OnScreenKeyboardVisible,
			UserInputService.OnScreenKeyboardPosition.Y,
			v3,
			UserInputService.OnScreenKeyboardSize.Y
		)))
	end, { flag })

	local v4 = React.useCallback(function(current)
		ref.current = current
		v3()
	end, { v3 })

	React.useEffect(function()
		v3()

		if not flag then
			return
		end

		local v5 = {
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(v3),
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(v3),
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(v3)
		}

		return function()
			for _, connection in v5 do
				connection:Disconnect()
			end
		end
	end, { flag, v3 })

	return v, v4
end

return useDescriptionKeyboardInset
