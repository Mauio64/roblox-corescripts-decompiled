local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local module = require("@luauforge/deferred/gJI")

local module2 = require("@luauforge/deferred/gJH")
local module3 = require("@luauforge/bundled/dXh")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withTriggerFeedback = require("@luauforge/bundled/gKs").withTriggerFeedback
local withNavigation = RoactNavigation.withNavigation

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameVertical = roactFitComponents.FitFrameVertical
local fitTextLabel = roactFitComponents.FitTextLabel

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module4 = require("@luauforge/bundled/egx")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module5 = require("@luauforge/bundled/fDf")

local getUnifiedLoggingSurfaceForRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Utils.getUnifiedLoggingSurfaceForRoute
local module6 = require("@luauforge/deferred/gKt")
local module7 = require("@luauforge/bundled/dPU")
local module8 = require("@luauforge/bundled/dPN")
local module9 = require("@luauforge/bundled/dVl")
local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData

local module10 = require("@luauforge/deferred/gKp")

local module11 = require("@luauforge/deferred/gKx")

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local checkbox = Foundation.Checkbox

local withStyle = UIBlox.Style.withStyle

local module12 = require("@luauforge/bundled/fCe")

local module13 = require("@luauforge/deferred/gKy")
local useAvatarSaveContext = require("@luauforge/bundled/gKz").Context.useAvatarSaveContext

local module14 = require("@luauforge/deferred/gKv")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
local economicRestrictionsCounter = module14.Counters.EconomicRestrictionsCounter
local universalEconomicRestrictionsCounter = economicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local economicRestrictionsSurface = economicRestrictionsCounter.EconomicRestrictionsSurface

local module15 = require("@luauforge/deferred/gKA")
local parseEconomicRestrictionsFailureReason = module14.Utility.parseEconomicRestrictionsFailureReason

local parseEconomicRestrictionsExpirationTimeInMinutes = module14.Utility.parseEconomicRestrictionsExpirationTimeInMinutes

local extended = Roact.PureComponent:extend("PurchasePrompt")
extended.defaultProps = { sellerName = "" }

function extended:getPolicySpecifiedSellerName(p3)
	if self.props.robloxSellerNameShouldBeLuobu then
		local v5 = utf8.nfdnormalize(p3)

		if string.lower(v5) == "roblox" then
			return "罗布乐思"
		end
	end

	return p3
end

function extended:init()
	self.checkboxRef = Roact.createRef()

	self.state = { isWearAfterPurchaseChecked = true }

	function self.onCancel()
		self.closePrompt()
	end

	function self.onConfirm()
		self.props.triggerFeedback("MakePurchase", "Press")
		local analytics = self.props.analytics
		local itemId = self.props.itemId
		local itemType = self.props.itemType
		local priceInRobux = self.props.priceInRobux
		local sellerId = self.props.sellerId
		local networking = self.props.networking
		local itemData2 = self.props.itemData
		local userAssetId = self.props.userAssetId
		local itemSubType = self.props.itemSubType
		local navigation = self.props.navigation
		local fromProfile = self.props.fromProfile
		local fromAvatarRoute = self.props.fromAvatarRoute
		local widgetInfo = self.props.widgetInfo
		local fromContentFeed = self.props.fromContentFeed

		local id = itemData2 and itemData2.product and itemData2.product.id
		local collectibleItemId = itemData2 and itemData2.collectibleItemId
		local kind = itemData2 and itemData2.creator and itemData2.creator.type

		local isWearAfterPurchaseChecked = self.state.isWearAfterPurchaseChecked

		local name = if fromAvatarRoute then fromAvatarRoute.current.name else nil

		local collectibleInstanceId = self.props.collectibleInstanceId

		local avatarSaveContext = self.props.avatarSaveContext

		if
			avatarSaveContext
			and avatarSaveContext.autoSaveNextNewSaveData
			and isWearAfterPurchaseChecked
		then
			avatarSaveContext.autoSaveNextNewSaveData()
		end

		self.props.purchaseProduct(
			networking,
			id,
			priceInRobux or 0,
			sellerId,
			itemId,
			itemType,
			itemSubType,
			isWearAfterPurchaseChecked,
			userAssetId,
			analytics,
			navigation,
			fromProfile,
			false,
			name,
			collectibleItemId,
			collectibleInstanceId,
			kind,
			widgetInfo,
			fromContentFeed,
			self.economicRestrictionErrorHandler,
			self.props.timedOptionDays
		)
	end

	function self.toggleWearAfterPurchase()
		self:setState({
			isWearAfterPurchaseChecked = not self.state.isWearAfterPurchaseChecked
		})
	end

	function self.closePrompt()
		module3.closeOverlay(self.props.navigation)
	end

	function self.economicRestrictionErrorHandler(p2)
		local v5 = parseEconomicRestrictionsFailureReason(p2)
		default:logRobloxTelemetryCounter(universalEconomicRestrictionsCounter, 1, {
			surface = economicRestrictionsSurface.AvatarExperience,
			failureReason = not p2 and "null" or tostring(v5)
		})

		self.closePrompt()
		self.props.openEconomicRestrictionPrompt(p2)
	end
end

function extended:showWearAfterPurchase()
	local itemType = self.props.itemType
	local itemSubType = self.props.itemSubType
	local v5

	if itemType == module8.ItemType.Asset then
		v5 = itemSubType ~= module8.AssetTypeIdStrings.EmoteAnimation
	else
		v5 = false
	end

	if module13 then
		local itemData2 = self.props.itemData

		if itemData2 and itemData2.collectibleItemId then
			v5 = false
		end
	end

	return v5
end

function extended.willUpdate(p2, p3, p4)
	if module12.isFetchingDoneOrFailed(p2.props.fetchingState, p3.fetchingState) then
		p2.closePrompt()
	end
end

function extended:renderMiddle(p2)
	local priceInRobux = self.props.priceInRobux or ""
	local v5 = priceInRobux == 0
	local v6 = not v5

	return withStyle(function(p3)
		local font = p3.Font
		local theme = p3.Theme
		local v7 = font.BaseSize * font.Body.RelativeSize

		return Roact.createElement(
			focusable[fitFrameVertical],
			{
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				defaultChild = self.checkboxRef
			},
			{
				PriceContainer = not v5 and Roact.createElement(fitFrameVertical, {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					contentPadding = UDim.new(0, 6),
					VerticalAlignment = Enum.VerticalAlignment.Center,
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					margin = roactFitComponents.Rect.quad(0, 0, 24, 0),
					width = UDim.new(1, 0)
				}, {
					PriceLabel = Roact.createElement(fitTextLabel, {
						width = fitTextLabel.Width.FitToText,
						BackgroundTransparency = 1,
						Font = font.Body.Font,
						Text = p2.priceLabel,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency,
						TextSize = v7,
						LayoutOrder = 0
					}),
					RobuxContainer = Roact.createElement(module10, {
						robuxAmountText = tostring(priceInRobux),
						iconSize = v6 and v7 or 0,
						textSize = v7,
						padding = 4,
						showRobuxIcon = v6
					})
				}),
				CheckboxContainer = self:showWearAfterPurchase() and Roact.createElement(checkbox, {
					label = p2.wearItemLabel,
					isChecked = self.state.isWearAfterPurchaseChecked,
					onActivated = self.toggleWearAfterPurchase,
					LayoutOrder = 2,
					ref = self.checkboxRef
				})
			}
		)
	end)
end

function extended:renderAlertLocalized(props2)
	local itemData2 = self.props.itemData

	local priceInRobux = self.props.priceInRobux
	local policySpecifiedSellerName = self:getPolicySpecifiedSellerName(self.props.sellerName)

	local name = itemData2 and itemData2.name or ""
	local v5, v6, v7

	if (priceInRobux or "") == 0 then
		v5 = props2.freeTitleText
		v6 = props2.freeDescriptionText
		v7 = props2.freeConfirmButtonText
	else
		v5 = props2.titleText
		v6 = props2.descriptionText
		v7 = props2.confirmButtonText
	end

	local v8 = v6:gsub("({itemName})", function()
		return name
	end):gsub("({creatorName})", function()
		return policySpecifiedSellerName
	end)

	local join = Cryo.Dictionary.join
	local widgetInfo = self.props.widgetInfo or {}
	local v9 = {
		itemId = self.props.itemId,
		itemType = self.props.itemType,
		assetType = 0,
		bundleType = 0
	}
	local v10 = if self.props.itemData then self.props.itemData.assetType else nil
	v9.assetType = v10
	local v11 = if self.props.itemData then self.props.itemData.bundleType else nil
	v9.bundleType = v11
	local v12 = join(widgetInfo, v9)

	local fromAvatarRoute = self.props.fromAvatarRoute
	local v13 = if fromAvatarRoute then getUnifiedLoggingSurfaceForRoute(fromAvatarRoute) else nil

	return Roact.createElement(module11, {
		surface = v13,
		priceInRobux = priceInRobux,
		showWearAfterPurchase = self:showWearAfterPurchase(),
		isWearAfterPurchaseChecked = self.state.isWearAfterPurchaseChecked,
		toggleWearAfterPurchase = self.toggleWearAfterPurchase,
		titleText = v5,
		bodyText = v8,
		confirmButtonText = v7,
		onConfirm = self.onConfirm,
		onCancel = self.onCancel,
		isLoading = self.props.fetchingState == retrievalStatus.Fetching,
		defaultChildRef = self.props.defaultChildRef,
		analyticsInfo = v12
	})
end

function extended:render()
	return withLocalization({
		freeConfirmButtonText = "Feature.Catalog.Label.Get",
		freeDescriptionText = "Feature.Catalog.Label.FreeItemConfirmation",
		freeTitleText = "Feature.Catalog.Heading.FreeItemConfirmation",
		titleText = "Feature.Catalog.Heading.BuyItem",
		priceLabel = "Feature.Catalog.Label.PriceColon",
		confirmButtonText = "Feature.Catalog.Heading.BuyItem",
		cancelButtonText = "Feature.Catalog.Action.Cancel",
		descriptionText = self.props.enablePurchasePromptIncludingWarning and "Feature.Catalog.Label.BuyConfirmationIncludingWarning" or "Feature.Catalog.Label.BuyConfirmation",
		wearItemLabel = "Feature.Catalog.Label.WearAfterPurchase"
	})(function(p2)
		return self:renderAlertLocalized(p2)
	end)
end

local v5 = roactAppPolicy.connect(function(p2, p3)
	return {
		robloxSellerNameShouldBeLuobu = p2.getRobloxCreatedItemsCreatedByLuobu(),
		enablePurchasePromptIncludingWarning = p2.getPurchasePromptIncludingWarning()
	}
end)(extended)

local v6 = RoactRodux.connect(function(p2, p3)
	local itemId = p3.itemId
	local itemType = p3.itemType
	local v7 = itemData(p2.AvatarExperience.Common, itemId, itemType)
	local id = v7 and v7.product and v7.product.id
	return {
		itemData = v7,
		itemSubType = module9.GetItemSubType(itemType, v7),
		fetchingState = performFetch.GetStatus(p2, module7.PurchaseProductKey .. tostring(id)),
		screenSize = p2.ScreenSize
	}
end, function(callback)
	return {
		purchaseProduct = function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22)
			return callback(module6(
				p2,
				p3,
				p4,
				p5,
				p6,
				p7,
				p8,
				p9,
				p10,
				p11,
				p12,
				p13,
				p14,
				p15,
				p16,
				p17,
				p18,
				p19,
				p20,
				p21,
				p22
			))
		end,
		openEconomicRestrictionPrompt = function(p2)
			return callback(module15(
				parseEconomicRestrictionsFailureReason(p2),
				(parseEconomicRestrictionsExpirationTimeInMinutes(p2))
			))
		end
	}
end)(v5)

local v7 = withTriggerFeedback((withNavigation((module2((module((roactServices.connect({
	networking = module4,
	analytics = module5
})(v6)))))))))

local function PurchasePromptContainer(p2)
	local v8 = useAvatarSaveContext()
	return React.createElement(v7, Cryo.Dictionary.join(p2, { avatarSaveContext = v8 }))
end

return PurchasePromptContainer
