local recipientSource = { ChatInbox = "chatInbox", OneToOneFriends = "oneToOneFriends" }

local set = {}

for _, v in recipientSource do
	set[v] = true
end

return {
	RecipientSource = recipientSource,
	DefaultRecipientSource = recipientSource.ChatInbox,
	isValidRecipientSource = function(p: string): boolean
		return set[p] == true
	end
}
