return [[
		type Names {
alias: String
combinedName: String
contactName: String
displayName: String
inExperienceCombinedName: String
username: String
platformName: String
		}
	
		type UserProfile implements User {
id: ID!
displayName: String!
names: Names
platformProfileId: String
isVerified: Boolean
isDeleted: Boolean
		}
	
		type Query {
userProfiles(userIds: [String]!): [UserProfile]!
		}
	]]
