local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ApiFetchGamePasses = require(Modules.LuaApp.Thunks.Games.ApiFetchGamePasses)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local t = require(CorePackages.Packages.t)
local withLocalization = require(Modules.LuaApp.withLocalization)
local Cryo = require(CorePackages.Packages.Cryo)
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local EdpStoreAnalytics = require(CorePackages.Workspace.Packages.EdpStoreAnalytics)
local Constants = EdpStoreAnalytics.Constants
local EdpStoreImpressionsDetector = EdpStoreAnalytics.EdpStoreImpressionsDetector
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local ImpressionsTagUtility = require(CorePackages.Workspace.Packages.Impressions).ImpressionsTagUtility
local GetFFlagEnableEdpStoreClickLogging = require(Modules.LuaApp.Flags.GetFFlagEnableEdpStoreClickLogging)
local GetFFlagEnableEdpStoreGridPositionLogging = require(Modules.LuaApp.Flags.GetFFlagEnableEdpStoreGridPositionLogging)
local FFlagLuaAppPassesPageFallbackViewWidth = require(Modules.LuaApp.Flags.FFlagLuaAppPassesPageFallbackViewWidth)
local getFallbackViewWidth = require(Modules.LuaApp.Components.Passes.getFallbackViewWidth)
local ApiFetchPassesThumbnails = require(Modules.LuaApp.Thunks.ApiFetchPassesThumbnails)
local ApiFetchGameDeveloperProducts = require(Modules.LuaApp.Thunks.DeveloperProduct.ApiFetchGameDeveloperProducts)
local ApiFetchGameSubscriptionProducts = require(Modules.LuaApp.Thunks.Subscription.ApiFetchGameSubscriptionProducts)
local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)
local DataStatus = DataHydration.DataStatus
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local PassesGrid = require(Modules.LuaApp.Components.Passes.PassesGrid)
local SubscriptionsGrid = require(Modules.LuaApp.Components.Subscription.SubscriptionsGrid)
local DeveloperProductsGrid = require(Modules.LuaApp.Components.DeveloperProduct.DeveloperProductsGrid)
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local GetFFlagEnableDevSubsInRobux = require(Modules.LuaApp.Flags.GetFFlagEnableDevSubsInRobux)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagLuaAppGamePassesDataHydrationMigrationEnabled = SharedFlags.FFlagLuaAppGamePassesDataHydrationMigrationEnabled
local FFlagLuaAppSduiEdpEnabled = SharedFlags.FFlagLuaAppSduiEdpEnabled
local FFlagLuaAppFixPassesPageStoreFetch = SharedFlags.FFlagLuaAppFixPassesPageStoreFetch
local useGamePasses = require(Modules.LuaApp.Components.ExperienceDetails.Hooks.useGamePasses)
local v41 = Roact.PureComponent:extend("PassesPage")

v41.validateProps = t.strictInterface({
	universeId = t.string,
	viewWidth = if not GetFFlagEnableEdpStoreGridPositionLogging() then nil else t.optional(t.number),
	networking = t.callback,
	passes = t.optional(t.table),
	showSubscriptionProducts = t.optional(t.boolean),
	subscriptionProducts = if not FFlagLuaAppFixPassesPageStoreFetch then nil else t.optional(t.table),
	developerProducts = t.optional(t.table),
	rootPlaceId = t.optional(t.string),
	localUserId = t.optional(t.string),
	creatorName = t.optional(t.string),
	creatorVerified = t.optional(t.boolean),
	topBarHeight = if not FFlagAppIaScrollAway then nil else t.number,
	requestPassesThumbnails = if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then t.callback else nil,
	fetchGamePasses = if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then t.callback else nil,
	fetchGameSubscriptionProducts = if not FFlagLuaAppFixPassesPageStoreFetch then nil else t.callback,
	fetchGameDeveloperProducts = t.callback,
	textSizeOffset = t.number
})

function v41.init(p1) -- line: 85
	-- upvalues: Roact (copy), AppCommonLib (copy)
	p1.gamePassRef = Roact.createRef()
	p1.developerProductsRef = Roact.createRef()
	p1.subscriptionsRef = Roact.createRef()
	p1.storeContainerRef = Roact.createRef()
	p1.scrollViewPositionChangedSignal = Roact.createRef()
	p1.scrollViewPositionChangedSignal.current = AppCommonLib.Signal.new()

	function p1.scrollViewPositionChangedSignalCallback(_) -- line: 94
		-- upvalues: p1 (copy)
		p1.scrollViewPositionChangedSignal.current:fire()
	end
	function p1.fetchPassesThumbnails(p3, p4) -- line: 98
		-- upvalues: p1 (copy)
		if p3 then
			local t1 = {}

			for _, v in ipairs(p3) do
				table.insert(t1, v.id)
			end

			p1.props.requestPassesThumbnails(p4, t1)
		end
	end
	function p1.fetchGameDeveloperProducts(p5, p6, p7, p8) -- line: 109
		-- upvalues: p1 (copy)
		p1.props.fetchGameDeveloperProducts(p5, p6, p7, p8)
	end
end
function v41.render(p9) -- line: 114
	-- upvalues: ImpressionsTagUtility (copy), Constants (copy), Roact (copy), EdpStoreImpressionsDetector (copy), withStyle (copy), TopBar (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), withLocalization (copy), SubscriptionsGrid (copy), GetFFlagEnableDevSubsInRobux (copy), PassesGrid (copy), GetFFlagEnableEdpStoreClickLogging (copy), GetFFlagEnableEdpStoreGridPositionLogging (copy), DeveloperProductsGrid (copy)
	local universeId = p9.props.universeId
	local passes = p9.props.passes
	local v48 = passes and #passes > 0
	local showSubscriptionProducts = p9.props.showSubscriptionProducts
	local developerProducts = p9.props.developerProducts
	local v51 = developerProducts and #developerProducts > 0

	local function u52(p10) -- line: 130
		-- upvalues: p9 (copy)
		p9.storeContainerRef.current = p10
	end
	local function u53(p11) -- line: 133
		-- upvalues: p9 (copy), ImpressionsTagUtility (copy), Constants (copy)
		p9.gamePassRef.current = p11
		ImpressionsTagUtility.AddTag(p9.gamePassRef, Constants.ImpressionsTags.GamePasses, 1)
	end
	local function u54(p12) -- line: 137
		-- upvalues: p9 (copy), ImpressionsTagUtility (copy), Constants (copy)
		p9.developerProductsRef.current = p12
		ImpressionsTagUtility.AddTag(p9.developerProductsRef, Constants.ImpressionsTags.DeveloperProducts, 1)
	end
	local function u55(p13) -- line: 145
		-- upvalues: p9 (copy), ImpressionsTagUtility (copy), Constants (copy)
		p9.subscriptionsRef.current = p13
		ImpressionsTagUtility.AddTag(p9.subscriptionsRef, Constants.ImpressionsTags.Subscriptions, 1)
	end

	local u56 = Roact.createElement(EdpStoreImpressionsDetector, {
		parentRef = p9.storeContainerRef,
		scrollViewPositionChangedSignal = p9.scrollViewPositionChangedSignal,
		impressionsTag = Constants.ImpressionsTags.GamePasses,
		parameters = {
			universeId = p9.props.universeId,
			productType = Constants.StoreEnums.ProductType.GamePasses,
			locationType = Constants.StoreEnums.LocationType.Store
		}
	})
	local u57 = Roact.createElement(EdpStoreImpressionsDetector, {
		parentRef = p9.storeContainerRef,
		scrollViewPositionChangedSignal = p9.scrollViewPositionChangedSignal,
		impressionsTag = Constants.ImpressionsTags.DeveloperProducts,
		parameters = {
			universeId = p9.props.universeId,
			productType = Constants.StoreEnums.ProductType.DeveloperProducts,
			locationType = Constants.StoreEnums.LocationType.Store
		}
	})
	local u58 = Roact.createElement(EdpStoreImpressionsDetector, {
		parentRef = p9.storeContainerRef,
		scrollViewPositionChangedSignal = p9.scrollViewPositionChangedSignal,
		impressionsTag = Constants.ImpressionsTags.Subscriptions,
		parameters = {
			universeId = p9.props.universeId,
			productType = Constants.StoreEnums.ProductType.Subscriptions,
			locationType = Constants.StoreEnums.LocationType.Store
		}
	})

	return withStyle(function(p14) -- line: 180
		-- upvalues: Roact (copy), TopBar (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), p9 (copy), u52 (ref), withLocalization (copy), u56 (ref), u57 (ref), u58 (ref), showSubscriptionProducts (copy), u55 (ref), SubscriptionsGrid (copy), universeId (copy), GetFFlagEnableDevSubsInRobux (copy), v48 (copy), u53 (ref), PassesGrid (copy), passes (copy), GetFFlagEnableEdpStoreClickLogging (copy), Constants (copy), GetFFlagEnableEdpStoreGridPositionLogging (copy), v51 (copy), u54 (ref), DeveloperProductsGrid (copy), developerProducts (copy)
		return Roact.createElement("Frame", {
			Name = "PassesContent",
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = p14.Theme.BackgroundDefault.Color,
			BackgroundTransparency = p14.Theme.BackgroundDefault.Transparency
		}, {
			TopBar = Roact.createElement(TopBar.Container, {
				leftItem = TopBar.BackButton,
				rightItems = { TopBar.BuyRobuxButton }
			}),
			PageContent = Roact.createElement(TopBar.PageContent, {}, {
				MainPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, (not FFlagAppIaScrollAway or not AppNavBar.getScrollAwayEnabled()) and 24 or 24 + p9.props.topBarHeight),
					PaddingBottom = UDim.new(0, 24),
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}),
				PassesArea = Roact.createElement("ScrollingFrame", {
					Name = "PassesArea",
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					ClipsDescendants = false,
					CanvasSize = UDim2.new(1, 0, 0, 0),
					ScrollBarThickness = 0,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					ElasticBehavior = Enum.ElasticBehavior.Always,
					[Roact.Ref] = u52
				}, {
					GridLayoutContainer = withLocalization({
						subscriptions = "Feature.Subscription.Heading.Subscriptions",
						passes = "Feature.GamePass.Heading.PassesForThisGame",
						developerProducts = "Feature.DeveloperProducts.Heading.Products"
					})(function(p15) -- line: 222
						-- upvalues: Roact (copy), p9 (copy), u56 (ref), u57 (ref), u58 (ref), showSubscriptionProducts (copy), p14 (copy), u55 (ref), SubscriptionsGrid (copy), universeId (copy), GetFFlagEnableDevSubsInRobux (copy), v48 (copy), u53 (ref), PassesGrid (copy), passes (copy), GetFFlagEnableEdpStoreClickLogging (copy), Constants (copy), GetFFlagEnableEdpStoreGridPositionLogging (copy), v51 (copy), u54 (ref), DeveloperProductsGrid (copy), developerProducts (copy)
						return Roact.createElement("Frame", {
							Size = UDim2.new(1, 0, 0, 0),
							BackgroundTransparency = 1,
							[Roact.Change.AbsolutePosition] = p9.scrollViewPositionChangedSignalCallback
						}, {
							GamePassesImpressionDetector = u56,
							DeveloperProductsImpressionDetector = u57,
							SubscriptionsImpressionDetector = u58,
							UIListLayout = Roact.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								FillDirection = Enum.FillDirection.Vertical,
								Padding = UDim.new(0, 24)
							}),
							SubscriptionHeader = if not showSubscriptionProducts then nil else Roact.createElement("TextLabel", {
								Text = p15.subscriptions,
								BackgroundTransparency = 1,
								TextColor3 = p14.Theme.TextDefault.Color,
								TextSize = p14.Font.BaseSize * p14.Font.Header2.RelativeSize,
								Font = p14.Font.Header2.Font,
								LayoutOrder = 0,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								TextXAlignment = Enum.TextXAlignment.Left,
								[Roact.Ref] = u55
							}),
							SubscriptionsGrid = if not showSubscriptionProducts then nil else Roact.createElement(SubscriptionsGrid, {
								layoutOrder = 1,
								universeId = universeId,
								creatorName = if not GetFFlagEnableDevSubsInRobux() then nil else p9.props.creatorName,
								creatorVerified = if not GetFFlagEnableDevSubsInRobux() then nil else p9.props.creatorVerified
							}),
							Passes = if not v48 then nil else Roact.createElement("TextLabel", {
								Text = p15.passes,
								BackgroundTransparency = 1,
								TextColor3 = p14.Theme.TextDefault.Color,
								TextSize = p14.Font.BaseSize * p14.Font.Header2.RelativeSize,
								Font = p14.Font.Header2.Font,
								LayoutOrder = 2,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								TextXAlignment = Enum.TextXAlignment.Left,
								[Roact.Ref] = u53
							}),
							PassesGrid = if not v48 then nil else Roact.createElement(PassesGrid, {
								layoutOrder = 3,
								universeId = universeId,
								passes = passes,
								textSizeOffset = p9.props.textSizeOffset,
								locationType = if not GetFFlagEnableEdpStoreClickLogging() then nil else Constants.StoreEnums.LocationType.Store,
								viewWidth = if not GetFFlagEnableEdpStoreGridPositionLogging() then nil else p9.props.viewWidth
							}),
							DeveloperProductHeader = if not v51 then nil else Roact.createElement("TextLabel", {
								Text = p15.developerProducts,
								BackgroundTransparency = 1,
								TextColor3 = p14.Theme.TextDefault.Color,
								TextSize = p14.Font.BaseSize * p14.Font.Header2.RelativeSize,
								Font = p14.Font.Header2.Font,
								LayoutOrder = 4,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y,
								TextXAlignment = Enum.TextXAlignment.Left,
								[Roact.Ref] = u54
							}),
							DeveloperProductsGrid = if not v51 then nil else Roact.createElement(DeveloperProductsGrid, {
								layoutOrder = 5,
								universeId = universeId,
								developerProducts = developerProducts,
								locationType = Constants.StoreEnums.LocationType.Store
							})
						})
					end)
				})
			})
		})
	end)
end
function v41.didMount(p16) -- line: 323
	-- upvalues: FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), FFlagLuaAppFixPassesPageStoreFetch (copy), FFlagLuaAppSduiEdpEnabled (copy), DataHydration (copy), DataStatus (copy)
	local passes = p16.props.passes
	local networking = p16.props.networking
	local developerProducts = p16.props.developerProducts
	local universeId = p16.props.universeId
	local rootPlaceId = p16.props.rootPlaceId
	local localUserId = p16.props.localUserId

	if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled and passes ~= nil then
		p16.fetchPassesThumbnails(passes, networking)
	end

	if developerProducts ~= nil then
		p16.fetchGameDeveloperProducts(networking, universeId, rootPlaceId, localUserId)
	end

	if FFlagLuaAppFixPassesPageStoreFetch and FFlagLuaAppSduiEdpEnabled then
		if FFlagLuaAppGamePassesDataHydrationMigrationEnabled then
			local v66 = DataHydration.Game.getGamePassStore(false)
			local v67 = v66.getPassesForUniverse(universeId).status(false)

			if v67 == DataStatus.NotReady or v67 == DataStatus.Failed then
				v66.fetchPassesForUniverse(universeId)
			end
		elseif passes == nil then
			p16.props.fetchGamePasses(networking, universeId)
		end

		if p16.props.subscriptionProducts == nil then
			p16.props.fetchGameSubscriptionProducts(networking, universeId)
		end

		if developerProducts == nil and rootPlaceId ~= nil and localUserId ~= nil then
			p16.fetchGameDeveloperProducts(networking, universeId, rootPlaceId, localUserId)
		end
	end
end
function v41.didUpdate(p17, p18, _) -- line: 363
	-- upvalues: FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy)
	if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled and p18.passes ~= p17.props.passes then
		p17.fetchPassesThumbnails(p17.props.passes, p17.props.networking)
	end
end

local v42 = RoactRodux.connect(function(p20, p21) -- line: 369
	-- upvalues: GetFFlagEnableDevSubsInRobux (copy), VerifiedBadges (copy), FFlagLuaAppPassesPageFallbackViewWidth (copy), getFallbackViewWidth (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), FFlagLuaAppFixPassesPageStoreFetch (copy), FFlagAppIaScrollAway (copy)
	local v73 = GetFFlagEnableDevSubsInRobux() and VerifiedBadges.isCreatorOfGameVerified(p20, {
		shouldUseV2GameDetails = true,
		universeId = p21.universeId
	})
	local v74 = nil

	if FFlagLuaAppPassesPageFallbackViewWidth and (not p21.viewWidth and (p20.ScreenSize and p20.GlobalGuiInset)) then
		v74 = getFallbackViewWidth(p20.ScreenSize, p20.GlobalGuiInset)
	end

	return {
		passes = if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then p20.GamePasses[tostring(p21.universeId)] else nil,
		showSubscriptionProducts = p20.GameSubscriptionProducts[p21.universeId] and #p20.GameSubscriptionProducts[p21.universeId] > 0,
		subscriptionProducts = if not FFlagLuaAppFixPassesPageStoreFetch then nil else p20.GameSubscriptionProducts[p21.universeId],
		developerProducts = p20.GameDeveloperProducts[tostring(p21.universeId)],
		rootPlaceId = if not p20.GameDetails or not p20.GameDetails[p21.universeId] then nil else p20.GameDetails[p21.universeId].rootPlaceId,
		localUserId = p20.LocalUserId,
		creatorName = if not GetFFlagEnableDevSubsInRobux() or (not p20.GameDetails or not p20.GameDetails[p21.universeId]) then nil else p20.GameDetails[p21.universeId].creator.name,
		creatorVerified = if not GetFFlagEnableDevSubsInRobux() then nil else v73,
		topBarHeight = if not FFlagAppIaScrollAway then nil else p20.TopBar.topBarHeight,
		viewWidth = if not FFlagLuaAppPassesPageFallbackViewWidth then nil else p21.viewWidth or v74
	}
end, function(p22) -- line: 412
	-- upvalues: FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), ApiFetchPassesThumbnails (copy), ApiFetchGamePasses (copy), FFlagLuaAppFixPassesPageStoreFetch (copy), ApiFetchGameSubscriptionProducts (copy), ApiFetchGameDeveloperProducts (copy)
	return {
		requestPassesThumbnails = not FFlagLuaAppGamePassesDataHydrationMigrationEnabled and function(p23, p24) -- line: 416
			-- upvalues: p22 (copy), ApiFetchPassesThumbnails (copy)
			return p22(ApiFetchPassesThumbnails(p23, p24))
		end or nil,
		fetchGamePasses = not FFlagLuaAppGamePassesDataHydrationMigrationEnabled and function(p25, p26) -- line: 421
			-- upvalues: p22 (copy), ApiFetchGamePasses (copy)
			return p22(ApiFetchGamePasses(p25, p26))
		end or nil,
		fetchGameSubscriptionProducts = if not FFlagLuaAppFixPassesPageStoreFetch then nil else function(p27, p28) -- line: 425
			-- upvalues: p22 (copy), ApiFetchGameSubscriptionProducts (copy)
			return p22(ApiFetchGameSubscriptionProducts(p27, p28))
		end,
		fetchGameDeveloperProducts = function(p29, p30, p31, p32) -- line: 429
			-- upvalues: p22 (copy), ApiFetchGameDeveloperProducts (copy)
			return p22(ApiFetchGameDeveloperProducts(p29, p30, p31, p32))
		end
	}
end)(v41)
local u43 = RoactServices.connect({
	networking = RoactNetworking
})(v42)

return function(p33) -- line: 438
	-- upvalues: useTextSizeOffset (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), useGamePasses (copy), Cryo (copy), Roact (copy), u43 (ref)
	local v77 = useTextSizeOffset()
	local v78 = if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then nil else useGamePasses(p33.universeId)
	local v79 = Cryo.Dictionary.join(p33, {
		textSizeOffset = v77,
		passes = if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then nil else v78
	})

	return Roact.createElement(u43, v79)
end
