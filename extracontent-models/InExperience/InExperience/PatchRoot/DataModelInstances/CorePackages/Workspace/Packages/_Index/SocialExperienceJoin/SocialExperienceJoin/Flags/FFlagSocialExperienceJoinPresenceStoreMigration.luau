local Parent = script:FindFirstAncestor("SocialExperienceJoin").Parent

return require(Parent.SharedFlags).FFlagFriendSortedByPresenceSignalsImplementation and game:DefineFastFlag("SocialExperienceJoinPresenceStoreMigration", false)
