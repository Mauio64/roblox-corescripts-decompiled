local Parent = script:FindFirstAncestor("TrustedContacts").Parent
local FFlagTrustedFriendsUseEnumCTA = require(Parent.SharedFlags).FFlagTrustedFriendsUseEnumCTA
local useModalButtonActions = require(script.useModalButtonActions)

if FFlagTrustedFriendsUseEnumCTA then
	return useModalButtonActions
end

return (require(script.useModalButtonActions_legacy))
