local parent = script:FindFirstAncestor("MomentsCreation").Parent

local React = require(parent.React)

local UserInputService = game:GetService("UserInputService")

local function readKeyboardTop() -- 1 equivalent call inferred from this helper
	if UserInputService.OnScreenKeyboardVisible then
		return UserInputService.OnScreenKeyboardPosition.Y
	end

	return nil
end

local function useOnScreenKeyboardTop()
	local state, setState = React.useState(readKeyboardTop)

	React.useEffect(function()
		local function update() -- 1 equivalent call inferred from this helper
			setState(readKeyboardTop()) -- inferred equivalent call
		end
		local v = {
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(update),
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(update),
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(update)
		}
		update() -- inferred equivalent call
		return function()
			for _, connection in v do
				connection:Disconnect()
			end
		end
	end, {})

	return state
end

return useOnScreenKeyboardTop
