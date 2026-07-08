local CorePackages = game:GetService("CorePackages")
local StarterGui = game:GetService("StarterGui")
local React = require(CorePackages.Packages.React)

function useCoreGuiEnabled(p1) -- line: 5
	-- upvalues: React (copy), StarterGui (copy)
	local v5, v6 = React.useState(StarterGui:GetCoreGuiEnabled(p1))

	React.useEffect(function() -- line: 7
		-- upvalues: StarterGui (copy), p1 (copy), v6 (copy)
		local connection = StarterGui.CoreGuiChangedSignal:Connect(function(p2, b1: boolean) -- line: 9
			-- upvalues: p1 (copy), v6 (copy)
			if p2 == p1 then
				v6(b1)
			end
		end)

		v6(StarterGui:GetCoreGuiEnabled(p1))

		return function() -- line: 16
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { p1 })

	return v5
end

return useCoreGuiEnabled
