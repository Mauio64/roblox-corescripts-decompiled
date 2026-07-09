local SocialTab = script:FindFirstAncestor("SocialTab")
local SocialTabParent = SocialTab.Parent
local dependencies = require(SocialTab.dependencies)
local Roact = dependencies.Roact
local withStyle = dependencies.UIBlox.Style.withStyle
local dependenciesText = dependencies.Text
local t = dependencies.t
local llama = dependencies.llama
local Mock = dependencies.Mock
local User = require(SocialTab.User)
local Logger = require(SocialTab.Logger)
local EnumScreens = require(SocialTab.EnumScreens)
local AddFriendsTile = require(script.Parent.AddFriendsTile)
local UserTile = require(script.Parent.UserTile)
local UserCarouselHeader = require(script.Parent.UserCarouselHeader)
local UIBloxCarouselAdaptor = require(script.Parent.UIBloxCarouselAdaptor)
local Sources = require(SocialTabParent.SocialLuaAnalytics).Analytics.Enums.Sources
local v18 = not require(SocialTab.Flags.getFFlagUserCarouselPaddingFixEnabled)() and 8 or 12
local v19 = Roact.PureComponent:extend("UserCarousel")

v19.defaultProps = {
	accountProviderName = "",
	enableDisplayNamePolicy = false,
	friendThumbnailSize = 96,
	LayoutOrder = 0,
	peopleListFrozen = false,
	shouldInviteFromAccountProvider = false,
	wideMode = false,
	hasFriendRequests = false,
	addFriendOnActivated = function() -- line: 36
	end,
	friends = {},
	Logger = Logger,
	onFriendSelected = function() -- line: 42
	end,
	screenSize = Vector2.new(1000, 1000)
}
v19.validateProps = t.interface({
	analytics = t.table,
	accountProviderName = t.optional(t.string),
	addFriendOnActivated = t.optional(t.callback),
	enableDisplayNamePolicy = t.optional(t.boolean),
	friends = t.array(User.validateUser),
	friendThumbnailSize = t.optional(t.number),
	LayoutOrder = t.optional(t.number),
	onFriendSelected = t.optional(t.callback),
	peopleListFrozen = t.optional(t.boolean),
	screenSize = t.optional(t.union(t.Vector2, Mock.MagicMock.is)),
	shouldInviteFromAccountProvider = t.optional(t.boolean),
	wideMode = t.optional(t.boolean),
	hasFriendRequests = t.boolean,
	navigateToLuaAppPages = t.optional(t.table),
	goToFriendsLanding = t.optional(t.callback),
	goToAddFriends = t.optional(t.callback),
	isLuaProfilePageEnabled = t.optional(t.boolean),
	luaAddFriendsPageEnabled = t.optional(t.boolean)
})

function v19.init(p1) -- line: 71
	-- upvalues: llama (copy), Sources (copy), EnumScreens (copy)
	p1.state = {
		friends = {}
	}

	function p1.onFriendSelected(p2) -- line: 76
		-- upvalues: p1 (copy), llama (copy), Sources (copy), EnumScreens (copy)
		p1.props.Logger:info("Going to ViewUser")
		p1.props.analytics:buttonClick("UserTile", {
			friendId = p2.user.id,
			position = p2.positionIndex,
			subpage = if not p1.props.isLuaProfilePageEnabled then nil else "peekView",
			page = if not p1.props.isLuaProfilePageEnabled then nil else "playerProfile"
		})

		if p1.props.isLuaProfilePageEnabled then
			p1.props.analytics:navigate("ViewUserProfile")
		end

		local v24 = llama.Dictionary.join(p2, {
			onOpen = function() -- line: 89
				-- upvalues: p1 (copy)
				p1.props.setPeopleListFrozen(true)
			end,
			onClose = function() -- line: 92
				-- upvalues: p1 (copy)
				p1.props.setPeopleListFrozen(false)
			end
		})

		if p1.props.isLuaProfilePageEnabled then
			local t1 = {
				openJoinable = true,
				contextualMenuProps = v24,
				profilePeekViewProps = {
					absolutePosition = p2.absolutePosition,
					source = Sources.SocialTab
				}
			}

			p1.props.navigateToLuaAppPages[EnumScreens.ViewUserProfile](p2.user.id, t1)

			return
		end

		p1.props.navigateToLuaAppPages[EnumScreens.ViewUser](v24)
	end
	function p1.goToFriendRequestsPage() -- line: 112
		-- upvalues: p1 (copy), EnumScreens (copy)
		local v26 = p1.props.enableFriendFinder and EnumScreens.FriendFinder or EnumScreens.AddFriends

		p1.props.navigateToLuaAppPages[v26]()
	end
	function p1.goToFriendsPage() -- line: 118
		-- upvalues: p1 (copy), EnumScreens (copy)
		p1.props.Logger:info("Going to FriendsPage")
		p1.props.analytics:buttonClick("CarouselTitle")
		p1.props.analytics:navigate("CarouselTitle")

		if p1.props.goToFriendsLanding then
			p1.props.analytics:buttonClick("friendsLanding")
			p1.props.analytics:navigate("FriendsLandingPage")
		end

		if p1.props.goToFriendsLanding then
			p1.props.goToFriendsLanding()

			return
		end

		p1.props.navigateToLuaAppPages[EnumScreens.AddFriends]()
	end
	function p1.activatedAddFriendsTile() -- line: 135
		-- upvalues: p1 (copy)
		p1.props.Logger:info("Going to AddFriends")
		p1.props.analytics:buttonClick("AddFriends")
		p1.props.analytics:navigate("AddFriends")
		p1.props.goToAddFriends()
	end
	function p1.activatedFriendRequestsButton() -- line: 142
		-- upvalues: p1 (copy)
		p1.props.Logger:info("Going to FriendRequests")
		p1.props.analytics:buttonClick("FriendRequests", {
			isBadgeShown = p1.props.hasFriendRequests
		})
		p1.props.analytics:navigate("FriendRequests")
		p1.props.goToAddFriends()
	end
end
function v19.getDerivedStateFromProps(p3) -- line: 152
	if not p3.peopleListFrozen then
		return {
			friends = p3.friends
		}
	end

	return nil
end
function v19.render(p4) -- line: 162
	-- upvalues: withStyle (copy), dependenciesText (copy), v18 (copy), Roact (copy), AddFriendsTile (copy), UserTile (copy), UIBloxCarouselAdaptor (copy), UserCarouselHeader (copy)
	return withStyle(function(p5) -- line: 163
		-- upvalues: dependenciesText (copy), p4 (copy), v18 (copy), Roact (copy), AddFriendsTile (copy), UserTile (copy), UIBloxCarouselAdaptor (copy), UserCarouselHeader (copy)
		local CaptionHeaderFont = p5.Font.CaptionHeader.Font
		local v29 = p5.Font.CaptionHeader.RelativeSize * p5.Font.BaseSize
		local v30 = dependenciesText.GetTextBounds("SampleText", CaptionHeaderFont, v29, Vector2.new(10000, 10000))
		local v31 = p4.props.friendThumbnailSize + v30.Y + v18

		local function createAddFriendButton() -- line: 169
			-- upvalues: Roact (copy), AddFriendsTile (copy), p4 (copy), v31 (copy)
			return Roact.createElement(AddFriendsTile, {
				layoutOrder = 1,
				accountProviderName = p4.props.getAccountProviderName,
				onActivated = p4.activatedAddFriendsTile,
				shouldInviteFromAccountProvider = p4.props.shouldInviteFromAccountProvider,
				thumbnailSize = p4.props.friendThumbnailSize,
				totalHeight = v31
			})
		end

		local v33 = Roact.createElement(UIBloxCarouselAdaptor, {
			LayoutOrder = 2,
			createUserEntry = function(p6) -- line: 180
				-- upvalues: createAddFriendButton (copy), Roact (copy), UserTile (copy), p4 (copy), v31 (copy)
				if p6.user == nil then
					return createAddFriendButton()
				end

				return Roact.createElement(UserTile, {
					enableDisplayNamePolicy = p4.props.enableDisplayNamePolicy,
					height = v31,
					layoutOrder = p6.index,
					onActivated = p4.onFriendSelected,
					thumbnailSize = p4.props.friendThumbnailSize,
					user = p6.user,
					absolutePosition = p6.absolutePosition
				})
			end,
			friends = p4.state.friends,
			friendThumbnailSize = p4.props.friendThumbnailSize,
			wideMode = p4.props.wideMode,
			tileHeight = v31
		})

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = p4.props.LayoutOrder,
			Size = UDim2.new(1, 0, 0, v31)
		}, {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 0)
			}),
			UserCarouselHeader = Roact.createElement(UserCarouselHeader, {
				layoutOrder = 1,
				friendCount = #p4.state.friends,
				hasFriendRequests = p4.props.hasFriendRequests,
				goToFriendRequestsPage = p4.activatedFriendRequestsButton,
				goToFriendsPage = p4.goToFriendsPage
			}),
			UserCarousel = v33
		})
	end)
end

return v19
