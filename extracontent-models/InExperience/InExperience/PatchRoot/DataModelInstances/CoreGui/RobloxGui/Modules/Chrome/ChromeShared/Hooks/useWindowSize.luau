local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require(CorePackages.Workspace.Packages.Chrome)

return function(p1) -- line: 7
	-- upvalues: React (copy)
	if p1 and p1.windowSize then
		local windowSize = p1.windowSize
		local v5, v6 = React.useState(windowSize:get())

		React.useEffect(function() -- line: 13
			-- upvalues: windowSize (copy), v6 (copy), v5 (copy)
			local v7 = windowSize:connect(function() -- line: 14
				-- upvalues: v6 (copy), windowSize (copy)
				v6(windowSize:get())
			end)

			if v5 ~= windowSize:get() then
				v6(windowSize:get())
			end

			return function() -- line: 22
				-- upvalues: v7 (copy)
				v7:disconnect()
			end
		end, { p1.id })

		return v5
	end

	warn("windowSize object not found")

	return UDim2.new()
end
