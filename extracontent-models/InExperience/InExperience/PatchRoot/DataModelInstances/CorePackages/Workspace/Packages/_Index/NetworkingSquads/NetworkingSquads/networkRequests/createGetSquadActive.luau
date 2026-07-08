local SQUAD_URL = require(script.Parent.Parent.SQUAD_URL)

require(script.Parent.Parent.networkingSquadTypes)

return function(p1) -- line: 5
	-- upvalues: SQUAD_URL (copy)
	local roduxNetworking = p1.roduxNetworking
	local t1 = nil
	local v5 = roduxNetworking.GET({
		Name = "GetSquadActive"
	}, function(p2, p3) -- line: 11
		-- upvalues: p1 (copy), t1 (ref), SQUAD_URL (copy)
		if p1.useMockedResponse then
			t1 = {
				responseBody = {
					groupUp = p3.mockedSquad
				}
			}
		end

		return p2(SQUAD_URL):path("group-up"):path("v1"):path("active-status")
	end)

	if p1.useMockedResponse then
		v5.Mock.clear()
		v5.Mock.reply(function() -- line: 26
			-- upvalues: t1 (ref)
			return t1
		end)
	end

	return v5
end
