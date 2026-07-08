local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

return function(p1) -- line: 4
	-- upvalues: React (copy)
	local v4, v5 = React.useState(p1:getIsLarge())

	React.useEffect(function() -- line: 7
		-- upvalues: p1 (copy), v5 (copy), v4 (copy)
		local v6 = p1:connect(function() -- line: 8
			-- upvalues: v5 (copy), p1 (copy)
			v5(p1:getIsLarge())
		end)

		if v4 ~= p1:getIsLarge() then
			v5(p1:getIsLarge())
		end

		return function() -- line: 16
			-- upvalues: v6 (copy)
			v6:disconnect()
		end
	end, { p1 })

	return v4
end
