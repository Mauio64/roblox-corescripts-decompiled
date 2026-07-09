local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Skeleton = require(CorePackages.Packages.Foundation).Skeleton
local withStyle = UIBlox.Style.withStyle
local RoactAnalyticsCommonGameEvents = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactAnalyticsCommonGameEvents
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local Cryo = require(CorePackages.Packages.Cryo)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local Constants = require(Modules.LuaApp.Constants)
local withLocalization = require(Modules.LuaApp.withLocalization)
local FitImageTextButton = require(Modules.LuaApp.Components.FitImageTextButton)
local User = require(Modules.LuaApp.Models.User)
local FriendIcon = require(CorePackages.Workspace.Packages.GameTile).FriendIcon
local joinGame = require(Modules.LuaApp.Util.joinGame)
local GetFFlagLuaAppUseWithLocalization = require(Modules.LuaApp.Flags.GetFFlagLuaAppUseWithLocalization)
local SourceSans = Enum.Font.SourceSans
local AvatarSize = Constants.PlacesList.ContextualMenu.AvatarSize
local HorizontalInnerPadding = Constants.PlacesList.ContextualMenu.HorizontalInnerPadding
local HorizontalOuterPadding = Constants.PlacesList.ContextualMenu.HorizontalOuterPadding
local v26 = HorizontalOuterPadding + AvatarSize + HorizontalInnerPadding
local v27 = Roact.PureComponent:extend("JoinableFriendEntry")

v27.defaultProps = {
	layoutOrder = 0
}

function v27.init(p1) -- line: 52
	-- upvalues: Roact (copy), joinGame (copy), Constants (copy)
	p1.state = {
		joinButtonWidth = 60
	}
	p1.joinButtonRef = Roact.createRef()

	function p1.onJoinButtonActivated() -- line: 58
		-- upvalues: p1 (copy), joinGame (copy), Constants (copy)
		local analytics = p1.props.analytics
		local upToDateUser = p1.props.upToDateUser
		local universePlaceInfo = p1.props.universePlaceInfo
		local placeId = universePlaceInfo.placeId
		local universeRootPlaceId = universePlaceInfo.universeRootPlaceId

		joinGame:ByUser(upToDateUser, Constants.AnalyticsContext.GamePlayIntentInPlacesList, function(p2) -- line: 66
			-- upvalues: analytics (copy), upToDateUser (copy), placeId (copy), universeRootPlaceId (copy)
			analytics.reportJoinGameInPlacesList(upToDateUser.id, placeId, universeRootPlaceId, upToDateUser.gameInstanceId, p2)
		end)
	end
	function p1.updateJoinButtonWidth() -- line: 77
		-- upvalues: p1 (copy)
		local current = p1.joinButtonRef.current

		if current then
			local AbsoluteSizeX = current.AbsoluteSize.X

			p1:setState({
				joinButtonWidth = AbsoluteSizeX
			})
		end
	end
end
function v27.didMount(p3) -- line: 88
	p3.updateJoinButtonWidth()
end
function v27.render(p4) -- line: 92
	-- upvalues: HorizontalInnerPadding (copy), HorizontalOuterPadding (copy), AvatarSize (copy), Constants (copy), SourceSans (copy), User (copy), Roact (copy), FriendIcon (copy), v26 (copy), Skeleton (copy), FitImageTextButton (copy), withStyle (copy), GetFFlagLuaAppUseWithLocalization (copy), withLocalization (copy)
	local upToDateUser = p4.props.upToDateUser
	local layoutOrder = p4.props.layoutOrder
	local entryHeight = p4.props.entryHeight
	local entryWidth = p4.props.entryWidth
	local universeId = p4.props.universeId
	local localization = p4.props.localization
	local universePlaceInfo = p4.props.universePlaceInfo
	local joinButtonWidth = p4.state.joinButtonWidth
	local v40 = not not universePlaceInfo and (universePlaceInfo.isPlayable or false)
	local u41 = not entryWidth and 60 or math.max((entryWidth - HorizontalInnerPadding) / 2 - HorizontalInnerPadding, 60)
	local v42 = HorizontalOuterPadding * 2 + AvatarSize + HorizontalInnerPadding * 2 + joinButtonWidth

	local function v43(p5, p6) -- line: 116
		-- upvalues: Constants (copy), SourceSans (copy), p4 (copy), upToDateUser (copy), User (copy), universeId (copy), v40 (copy), Roact (copy), entryWidth (copy), entryHeight (copy), layoutOrder (copy), AvatarSize (copy), HorizontalOuterPadding (copy), FriendIcon (copy), v42 (copy), v26 (copy), Skeleton (copy), FitImageTextButton (copy), u41 (ref)
		local GREEN_PRIMARY = Constants.Color.GREEN_PRIMARY
		local n1 = 0
		local WHITE = Constants.Color.WHITE
		local n2 = 0
		local v67 = SourceSans
		local v68 = SourceSans
		local BLACK = Constants.Color.BLACK
		local n3 = 0
		local n4 = 22
		local WHITE2 = Constants.Color.WHITE
		local n5 = 0
		local v74 = if not p4.props.enableDisplayNamePolicy then p4.props.userName else p4.props.combinedName

		if p5 then
			GREEN_PRIMARY = p5.Theme.ContextualPrimaryDefault.Color
			n1 = p5.Theme.ContextualPrimaryDefault.Transparency
			WHITE = p5.Theme.ContextualPrimaryContent.Color
			n2 = p5.Theme.ContextualPrimaryContent.Transparency
			v67 = p5.Font.Header2.Font
			v68 = p5.Font.Body.Font
			BLACK = p5.Theme.TextDefault.Color
			n3 = p5.Theme.TextDefault.Transparency
			n4 = p5.Font.BaseSize * p5.Font.Body.RelativeSize
			WHITE2 = p5.Theme.BackgroundUIDefault.Color
			n5 = p5.Theme.BackgroundUIDefault.Transparency
		end

		local onJoinButtonActivated

		if upToDateUser.presence == User.PresenceType.IN_GAME and tostring(upToDateUser.universeId) == tostring(universeId) and v40 then
			onJoinButtonActivated = p4.onJoinButtonActivated
		else
			onJoinButtonActivated = nil

			if p5 then
				n1 *= 0.5
				n2 *= 0.5
			else
				GREEN_PRIMARY = Constants.Color.GREEN_DISABLED
			end
		end

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(0, entryWidth, 0, entryHeight),
			BackgroundColor3 = WHITE2,
			BackgroundTransparency = n5,
			LayoutOrder = layoutOrder
		}, {
			AvatarHolder = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0, AvatarSize, 0, AvatarSize),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, HorizontalOuterPadding, 0.5, 0)
			}, {
				Avatar = Roact.createElement(FriendIcon, {
					layoutOrder = 1,
					user = upToDateUser,
					itemSize = AvatarSize,
					maskColor = WHITE2
				})
			}),
			Username = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -v42, 1, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, v26, 0.5, 0)
			}, {
				Text = if p4.props.shouldShimmerName then nil else Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					Text = v74,
					TextSize = n4,
					Font = v68,
					TextColor3 = BLACK,
					TextTransparency = n3,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center
				}),
				ShimmerName = if not p4.props.shouldShimmerName then nil else Roact.createElement(Skeleton, {
					Size = UDim2.fromScale(0.8, 0.5),
					Position = UDim2.new(0, 0, 0.25, 0)
				})
			}),
			JoinButton = Roact.createElement(FitImageTextButton, {
				backgroundColor = GREEN_PRIMARY,
				backgroundTransparency = n1,
				backgroundImage = "LuaApp/9-slice/input-default",
				leftIconEnabled = false,
				height = 32,
				minWidth = 60,
				maxWidth = u41,
				text = p6.joinText,
				textFont = v67,
				textColor = WHITE,
				textTransparency = n2,
				anchorPoint = Vector2.new(1, 0.5),
				position = UDim2.new(1, -HorizontalOuterPadding, 0.5, 0),
				onActivated = onJoinButtonActivated,
				[Roact.Ref] = p4.joinButtonRef,
				[Roact.Change.AbsoluteSize] = p4.updateJoinButtonWidth
			})
		})
	end
	local function v44(p7) -- line: 238
		-- upvalues: withStyle (copy), v43 (copy)
		return withStyle(function(p8) -- line: 239
			-- upvalues: v43 (copy), p7 (copy)
			return v43(p8, p7)
		end)
	end

	if GetFFlagLuaAppUseWithLocalization() then
		return withLocalization({
			joinText = "Feature.Chat.Drawer.Join"
		})(v44)
	end

	return v44({
		joinText = localization:Format("Feature.Chat.Drawer.Join")
	})
end

local function JoinableFriendEntryWrapper(p9) -- line: 256
	-- upvalues: useSelector (copy), useRoactService (copy), RoactAnalyticsCommonGameEvents (copy), RoactLocalization (copy), useAppPolicy (copy), UserProfiles (copy), Roact (copy), v27 (copy), Cryo (copy)
	local v46 = useSelector(function(p10) -- line: 259
		-- upvalues: p9 (copy)
		local id = p9.user.id
		local universeId = p9.universeId

		return {
			upToDateUser = p10.Users[id],
			universePlaceInfo = p10.UniversePlaceInfos[universeId]
		}
	end)
	local v47 = useRoactService(RoactAnalyticsCommonGameEvents)
	local v48 = useRoactService(RoactLocalization)
	local v49 = useAppPolicy(function(p11) -- line: 272
		return p11.getShowDisplayName()
	end)
	local v50 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { p9.user.id },
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})
	local v51 = if not v50 or not v50.data then nil else UserProfiles.Selectors.getUsernameFromId(v50.data, p9.user.id)
	local v52 = if not v50 or not v50.data then nil else UserProfiles.Selectors.getCombinedNameFromId(v50.data, p9.user.id)
	local v53 = not v50 or (v50.loading and true or not not v50.error)

	return Roact.createElement(v27, Cryo.Dictionary.join(p9, {
		upToDateUser = v46.upToDateUser,
		universePlaceInfo = v46.universePlaceInfo,
		analytics = v47,
		localization = v48,
		enableDisplayNamePolicy = v49,
		userName = v51,
		combinedName = v52,
		shouldShimmerName = v53
	}))
end

return JoinableFriendEntryWrapper
