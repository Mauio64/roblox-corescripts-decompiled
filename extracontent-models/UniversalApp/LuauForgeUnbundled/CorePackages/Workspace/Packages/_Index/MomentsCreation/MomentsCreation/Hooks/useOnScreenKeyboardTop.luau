local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local UserInputService = game:GetService("UserInputService")

local function readKeyboardTop()
	if UserInputService.OnScreenKeyboardVisible then
		return UserInputService.OnScreenKeyboardPosition.Y
	end

	return nil
end

local function useOnScreenKeyboardTop()
	local state, setState = React.useState(readKeyboardTop)

	React.useEffect(function()
		local function update()
			local v6 = if UserInputService.OnScreenKeyboardVisible then UserInputService.OnScreenKeyboardPosition.Y else nil

			setState(v6)
		end
		local v5 = {
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(update),
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(update),
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(update)
		}
		local v7 = if UserInputService.OnScreenKeyboardVisible then UserInputService.OnScreenKeyboardPosition.Y else nil

		setState(v7)

		return function()
			for k, connection in v5 do
				connection:Disconnect()
			end
		end
	end, {})

	return state
end

return useOnScreenKeyboardTop
