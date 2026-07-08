local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local usePlayerGui = require(script.Parent.usePlayerGui)

local function usePlayerCurrentScreenOrientation() -- line: 5
	-- upvalues: usePlayerGui (copy), React (copy)
	local v5 = usePlayerGui()
	local v6, v7 = React.useState(nil)

	React.useEffect(function() -- line: 9
		-- upvalues: v5 (copy), v7 (copy)
		local connection = nil

		if v5 then
			v7(v5.CurrentScreenOrientation)
			connection = v5:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function() -- line: 15
				-- upvalues: v7 (copy), v5 (copy)
				v7(v5.CurrentScreenOrientation)
			end)
		end

		return function() -- line: 20
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { v5 })

	return v6
end

return usePlayerCurrentScreenOrientation
