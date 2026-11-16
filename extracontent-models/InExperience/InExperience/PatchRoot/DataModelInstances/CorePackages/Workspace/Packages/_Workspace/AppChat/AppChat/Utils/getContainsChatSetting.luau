return function(list): boolean
	if list then
		return (table.find(list, "WhoCanChatWithMeInApp") or table.find(list, "WhoCanGroupChatWithMeInApp") or table.find(list, "WhoCanOneOnOnePartyWithMe") or table.find(list, "WhoCanGroupPartyWithMe")) ~= nil
	end

	return false
end
