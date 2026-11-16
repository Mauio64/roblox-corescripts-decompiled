local Players = game:GetService("Players")

local function getNewGameChatDraftKey(p2)
	local v5 = p2 or Players.LocalPlayer

	if v5 == nil or v5.UserId <= 0 then
		return nil
	end

	return "newGame:" .. tostring(v5.UserId)
end

return getNewGameChatDraftKey
