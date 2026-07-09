local Parent = script:FindFirstAncestor("TrustedContacts").Parent
local FFlagTrustedFriendsUseEnumCTA = require(Parent.SharedFlags).FFlagTrustedFriendsUseEnumCTA

return game:DefineFastFlag("TrustedFriendsLinkVPC_1", false) and FFlagTrustedFriendsUseEnumCTA
