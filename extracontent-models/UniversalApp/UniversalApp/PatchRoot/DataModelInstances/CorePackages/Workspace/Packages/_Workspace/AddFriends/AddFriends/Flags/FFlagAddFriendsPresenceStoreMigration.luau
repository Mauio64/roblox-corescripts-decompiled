local Parent = script:FindFirstAncestor("AddFriends").Parent

return require(Parent.SharedFlags).FFlagFriendSortedByPresenceSignalsImplementation and game:DefineFastFlag("AddFriendsPresenceStoreMigration", false)
