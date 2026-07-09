local SocialTab = script:FindFirstAncestor("SocialTab")
local SocialTabParent = SocialTab.Parent
local dependencies = require(SocialTab.dependencies)
local Logger = require(SocialTab.Logger)
local t = dependencies.t
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local memoize = dependencies.memoize
local RoactAppExperiment = dependencies.RoactAppExperiment
local FormFactor = require(SocialTabParent.FormFactor).Enums.FormFactor
local ChatEntryPointNames = dependencies.SocialCommon.Enums.ChatEntryPointNames
local DefaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local GridMetrics = UIBlox.App.Grid.GridMetrics
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local Promise = dependencies.Promise
local UserSearchBarButton = require(SocialTabParent.SocialCommon).Components.UserSearchBar.UserSearchBarButton
local Sources = require(SocialTabParent.SocialLuaAnalytics).Analytics.Enums.Sources
local Components = script:FindFirstAncestor("Components")
local ChatTile = require(Components.ChatTile)
local GroupsTile = require(Components.GroupsTile)
local ProfileEntry = require(Components.ProfileEntry)
local RefreshScrollingFrame = dependencies.SocialLibraries.Components.RefreshScrollingFrame
local EntryPoints = dependencies.DiscoverabilityModal.Analytics.EntryPoints
local getFStringSocialConnectTabLayer = require(SocialTabParent.SharedFlags).getFStringSocialConnectTabLayer
local n1 = 24
local n2 = 22
local EnumScreens = require(SocialTab.EnumScreens)
local User = require(SocialTab.User)
local StreamNotificationsBellIcon = dependencies.StreamNotifications.StreamNotificationsBellIcon
local v33 = Roact.PureComponent:extend("SocialTabPage")

v33.TileCellSize = {
	Wide = UDim2.fromOffset(176, 176),
	Compact = UDim2.fromOffset(158, 158)
}
v33.TileHorizontalAlignment = {
	Wide = Enum.HorizontalAlignment.Left,
	Compact = Enum.HorizontalAlignment.Center
}
v33.defaultProps = {
	topBarHeight = 56,
	navigation = nil,
	wideMode = false,
	unreadConversationCount = 0,
	numberOfNotifications = 0,
	enableDisplayNamePolicy = false,
	socialText = "[LOCALIZE] TITLE",
	chatsText = "[LOCALIZE] CHATS",
	groupsText = "[LOCALIZE] GROUPS",
	shouldShowGroupsTilePolicy = false,
	enableNotificationsPolicy = false,
	disableWebViewSupport = false,
	localUser = {},
	renderUserCarousel = function(p1) -- line: 74
		-- upvalues: Roact (copy)
		return Roact.createElement("TextLabel", {
			Text = "User Carousel PlaceHolder",
			Size = UDim2.new(1, 0, 0, 40),
			LayoutOrder = p1.LayoutOrder
		})
	end,
	refreshPageData = function() -- line: 82
		-- upvalues: Promise (copy)
		return Promise.resolve()
	end,
	enteredChatFromEntryPoint = function() -- line: 88
	end
}
v33.validateProps = t.interface({
	topBarHeight = t.optional(t.number),
	showTopBar = t.optional(t.boolean),
	analytics = t.table,
	wideMode = t.optional(t.boolean),
	navigateToLuaAppPages = t.optional(t.table),
	navigation = t.optional(t.table),
	localUser = User.validateUser,
	enableDisplayNamePolicy = t.optional(t.boolean),
	enableNotificationsPolicy = t.optional(t.boolean),
	renderUserCarousel = t.callback,
	socialText = t.optional(t.string),
	chatsText = t.optional(t.string),
	groupsText = t.optional(t.string),
	numberOfNotifications = t.optional(t.number),
	unreadConversationCount = t.optional(t.number),
	refreshPageData = t.optional(t.callback),
	shouldShowGroupsTilePolicy = t.optional(t.boolean),
	luaAddFriendsPageEnabled = t.optional(t.boolean),
	isLuaProfilePageEnabled = t.optional(t.boolean),
	replaceSearchEntry = t.optional(t.boolean),
	enteredChatFromEntryPoint = t.optional(t.callback)
})

function v33.init(p2) -- line: 115
	-- upvalues: n1 (ref), n2 (ref), Logger (copy), ChatEntryPointNames (copy), EnumScreens (copy), Sources (copy), EntryPoints (copy), FormFactor (copy), memoize (copy), Roact (copy), StreamNotificationsBellIcon (copy), IconButton (copy), Images (copy), ChatTile (copy), GroupsTile (copy)
	if p2.props.replaceSearchEntry then
		n1 = 16
		n2 = 16
	end

	p2.gridButtons = p2:getGridItems()

	function p2.goToChat() -- line: 124
		-- upvalues: Logger (copy), p2 (copy), ChatEntryPointNames (copy), EnumScreens (copy)
		Logger:info("Going to Chats")
		p2.props.analytics:buttonClick("Chats")
		p2.props.analytics:navigate("Chats")
		p2.props.enteredChatFromEntryPoint(ChatEntryPointNames.SocialTab)
		p2.props.navigation.navigate(EnumScreens.RoactChat)
	end
	function p2.goToGroups() -- line: 134
		-- upvalues: Logger (copy), p2 (copy), EnumScreens (copy)
		Logger:info("Going to Groups")
		p2.props.analytics:buttonClick("Groups")
		p2.props.analytics:navigate("Groups")
		p2.props.navigateToLuaAppPages[EnumScreens.Groups]()
	end
	function p2.goToUserProfile() -- line: 141
		-- upvalues: Logger (copy), p2 (copy), EnumScreens (copy), Sources (copy), EntryPoints (copy)
		Logger:info("Going to User Profile")
		p2.props.analytics:buttonClick("LoggedInUserIdentity")
		p2.props.analytics:navigate("LoggedInUserIdentity")

		if p2.props.isPhoneVerified and p2.props.isDiscoverabilityUnset then
			p2.props.navigateToLuaAppPages[EnumScreens.DiscoverabilityModal]({
				isStandaloneDiscoverabilityModal = true,
				showToast = p2.props.showToast,
				openLearnMoreLink = p2.props.openLearnMoreLink,
				navigateOnActivated = function() -- line: 150
					-- upvalues: p2 (copy), EnumScreens (copy), Sources (copy)
					p2.props.navigateToLuaAppPages[EnumScreens.ViewUserProfile](p2.props.localUser.id, {
						profilePeekViewProps = {
							source = Sources.SocialTab
						}
					})
				end,
				entryPoint = EntryPoints.SocialTabProfile,
				onClose = p2.props.closeCentralOverlay
			})

			return
		end

		p2.props.navigateToLuaAppPages[EnumScreens.ViewUserProfile](p2.props.localUser.id, {
			profilePeekViewProps = {
				source = Sources.SocialTab
			}
		})
	end
	function p2.goToFriendsLanding() -- line: 169
		-- upvalues: p2 (copy), EnumScreens (copy)
		if p2.props.navigatingFromSocialTabEvent then
			p2.props.navigatingFromSocialTabEvent(EnumScreens.FriendsLanding)
		end

		p2.props.navigateToFriendsPage()
	end
	function p2.goToAddFriends() -- line: 177
		-- upvalues: p2 (copy)
		p2.props.navigateToAddFriendsPage()
	end
	function p2.goToUserSearch() -- line: 181
		-- upvalues: p2 (copy), FormFactor (copy)
		p2.props.analytics:buttonClick("peopleSearchBar", {
			formFactor = p2.props.wideMode and FormFactor.WIDE or FormFactor.COMPACT
		})
		p2.props.analytics:openPlayerSearch()
		p2.props.navigateToUserSearch()
	end

	p2.renderTopBarButtons = memoize(function(p3, _) -- line: 190
		-- upvalues: Roact (copy), StreamNotificationsBellIcon (copy), p2 (copy), IconButton (copy), Images (copy), Logger (copy), EnumScreens (copy)
		local u46 = if not p2.props.enableNotificationsPolicy then nil else Roact.createElement(StreamNotificationsBellIcon, {
			layoutOrder = 3,
			notificationCount = p3,
			compactWidth = not p2.props.wideMode
		})

		if p2.props.disableWebViewSupport then
			return function() -- line: 207
				-- upvalues: Roact (copy)
				return Roact.createFragment({})
			end
		end

		return function() -- line: 211
			-- upvalues: Roact (copy), p2 (copy), IconButton (copy), Images (copy), Logger (copy), EnumScreens (copy), u46 (ref)
			return Roact.createFragment({
				filter = if not p2.props.replaceSearchEntry then Roact.createElement(IconButton, {
					layoutOrder = 1,
					size = UDim2.fromOffset(0, 0),
					icon = Images["icons/common/search"],
					onActivated = function() -- line: 220
						-- upvalues: Logger (copy), p2 (copy), EnumScreens (copy)
						Logger:info("Going to AddFriends")
						p2.props.analytics:buttonClick("SearchFriends")
						p2.props.analytics:navigate("SearchFriends")
						p2.props.navigateToLuaAppPages[EnumScreens.AddFriends]()
					end
				}) else nil,
				notifications = u46
			})
		end
	end)
	p2.renderButtonGridItem = memoize(function(p5) -- line: 233
		-- upvalues: Roact (copy), ChatTile (copy), p2 (copy), GroupsTile (copy)
		return function(p6, p7) -- line: 234
			-- upvalues: Roact (copy), ChatTile (copy), p5 (copy), p2 (copy), GroupsTile (copy)
			if p6 == "Chats" then
				return Roact.createElement(ChatTile, {
					unreadConversationCount = p5,
					LayoutOrder = p7,
					title = p2.props.chatsText,
					onActivated = p2.goToChat
				})
			end

			if p6 == "Groups" then
				return Roact.createElement(GroupsTile, {
					LayoutOrder = p7,
					title = p2.props.groupsText,
					onActivated = p2.goToGroups
				})
			end

			return nil
		end
	end)

	function p2.getButtonGridItemHeight(p8) -- line: 254
		return p8
	end

	local v36, v37 = Roact.createBinding(0)

	p2.contentHeight = v36
	p2.updateContentHeight = v37
end
function v33.getGridItems(p9) -- line: 261
	local t1 = { "Chats" }

	if p9.props.shouldShowGroupsTilePolicy and not p9.props.disableWebViewSupport then
		table.insert(t1, "Groups")
	end

	return t1
end
function v33.render(p10) -- line: 271
	-- upvalues: UIBlox (copy), Roact (copy), HeaderBar (copy), UserSearchBarButton (copy), RefreshScrollingFrame (copy), HorizontalPageMargin (copy), n1 (ref), ProfileEntry (copy), n2 (ref), DefaultMetricsGridView (copy), GridMetrics (copy)
	return UIBlox.Style.withStyle(function(_) -- line: 272
		-- upvalues: Roact (copy), p10 (copy), HeaderBar (copy), UserSearchBarButton (copy), RefreshScrollingFrame (copy), HorizontalPageMargin (copy), n1 (ref), ProfileEntry (copy), n2 (ref), DefaultMetricsGridView (copy), GridMetrics (copy)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			topBar = Roact.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, if not p10.props.replaceSearchEntry then p10.props.topBarHeight else p10.props.topBarHeight + 48)
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				Header = Roact.createElement(HeaderBar, {
					barHeight = p10.props.topBarHeight,
					title = p10.props.socialText,
					renderRight = p10.renderTopBarButtons(p10.props.numberOfNotifications, p10.props.enableNotificationsPolicy)
				}),
				UserSearchBarButton = if not p10.props.replaceSearchEntry then nil else Roact.createElement(UserSearchBarButton, {
					onActivated = p10.goToUserSearch
				})
			}),
			gridFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				ScrollView = Roact.createElement(RefreshScrollingFrame, {
					usesBuilderIcon = true,
					scrollingElementProps = {
						ScrollBarThickness = 0,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 1, if not p10.props.replaceSearchEntry then -p10.props.topBarHeight else -(p10.props.topBarHeight + 48)),
						CanvasSize = UDim2.new(1, 0, 1, if not p10.props.replaceSearchEntry then -p10.props.topBarHeight + 1 else -(p10.props.topBarHeight + 48) + 1),
						AutomaticCanvasSize = Enum.AutomaticSize.XY,
						ScrollingDirection = Enum.ScrollingDirection.Y
					},
					refresh = p10.props.refreshPageData
				}, {
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					pageMargin = Roact.createElement(HorizontalPageMargin, {
						useAutomaticSizing = true,
						layoutOrder = 1,
						backgroundTransparency = 1,
						size = UDim2.new(1, 0, 0, 0)
					}, {
						Layout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						spacerTopBar = Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Size = UDim2.new(1, 0, 0, n1)
						}),
						profileEntry = Roact.createElement(ProfileEntry, {
							layoutOrder = 2,
							userText = p10.props.enableDisplayNamePolicy and p10.props.localUser.displayName or p10.props.localUser.username,
							avatarImage = p10.props.localUser.thumbnail,
							isPremium = p10.props.localUser.isPremium,
							isRobloxSubscriber = p10.props.localUser.isRobloxSubscriber,
							navigateToLuaAppPages = p10.props.navigateToLuaAppPages,
							hasVerifiedBadge = p10.props.localUser.hasVerifiedBadge,
							onActivated = p10.goToUserProfile
						}),
						spacerProfile = Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							Size = UDim2.new(1, 0, 0, n2)
						}),
						friendsCarousel = p10.props.renderUserCarousel({
							LayoutOrder = 4,
							wideMode = p10.props.wideMode,
							navigateToLuaAppPages = p10.props.navigateToLuaAppPages,
							goToFriendsLanding = p10.goToFriendsLanding,
							goToAddFriends = p10.goToAddFriends,
							luaAddFriendsPageEnabled = p10.props.luaAddFriendsPageEnabled
						}),
						spacerFriends = Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 5,
							Size = UDim2.new(1, 0, 0, 36)
						}),
						buttonGrid = Roact.createElement(DefaultMetricsGridView, {
							LayoutOrder = 6,
							renderItem = p10.renderButtonGridItem(p10.props.unreadConversationCount),
							getItemHeight = p10.getButtonGridItemHeight,
							getItemMetrics = GridMetrics.getMediumMetrics,
							itemPadding = Vector2.new(12, 12),
							items = p10.gridButtons
						})
					})
				})
			})
		})
	end)
end
function v33.didMount(p12) -- line: 406
	-- upvalues: Logger (copy)
	Logger:info("SocialTabPage mounted")
	p12.props.analytics:pageLoaded()
end

return (RoactAppExperiment.connectUserLayer({ getFStringSocialConnectTabLayer() }, function(p13, _) -- line: 413
	-- upvalues: getFStringSocialConnectTabLayer (copy)
	return {
		replaceSearchEntry = (p13[getFStringSocialConnectTabLayer()] or {}).replace_search_entry
	}
end)(v33))
