return function(t1: {[any]: any}?) -- line: 1
	if not t1 then
		return false
	end

	return (table.find(t1, "WhoCanChatWithMeInApp") or (table.find(t1, "WhoCanGroupChatWithMeInApp") or (table.find(t1, "WhoCanOneOnOnePartyWithMe") or table.find(t1, "WhoCanGroupPartyWithMe")))) ~= nil
end
