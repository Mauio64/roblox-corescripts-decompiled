local function shouldNavigateTabs(data)
	if data.isTabBarVisible and not (data.tabCount <= 1) then
		return data.isChatFocused
	end

	return false
end

return shouldNavigateTabs
