local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require(ChromeShared.Service.ChromeUtils)

return function(p1, p2: ((...any) -> ...any)?) -- line: 7
	-- upvalues: React (copy)
	if not p1 then
		warn("observableValue undefined")

		return React.useBinding(nil)
	end

	local u6 = p2 or function(p3) -- line: 17
		return p3
	end
	local v7, v8 = React.useBinding(u6(p1:get()))

	React.useEffect(function() -- line: 24
		-- upvalues: p1 (copy), v8 (copy), u6 (ref)
		local v10 = p1:connect(function() -- line: 25
			-- upvalues: v8 (copy), u6 (ref), p1 (copy)
			v8(u6(p1:get()))
		end)

		v8(u6(p1:get()))

		return function() -- line: 31
			-- upvalues: v10 (copy)
			v10:disconnect()
		end
	end, { p1 })

	return v7
end
