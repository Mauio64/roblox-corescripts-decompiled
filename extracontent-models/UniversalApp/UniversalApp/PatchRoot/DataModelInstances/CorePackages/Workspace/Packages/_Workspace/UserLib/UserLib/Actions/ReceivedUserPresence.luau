local Parent = script:FindFirstAncestor("UserLib").Parent
local makeActionCreator = require(Parent.Rodux).makeActionCreator
local DateTime = require(Parent.Time).DateTime

return makeActionCreator(script.Name, function(p1, p2, p3, p4, p5, p6, p7, p8, p9) -- line: 10
	-- upvalues: DateTime (copy)
	local n1 = 0

	if p7 ~= nil then
		local v14 = DateTime.fromIsoDate(p7)

		if v14 ~= nil then
			n1 = v14:GetUnixTimestamp()
		end
	end

	return {
		userId = p1,
		presence = p2,
		lastLocation = p3,
		placeId = p4,
		rootPlaceId = p5,
		gameInstanceId = p6,
		lastOnline = n1,
		universeId = p8,
		previousUniverseId = p9
	}
end)
