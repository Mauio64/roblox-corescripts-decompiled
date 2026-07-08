local Responsive = script:FindFirstAncestor("Responsive")
local ResponsiveParent = Responsive.Parent
local React = require(ResponsiveParent.React)
local InputMode = require(Responsive.InputMode)

local function useLastInput() -- line: 6
	-- upvalues: React (copy), InputMode (copy)
	local v6, v7 = React.useState(InputMode.last)

	React.useEffect(function() -- line: 8
		-- upvalues: v7 (copy), InputMode (copy)
		v7(InputMode.last)

		local v8 = InputMode.connect(function() -- line: 10
			-- upvalues: v7 (copy), InputMode (copy)
			v7(InputMode.last)
		end)

		return function() -- line: 13
			-- upvalues: v8 (copy)
			v8:disconnect()
		end
	end, {})

	return v6 or ""
end

return useLastInput
