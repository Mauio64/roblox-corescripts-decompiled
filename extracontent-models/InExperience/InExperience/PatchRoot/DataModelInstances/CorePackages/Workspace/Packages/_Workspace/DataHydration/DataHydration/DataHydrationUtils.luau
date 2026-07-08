local Players = game:GetService("Players")

return {
	areAllKeysPresent = function(p1, t1: {[any]: any}) -- line: 12
		if p1 == nil or type(p1) ~= "table" then
			return #t1 == 0
		end

		for _, v6 in t1 do
			if p1[v6] == nil then
				return false
			end
		end

		return true
	end,
	getLocalPlayerUserId = function() -- line: 3
		-- upvalues: Players (copy)
		local v2 = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

		if v2 == nil or v2 <= 0 then
			return nil
		end

		return v2
	end
}
