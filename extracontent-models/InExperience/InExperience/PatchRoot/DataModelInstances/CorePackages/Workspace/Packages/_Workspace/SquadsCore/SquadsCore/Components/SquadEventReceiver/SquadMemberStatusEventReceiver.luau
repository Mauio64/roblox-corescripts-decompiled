local parent = script:FindFirstAncestor("SquadsCore").Parent
local GuiService = game:GetService("GuiService")

local Cryo = require(parent.Cryo)
local UserLib = require(parent.UserLib)
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local React = require(parent.React)
local RoduxSquads = require(parent.RoduxSquads)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UserProfiles = require(parent.UserProfiles)
local UserProfileStore = UserProfiles.Stores.UserProfileStore
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local useCurrentSquadSelector = RoduxSquads.Hooks.useCurrentSquadSelector

return function(): nil
	local v = useCurrentSquadSelector()
	local v2 = useLocalUserId()
	local ref = React.useRef(nil)

	local v3 = useLocalization({
		friendJoinedYourPartyText = "Feature.Squads.Label.FriendJoinedYourParty",
		multiplePeopleJoinedYourPartyText = "Feature.Squads.Label.MultiplePeopleJoinedYourParty",
		twoFriendsJoinedYourPartyText = "Feature.Squads.Label.TwoFriendsJoinedYourParty"
	})

	local v4 = useSelector((React.useCallback(function(p)
		return p.Squad.UserBlocking.isBlockedByMe
	end, {})))

	React.useEffect(function()
		local members

		if v then
			members = v.members
		end

		if ref.current and members then
			local set = Cryo.List.toSet(Cryo.List.map(ref.current, function(p)
				return (tostring(p.userId))
			end))

			local userIds = {}

			for _, member in members do
				local userId = tostring(member.userId)

				if set[userId] or userId == v2 or v4[userId] then
					continue
				end

				table.insert(userIds, userId)
			end

			local count = #userIds

			if count > 0 then
				if count > 2 then
					GuiService:SendNotification({
						Title = v3.multiplePeopleJoinedYourPartyText,
						Icon = getStandardSizeAvatarHeadShotRbxthumb(userIds[1])
					})
				else
					UserProfileStore.get().fetchNamesByUserIds(userIds, function(p)
						if #p.data > 0 and p.status == "success" then
							local title

							if count == 1 then
								title = v3.friendJoinedYourPartyText:gsub("{(.-)}", {
									combinedName = p.data[1].names.getCombinedName(false)
								})
							else
								title = v3.twoFriendsJoinedYourPartyText:gsub("{(.-)}", {
									combinedName1 = p.data[1].names.getCombinedName(false),
									combinedName2 = p.data[2].names.getCombinedName(false)
								})
							end

							if count == 1 then
							end

							GuiService:SendNotification({
								Title = title,
								Icon = getStandardSizeAvatarHeadShotRbxthumb(userIds[1])
							})
						end
					end)
				end
			end
		end

		ref.current = members
	end, { v and v.members })

	return nil
end
