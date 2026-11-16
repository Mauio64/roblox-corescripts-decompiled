local CorePackages = game:GetService("CorePackages")
local StarterGui = game:GetService("StarterGui")
local React = require(CorePackages.Packages.React)

function useCoreGuiEnabled(p)
	local state, setState = React.useState(StarterGui:GetCoreGuiEnabled(p))
	React.useEffect(function()
		local coreGuiChangedSignalConnection = StarterGui.CoreGuiChangedSignal:Connect(function(p2, flag: boolean)
			if p2 == p then
				setState(flag)
			end
		end)

		setState(StarterGui:GetCoreGuiEnabled(p))
		return function()
			coreGuiChangedSignalConnection:Disconnect()
		end
	end, { p })
	return state
end

return useCoreGuiEnabled
