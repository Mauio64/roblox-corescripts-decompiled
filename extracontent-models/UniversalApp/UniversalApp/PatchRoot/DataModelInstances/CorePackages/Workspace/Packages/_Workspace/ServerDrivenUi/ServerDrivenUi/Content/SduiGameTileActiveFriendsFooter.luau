local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local SignalsReact = require(ServerDrivenUiParent.SignalsReact)
local useTokens = require(ServerDrivenUiParent.Foundation).Hooks.useTokens
local useLocalization = require(ServerDrivenUiParent.Localization).Hooks.useLocalization
local SduiTileFooter = require(ServerDrivenUi.Content.SduiTileFooter)
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiParsers = SduiCoreSystem.SduiParsers
local UserProfiles = require(ServerDrivenUiParent.UserProfiles)
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local SduiInGameFriendsData = require(ServerDrivenUi.DataStore.SduiInGameFriendsData)

local function getUserIdsForFacePile(t1: {[any]: any}, n1: number) -- line: 51
	local t2 = {}

	for i = 1, n1 do
		t2[i] = t1[i].userId
	end

	return t2
end
local function getDisplayText(t3: {[any]: any}, s1: string, n2: number) -- line: 60
	local t4 = {}

	for i = 1, n2 do
		t4[i] = t3[i].displayName
	end

	return table.concat(t4, s1)
end
local function alphabeticalSort(t5: {[any]: any}, t6: {[any]: any}) -- line: 69
	if not t5.displayName then
		return false
	end

	if not t6.displayName then
		return true
	end

	return t5.displayName:lower() < t6.displayName:lower()
end
local function getSortedFriendDisplayNames(p1, p2) -- line: 79
	-- upvalues: UserProfiles (copy), alphabeticalSort (copy)
	if not p1 or (not p2 or not p2.data) then
		return {}
	end

	local t7 = {}

	for _, v34 in p1 do
		table.insert(t7, {
			userId = v34,
			displayName = UserProfiles.Selectors.getCombinedNameFromId(p2.data, v34)
		})
	end

	table.sort(t7, alphabeticalSort)

	return t7
end
local function SduiGameTileActiveFriendsFooter(t8: {[any]: any}) -- line: 98
	-- upvalues: useTokens (copy), React (copy), SduiParsers (copy), SduiActionType (copy), useLocalization (copy), SduiInGameFriendsData (copy), SignalsReact (copy), useUserProfilesFetch (copy), UserProfiles (copy), getSortedFriendDisplayNames (copy), getDisplayText (copy), SduiTileFooter (copy)
	local layoutOrder = t8.layoutOrder
	local anchorPoint = t8.anchorPoint
	local automaticSize = t8.automaticSize
	local size = t8.size
	local zIndex = t8.zIndex
	local position = t8.position
	local v42 = useTokens()
	local v43 = t8.iconWidth or v42.Size.Size_500
	local v44 = React.useCallback(function(p3) -- line: 110
		-- upvalues: t8 (copy), SduiParsers (copy), SduiActionType (copy)
		if t8.onActivated then
			t8.onActivated(p3)

			return
		end

		local v59 = SduiParsers.safeParseCallback({
			actionType = SduiActionType.OpenJoinFriends,
			actionParams = {
				placeId = t8.placeId,
				universeId = t8.universeId
			}
		}, t8.sduiContext, t8.analyticsContext)

		if v59 then
			v59(p3)
		end
	end, {
		t8.placeId,
		t8.universeId,
		t8.analyticsContext,
		t8.onActivated,
		t8.sduiContext
	})
	local v45 = useLocalization({
		separator = "Feature.GameDetails.Label.FriendsSeparator"
	})
	local getInGameFriendsByGame = SduiInGameFriendsData.getInGameFriendsByGame
	local v47 = SignalsReact.useSignalState(getInGameFriendsByGame)
	local v48 = React.useMemo(function() -- line: 134
		-- upvalues: v47 (copy), t8 (copy)
		local t9 = {}

		for v61, _ in v47[t8.universeId] or {} do
			table.insert(t9, v61)
		end

		return t9
	end, {
		v47,
		t8.universeId
	})
	local v49 = useUserProfilesFetch({
		userIds = v48,
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds,
		skip = #v48 == 0
	})
	local v50 = React.useMemo(function() -- line: 148
		-- upvalues: getSortedFriendDisplayNames (copy), v48 (copy), v49 (copy)
		return (getSortedFriendDisplayNames(v48, v49))
	end, {
		v48,
		v49
	})
	local v51 = math.min(t8.maxAvatars or 3, #v50)
	local v52 = getDisplayText(v50, v45.separator, v51)
	local t10 = {}

	for i = 1, v51 do
		t10[i] = v50[i].userId
	end

	local t11 = {}

	for i = 1, v51 do
		local v57 = t10[i]

		t11[`userId_{ i }`] = React.createElement("ImageLabel", {
			BackgroundTransparency = 0,
			LayoutOrder = i,
			BackgroundColor3 = v42.Color.Content.Muted.Color3,
			Image = `rbxthumb://type=AvatarHeadShot&id={ v57 }&w=100&h=100`,
			Size = UDim2.fromOffset(v43, v43),
			Position = UDim2.fromOffset((i - 1) * v43 / 2, 0)
		}, {
			BorderRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			}),
			Border = if not t8.hideBorder then React.createElement("UIStroke", {
				Transparency = 0,
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = v42.Color.System.Emphasis.Color3
			}) else nil
		})
	end

	return React.createElement(SduiTileFooter, {
		position = position,
		anchorPoint = anchorPoint,
		automaticSize = automaticSize,
		size = size,
		layoutOrder = layoutOrder,
		zIndex = zIndex,
		sduiContext = t8.sduiContext,
		textIconGap = v42.Gap.Small,
		leftText = v52,
		leftTextFlexMode = Enum.UIFlexMode.Shrink,
		leftIconComponent = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY
		}, t11),
		onActivated = v44,
		testId = t8.testId
	})
end

return React.memo(SduiGameTileActiveFriendsFooter)
