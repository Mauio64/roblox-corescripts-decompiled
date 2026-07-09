return function(p1) -- line: 1
	local UserGameSettings = UserSettings():GetService("UserGameSettings")

	if UserGameSettings.ReadAloud then
		p1.Enable()
	end

	UserGameSettings:GetPropertyChangedSignal("ReadAloud"):Connect(function() -- line: 9
		-- upvalues: UserGameSettings (copy), p1 (copy)
		if UserGameSettings.ReadAloud then
			p1.Enable()
			p1.ReadSystemTextFromKey("SystemEnabled")

			return
		end

		p1.Disable()
	end)
end
