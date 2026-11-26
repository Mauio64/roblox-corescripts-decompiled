local module = require("@luauforge/deferred/eko")
local useNavigationFocus = require("@luauforge/deferred/ekp").useNavigationFocus

local Players = game:GetService("Players")

local module2 = require("@luauforge/deferred/ekB")

local function useSchoolEntryLiveRefresh()
	local localPlayer = Players.LocalPlayer
	local v5 = not localPlayer and "0" or tostring(localPlayer.UserId)
	local v6 = useNavigationFocus()
	local ref = module.useRef(v6)

	module.useEffect(function(): nil
		if v6 and not ref.current then
			module2(false).refresh(v5)
		end

		ref.current = v6
		return nil
	end, { v6, v5 })
end

return useSchoolEntryLiveRefresh
