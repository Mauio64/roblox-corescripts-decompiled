local MessageEffect = require(script.Parent.MessageEffect)

local v = { MessageEffect.ChatWindowEnlarge }

local function getChatWindowMessageEffects(list)
	local chatWindowMessageEffects = {}

	if list then
		for _, v2 in v do
			if table.find(list, v2) then
				table.insert(chatWindowMessageEffects, v2)
			end
		end
	end

	return chatWindowMessageEffects
end

return getChatWindowMessageEffects
