local UserSearch = script:FindFirstAncestor("UserSearch")

local FFlagUserSearchPresenceStoreMigration = require(UserSearch.Flags.FFlagUserSearchPresenceStoreMigration)

return game:DefineFastFlag("UserSearchJoinPassStorePresence", false) and FFlagUserSearchPresenceStoreMigration
