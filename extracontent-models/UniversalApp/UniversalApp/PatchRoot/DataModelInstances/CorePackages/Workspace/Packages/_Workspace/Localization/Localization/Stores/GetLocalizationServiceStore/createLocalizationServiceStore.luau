local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("Localization").Parent
local Signals = require(Parent.Signals)

return function() -- line: 12
	-- upvalues: Signals (copy), LocalizationService (copy)
	local t1 = {}
	local v5, v6 = Signals.createSignal(LocalizationService.RobloxLocaleId)

	t1.robloxLocaleId = LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function() -- line: 16
		-- upvalues: v6 (copy), LocalizationService (copy)
		v6(LocalizationService.RobloxLocaleId)
	end)

	return {
		getRobloxLocaleId = v5,
		cleanUp = function() -- line: 23
			-- upvalues: t1 (ref)
			for _, v8 in t1 do
				v8:Disconnect()
			end

			t1 = {}
		end
	}
end
