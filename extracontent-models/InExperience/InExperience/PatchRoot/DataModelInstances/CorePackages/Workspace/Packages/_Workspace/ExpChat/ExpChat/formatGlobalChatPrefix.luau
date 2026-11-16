local Players = game:GetService("Players")
local ExpChat = script:FindFirstAncestor("ExpChat")

local isGlobalMessagePrefixEnabled = require(ExpChat.isGlobalMessagePrefixEnabled)
local isGlobalChatMessage = require(ExpChat.isGlobalChatMessage)

local function formatGlobalChatPrefix(value: string, p, p2: string?, p3)
	local v = p3 or Players

	if not isGlobalMessagePrefixEnabled() or (not isGlobalChatMessage(p) or #value == 0) then
		return value
	end

	if p2 == nil or p2 == "" then
		return value
	end

	local userId = tonumber(p.userId)

	if userId == nil or v:GetPlayerByUserId(userId) == nil then
		return value
	end

	local localPlayer = v.LocalPlayer

	if localPlayer ~= nil and userId == localPlayer.UserId then
		return value
	end

	local v2, v3 = string.match(value, "^(<font[^>]*>)(.*)$")

	if v2 == nil or v3 == nil then
		return `{p2} · {value}`
	end

	return `{v2}{p2} · {v3}`
end

return formatGlobalChatPrefix
