local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local devDependencies = require(FriendsLanding.devDependencies)
local jest = devDependencies.JestGlobals.jest
local installReducer = require(FriendsLanding.installReducer)
local t = dependencies.t
local filterStates = require(FriendsLanding.Friends.filterStates)
local foldProviders = require(FriendsLanding.Utils.foldProviders)
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local FriendsLandingAnalytics = require(FriendsLanding.FriendsLandingAnalytics)
local EnumScreens = require(FriendsLanding.EnumScreens)
local llama = dependencies.llama
local Foundation = devDependencies.Foundation
local UIBlox = dependencies.UIBlox
local Roact = dependencies.Roact
local Rodux = dependencies.Rodux
local RoactRodux = dependencies.RoactRodux
local RoactNavigation = dependencies.RoactNavigation
local ApolloClient = require(FriendsLandingParent.ApolloClient)
local GraphQLServer = require(FriendsLandingParent.GraphQLServer)
local UserProfiles = require(FriendsLandingParent.UserProfiles)
local mockApolloClient = GraphQLServer.ApolloClientTestUtils.mockApolloClient
local ReactFocusNavigation = require(FriendsLandingParent.ReactFocusNavigation)
local FocusNavigationService = ReactFocusNavigation.FocusNavigationService
local CoreGui = ReactFocusNavigation.EngineInterface.CoreGui
local DesignTokenProvider = require(FriendsLandingParent.Style).DesignTokenProvider
local v28 = t.strictInterface({
	context = t.optional(t.table),
	initialState = t.optional(t.table),
	props = t.optional(t.table),
	store = t.optional(t.table),
	policy = t.optional(t.table),
	analytics = t.optional(t.table),
	navigation = t.optional(t.table),
	apolloClient = t.optional(t.table)
})
local t1 = {
	state = {
		routeName = "",
		key = "",
		params = {}
	},
	dispatch = function() -- line: 54
	end,
	goBack = function() -- line: 55
	end,
	addListener = function() -- line: 56
		return {
			remove = function() -- line: 58
			end
		}
	end,
	isFocused = function() -- line: 61
	end,
	setParams = function() -- line: 62
	end,
	getParam = function() -- line: 63
	end,
	navigate = function() -- line: 64
	end,
	_dangerouslyGetParent = function() -- line: 65
	end
}

return function(p1) -- line: 69
	-- upvalues: v28 (copy), Rodux (copy), installReducer (copy), llama (copy), dependencies (copy), mockApolloClient (copy), UserProfiles (copy), ApolloClient (copy), jest (copy), filterStates (copy), EnumScreens (copy), FriendsLandingContext (copy), FriendsLandingAnalytics (copy), RoactNavigation (copy), t1 (copy), DesignTokenProvider (copy), FocusNavigationService (copy), CoreGui (copy), ReactFocusNavigation (copy), RoactRodux (copy), UIBlox (copy), Foundation (copy), Roact (copy), foldProviders (copy)
	return function(p2, p3) -- line: 70
		-- upvalues: v28 (copy), Rodux (copy), installReducer (copy), llama (copy), dependencies (copy), mockApolloClient (copy), UserProfiles (copy), ApolloClient (copy), jest (copy), filterStates (copy), EnumScreens (copy), FriendsLandingContext (copy), FriendsLandingAnalytics (copy), RoactNavigation (copy), t1 (copy), DesignTokenProvider (copy), FocusNavigationService (copy), CoreGui (copy), ReactFocusNavigation (copy), RoactRodux (copy), UIBlox (copy), Foundation (copy), Roact (copy), foldProviders (copy), p1 (copy)
		assert(v28(p3))

		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Parent = game:GetService("CoreGui")

		local t2 = {}
		local t3 = {
			LocalUserId = "LocalUserId",
			ScreenSize = Vector2.new(1000, 1000),
			FriendsLanding = {
				NetworkStatus = {
					["https://friends.roblox.com//v1/users/test/friends"] = "Done"
				}
			}
		}
		local v36 = Rodux.Store.new(Rodux.combineReducers({
			FriendsLanding = installReducer(),
			LocalUserId = function(p4) -- line: 91
				return p4
			end,
			ScreenSize = function(p5) -- line: 94
				return p5
			end
		}), llama.Dictionary.join(t3, p3.initialState), { Rodux.thunkMiddleware })
		local t4 = {
			getShowDisplayName = function() -- line: 104
				return true
			end,
			getFriendFinder = function() -- line: 107
				return true
			end,
			getAccountProviderName = function() -- line: 110
				return ""
			end,
			shouldInviteFromAccountProvider = function() -- line: 113
				return true
			end,
			getEnableProfileQrCode = function() -- line: 116
				return true
			end,
			getShouldHideContactImporterUpsell = function() -- line: 119
				return false
			end,
			getFriendRequestNicknamesEnabled = function() -- line: 122
				return true
			end,
			getCanAccessTrustedContacts = function() -- line: 125
				return false
			end,
			getRequiresOSAFriendingEducation = function() -- line: 128
				return false
			end,
			getWebViewSupport = function() -- line: 131
				return false
			end
		}

		table.insert(t2, {
			dependencies.UniversalAppPolicy.Provider,
			{
				policy = { function() -- line: 140
					-- upvalues: llama (copy), t4 (copy), p3 (copy)
					return llama.Dictionary.join(t4, p3.policy)
				end }
			}
		})

		local v38 = mockApolloClient({})
		local userProfilesFriendsLandingQueryByUserIds = UserProfiles.Queries.userProfilesFriendsLandingQueryByUserIds

		v38:writeQuery({
			variables = {
				userIds = { "0" }
			},
			query = userProfilesFriendsLandingQueryByUserIds,
			data = {
				userProfiles = {{
					__typename = "UserProfile",
					id = "0",
					isVerified = false,
					isDeleted = false,
					names = {
						__typename = "Names",
						combinedName = "test",
						username = "test"
					}
				}}
			}
		})
		v38:writeQuery({
			variables = {
				userIds = { "40" }
			},
			query = userProfilesFriendsLandingQueryByUserIds,
			data = {
				userProfiles = {{
					__typename = "UserProfile",
					id = "40",
					isVerified = false,
					isDeleted = false,
					names = {
						__typename = "Names",
						combinedName = "offlineFriend1",
						username = "offlineFriend1"
					}
				}}
			}
		})
		v38:writeQuery({
			variables = {
				userIds = { "39" }
			},
			query = userProfilesFriendsLandingQueryByUserIds,
			data = {
				userProfiles = {{
					__typename = "UserProfile",
					id = "39",
					isVerified = false,
					isDeleted = false,
					names = {
						__typename = "Names",
						combinedName = "offlineFriend2",
						username = "offlineFriend2"
					}
				}}
			}
		})
		v38:writeQuery({
			variables = {
				userIds = { "38" }
			},
			query = userProfilesFriendsLandingQueryByUserIds,
			data = {
				userProfiles = {{
					__typename = "UserProfile",
					id = "38",
					isVerified = false,
					isDeleted = false,
					names = {
						__typename = "Names",
						combinedName = "onlineFriend",
						username = "onlineFriend"
					}
				}}
			}
		})
		v38:writeQuery({
			variables = {
				userIds = { "37" }
			},
			query = userProfilesFriendsLandingQueryByUserIds,
			data = {
				userProfiles = {{
					__typename = "UserProfile",
					id = "37",
					isVerified = false,
					isDeleted = false,
					names = {
						__typename = "Names",
						combinedName = "inGameFriend",
						username = "inGameFriend"
					}
				}}
			}
		})
		v38:writeQuery({
			variables = {
				userIds = { "36" }
			},
			query = userProfilesFriendsLandingQueryByUserIds,
			data = {
				userProfiles = {{
					__typename = "UserProfile",
					id = "36",
					isVerified = false,
					isDeleted = false,
					names = {
						__typename = "Names",
						combinedName = "inStudioFriend",
						username = "inStudioFriend"
					}
				}}
			}
		})
		v38:writeQuery({
			variables = {
				userIds = { "123" }
			},
			query = userProfilesFriendsLandingQueryByUserIds,
			data = {
				userProfiles = {{
					__typename = "UserProfile",
					id = "123",
					isVerified = false,
					isDeleted = false,
					names = {
						__typename = "Names",
						combinedName = "rowan",
						username = "mance"
					}
				}}
			}
		})
		v38:writeQuery({
			variables = {
				userIds = { "456" }
			},
			query = userProfilesFriendsLandingQueryByUserIds,
			data = {
				userProfiles = {{
					__typename = "UserProfile",
					id = "456",
					isVerified = false,
					isDeleted = false,
					names = {
						__typename = "Names",
						combinedName = "henry",
						username = "williams"
					}
				}}
			}
		})
		table.insert(t2, {
			ApolloClient.ApolloProvider,
			{
				client = v38
			}
		})

		local t5 = {
			setFilterKeys = jest.fn(),
			refreshPage = jest.fn(),
			wideMode = true,
			screenSize = Vector2.new(512, 512),
			filter = filterStates.All,
			navigateToLuaAppPages = {
				[EnumScreens.FriendFinder] = jest.fn(),
				[EnumScreens.ViewUserProfile] = jest.fn()
			},
			getScreenTopBar = function() -- line: 339
				return {
					shouldRenderCenter = false
				}
			end,
			friendRequestCount = 0,
			setScreenTopBar = jest.fn()
		}

		if p3.context then
			llama.Dictionary.map(p3.context, function(p6, p7) -- line: 348
				-- upvalues: t5 (copy)
				t5[p7] = p6
			end)
		end

		table.insert(t2, {
			FriendsLandingContext.Provider,
			{
				value = t5
			}
		})
		table.insert(t2, {
			FriendsLandingAnalytics.Context.Provider,
			{
				value = p3.analytics or {
					buttonClick = jest.fn(),
					pageLoaded = jest.fn(),
					navigate = jest.fn(),
					pageLoadingTimeReport = jest.fn(),
					pageLoadedWithArgs = jest.fn(),
					pageMountingTimeReport = jest.fn(),
					impressionEvent = jest.fn()
				}
			}
		})
		table.insert(t2, {
			RoactNavigation.Provider,
			{
				value = llama.Dictionary.join(t1, p3.navigation)
			}
		})
		table.insert(t2, {
			DesignTokenProvider,
			{
				tokenMappers = {
					App = function(_, p9) -- line: 389
						return {
							Page = {
								BackgroundColor = p9.Color.Surface.Surface_0.Color3,
								BackgroundTransparency = p9.Color.Surface.Surface_0.Transparency,
								SafeAreaMargin = Vector2.new(p9.Size.Size_1600, p9.Size.Size_600)
							}
						}
					end,
					FriendsLanding = function(_, _) -- line: 398
						return {
							AddFriendsPage = {
								GridViewItemMetrics = {
									minimumItemsPerRow = 6,
									minimumItemWidth = 258
								}
							},
							FriendsLandingPage = {
								GridHorizontalSpacing = 24,
								GridVerticalSpacing = 24,
								GridViewItemMetrics = {
									minimumItemsPerRow = 6,
									minimumItemWidth = 258
								}
							},
							ShowMore = {}
						}
					end
				}
			}
		})

		local v41 = FocusNavigationService.new(CoreGui)

		table.insert(t2, {
			ReactFocusNavigation.FocusNavigationContext.Provider,
			{
				value = v41
			}
		})
		table.insert(t2, {
			RoactRodux.StoreProvider,
			{
				store = p3.store or v36
			}
		})
		table.insert(t2, {
			UIBlox.App.Style.AppStyleProvider,
			{
				style = {
					themeName = "Dark",
					fontName = "Gotham"
				}
			}
		})
		table.insert(t2, {
			Foundation.FoundationProvider,
			{
				style = {
					theme = Foundation.Enums.Theme.Dark,
					device = Foundation.Enums.Device.Desktop
				}
			}
		})

		local v42 = Roact.createElement(p2, llama.Dictionary.join(p3.props))
		local v43 = foldProviders(v42, t2)
		local v44 = Roact.mount(p1(v43), ScreenGui)

		return ScreenGui, function() -- line: 467
			-- upvalues: Roact (copy), v44 (copy), ScreenGui (copy), v41 (copy)
			Roact.unmount(v44)
			ScreenGui:Destroy()
			v41:focusGuiObject(nil)
			v41:teardown()
		end
	end
end
