local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require(ChromeShared.Service.ChromeUtils)

return function(p1, p2: ((...any) -> ...any)) -- line: 11
	-- upvalues: React (copy)
	if not p1 then
		warn("observableValue undefined")

		return nil
	end

	local v6, v7 = React.useState(p2(p1:get()))

	React.useEffect(function() -- line: 18
		-- upvalues: p1 (copy), v7 (copy), p2 (copy), v6 (copy)
		local v8 = p1:connect(function() -- line: 19
			-- upvalues: v7 (copy), p2 (copy), p1 (copy)
			v7(p2(p1:get()))
		end)
		local v9 = p2(p1:get())

		if v9 ~= v6 then
			v7(v9)
		end

		return function() -- line: 28
			-- upvalues: v8 (copy)
			v8:disconnect()
		end
	end, { p1 })

	return v6
end
