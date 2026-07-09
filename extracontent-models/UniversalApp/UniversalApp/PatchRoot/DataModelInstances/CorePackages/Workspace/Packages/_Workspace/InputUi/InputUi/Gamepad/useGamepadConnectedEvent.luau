local Parent = script:FindFirstAncestor("InputUi").Parent
local React = require(Parent.React)
local MemStorageService = game:GetService("MemStorageService")

local function useGamepadConnectedEvent(p1: ((...any) -> ...any), p2: ((...any) -> ...any)) -- line: 12
	-- upvalues: React (copy), MemStorageService (copy)
	React.useEffect(function() -- line: 13
		-- upvalues: MemStorageService (copy), p2 (copy), p1 (copy)
		local v7 = MemStorageService:BindAndFire("ActiveGamepadConnected", function(p3) -- line: 14
			-- upvalues: p2 (copy), p1 (copy)
			if p3 == "false" then
				p2()

				return
			end

			p1()
		end)

		return function() -- line: 22
			-- upvalues: v7 (copy)
			v7:Disconnect()
		end
	end, {
		p1,
		p2
	})
end

return useGamepadConnectedEvent
