local parent = script.Parent.Parent.Parent

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local React = require(parent.React)

return function()
	local ref = React.useRef(nil)

	React.useEffect(function()
		local shutterSound = Instance.new("Sound")
		shutterSound.Name = "ShutterSound"
		shutterSound.Parent = RobloxGui
		shutterSound.Volume = 1

		if not (_G.__TEST_SUITE_PACKAGE__ or _G.__TESTEZ_RUNNING_TEST__) then
			shutterSound.SoundId = "rbxassetid://10066921516"
		end

		ref.current = shutterSound

		return function()
			ref.current = nil
			shutterSound:Destroy()
		end
	end, {})

	return (React.useCallback(function()
		if ref.current then
			ref.current:Play()
		end
	end, {}))
end
