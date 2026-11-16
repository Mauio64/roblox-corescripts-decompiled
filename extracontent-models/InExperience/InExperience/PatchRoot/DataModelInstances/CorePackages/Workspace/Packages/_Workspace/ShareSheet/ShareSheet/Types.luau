local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

require(parent.AppChat.GetConversationListStore)
require(ShareSheet.Recipients.ListRecipientsStatus)
require(ShareSheet.Recipients.Recipient)
require(parent.Signals)

return {}
