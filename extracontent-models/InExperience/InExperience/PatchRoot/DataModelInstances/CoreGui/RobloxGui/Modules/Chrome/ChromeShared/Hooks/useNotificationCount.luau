local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require(CorePackages.Workspace.Packages.Chrome)

return function(p1) -- line: 9
	-- upvalues: React (copy)
	if p1 and p1.notification then
		local notification = p1.notification
		local v5, v6 = React.useState(notification:get())

		React.useEffect(function() -- line: 15
			-- upvalues: p1 (copy), v6 (copy), notification (copy)
			local v7 = p1.notification:connect(function() -- line: 16
				-- upvalues: v6 (copy), notification (copy)
				v6(notification:get())
			end)

			return function() -- line: 20
				-- upvalues: v7 (copy)
				v7:disconnect()
			end
		end, { p1.id })

		if v5 and v5.type == "count" then
			return v5.value
		end

		return 0
	end

	warn("notification object not found")

	return 0
end
