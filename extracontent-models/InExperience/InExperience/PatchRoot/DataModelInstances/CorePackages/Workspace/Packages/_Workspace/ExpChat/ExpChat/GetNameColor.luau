local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("ExpChat").Parent
local ExpChatShared = require(parent.ExpChatShared)
local v

if ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs() then
	local ChatUIPrimitives = require(parent.ChatUIPrimitives)
	v = ChatUIPrimitives.Utils.computeNameColor
else
	local v2 = {
		Color3.new(253 / 255, 41 / 255, 67 / 255),
		Color3.new(1 / 255, 162 / 255, 1),
		Color3.new(2 / 255, 184 / 255, 87 / 255),
		BrickColor.new("Alder").Color,
		BrickColor.new("Bright orange").Color,
		BrickColor.new("Bright yellow").Color,
		BrickColor.new("Light reddish violet").Color,
		BrickColor.new("Brick yellow").Color
	}

	local function GetNameValue(value: string)
		local nameValue = 0

		for i = 1, #value do
			local v3 = string.byte((string.sub(value, i, i)))
			local v4 = #value - i + 1

			if #value % 2 == 1 then
				v4 -= 1
			end

			if v4 % 4 >= 2 then
				v3 = -v3
			end

			nameValue += v3
		end

		return nameValue
	end

	v = function(p: string)
		return v2[(GetNameValue(p) + 0) % #v2 + 1]
	end
end

local function GetNameColor(p: number)
	local playerByUserId = Players:GetPlayerByUserId(p)

	if not playerByUserId then
		return Color3.fromRGB(255, 255, 255)
	end

	if playerByUserId.Team == nil then
		return v(playerByUserId.Name)
	end

	return playerByUserId.TeamColor.Color
end

return GetNameColor
