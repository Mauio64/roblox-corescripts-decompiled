local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local UserList = require(parent.UserList)
local ButtonTypes = UserList.Enums.ButtonTypes

require(SocialTabsPage.Common.Types)

local SharedFlags = require(parent.SharedFlags)
local FFlagUserListActionsV2 = SharedFlags.FFlagUserListActionsV2

local function fn() end

local v = {
	JoinExperience = ButtonTypes.Join,
	Chat = ButtonTypes.Chat,
	AddFriend = ButtonTypes.Add,
	AcceptFriendRequest = ButtonTypes.Accept,
	PendingFriendRequest = ButtonTypes.Pending
}

local function mapProfileCTAToRowCTA(p, p2, p3: string)
	if not (p and p.buttons) then
		return nil
	end

	for _, button in p.buttons do
		local v2 = v[button.type]

		if v2 then
			local v3 = p2[v2]
			local v4 = v2 == ButtonTypes.Pending or nil
			return {
				type = v2,
				onActivated = v3 and function()
					v3(p3)
				end or fn,
				isDisabled = FFlagUserListActionsV2 and button.disabledReason ~= nil and true or v4,
				disabledReason = button.disabledReason
			}
		end
	end

	return nil
end

return mapProfileCTAToRowCTA
