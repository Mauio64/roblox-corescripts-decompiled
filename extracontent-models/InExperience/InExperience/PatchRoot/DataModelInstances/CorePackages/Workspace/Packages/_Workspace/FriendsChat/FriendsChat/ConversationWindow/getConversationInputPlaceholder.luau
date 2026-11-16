local function getConversationInputPlaceholder(p, p2, callback, object)
	if p.isTouch then
		return callback("CoreScripts.TextChat.InputBar.Hint.Touch")
	end

	return callback("CoreScripts.TextChat.InputBar.Hint.MouseKeyboard", {
		KEY = object:GetStringForKeyCode(p2)
	})
end

return getConversationInputPlaceholder
