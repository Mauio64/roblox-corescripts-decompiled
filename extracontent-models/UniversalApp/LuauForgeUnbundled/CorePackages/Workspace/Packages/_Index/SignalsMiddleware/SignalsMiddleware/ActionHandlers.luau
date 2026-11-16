local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/SignalsMiddleware/SignalsExperimental")

return {
	create = function()
		return {}
	end,
	register = function(p2, p3, p4)
		if not p2[p3] then
			p2[p3] = {}
		end

		table.insert(p2[p3], p4)
	end,
	handleAction = function(p2, p3)
		local v5 = p2[p3.type]

		if v5 and #v5 > 0 then
			SignalsExperimental.batch(function()
				for k, v6 in v5 do
					v6(p3)
				end
			end)
		end
	end
}
