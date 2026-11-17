local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")

local parent = ServerDrivenUi.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local StatusIndicator = Foundation.StatusIndicator
local StatusIndicatorShape = Foundation.Enums.StatusIndicatorShape
local StatusIndicatorSize = Foundation.Enums.StatusIndicatorSize
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
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
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiActiveFriendsFooterTreatment = SharedFlags2.FFlagSduiActiveFriendsFooterTreatment
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiGameTileFixFacePileZIndex = SharedFlags3.FFlagSduiGameTileFixFacePileZIndex

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

local function getFormattedText(list, p: number, props)
	if p == 0 then
		return nil
	end

	local v

	if p == 1 then
		v = props.textFormatOne
	else
		v = if p == 2 then props.textFormatTwo else props.textFormatMany
	end

	if not v or v == "" then
		return nil
	end

	local displayName

	if list[1] then
		displayName = list[1].displayName
	end

	if displayName or not v:find("{name}", 1, true) then
		return (v:gsub("{(%w+)}", {
			name = displayName or "",
			count = tostring(p - 1)
		}))
	end

	return nil
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
	local leftText

	if FFlagSduiActiveFriendsFooterTreatment then
		leftText = getFormattedText(v6, #userIds, props) or getDisplayText(v6, v2.separator, v7)
	else
		leftText = getDisplayText(v6, v2.separator, v7)
	end

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
			Position = UDim2.fromOffset((i - 1) * iconWidth / 2, 0),
			ZIndex = 0
		}
		local zIndex2

		if FFlagSduiGameTileFixFacePileZIndex then
			zIndex2 = v7 - i + 1
		end

		v9.ZIndex = zIndex2
		local v10 = {
			BorderRadius = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) }),
			Border = 0,
			PresenceDot = 0
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
		local presenceDot

		if FFlagSduiActiveFriendsFooterTreatment and props.showPresenceDot then
			presenceDot = React.createElement(StatusIndicator, {
				variant = StatusIndicatorVariant.Success,
				shape = StatusIndicatorShape.Circle,
				size = StatusIndicatorSize.XSmall,
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.fromScale(1, 1)
			})
		end

		v10.PresenceDot = presenceDot
		children[formatted] = createElement("ImageLabel", v9, v10)
	end

	local createElement = React.createElement
	local v8 = {
		position = position,
		anchorPoint = anchorPoint,
		automaticSize = automaticSize,
		size = size,
		layoutOrder = layoutOrder,
		zIndex = zIndex,
		sduiContext = props.sduiContext,
		textIconGap = 0,
		leftText = 0,
		leftTextFlexMode = 0,
		leftIconComponent = 0,
		onActivated = 0,
		testId = 0
	}
	local textIconGap

	if FFlagSduiActiveFriendsFooterTreatment then
		textIconGap = props.textIconGap or v.Gap.Small
	else
		textIconGap = v.Gap.Small
	end

	v8.textIconGap = textIconGap

	v8.leftText = leftText
	v8.leftTextFlexMode = Enum.UIFlexMode.Shrink
	v8.leftIconComponent = React.createElement(
		"Frame",
		{ AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1, BorderSizePixel = 0 },
		children
	)

	v8.onActivated = onActivated
	v8.testId = props.testId
	return createElement(SduiTileFooter, v8)
end

return React.memo(SduiGameTileActiveFriendsFooter)
