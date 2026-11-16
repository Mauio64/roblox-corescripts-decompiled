local UserRelationship = { Unknown = "Unknown", Friend = "Friend", NonFriend = "NonFriend" }

local set = {}

for _, v in pairs(UserRelationship) do
	set[v] = true
end

function UserRelationship.fromValue(p: string?)
	return if not (p == nil or not set[p]) then p else nil
end

return UserRelationship
