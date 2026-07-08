local Packages = game:GetService("CorePackages").Packages
local React = require(Packages.React)
local Players = game:GetService("Players")

local function useLocalPlayer() -- line: 8
	-- upvalues: React (copy), Players (copy)
	return React.useMemo(function() -- line: 9
		-- upvalues: Players (copy)
		local LocalPlayer = Players.LocalPlayer

		while not LocalPlayer do
			Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			LocalPlayer = Players.LocalPlayer
		end

		assert(LocalPlayer ~= nil)

		return LocalPlayer
	end)
end

return useLocalPlayer
