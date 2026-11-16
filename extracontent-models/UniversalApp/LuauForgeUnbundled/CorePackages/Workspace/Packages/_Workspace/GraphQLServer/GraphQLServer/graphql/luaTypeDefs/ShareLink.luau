return [[
		 enum ShareLinkType {
ExperienceInvite,
FriendInvite,
Home,
Profile,
NotificationExperienceInvite,
ScreenshotInvite,
PrivateServer,
Server,
ExperienceDetails,
		 }
	
		interface ShareLink {
linkId: ID!
shortUrl: String!
linkType: ShareLinkType!
		}
	
		type ExperienceDetailsLink implements ShareLink {
universeId: String!
linkId: ID!
shortUrl: String!
linkType: ShareLinkType!
		}
	
		type Query {
experienceDetailsLinkByUniverseId(universeId: String!): ExperienceDetailsLink!
		}
	]]
