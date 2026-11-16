local Players = game:GetService("Players")

local function getNewGameChatDraftKey(p)
	local v = p or Players.LocalPlayer

	if v == nil or v.UserId <= 0 then
		return nil
	end

	return "newGame:" .. tostring(v.UserId)
end

return getNewGameChatDraftKey
