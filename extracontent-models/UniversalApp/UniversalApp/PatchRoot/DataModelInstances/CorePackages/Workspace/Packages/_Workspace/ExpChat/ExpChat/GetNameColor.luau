local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("ExpChat").Parent
local computeNameColor

if require(Parent.ExpChatShared).Flags.GetFFlagTextChatEnableUniverseChatTabs() then
	computeNameColor = require(Parent.ChatUIPrimitives).Utils.computeNameColor
else
	local t1 = {
		Color3.new(0.9921568627450981, 0.1607843137254902, 0.2627450980392157),
		Color3.new(0.00392156862745098, 0.6352941176470588, 1),
		Color3.new(0.00784313725490196, 0.7215686274509804, 0.3411764705882353),
		BrickColor.new("Alder").Color,
		BrickColor.new("Bright orange").Color,
		BrickColor.new("Bright yellow").Color,
		BrickColor.new("Light reddish violet").Color,
		BrickColor.new("Brick yellow").Color
	}

	local function GetNameValue(s1: string) -- line: 24
		local n1 = 0

		for i = 1, #s1 do
			local byte = string.byte((string.sub(s1, i, i)))
			local v11 = #s1 - i + 1

			if #s1 % 2 == 1 then
				v11 -= 1
			end

			if v11 % 4 >= 2 then
				byte = -byte
			end

			n1 += byte
		end

		return n1
	end

	function computeNameColor(s2: string) -- line: 42
		-- upvalues: t1 (copy), GetNameValue (copy)
		return t1[(GetNameValue(s2) + 0) % #t1 + 1]
	end
end

local function GetNameColor(n2: number) -- line: 47
	-- upvalues: Players (copy), computeNameColor (ref)
	local PlayerByUserId = Players:GetPlayerByUserId(n2)

	if PlayerByUserId then
		if PlayerByUserId.Team ~= nil then
			return PlayerByUserId.TeamColor.Color
		end

		return computeNameColor(PlayerByUserId.Name)
	end

	return Color3.fromRGB(255, 255, 255)
end

return GetNameColor
