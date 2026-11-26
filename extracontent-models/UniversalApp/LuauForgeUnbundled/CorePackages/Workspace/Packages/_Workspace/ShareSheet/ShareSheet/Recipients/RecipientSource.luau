local v5 = { ChatInbox = "chatInbox", OneToOneFriends = "oneToOneFriends" }

local set = {}

for k, v6 in v5 do
	set[v6] = true
end

return {
	RecipientSource = v5,
	DefaultRecipientSource = v5.ChatInbox,
	isValidRecipientSource = function(p2): boolean
		return set[p2] == true
	end
}
