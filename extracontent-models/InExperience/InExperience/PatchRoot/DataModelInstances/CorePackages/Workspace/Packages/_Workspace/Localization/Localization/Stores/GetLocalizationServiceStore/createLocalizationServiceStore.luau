local LocalizationService = game:GetService("LocalizationService")
local parent = script:FindFirstAncestor("Localization").Parent

local Signals = require(parent.Signals)

return function()
	local v = {}

	local signal, v2 = Signals.createSignal(LocalizationService.RobloxLocaleId)
	v.robloxLocaleId = LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function()
		v2(LocalizationService.RobloxLocaleId)
	end)

	return {
		getRobloxLocaleId = signal,
		cleanUp = function()
			for _, connection in v do
				connection:Disconnect()
			end

			v = {}
		end
	}
end
