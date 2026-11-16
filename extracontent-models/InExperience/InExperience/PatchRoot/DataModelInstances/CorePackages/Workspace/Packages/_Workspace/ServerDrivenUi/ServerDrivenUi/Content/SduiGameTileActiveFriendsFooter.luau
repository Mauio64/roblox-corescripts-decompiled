local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")

local parent = ServerDrivenUi.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local SduiTileFooter = require(ServerDrivenUi.Content.SduiTileFooter)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiParsers = SduiCoreSystem.SduiParsers
local UserProfiles = require(parent.UserProfiles)
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local SduiInGameFriendsData = require(ServerDrivenUi.DataStore.SduiInGameFriendsData)
local DataHydration = require(parent.DataHydration)
require(parent.DataHydration.UserProfile)
local getAndFetchUserNamesByUserIds = DataHydration.UserProfile.getAndFetchUserNamesByUserIds

local SharedFlags = require(parent.SharedFlags)
local FFlagHomeFriendNamesUseUserProfileHydration = SharedFlags.FFlagHomeFriendNamesUseUserProfileHydration

local function getUserIdsForFacePile(list, p: number) -- 1 equivalent call inferred from this helper
	local userIds = {}

	for i = 1, p do
		userIds[i] = list[i].userId
	end

	return userIds
end

local function getDisplayText(list, separator: string, p: number)
	local displayNames = {}

	for i = 1, p do
		displayNames[i] = list[i].displayName
	end

	return table.concat(displayNames, separator)
end

local function alphabeticalSort(p, p2): boolean
	return not not p.displayName and (not p2.displayName or p.displayName:lower() < p2.displayName:lower())
end

local function getSortedFriendNames(items, p)
	local sortedFriendNames = {}

	if p.status == DataHydration.DataStatus.NotReady then
		return sortedFriendNames
	end

	for _, item in items do
		local name = p.namesByUserId[tostring(item)]

		if name then
			table.insert(sortedFriendNames, { userId = item, displayName = name.combinedName })
		end
	end

	table.sort(sortedFriendNames, alphabeticalSort)
	return sortedFriendNames
end

local function getSortedFriendDisplayNames(items, p)
	if not (items and p and p.data) then
		return {}
	end

	local result = {}

	for _, item in items do
		table.insert(result, {
			userId = item,
			displayName = UserProfiles.Selectors.getCombinedNameFromId(p.data, item)
		})
	end

	table.sort(result, alphabeticalSort)
	return result
end

local function SduiGameTileActiveFriendsFooter(props)
	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint
	local automaticSize = props.automaticSize
	local size = props.size
	local zIndex = props.zIndex
	local position = props.position

	local v = useTokens()

	local iconWidth = props.iconWidth or v.Size.Size_500

	local onActivated = React.useCallback(function(p)
		if props.onActivated then
			props.onActivated(p)
			return
		end

		local safeParseCallback = SduiParsers.safeParseCallback({
			actionType = SduiActionType.OpenJoinFriends,
			actionParams = { placeId = props.placeId, universeId = props.universeId }
		}, props.sduiContext, props.analyticsContext)

		if safeParseCallback then
			safeParseCallback(p)
		end
	end, {
		props.placeId,
		props.universeId,
		props.analyticsContext,
		props.onActivated,
		props.sduiContext
	})

	local v2 = useLocalization({ separator = "Feature.GameDetails.Label.FriendsSeparator" })

	local getInGameFriendsByGame = SduiInGameFriendsData.getInGameFriendsByGame

	local v3 = SignalsReact.useSignalState(getInGameFriendsByGame)
	local userIds = React.useMemo(function()
		local result = {}

		for k, _ in v3[props.universeId] or {} do
			table.insert(result, k)
		end

		return result
	end, { v3, props.universeId })
	local v4

	if FFlagHomeFriendNamesUseUserProfileHydration then
		v4 = nil
	else
		v4 = useUserProfilesFetch({
			userIds = userIds,
			query = UserProfiles.Queries.userProfilesCombinedNameByUserIds,
			skip = #userIds == 0
		})
	end

	local v5

	if FFlagHomeFriendNamesUseUserProfileHydration then
		local joined = table.concat(userIds, ",")
		local v6 = React.useMemo(function()
			return getAndFetchUserNamesByUserIds(string.split(joined, ","))
		end, { joined })
		v5 = SignalsReact.useSignalState(v6)
	else
		v5 = nil
	end

	local v6 = React.useMemo(function()
		if v5 then
			return getSortedFriendNames(userIds, v5)
		end

		return getSortedFriendDisplayNames(userIds, v4)
	end, { userIds, v4, v5 })

	local v7 = math.min(props.maxAvatars or 3, #v6)

	local displayText = getDisplayText(v6, v2.separator, v7)
	local userIdsForFacePile = getUserIdsForFacePile(v6, v7) -- inferred equivalent call
	local children = {}

	for i = 1, v7 do
		local v8 = userIdsForFacePile[i]
		local formatted = `userId_{i}`
		local createElement = React.createElement
		local v9 = {
			LayoutOrder = i,
			BackgroundTransparency = 0,
			BackgroundColor3 = v.Color.Content.Muted.Color3,
			Image = `rbxthumb://type=AvatarHeadShot&id={v8}&w=100&h=100`,
			Size = UDim2.fromOffset(iconWidth, iconWidth),
			Position = UDim2.fromOffset((i - 1) * iconWidth / 2, 0)
		}
		local v10 = {
			BorderRadius = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) }),
			Border = 0
		}
		local border

		if not props.hideBorder then
			border = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = v.Color.System.Emphasis.Color3,
				Transparency = 0,
				Thickness = 1
			})
		end

		v10.Border = border
		children[formatted] = createElement("ImageLabel", v9, v10)
	end

	return React.createElement(SduiTileFooter, {
		position = position,
		anchorPoint = anchorPoint,
		automaticSize = automaticSize,
		size = size,
		layoutOrder = layoutOrder,
		zIndex = zIndex,
		sduiContext = props.sduiContext,
		textIconGap = v.Gap.Small,
		leftText = displayText,
		leftTextFlexMode = Enum.UIFlexMode.Shrink,
		leftIconComponent = React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			children
		),
		onActivated = onActivated,
		testId = props.testId
	})
end

return React.memo(SduiGameTileActiveFriendsFooter)
