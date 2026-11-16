local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/React")

local MemStorageService = game:GetService("MemStorageService")

local function useGamepadConnectedEvent(callback, callback2)
	React.useEffect(function()
		local connection = MemStorageService:BindAndFire("ActiveGamepadConnected", function(p2)
			if p2 == "false" then
				callback2()
			else
				callback()
			end
		end)

		return function()
			connection:Disconnect()
		end
	end, { callback, callback2 })
end

return useGamepadConnectedEvent
