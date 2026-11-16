local LocalizationService = game:GetService("LocalizationService")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Localization/Signals")

return function()
	local v5 = {}

	local signal, v6 = Signals.createSignal(LocalizationService.RobloxLocaleId)
	v5.robloxLocaleId = LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function()
		v6(LocalizationService.RobloxLocaleId)
	end)

	return {
		getRobloxLocaleId = signal,
		cleanUp = function()
			for k, connection in v5 do
				connection:Disconnect()
			end

			v5 = {}
		end
	}
end
