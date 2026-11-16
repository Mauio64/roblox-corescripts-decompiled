local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Services = require(Foundation.Utility.Wrappers.Services)
local UserInputService = Services.UserInputService

local constants = require(script.Parent.constants)

local function isCaptureKey(keyCode): boolean -- 1 equivalent call inferred from this helper
	return table.find(constants.enter, keyCode) ~= nil or table.find(constants.thumbSwitch, keyCode) ~= nil
end

local function useSliderCaptureKeys(flag: boolean, current)
	local ref = React.useRef(current)
	ref.current = current

	React.useEffect(function()
		if not flag then
			return
		end

		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
			if isCaptureKey(input.KeyCode) then -- inferred equivalent call
				ref.current()
			end
		end)
		return function()
			inputBeganConnection:Disconnect()
		end
	end, { flag })
end

return useSliderCaptureKeys
