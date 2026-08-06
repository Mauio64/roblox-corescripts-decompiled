local Foundation = game:GetService("CorePackages").Packages._Index.Foundation.Foundation
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local useScreen = require(Foundation.Providers.Overlay.useScreen)

local function useScreenSize() -- line: 7
	-- upvalues: useScreen (copy), React (copy)
	local v6 = useScreen()
	local v7, v8 = React.useState(v6 and v6.AbsoluteSize or Vector2.new(0, 0))

	React.useLayoutEffect(function() -- line: 11
		-- upvalues: v6 (copy), v8 (copy)
		local connection = nil

		if v6 then
			v8(v6.AbsoluteSize)
			connection = v6:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 16
				-- upvalues: v8 (copy), v6 (copy)
				v8(v6.AbsoluteSize)
			end)
		end

		return function() -- line: 21
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { v6 })

	return v7
end

return useScreenSize
