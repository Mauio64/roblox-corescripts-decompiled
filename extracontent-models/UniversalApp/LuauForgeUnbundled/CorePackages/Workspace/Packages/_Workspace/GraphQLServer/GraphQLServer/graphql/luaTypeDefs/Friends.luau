return [[
		interface Friendship {
id: ID!
targetUserId: ID!
		}
	
		type Friend implements User & Friendship {
id: ID!
hasVerifiedBadge: Boolean
displayName: String!
targetUserId: ID!
presence: UserPresence
sortScore: Float
		}
	
		type AllFriendsPage {
targetUserId: ID!
curCursor: String
prevCursor: String
nextCursor: String
friends: [Friend]
		}
	
		type Query {
allFriendsByUserId(userId: ID!, sort: Int, pageLimit: Int, pageCursor: String): AllFriendsPage
onlineFriendsByUserId(userId: ID!, sort: Int): [Friend]
		}
	]]
