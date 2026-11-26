return function(data)
	local UserGameSettings = UserSettings():GetService("UserGameSettings")

	if UserGameSettings.ReadAloud then
		data.Enable()
	end

	UserGameSettings:GetPropertyChangedSignal("ReadAloud"):Connect(function()
		if not UserGameSettings.ReadAloud then
			data.Disable()

			return
		end

		data.Enable()
		data.ReadSystemTextFromKey("SystemEnabled")
	end)
end
