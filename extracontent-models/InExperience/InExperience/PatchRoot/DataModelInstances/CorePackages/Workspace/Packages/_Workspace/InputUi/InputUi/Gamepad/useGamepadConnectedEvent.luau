local parent = script:FindFirstAncestor("InputUi").Parent
local React = require(parent.React)

local MemStorageService = game:GetService("MemStorageService")

local function useGamepadConnectedEvent(callback, callback2)
	React.useEffect(function()
		local connection = MemStorageService:BindAndFire("ActiveGamepadConnected", function(p)
			if p == "false" then
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
