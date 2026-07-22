local Parent = script:FindFirstAncestor("DataHydration").Parent
local Players = game:GetService("Players")
local FFlagAddFriendsPageTrustedFriendRequestSection = require(Parent.SharedFlags).FFlagAddFriendsPageTrustedFriendRequestSection
local v4 = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else require(Parent.Cryo)

local function mergeListsWithoutDuplicates(t1: {[any]: any}?, t2: {[any]: any}?, s1: string?) -- line: 32
	-- upvalues: v4 (copy)
	if not t2 or #t2 == 0 then
		if t1 then
			return t1
		end

		return {}
	end

	if not t1 or #t1 == 0 then
		return t2
	end

	local v14 = v4.List.toSet(v4.List.map(t1, function(p1) -- line: 40
		-- upvalues: s1 (copy)
		if s1 then
			return p1[s1]
		end

		return p1
	end))
	local v15 = v4.List.filter(t2, function(p2) -- line: 45
		-- upvalues: s1 (copy), v14 (copy)
		return not v14[if not s1 then p2 else p2[s1]]
	end)

	return v4.List.join(table.clone(t1), v15)
end

return {
	areAllKeysPresent = function(p3, t3: {[any]: any}) -- line: 20
		if p3 == nil or type(p3) ~= "table" then
			return #t3 == 0
		end

		for _, v10 in t3 do
			if p3[v10] == nil then
				return false
			end
		end

		return true
	end,
	getLocalPlayerUserId = function() -- line: 11
		-- upvalues: Players (copy)
		local v6 = Players.LocalPlayer and Players.LocalPlayer.UserId or nil

		if v6 == nil or v6 <= 0 then
			return nil
		end

		return v6
	end,
	mergeListsWithoutDuplicates = if not FFlagAddFriendsPageTrustedFriendRequestSection then nil else mergeListsWithoutDuplicates
}
