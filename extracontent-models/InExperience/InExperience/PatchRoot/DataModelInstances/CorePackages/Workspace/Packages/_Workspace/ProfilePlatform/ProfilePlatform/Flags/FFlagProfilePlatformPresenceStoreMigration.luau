local Parent = script:FindFirstAncestor("ProfilePlatform").Parent

return require(Parent.SharedFlags).FFlagFriendSortedByPresenceSignalsImplementation and game:DefineFastFlag("ProfilePlatformPresenceStoreMigration", false)
