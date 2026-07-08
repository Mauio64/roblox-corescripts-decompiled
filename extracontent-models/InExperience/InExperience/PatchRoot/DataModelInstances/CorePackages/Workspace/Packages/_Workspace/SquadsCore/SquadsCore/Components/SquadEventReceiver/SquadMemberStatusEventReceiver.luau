local Parent = script:FindFirstAncestor("SquadsCore").Parent
local GuiService = game:GetService("GuiService")
local Cryo = require(Parent.Cryo)
local getStandardSizeAvatarHeadShotRbxthumb = require(Parent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local React = require(Parent.React)
local RoduxSquads = require(Parent.RoduxSquads)
local useLocalUserId = require(Parent.RobloxAppHooks).useLocalUserId
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local UserProfileStore = require(Parent.UserProfiles).Stores.UserProfileStore
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local useCurrentSquadSelector = RoduxSquads.Hooks.useCurrentSquadSelector

return function() -- line: 18
	-- upvalues: useCurrentSquadSelector (copy), useLocalUserId (copy), React (copy), useLocalization (copy), useSelector (copy), Cryo (copy), GuiService (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), UserProfileStore (copy)
	local v12 = useCurrentSquadSelector()
	local v13 = useLocalUserId()
	local v14 = React.useRef(nil)
	local v15 = useLocalization({
		friendJoinedYourPartyText = "Feature.Squads.Label.FriendJoinedYourParty",
		multiplePeopleJoinedYourPartyText = "Feature.Squads.Label.MultiplePeopleJoinedYourParty",
		twoFriendsJoinedYourPartyText = "Feature.Squads.Label.TwoFriendsJoinedYourParty"
	})
	local v16 = React.useCallback(function(p1) -- line: 29
		return p1.Squad.UserBlocking.isBlockedByMe
	end, {})
	local v17 = useSelector(v16)

	React.useEffect(function() -- line: 34
		-- upvalues: v12 (copy), v14 (copy), Cryo (copy), v13 (copy), v17 (copy), GuiService (copy), v15 (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), UserProfileStore (copy)
		local v19 = if not v12 then nil else v12.members

		if v14.current and v19 then
			local v20 = Cryo.List.toSet(Cryo.List.map(v14.current, function(p2) -- line: 39
				return (tostring(p2.userId))
			end))
			local t1 = {}

			for _, v23 in v19 do
				local str = tostring(v23.userId)

				if not v20[str] and str ~= v13 and not v17[str] then
					table.insert(t1, str)
				end
			end

			local v25 = #t1

			if v25 > 0 then
				if v25 > 2 then
					GuiService:SendNotification({
						Title = v15.multiplePeopleJoinedYourPartyText,
						Icon = getStandardSizeAvatarHeadShotRbxthumb(t1[1])
					})
				else
					UserProfileStore.get().fetchNamesByUserIds(t1, function(p3) -- line: 63
						-- upvalues: v25 (copy), v15 (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), t1 (copy), GuiService (copy)
						if #p3.data > 0 and p3.status == "success" then
							local v28 = if v25 ~= 1 then v15.twoFriendsJoinedYourPartyText:gsub("{(.-)}", {
								combinedName1 = p3.data[1].names.getCombinedName(false),
								combinedName2 = p3.data[2].names.getCombinedName(false)
							}) else v15.friendJoinedYourPartyText:gsub("{(.-)}", {
								combinedName = p3.data[1].names.getCombinedName(false)
							})
							local v29 = if v25 ~= 1 then getStandardSizeAvatarHeadShotRbxthumb(t1[1]) else getStandardSizeAvatarHeadShotRbxthumb(t1[1])

							GuiService:SendNotification({
								Title = v28,
								Icon = v29
							})
						end
					end)
				end
			end
		end

		v14.current = v19
	end, { v12 and v12.members })

	return nil
end
