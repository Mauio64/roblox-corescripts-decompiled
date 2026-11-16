local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local module = require("@luauforge/bundled/fXj")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/eda")
local t = require(CorePackages.Packages.t)
local module3 = require("@luauforge/bundled/edC")
local Cryo = require(CorePackages.Packages.Cryo)
local module4 = require("@luauforge/bundled/dHu")
local module5 = require("@luauforge/deferred/fXN")
local constants = module5.Constants
local edpStoreImpressionsDetector = module5.EdpStoreImpressionsDetector
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset

local AppCommonLib = require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local impressionsTagUtility = require("@luauforge/bundled/edd").ImpressionsTagUtility
local module7 = require("@luauforge/deferred/fXQ")

local module8 = require("@luauforge/deferred/fXs")
local module9 = require("@luauforge/deferred/gaJ")
local module10 = require("@luauforge/deferred/gaK")
local module11 = require("@luauforge/bundled/fWR")
local module12 = require("@luauforge/bundled/fXw")
local module13 = require("@luauforge/bundled/fXG")

local module14 = require("@luauforge/bundled/dPI")
local dataStatus = module14.DataStatus

local module15 = require("@luauforge/bundled/fox")
local module16 = require("@luauforge/deferred/fXt")
local module17 = require("@luauforge/deferred/gaL")
local module18 = require("@luauforge/deferred/gaR")

local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges")

local module20 = require("@luauforge/deferred/gaQ")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway

local fFlagLuaAppGamePassesDataHydrationMigrationEnabled = SharedFlags.FFlagLuaAppGamePassesDataHydrationMigrationEnabled
local fFlagLuaAppSduiEdpEnabled = SharedFlags.FFlagLuaAppSduiEdpEnabled
local fFlagLuaAppFixPassesPageStoreFetch = SharedFlags.FFlagLuaAppFixPassesPageStoreFetch

local module22 = require("@luauforge/deferred/fYa")

local extended = Roact.PureComponent:extend("PassesPage")

local strictInterface = t.strictInterface
local v5 = {
	universeId = t.string,
	viewWidth = 0,
	networking = 0,
	passes = 0,
	showSubscriptionProducts = 0,
	subscriptionProducts = 0,
	developerProducts = 0,
	rootPlaceId = 0,
	localUserId = 0,
	creatorName = 0,
	creatorVerified = 0,
	topBarHeight = 0,
	requestPassesThumbnails = 0,
	fetchGamePasses = 0,
	fetchGameSubscriptionProducts = 0,
	fetchGameDeveloperProducts = 0,
	textSizeOffset = 0
}
local v6 = if module8() then t.optional(t.number) else nil
v5.viewWidth = v6

v5.networking = t.callback

v5.passes = t.optional(t.table)
v5.showSubscriptionProducts = t.optional(t.boolean)
local v7 = if fFlagLuaAppFixPassesPageStoreFetch then t.optional(t.table) else nil
v5.subscriptionProducts = v7
v5.developerProducts = t.optional(t.table)
v5.rootPlaceId = t.optional(t.string)
v5.localUserId = t.optional(t.string)
v5.creatorName = t.optional(t.string)
v5.creatorVerified = t.optional(t.boolean)
local v8 = if fFlagAppIaScrollAway then t.number else nil
v5.topBarHeight = v8

local v9 = if not fFlagLuaAppGamePassesDataHydrationMigrationEnabled then t.callback else nil
v5.requestPassesThumbnails = v9
local v10 = if not fFlagLuaAppGamePassesDataHydrationMigrationEnabled then t.callback else nil
v5.fetchGamePasses = v10
local v11 = if fFlagLuaAppFixPassesPageStoreFetch then t.callback else nil
v5.fetchGameSubscriptionProducts = v11
v5.fetchGameDeveloperProducts = t.callback

v5.textSizeOffset = t.number
extended.validateProps = strictInterface(v5)

function extended:init()
	self.gamePassRef = Roact.createRef()
	self.developerProductsRef = Roact.createRef()
	self.subscriptionsRef = Roact.createRef()
	self.storeContainerRef = Roact.createRef()

	self.scrollViewPositionChangedSignal = Roact.createRef()
	self.scrollViewPositionChangedSignal.current = AppCommonLib.Signal.new()

	function self.scrollViewPositionChangedSignalCallback(p2)
		self.scrollViewPositionChangedSignal.current:fire()
	end

	function self.fetchPassesThumbnails(list, p2)
		if list then
			local ids = {}

			for i, item in ipairs(list) do
				table.insert(ids, item.id)
			end

			self.props.requestPassesThumbnails(p2, ids)
		end
	end

	function self.fetchGameDeveloperProducts(p2, p3, p4, p5)
		self.props.fetchGameDeveloperProducts(p2, p3, p4, p5)
	end
end

function extended.render(props)
	local universeId = props.props.universeId
	local passes = props.props.passes
	local v12 = passes and #passes > 0
	local showSubscriptionProducts = props.props.showSubscriptionProducts
	local developerProducts = props.props.developerProducts
	local v13 = developerProducts and #developerProducts > 0

	local function fn(current)
		props.storeContainerRef.current = current
	end
	local function fn2(current)
		props.gamePassRef.current = current
		impressionsTagUtility.AddTag(props.gamePassRef, constants.ImpressionsTags.GamePasses, 1)
	end
	local function fn3(current)
		props.developerProductsRef.current = current
		impressionsTagUtility.AddTag(
			props.developerProductsRef,
			constants.ImpressionsTags.DeveloperProducts,
			1
		)
	end
	local function fn4(current)
		props.subscriptionsRef.current = current
		impressionsTagUtility.AddTag(props.subscriptionsRef, constants.ImpressionsTags.Subscriptions, 1)
	end
	local element = Roact.createElement(edpStoreImpressionsDetector, {
		parentRef = props.storeContainerRef,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		impressionsTag = constants.ImpressionsTags.GamePasses,
		parameters = {
			universeId = props.props.universeId,
			productType = constants.StoreEnums.ProductType.GamePasses,
			locationType = constants.StoreEnums.LocationType.Store
		}
	})

	local element2 = Roact.createElement(edpStoreImpressionsDetector, {
		parentRef = props.storeContainerRef,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		impressionsTag = constants.ImpressionsTags.DeveloperProducts,
		parameters = {
			universeId = props.props.universeId,
			productType = constants.StoreEnums.ProductType.DeveloperProducts,
			locationType = constants.StoreEnums.LocationType.Store
		}
	})

	local element3 = Roact.createElement(edpStoreImpressionsDetector, {
		parentRef = props.storeContainerRef,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		impressionsTag = constants.ImpressionsTags.Subscriptions,
		parameters = {
			universeId = props.props.universeId,
			productType = constants.StoreEnums.ProductType.Subscriptions,
			locationType = constants.StoreEnums.LocationType.Store
		}
	})

	return withStyle(function(props2)
		return Roact.createElement("Frame", {
			Name = "PassesContent",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = props2.Theme.BackgroundDefault.Color,
			BackgroundTransparency = props2.Theme.BackgroundDefault.Transparency,
			BorderSizePixel = 0
		}, {
			TopBar = Roact.createElement(module15.Container, {
				leftItem = module15.BackButton,
				rightItems = { module15.BuyRobuxButton }
			}),
			PageContent = Roact.createElement(module15.PageContent, {}, {
				MainPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(
						0,
						not (fFlagAppIaScrollAway and module4.getScrollAwayEnabled()) and 24 or 24 + props.props.topBarHeight
					),
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
					[Roact.Ref] = fn
				}, {
					GridLayoutContainer = module3({
						subscriptions = "Feature.Subscription.Heading.Subscriptions",
						passes = "Feature.GamePass.Heading.PassesForThisGame",
						developerProducts = "Feature.DeveloperProducts.Heading.Products"
					})(function(props3)
						local createElement4 = Roact.createElement
						local scrollViewPositionChangedSignalCallbacksByAbsolutePosition = {
							Size = UDim2.new(1, 0, 0, 0),
							BackgroundTransparency = 1,
							[Roact.Change.AbsolutePosition] = props.scrollViewPositionChangedSignalCallback
						}
						local v19 = {
							GamePassesImpressionDetector = element,
							DeveloperProductsImpressionDetector = element2,
							SubscriptionsImpressionDetector = element3,
							UIListLayout = Roact.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								FillDirection = Enum.FillDirection.Vertical,
								Padding = UDim.new(0, 24)
							}),
							SubscriptionHeader = 0,
							SubscriptionsGrid = 0,
							Passes = 0,
							PassesGrid = 0,
							DeveloperProductHeader = 0,
							DeveloperProductsGrid = 0
						}
						local v20

						if showSubscriptionProducts then
							local createElement5 = Roact.createElement
							local v22 = {}
							v22.Text = props3.subscriptions
							v22.BackgroundTransparency = 1
							v22.TextColor3 = props2.Theme.TextDefault.Color
							v22.TextSize = props2.Font.BaseSize * props2.Font.Header2.RelativeSize
							local v23 = if not foundationFontFaceMigration then props2.Font.Header2.Font else nil
							v22.Font = v23

							local v24 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.TitleLarge.Font) else nil
							v22.FontFace = v24

							v22.LayoutOrder = 0
							v22.Size = UDim2.new(1, 0, 0, 0)
							v22.AutomaticSize = Enum.AutomaticSize.Y
							v22.TextXAlignment = Enum.TextXAlignment.Left
							v22[Roact.Ref] = fn4
							v20 = createElement5("TextLabel", v22)
						end

						v19.SubscriptionHeader = v20
						local v21

						if showSubscriptionProducts then
							local createElement5 = Roact.createElement
							local v23 = {
								universeId = universeId,
								layoutOrder = 1,
								creatorName = 0,
								creatorVerified = 0
							}

							local v24 = if module20() then props.props.creatorName else nil
							v23.creatorName = v24

							local v25 = if module20() then props.props.creatorVerified else nil
							v23.creatorVerified = v25
							v21 = createElement5(module17, v23)
						end

						v19.SubscriptionsGrid = v21
						local v22

						if v12 then
							local createElement5 = Roact.createElement
							local v24 = {}
							v24.Text = props3.passes
							v24.BackgroundTransparency = 1
							v24.TextColor3 = props2.Theme.TextDefault.Color
							v24.TextSize = props2.Font.BaseSize * props2.Font.Header2.RelativeSize
							local v25 = if not foundationFontFaceMigration then props2.Font.Header2.Font else nil
							v24.Font = v25

							local v26 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.TitleLarge.Font) else nil
							v24.FontFace = v26

							v24.LayoutOrder = 2
							v24.Size = UDim2.new(1, 0, 0, 0)
							v24.AutomaticSize = Enum.AutomaticSize.Y
							v24.TextXAlignment = Enum.TextXAlignment.Left
							v24[Roact.Ref] = fn2
							v22 = createElement5("TextLabel", v24)
						end

						v19.Passes = v22
						local v23

						if v12 then
							local createElement5 = Roact.createElement
							local v25 = {
								universeId = universeId,
								passes = passes,
								layoutOrder = 3,
								textSizeOffset = props.props.textSizeOffset,
								locationType = 0,
								viewWidth = 0
							}
							local v26 = if module7() then constants.StoreEnums.LocationType.Store else nil
							v25.locationType = v26

							local v27 = if module8() then props.props.viewWidth else nil
							v25.viewWidth = v27
							v23 = createElement5(module16, v25)
						end

						v19.PassesGrid = v23
						local v24

						if v13 then
							local createElement5 = Roact.createElement
							local v26 = {}
							v26.Text = props3.developerProducts
							v26.BackgroundTransparency = 1
							v26.TextColor3 = props2.Theme.TextDefault.Color
							v26.TextSize = props2.Font.BaseSize * props2.Font.Header2.RelativeSize
							local v27 = if not foundationFontFaceMigration then props2.Font.Header2.Font else nil
							v26.Font = v27

							local v28 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.TitleLarge.Font) else nil
							v26.FontFace = v28

							v26.LayoutOrder = 4
							v26.Size = UDim2.new(1, 0, 0, 0)
							v26.AutomaticSize = Enum.AutomaticSize.Y
							v26.TextXAlignment = Enum.TextXAlignment.Left
							v26[Roact.Ref] = fn3
							v24 = createElement5("TextLabel", v26)
						end

						v19.DeveloperProductHeader = v24

						local v25 = if v13 then Roact.createElement(module18, {
							universeId = universeId,
							developerProducts = developerProducts,
							layoutOrder = 5,
							locationType = constants.StoreEnums.LocationType.Store
						}) else nil
						v19.DeveloperProductsGrid = v25
						return createElement4(
							"Frame",
							scrollViewPositionChangedSignalCallbacksByAbsolutePosition,
							v19
						)
					end)
				})
			})
		})
	end)
end

function extended.didMount(data)
	local passes = data.props.passes
	local networking = data.props.networking
	local developerProducts = data.props.developerProducts
	local universeId = data.props.universeId
	local rootPlaceId = data.props.rootPlaceId
	local localUserId = data.props.localUserId

	if not fFlagLuaAppGamePassesDataHydrationMigrationEnabled and passes ~= nil then
		data.fetchPassesThumbnails(passes, networking)
	end

	if developerProducts ~= nil then
		data.fetchGameDeveloperProducts(networking, universeId, rootPlaceId, localUserId)
	end

	if fFlagLuaAppFixPassesPageStoreFetch and fFlagLuaAppSduiEdpEnabled then
		if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
			local gamePassStore = module14.Game.getGamePassStore(false)
			local status = gamePassStore.getPassesForUniverse(universeId).status(false)

			if status == dataStatus.NotReady or status == dataStatus.Failed then
				gamePassStore.fetchPassesForUniverse(universeId)
			end
		elseif passes == nil then
			data.props.fetchGamePasses(networking, universeId)
		end

		if data.props.subscriptionProducts == nil then
			data.props.fetchGameSubscriptionProducts(networking, universeId)
		end

		if developerProducts == nil and rootPlaceId ~= nil and localUserId ~= nil then
			data.fetchGameDeveloperProducts(networking, universeId, rootPlaceId, localUserId)
		end
	end
end

function extended.didUpdate(p2, p3, p4)
	if not fFlagLuaAppGamePassesDataHydrationMigrationEnabled and p3.passes ~= p2.props.passes then
		p2.fetchPassesThumbnails(p2.props.passes, p2.props.networking)
	end
end

local v12 = RoactRodux.connect(function(data, p2)
	local v13 = module20()
		and VerifiedBadges.isCreatorOfGameVerified(data, {
			universeId = p2.universeId,
			shouldUseV2GameDetails = true
		})
	local v14

	if module9 and not p2.viewWidth and data.ScreenSize and data.GlobalGuiInset then
		v14 = module10(data.ScreenSize, data.GlobalGuiInset)
	end

	local v16 = if not fFlagLuaAppGamePassesDataHydrationMigrationEnabled then data.GamePasses[tostring(p2.universeId)] else nil
	local v15 = {
		passes = v16,
		showSubscriptionProducts = data.GameSubscriptionProducts[p2.universeId] and #data.GameSubscriptionProducts[p2.universeId] > 0,
		subscriptionProducts = 0,
		developerProducts = 0,
		rootPlaceId = 0,
		localUserId = 0,
		creatorName = 0,
		creatorVerified = 0,
		topBarHeight = 0,
		viewWidth = 0
	}

	local v17 = if fFlagLuaAppFixPassesPageStoreFetch then data.GameSubscriptionProducts[p2.universeId] else nil
	v15.subscriptionProducts = v17

	v15.developerProducts = data.GameDeveloperProducts[tostring(p2.universeId)]
	local v18 = if data.GameDetails and data.GameDetails[p2.universeId] then data.GameDetails[p2.universeId].rootPlaceId else nil
	v15.rootPlaceId = v18

	v15.localUserId = data.LocalUserId
	local v19 = if module20() and data.GameDetails and data.GameDetails[p2.universeId] then data.GameDetails[p2.universeId].creator.name else nil
	v15.creatorName = v19

	if not module20() then
		v13 = nil
	end

	v15.creatorVerified = v13
	local v20 = if fFlagAppIaScrollAway then data.TopBar.topBarHeight else nil
	v15.topBarHeight = v20
	local v21 = if module9 then p2.viewWidth or v14 else nil
	v15.viewWidth = v21
	return v15
end, function(callback)
	return {
		requestPassesThumbnails = not fFlagLuaAppGamePassesDataHydrationMigrationEnabled and function(p2, p3)
			return callback(module11(p2, p3))
		end or nil,
		fetchGamePasses = not fFlagLuaAppGamePassesDataHydrationMigrationEnabled and function(p2, p3)
			return callback(module(p2, p3))
		end or nil,
		fetchGameSubscriptionProducts = fFlagLuaAppFixPassesPageStoreFetch and function(p2, p3)
			return callback(module13(p2, p3))
		end or nil,
		fetchGameDeveloperProducts = function(p2, p3, p4, p5)
			return callback(module12(p2, p3, p4, p5))
		end
	}
end)(extended)

local v13 = roactServices.connect({ networking = module2 })(v12)
return function(p2)
	local v14 = useTextSizeOffset()
	local v15

	if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
		v15 = module22(p2.universeId)
	end

	local join = Cryo.Dictionary.join

	if not fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
		v15 = nil
	end

	local v17 = join(p2, { textSizeOffset = v14, passes = v15 })

	return Roact.createElement(v13, v17)
end
