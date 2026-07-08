local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)

local function useRobloxLocale() -- line: 7
	-- upvalues: React (copy), LocalizationService (copy)
	local v5, v6 = React.useState(LocalizationService.RobloxLocaleId)

	React.useEffect(function() -- line: 10
		-- upvalues: LocalizationService (copy), v6 (copy)
		local connection = LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function() -- line: 11
			-- upvalues: v6 (copy), LocalizationService (copy)
			v6(LocalizationService.RobloxLocaleId)
		end)

		return function() -- line: 15
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	return v5
end

return useRobloxLocale
