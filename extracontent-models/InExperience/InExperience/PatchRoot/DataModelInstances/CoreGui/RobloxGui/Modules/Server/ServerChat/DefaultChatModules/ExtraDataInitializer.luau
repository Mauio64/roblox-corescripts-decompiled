local t1 = {
	Groups = {{
		GroupId = 1200769,
		ChatColor = Color3.new(1, 0.8431372549019608, 0)
	}},
	Players = {{}}
}

local function MakeIsInGroup(p1, p2) -- line: 23
	assert(type(p2) == "nil" or type(p2) == "number", "requiredRank must be a number or nil")

	return function(p3) -- line: 26
		-- upvalues: p2 (copy), p1 (copy)
		if p3 and p3.UserId then
			local _ = p3.UserId
			local u30 = false
			local ok, result = pcall(function() -- line: 31
				-- upvalues: p2 (copy), u30 (ref), p3 (copy), p1 (copy)
				if p2 then
					u30 = p3:GetRankInGroup(p1) > p2

					return
				end

				u30 = p3:IsInGroup(p1)
			end)

			if not ok and result then
				print("Error checking in group: " .. result)
			end

			return u30
		end

		return false
	end
end
local function ConstructIsInGroups() -- line: 49
	-- upvalues: t1 (copy)
	if t1.Groups then
		for _, v in pairs(t1.Groups) do
			local GroupId = v.GroupId
			local Rank = v.Rank

			assert(type(Rank) == "nil" or type(Rank) == "number", "requiredRank must be a number or nil")

			function v.IsInGroup(p4) -- line: 26
				-- upvalues: Rank (copy), GroupId (copy)
				if p4 and p4.UserId then
					local _ = p4.UserId
					local u35 = false
					local ok, result = pcall(function() -- line: 31
						-- upvalues: Rank (copy), u35 (ref), p4 (copy), GroupId (copy)
						if Rank then
							u35 = p4:GetRankInGroup(GroupId) > Rank

							return
						end

						u35 = p4:IsInGroup(GroupId)
					end)

					if not ok and result then
						print("Error checking in group: " .. result)
					end

					return u35
				end

				return false
			end
		end
	end
end

ConstructIsInGroups()

local Players = game:GetService("Players")

local function GetSpecialChatColor(p5) -- line: 60
	-- upvalues: t1 (copy), Players (copy)
	if t1.Players then
		local p5_2 = Players:FindFirstChild(p5)

		if p5_2 then
			for _, v in pairs(t1.Players) do
				if p5_2.UserId == v.UserId then
					return v.ChatColor
				end
			end
		end
	end

	if t1.Groups then
		for _, v in pairs(t1.Groups) do
			if v.IsInGroup(Players:FindFirstChild(p5)) then
				return v.ChatColor
			end
		end
	end
end
local function Run(p6) -- line: 80
	-- upvalues: GetSpecialChatColor (copy), Players (copy)
	local t2 = {
		Color3.new(0.9921568627450981, 0.1607843137254902, 0.2627450980392157),
		Color3.new(0.00392156862745098, 0.6352941176470588, 1),
		Color3.new(0.00784313725490196, 0.7215686274509804, 0.3411764705882353),
		BrickColor.new("Bright violet").Color,
		BrickColor.new("Bright orange").Color,
		BrickColor.new("Bright yellow").Color,
		BrickColor.new("Light reddish violet").Color,
		BrickColor.new("Brick yellow").Color
	}

	local function GetNameValue(p7) -- line: 93
		local n1 = 0

		for i = 1, #p7 do
			local byte = string.byte((string.sub(p7, i, i)))
			local v42 = #p7 - i + 1

			if #p7 % 2 == 1 then
				v42 -= 1
			end

			if v42 % 4 >= 2 then
				byte = -byte
			end

			n1 += byte
		end

		return n1
	end
	local function ComputeNameColor(p8) -- line: 110
		-- upvalues: t2 (copy), GetNameValue (copy)
		return t2[(GetNameValue(p8) + 0) % #t2 + 1]
	end
	local function GetNameColor(p9) -- line: 114
		-- upvalues: t2 (copy), GetNameValue (copy)
		local Player = p9:GetPlayer()

		if Player and Player.Team ~= nil then
			return Player.TeamColor.Color
		end

		local p9Name = p9.Name

		return t2[(GetNameValue(p9Name) + 0) % #t2 + 1]
	end
	local function onNewSpeaker(p10) -- line: 124
		-- upvalues: p6 (copy), t2 (copy), GetNameValue (copy), GetSpecialChatColor (copy)
		local Speaker = p6:GetSpeaker(p10)

		if not Speaker:GetExtraData("NameColor") then
			local Player = Speaker:GetPlayer()
			local TeamColorColor

			if Player and Player.Team ~= nil then
				TeamColorColor = Player.TeamColor.Color
			else
				local SpeakerName = Speaker.Name

				TeamColorColor = t2[(GetNameValue(SpeakerName) + 0) % #t2 + 1]
			end

			Speaker:SetExtraData("NameColor", TeamColorColor)
		end

		if not Speaker:GetExtraData("ChatColor") then
			local v52 = GetSpecialChatColor(p10)

			if v52 then
				Speaker:SetExtraData("ChatColor", v52)
			end
		end

		if not Speaker:GetExtraData("Tags") then
			Speaker:SetExtraData("Tags", {})
		end
	end

	p6.SpeakerAdded:connect(onNewSpeaker)

	for _, v in pairs(p6:GetSpeakerList()) do
		onNewSpeaker(v)
	end

	local t3 = {}

	Players.PlayerAdded:connect(function(p11) -- line: 161
		-- upvalues: p6 (copy), t2 (copy), GetNameValue (copy), t3 (copy)
		t3[p11] = p11.Changed:connect(function(p12) -- line: 162
			-- upvalues: p6 (copy), p11 (copy), t2 (copy), GetNameValue (copy)
			local Speaker = p6:GetSpeaker(p11.Name)

			if Speaker and (p12 == "TeamColor" or p12 == "Neutral" or p12 == "Team") then
				local Player = Speaker:GetPlayer()
				local TeamColorColor

				if Player and Player.Team ~= nil then
					TeamColorColor = Player.TeamColor.Color
				else
					local SpeakerName = Speaker.Name

					TeamColorColor = t2[(GetNameValue(SpeakerName) + 0) % #t2 + 1]
				end

				Speaker:SetExtraData("NameColor", TeamColorColor)
			end
		end)
	end)
	Players.PlayerRemoving:connect(function(p13) -- line: 173
		-- upvalues: t3 (copy)
		local v55 = t3[p13]

		if v55 then
			v55:Disconnect()
		end

		t3[p13] = nil
	end)
end

return Run
