local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ego")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local skeleton = Foundation.Skeleton

local withStyle = UIBlox.Style.withStyle
local roactAnalyticsCommonGameEvents = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactAnalyticsCommonGameEvents
local module2 = require("@luauforge/bundled/egY")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local module4 = require("@luauforge/deferred/fel")
local Cryo = require(CorePackages.Packages.Cryo)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local module5 = require("@luauforge/bundled/dzD")
local module6 = require("@luauforge/bundled/egZ")
local module7 = require("@luauforge/deferred/gHY")

local module8 = require("@luauforge/bundled/dAF")
local friendIcon = require("@luauforge/bundled/gDC").FriendIcon
local module9 = require("@luauforge/bundled/ehY")

local module10 = require("@luauforge/bundled/dSY")
local presenceType = module10.Presence.PresenceEnums.PresenceType
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local module11 = require("@luauforge/bundled/eha")
local module12 = require("@luauforge/deferred/hWA")

local fFlagHomeFriendNamesUseUserProfileHydration = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagHomeFriendNamesUseUserProfileHydration

local sourceSans = Enum.Font.SourceSans

local avatarSize = module5.PlacesList.ContextualMenu.AvatarSize
local horizontalInnerPadding = module5.PlacesList.ContextualMenu.HorizontalInnerPadding
local horizontalOuterPadding = module5.PlacesList.ContextualMenu.HorizontalOuterPadding

local v5 = horizontalOuterPadding + avatarSize + horizontalInnerPadding

local extended = module.PureComponent:extend("JoinableFriendEntry")

extended.defaultProps = { layoutOrder = 0 }

function extended:init()
	self.state = { joinButtonWidth = 60 }

	self.joinButtonRef = module.createRef()

	function self.onJoinButtonActivated()
		local analytics = self.props.analytics

		local v6 = if module12 then self.props.user else self.props.upToDateUser
		local universePlaceInfo = self.props.universePlaceInfo

		local placeId = universePlaceInfo.placeId
		local universeRootPlaceId = universePlaceInfo.universeRootPlaceId

		local v7 = if module12 then v6.presence and v6.presence.gameId else v6.gameInstanceId

		module9:ByUser(v6, module5.AnalyticsContext.GamePlayIntentInPlacesList, function(p2)
			analytics.reportJoinGameInPlacesList(v6.id, placeId, universeRootPlaceId, v7, p2)
		end)
	end

	function self.updateJoinButtonWidth()
		local current = self.joinButtonRef.current

		if current then
			self:setState({ joinButtonWidth = current.AbsoluteSize.X })
		end
	end
end

function extended.didMount(p2)
	p2.updateJoinButtonWidth()
end

function extended.render(data)
	local v6 = if module12 then data.props.user else data.props.upToDateUser
	local layoutOrder = data.props.layoutOrder
	local entryHeight = data.props.entryHeight
	local entryWidth = data.props.entryWidth
	local universeId = data.props.universeId
	local localization = data.props.localization
	local universePlaceInfo = data.props.universePlaceInfo
	local joinButtonWidth = data.state.joinButtonWidth

	local isPlayable = universePlaceInfo and universePlaceInfo.isPlayable or false

	local v7 = not entryWidth and 60
		or math.max((entryWidth - horizontalInnerPadding) / 2 - horizontalInnerPadding, 60)

	local v8 = horizontalOuterPadding * 2 + avatarSize + horizontalInnerPadding * 2 + joinButtonWidth

	local function fn(p2, p3)
		local v9 = module5.Color.GREEN_PRIMARY
		local v10 = 0
		local v11 = module5.Color.WHITE
		local v12 = 0
		local v13 = sourceSans
		local v14 = sourceSans
		local v15 = module5.Color.BLACK
		local v16 = 0
		local v17 = 22
		local v18 = module5.Color.WHITE
		local v19 = 0
		local v20

		if data.props.enableDisplayNamePolicy then
			v20 = data.props.combinedName
		else
			v20 = data.props.userName
		end

		if p2 then
			v9 = p2.Theme.ContextualPrimaryDefault.Color
			v10 = p2.Theme.ContextualPrimaryDefault.Transparency
			v11 = p2.Theme.ContextualPrimaryContent.Color
			v12 = p2.Theme.ContextualPrimaryContent.Transparency
			v13 = p2.Font.Header2.Font
			v14 = p2.Font.Body.Font
			v15 = p2.Theme.TextDefault.Color
			v16 = p2.Theme.TextDefault.Transparency
			v17 = p2.Font.BaseSize * p2.Font.Body.RelativeSize
			v18 = p2.Theme.BackgroundUIDefault.Color
			v19 = p2.Theme.BackgroundUIDefault.Transparency
		end

		local v21, universeId2

		if module12 then
			local presence = v6.presence
			v21 = not (presence == nil) and presence.userPresenceType == presenceType.InGame
			universeId2 = presence and presence.universeId
		else
			v21 = v6.presence == module8.PresenceType.IN_GAME
			universeId2 = v6.universeId
		end

		local onJoinButtonActivated

		if v21 and tostring(universeId2) == tostring(universeId) and isPlayable then
			onJoinButtonActivated = data.onJoinButtonActivated
		elseif p2 then
			v10 *= 0.5
			v12 *= 0.5
		else
			v9 = module5.Color.GREEN_DISABLED
		end

		local createElement = module.createElement
		local v23 = {
			Size = UDim2.new(0, entryWidth, 0, entryHeight),
			BackgroundColor3 = v18,
			BackgroundTransparency = v19,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder
		}

		local children = {
			AvatarHolder = module.createElement("Frame", {
				Size = UDim2.new(0, avatarSize, 0, avatarSize),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, horizontalOuterPadding, 0.5, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, {
				Avatar = module.createElement(friendIcon, {
					user = v6,
					itemSize = avatarSize,
					layoutOrder = 1,
					maskColor = v18
				})
			}),
			Username = 0,
			JoinButton = 0
		}

		local createElement2 = module.createElement
		local v25 = {
			Size = UDim2.new(1, -v8, 1, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, v5, 0.5, 0)
		}

		local v27 = if not data.props.shouldShimmerName then module.createElement("TextLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Text = v20,
			TextSize = v17,
			Font = v14,
			TextColor3 = v15,
			TextTransparency = v16,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		}) else nil

		local v28 = if data.props.shouldShimmerName then module.createElement(skeleton, {
			Size = UDim2.fromScale(0.8, 0.5),
			Position = UDim2.new(0, 0, 0.25, 0)
		}) else nil
		children.Username = createElement2("Frame", v25, {
			Text = v27,
			ShimmerName = v28
		})

		children.JoinButton = module.createElement(module7, {
			backgroundColor = v9,
			backgroundTransparency = v10,
			backgroundImage = "LuaApp/9-slice/input-default",
			leftIconEnabled = false,
			height = 32,
			minWidth = 60,
			maxWidth = v7,
			text = p3.joinText,
			textFont = v13,
			textColor = v11,
			textTransparency = v12,
			anchorPoint = Vector2.new(1, 0.5),
			position = UDim2.new(1, -horizontalOuterPadding, 0.5, 0),
			onActivated = onJoinButtonActivated,
			testId = "discovery-home-join-friend-" .. tostring(v6.id),
			[module.Ref] = data.joinButtonRef,
			[module.Change.AbsoluteSize] = data.updateJoinButtonWidth
		})
		return createElement("Frame", v23, children)
	end

	local function fn2(p2)
		return withStyle(function(p3)
			return fn(p3, p2)
		end)
	end

	if module11() then
		return module6({ joinText = "Feature.Chat.Drawer.Join" })(fn2)
	end

	return fn2({
		joinText = localization:Format("Feature.Chat.Drawer.Join")
	})
end

local function JoinableFriendEntryWrapper(p2)
	local v6 = useSelector(function(p3)
		local universeId = p2.universeId

		local v8 = if not module12 then p3.Users[p2.user.id] else nil
		return {
			upToDateUser = v8,
			universePlaceInfo = p3.UniversePlaceInfos[universeId]
		}
	end)

	local v7 = useRoactService(roactAnalyticsCommonGameEvents)
	local v8 = useRoactService(module2)

	local v9 = useAppPolicy(function(p3)
		return p3.getShowDisplayName()
	end)
	local v10

	if not fFlagHomeFriendNamesUseUserProfileHydration then
		v10 = module4.Hooks.useUserProfilesFetch({
			userIds = { p2.user.id },
			query = module4.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})
	end

	local v11

	if v10 and v10.data then
		v11 = module4.Selectors.getUsernameFromId(v10.data, p2.user.id)
	end

	local v12

	if v10 and v10.data then
		v12 = module4.Selectors.getCombinedNameFromId(v10.data, p2.user.id)
	end

	local v13 = (not v10 or v10.loading or v10.error) and true or false

	if fFlagHomeFriendNamesUseUserProfileHydration then
		local v14 = useSignalState(module10.UserProfile.getAndFetchUserNames(p2.user.id).names)
		v11 = v14 and v14.username
		v12 = v14 and v14.combinedName
		v13 = v14 == nil
	end

	return module.createElement(extended, Cryo.Dictionary.join(p2, {
		upToDateUser = v6.upToDateUser,
		universePlaceInfo = v6.universePlaceInfo,
		analytics = v7,
		localization = v8,
		enableDisplayNamePolicy = v9,
		userName = v11,
		combinedName = v12,
		shouldShimmerName = v13
	}))
end

return JoinableFriendEntryWrapper
