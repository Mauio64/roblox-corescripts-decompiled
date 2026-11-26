return [[
		type MutualFriend implements User {
id: ID!
username: String!
displayName: String!
		}
	
		type ProfileInsights {
targetUserId: ID!
mutualFriends: [MutualFriend!]
isOfflineFrequents: Boolean!
friendshipAgeUnixSeconds: Int
friendRequestOriginSource: Int
accountCreationDateUnixSeconds: Int
localizedCountryName: String
userAgeVerifiedBracket: String
		}
	
		type ProfileInsightsPages {
id: ID!
profileInsights: [ProfileInsights!]
		}
	
		type Query {
profilesInsights(userIds: [String]!, count: Int, pageId: String, rankingStrategy: String): ProfileInsightsPages
profilesInsightsByUserIds(userIds: [String]!, count: Int, rankingStrategy: String): [ProfileInsights]
		}
	]]
