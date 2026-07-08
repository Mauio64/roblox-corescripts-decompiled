require(script.Parent.VoiceChatServiceManager)

local function getPlayerPrimaryPart(p1) -- line: 4
	return p1 and (p1.Character and p1.Character.PrimaryPart)
end
local function getPlayerDistanceFrom(p2, vector3: Vector3) -- line: 8
	local v6 = p2 and (p2.Character and p2.Character.PrimaryPart)
	local Magnitude = nil

	if v6 then
		Magnitude = (v6.Position - vector3).Magnitude
	end

	return Magnitude
end

return {
	getComparator = function(vector3: Vector3) -- line: 19
		return function(p3, p4) -- line: 20
			-- upvalues: vector3 (copy)
			local v24 = p3 and (p3.Character and p3.Character.PrimaryPart)
			local v25 = p4 and (p4.Character and p4.Character.PrimaryPart)

			if not v24 and not v25 then
				return p3.Name:lower() < p4.Name:lower()
			end

			if v24 and not v25 then
				return true
			end

			if not v24 and v25 then
				return false
			end

			local v26 = vector3
			local v27 = p3 and (p3.Character and p3.Character.PrimaryPart)
			local Magnitude = nil

			if v27 then
				Magnitude = (v27.Position - v26).Magnitude
			end

			local v29 = vector3
			local v30 = p4 and (p4.Character and p4.Character.PrimaryPart)
			local Magnitude2 = nil

			if v30 then
				Magnitude2 = (v30.Position - v29).Magnitude
			end

			return Magnitude < Magnitude2
		end
	end,
	getSortedPlayers = function(p5, p6, vector3: Vector3, n1: number?, b1: boolean?, p7, b2: boolean?) -- line: 41
		local t1 = {}

		for k, _ in pairs(p6.participants) do
			local PlayerByUserId = p5:GetPlayerByUserId(k)

			if not PlayerByUserId or p7 == PlayerByUserId or not b2 and (not PlayerByUserId or (not PlayerByUserId.Character or not PlayerByUserId.Character.PrimaryPart)) then
				continue
			end

			if n1 and PlayerByUserId then
				local v20 = PlayerByUserId and (PlayerByUserId.Character and PlayerByUserId.Character.PrimaryPart)
				local Magnitude = nil

				if v20 then
					Magnitude = (v20.Position - vector3).Magnitude
				end

				if n1 < Magnitude then
					continue
				end
			end

			if not b1 or p6:getRecentUsersInteractionData()[tostring(PlayerByUserId.UserId)] then
				table.insert(t1, PlayerByUserId)
			end
		end

		table.sort(t1, function(p8, p9) -- line: 20
			-- upvalues: vector3 (copy)
			local v34 = p8 and (p8.Character and p8.Character.PrimaryPart)
			local v35 = p9 and (p9.Character and p9.Character.PrimaryPart)

			if not v34 and not v35 then
				return p8.Name:lower() < p9.Name:lower()
			end

			if v34 and not v35 then
				return true
			end

			if not v34 and v35 then
				return false
			end

			local v36 = vector3
			local v37 = p8 and (p8.Character and p8.Character.PrimaryPart)
			local Magnitude = nil

			if v37 then
				Magnitude = (v37.Position - v36).Magnitude
			end

			local v39 = vector3
			local v40 = p9 and (p9.Character and p9.Character.PrimaryPart)
			local Magnitude3 = nil

			if v40 then
				Magnitude3 = (v40.Position - v39).Magnitude
			end

			return Magnitude < Magnitude3
		end)

		return t1
	end
}
