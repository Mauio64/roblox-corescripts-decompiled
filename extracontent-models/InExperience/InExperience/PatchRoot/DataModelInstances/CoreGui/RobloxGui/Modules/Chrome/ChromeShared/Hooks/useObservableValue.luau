local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require(ChromeShared.Service.ChromeUtils)

return function(p1) -- line: 7
	-- upvalues: React (copy)
	if not p1 then
		warn("observableValue undefined")

		return nil
	end

	local v5, v6 = React.useState(p1:get())

	React.useEffect(function() -- line: 14
		-- upvalues: p1 (copy), v6 (copy), v5 (copy)
		local v7 = p1:connect(function() -- line: 15
			-- upvalues: v6 (copy), p1 (copy)
			v6(p1:get())
		end)

		if v5 ~= p1:get() then
			v6(p1:get())
		end

		return function() -- line: 23
			-- upvalues: v7 (copy)
			v7:disconnect()
		end
	end, { p1 })

	return v5
end
