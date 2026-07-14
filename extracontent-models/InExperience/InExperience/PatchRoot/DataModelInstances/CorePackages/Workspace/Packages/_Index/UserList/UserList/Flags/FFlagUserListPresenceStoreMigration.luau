local Parent = script:FindFirstAncestor("UserList").Parent

return require(Parent.SharedFlags).FFlagFriendSortedByPresenceSignalsImplementation and game:DefineFastFlag("UserListPresenceStoreMigration", false)
