local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local ButtonTypes = require(SocialTabsPageParent.UserList).Enums.ButtonTypes

require(SocialTabsPage.Common.Types)

local function v4() -- line: 13
end

local t1 = {
	JoinExperience = ButtonTypes.Join,
	Chat = ButtonTypes.Chat,
	AddFriend = ButtonTypes.Add,
	AcceptFriendRequest = ButtonTypes.Accept,
	PendingFriendRequest = ButtonTypes.Pending
}

local function mapProfileCTAToRowCTA(p1, p2, s1: string) -- line: 23
	-- upvalues: t1 (copy), v4 (copy), ButtonTypes (copy)
	if not p1 or not p1.buttons then
		return nil
	end

	for _, v11 in p1.buttons do
		local v12 = t1[v11.type]

		if v12 then
			local v13 = p2[v12]

			return {
				type = v12,
				onActivated = if not v13 then v4 else function() -- line: 39
					-- upvalues: v13 (copy), s1 (copy)
					v13(s1)
				end,
				isDisabled = v12 == ButtonTypes.Pending or nil,
				disabledReason = v11.disabledReason
			}
		end
	end

	return nil
end

return mapProfileCTAToRowCTA
