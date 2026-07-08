local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useLocalPlayer = require(script.Parent.useLocalPlayer)

local function usePlayerGui() -- line: 5
	-- upvalues: useLocalPlayer (copy), React (copy)
	local v5 = useLocalPlayer()
	local v6, v7 = React.useState(nil)

	React.useEffect(function() -- line: 9
		-- upvalues: v5 (copy), v7 (copy)
		local connection = nil

		if v5 then
			v7(v5:FindFirstChildOfClass("PlayerGui"))
			connection = v5.ChildAdded:Connect(function(child) -- line: 15
				-- upvalues: v7 (copy)
				if child:IsA("PlayerGui") then
					v7(child)
				end
			end)
		end

		return function() -- line: 22
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { v5 })

	return v6
end

return usePlayerGui
