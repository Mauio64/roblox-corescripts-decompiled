return function() -- line: 10
	local _ = {
		on = "icons/menu/chat_on",
		off = "icons/menu/chat_off"
	}
	local t1 = {
		on = "icons/menu/platformChatOn",
		off = "icons/menu/platformChatOff"
	}

	return {
		label = "CoreScripts.TopBar.Chat",
		icon = t1,
		iconSize = 30
	}
end
