local FoundationParent = game:GetService("CorePackages").Packages._Index.Foundation.Foundation.Parent
local React = require(FoundationParent.React)
local getHardwareSafeAreaInsets = require(script.Parent.getHardwareSafeAreaInsets)

local function useHardwareInsets(p1) -- line: 7
	-- upvalues: React (copy), getHardwareSafeAreaInsets (copy)
	local v6, v7 = React.useState(getHardwareSafeAreaInsets)

	React.useEffect(function() -- line: 10
		-- upvalues: p1 (copy), v7 (copy), getHardwareSafeAreaInsets (copy)
		local connection = nil

		if p1 then
			connection = p1:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 14
				-- upvalues: v7 (copy), getHardwareSafeAreaInsets (copy)
				v7(function(p2) -- line: 15
					-- upvalues: getHardwareSafeAreaInsets (copy)
					local v10 = getHardwareSafeAreaInsets()

					if v10.bottom ~= p2.bottom or (v10.top ~= p2.top or v10.left ~= p2.left or v10.right ~= p2.right) then
						return v10
					end

					return p2
				end)
			end)
		end

		return function() -- line: 31
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, { p1 })

	return v6
end

return useHardwareInsets
