local SocialProof = script:FindFirstAncestor("SocialProof")
local SocialProofParent = SocialProof.Parent
local Foundation = require(SocialProofParent.Foundation)
local Chip = Foundation.Chip
local React = require(SocialProofParent.React)
local useDispatch = require(SocialProofParent.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigateDown = require(SocialProofParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(SocialProofParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(SocialProofParent.RobloxAppNavigation).NavigationCommands
local AppPage = require(SocialProofParent.RobloxAppEnums).AppPage
local AvatarGroupType = Foundation.Enums.AvatarGroupType
local useEntityConnectionsPagination = require(SocialProof.Hooks.useEntityConnectionsPagination)
local Enums = require(SocialProof.Common.Enums)
local useLocalization = require(SocialProofParent.Localization).Hooks.useLocalization

require(SocialProof.Common.Types)

local SharedFlags = require(SocialProofParent.SharedFlags)
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation = SharedFlags.FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation

local function FriendsOwnedChip(p1, p2) -- line: 36
	-- upvalues: useDispatch (copy), useEntityConnectionsPagination (copy), Enums (copy), React (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation (copy), Chip (copy), AvatarGroupType (copy)
	local fromProfile = p1.fromProfile
	local itemId = p1.itemId
	local itemType = p1.itemType
	local v24 = useDispatch()
	local v25 = useEntityConnectionsPagination({
		entityId = itemId,
		entityType = itemType,
		connectionType = Enums.ConnectionType.Friend
	})
	local v26 = v25.userIds or {}
	local t1 = { table.unpack(v26, 1, (math.min(2, #v26))) }
	local v28 = v25.totalConnections or 0
	local v29 = React.useCallback(function() -- line: 58
		-- upvalues: AppPage (copy), itemId (copy), itemType (copy), fromProfile (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), v24 (copy), NavigateDown (copy)
		local t2 = {
			name = AppPage.FriendsOwnedUserList,
			extraProps = {
				entityId = itemId,
				entityType = itemType,
				source = not fromProfile and "marketplace" or "profile"
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v9.down(v9.fromLegacyPage(t2))

			return
		end

		v24(NavigateDown(t2))
	end, {
		v24,
		itemId,
		itemType,
		fromProfile
	})
	local v30 = useLocalization({
		connectionsOwn = {
			not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.ConnectionsOwn" or "Feature.Friends.Label.FriendsOwn",
			numberOfConnections = v28
		},
		singleConnectionOwns = not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.ConnectionOwns" or "Feature.Friends.Label.FriendOwns"
	})
	local v31 = if v28 ~= 1 then v30.connectionsOwn else v30.singleConnectionOwns

	if FFlagEnableSocialProofOnItemDetailsRoactGamepadNavigation then
		React.useEffect(function() -- line: 91
			-- upvalues: v28 (copy), p1 (copy)
			if v28 > 0 and p1.chipIsRenderedCallback then
				p1.chipIsRenderedCallback(true)
			end
		end, {
			v28,
			p1.chipIsRenderedCallback
		})
	end

	if v28 == 0 then
		return nil
	end

	return React.createElement(Chip, {
		LayoutOrder = p1.layoutOrder or 0,
		text = v31,
		onActivated = v29,
		leading = {
			type = "AvatarGroup",
			props = {
				max = 2,
				avatars = t1,
				type = AvatarGroupType.Stacked
			}
		},
		ref = p2,
		NextSelectionUp = p1.NextSelectionUp,
		NextSelectionDown = p1.NextSelectionDown,
		NextSelectionRight = p1.NextSelectionRight,
		NextSelectionLeft = p1.NextSelectionLeft
	})
end

return React.forwardRef(FriendsOwnedChip)
