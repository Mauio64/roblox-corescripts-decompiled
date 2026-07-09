local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local Dash = require(ParentParentParent.Dash)
local React = require(ParentParentParent.React)
local FFlagCapturesUpdateUsePlayShutterSoundTesting = require(ParentParent.Flags.FFlagCapturesUpdateUsePlayShutterSoundTesting)

return function() -- line: 17
	-- upvalues: FFlagCapturesUpdateUsePlayShutterSoundTesting (copy), Dash (copy), React (copy), RobloxGui (copy)
	if not FFlagCapturesUpdateUsePlayShutterSoundTesting and (_G.__TEST_SUITE_PACKAGE__ or _G.__TESTEZ_RUNNING_TEST__) then
		return Dash.noop
	end

	local v7 = React.useRef(nil)

	React.useEffect(function() -- line: 27
		-- upvalues: FFlagCapturesUpdateUsePlayShutterSoundTesting (copy), RobloxGui (copy), v7 (copy)
		local Sound = Instance.new("Sound")

		Sound.Name = not FFlagCapturesUpdateUsePlayShutterSoundTesting and "ShutterSound" or "ShutterSound"
		Sound.Parent = RobloxGui
		Sound.Volume = not FFlagCapturesUpdateUsePlayShutterSoundTesting and 1 or 1

		if not FFlagCapturesUpdateUsePlayShutterSoundTesting then
			Sound.SoundId = "rbxassetid://10066921516"
		end

		v7.current = Sound

		if FFlagCapturesUpdateUsePlayShutterSoundTesting and not _G.__TEST_SUITE_PACKAGE__ and not _G.__TESTEZ_RUNNING_TEST__ then
			Sound.SoundId = "rbxassetid://10066921516"
		end

		return function() -- line: 44
			-- upvalues: v7 (copy), Sound (copy)
			v7.current = nil
			Sound:Destroy()
		end
	end, {})

	return (React.useCallback(function() -- line: 50
		-- upvalues: v7 (copy)
		if v7.current then
			v7.current:Play()
		end
	end, {}))
end
