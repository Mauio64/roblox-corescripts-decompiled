local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withTriggerFeedback = require(CorePackages.Workspace.Packages.InteractionFeedback).withTriggerFeedback
local withNavigation = RoactNavigation.withNavigation
local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitTextLabel = RoactFitComponents.FitTextLabel
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local PurchaseProduct = require(Modules.AvatarExperience.Catalog.Thunks.PurchaseProduct)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local RobuxAmountDisplay = require(Modules.AvatarExperience.Common.Components.ItemDetails.RobuxAmountDisplay)
local PurchasePromptInteractiveAlert = require(Modules.AvatarExperience.Common.Components.ItemDetails.Prompts.PurchasePromptInteractiveAlert)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Checkbox = require(CorePackages.Packages.Foundation).Checkbox
local withStyle = UIBlox.Style.withStyle
local Utils = require(Modules.AvatarExperience.Common.Utils)
local FFlagDisableWearAfterPurchaseForCollectibles = require(Modules.AvatarExperience.Flags.FFlagDisableWearAfterPurchaseForCollectibles)
local useAvatarSaveContext = require(CorePackages.Workspace.Packages.AvatarExperienceSave).Context.useAvatarSaveContext
local IAPExperience = require(CorePackages.Workspace.Packages.IAPExperience)
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local EconomicRestrictionsCounter = IAPExperience.Counters.EconomicRestrictionsCounter
local UniversalEconomicRestrictionsCounter = EconomicRestrictionsCounter.UniversalEconomicRestrictionsCounter
local EconomicRestrictionsSurface = EconomicRestrictionsCounter.EconomicRestrictionsSurface
local OpenCentralOverlayForEconomicRestrictionPrompt = require(Modules.LuaApp.Thunks.Fraud.OpenCentralOverlayForEconomicRestrictionPrompt)
local parseEconomicRestrictionsFailureReason = IAPExperience.Utility.parseEconomicRestrictionsFailureReason
local parseEconomicRestrictionsExpirationTimeInMinutes = IAPExperience.Utility.parseEconomicRestrictionsExpirationTimeInMinutes
local v46 = Roact.PureComponent:extend("PurchasePrompt")

v46.defaultProps = {
	sellerName = ""
}

function v46.getPolicySpecifiedSellerName(p1, p2) -- line: 89
	if p1.props.robloxSellerNameShouldBeLuobu then
		local v53 = utf8.nfdnormalize(p2)

		if string.lower(v53) == "roblox" then
			return "罗布乐思"
		end
	end

	return p2
end
function v46.init(p3) -- line: 100
	-- upvalues: Roact (copy), NavigationUtils (copy), parseEconomicRestrictionsFailureReason (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy)
	p3.checkboxRef = Roact.createRef()
	p3.state = {
		isWearAfterPurchaseChecked = true
	}

	function p3.onCancel() -- line: 107
		-- upvalues: p3 (copy)
		p3.closePrompt()
	end
	function p3.onConfirm() -- line: 111
		-- upvalues: p3 (copy)
		p3.props.triggerFeedback("MakePurchase", "Press")

		local analytics = p3.props.analytics
		local itemId = p3.props.itemId
		local itemType = p3.props.itemType
		local priceInRobux = p3.props.priceInRobux
		local sellerId = p3.props.sellerId
		local networking = p3.props.networking
		local itemData = p3.props.itemData
		local userAssetId = p3.props.userAssetId
		local itemSubType = p3.props.itemSubType
		local navigation = p3.props.navigation
		local fromProfile = p3.props.fromProfile
		local fromAvatarRoute = p3.props.fromAvatarRoute
		local widgetInfo = p3.props.widgetInfo
		local fromContentFeed = p3.props.fromContentFeed
		local v107 = itemData and (itemData.product and itemData.product.id)
		local v108 = itemData and itemData.collectibleItemId
		local v109 = itemData and (itemData.creator and itemData.creator.type)
		local isWearAfterPurchaseChecked = p3.state.isWearAfterPurchaseChecked
		local v111 = if not fromAvatarRoute then nil else fromAvatarRoute.current.name
		local collectibleInstanceId = p3.props.collectibleInstanceId
		local avatarSaveContext = p3.props.avatarSaveContext

		if avatarSaveContext and (avatarSaveContext.autoSaveNextNewSaveData and isWearAfterPurchaseChecked) then
			avatarSaveContext.autoSaveNextNewSaveData()
		end

		p3.props.purchaseProduct(networking, v107, priceInRobux or 0, sellerId, itemId, itemType, itemSubType, isWearAfterPurchaseChecked, userAssetId, analytics, navigation, fromProfile, false, v111, v108, collectibleInstanceId, v109, widgetInfo, fromContentFeed, p3.economicRestrictionErrorHandler, p3.props.timedOptionDays)
	end
	function p3.toggleWearAfterPurchase() -- line: 169
		-- upvalues: p3 (copy)
		local isWearAfterPurchaseChecked = p3.state.isWearAfterPurchaseChecked

		p3:setState({
			isWearAfterPurchaseChecked = not isWearAfterPurchaseChecked
		})
	end
	function p3.closePrompt() -- line: 177
		-- upvalues: NavigationUtils (copy), p3 (copy)
		NavigationUtils.closeOverlay(p3.props.navigation)
	end
	function p3.economicRestrictionErrorHandler(p4) -- line: 181
		-- upvalues: parseEconomicRestrictionsFailureReason (copy), default (copy), UniversalEconomicRestrictionsCounter (copy), EconomicRestrictionsSurface (copy), p3 (copy)
		local v116 = parseEconomicRestrictionsFailureReason(p4)

		default:logRobloxTelemetryCounter(UniversalEconomicRestrictionsCounter, 1, {
			surface = EconomicRestrictionsSurface.AvatarExperience,
			failureReason = not p4 and "null" or tostring(v116)
		})
		p3.closePrompt()
		p3.props.openEconomicRestrictionPrompt(p4)
	end
end
function v46.showWearAfterPurchase(p5) -- line: 192
	-- upvalues: Constants (copy), FFlagDisableWearAfterPurchaseForCollectibles (copy)
	local itemType = p5.props.itemType
	local itemSubType = p5.props.itemSubType
	local v58 = itemType == Constants.ItemType.Asset and itemSubType ~= Constants.AssetTypeIdStrings.EmoteAnimation

	if FFlagDisableWearAfterPurchaseForCollectibles then
		local itemData = p5.props.itemData

		if itemData and itemData.collectibleItemId then
			v58 = false
		end
	end

	return v58
end
function v46.willUpdate(p6, p7, _) -- line: 211
	-- upvalues: Utils (copy)
	if Utils.isFetchingDoneOrFailed(p6.props.fetchingState, p7.fetchingState) then
		p6.closePrompt()
	end
end
function v46.renderMiddle(p9, p10) -- line: 217
	-- upvalues: withStyle (copy), Roact (copy), Focusable (copy), FitFrameVertical (copy), RoactFitComponents (copy), FitTextLabel (copy), RobuxAmountDisplay (copy), Checkbox (copy)
	local v65 = p9.props.priceInRobux or ""
	local v66 = v65 == 0
	local v67 = not v66

	return withStyle(function(p11) -- line: 223
		-- upvalues: v67 (copy), Roact (copy), Focusable (copy), FitFrameVertical (copy), p9 (copy), v66 (copy), RoactFitComponents (copy), FitTextLabel (copy), p10 (copy), RobuxAmountDisplay (copy), v65 (copy), Checkbox (copy)
		local p11Font = p11.Font
		local Theme = p11.Theme
		local v120 = p11Font.BaseSize * p11Font.Body.RelativeSize
		local v121 = v67 and v120 or 0

		return Roact.createElement(Focusable[FitFrameVertical], {
			BackgroundTransparency = 1,
			width = UDim.new(1, 0),
			defaultChild = p9.checkboxRef
		}, {
			PriceContainer = not v66 and Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				contentPadding = UDim.new(0, 6),
				VerticalAlignment = Enum.VerticalAlignment.Center,
				margin = RoactFitComponents.Rect.quad(0, 0, 24, 0),
				width = UDim.new(1, 0)
			}, {
				PriceLabel = Roact.createElement(FitTextLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 0,
					width = FitTextLabel.Width.FitToText,
					Font = p11Font.Body.Font,
					Text = p10.priceLabel,
					TextColor3 = Theme.TextDefault.Color,
					TextTransparency = Theme.TextDefault.Transparency,
					TextSize = v120
				}),
				RobuxContainer = Roact.createElement(RobuxAmountDisplay, {
					padding = 4,
					robuxAmountText = tostring(v65),
					iconSize = v121,
					textSize = v120,
					showRobuxIcon = v67
				})
			}),
			CheckboxContainer = p9:showWearAfterPurchase() and Roact.createElement(Checkbox, {
				LayoutOrder = 2,
				label = p10.wearItemLabel,
				isChecked = p9.state.isWearAfterPurchaseChecked,
				onActivated = p9.toggleWearAfterPurchase,
				ref = p9.checkboxRef
			})
		})
	end)
end
function v46.renderAlertLocalized(p12, p13) -- line: 276
	-- upvalues: Cryo (copy), Roact (copy), PurchasePromptInteractiveAlert (copy), RetrievalStatus (copy)
	local itemData = p12.props.itemData
	local priceInRobux = p12.props.priceInRobux
	local v72 = p12:getPolicySpecifiedSellerName(p12.props.sellerName)
	local v73 = itemData and itemData.name or ""
	local freeTitleText, freeDescriptionText, freeConfirmButtonText

	if (priceInRobux or "") == 0 then
		freeTitleText = p13.freeTitleText
		freeDescriptionText = p13.freeDescriptionText
		freeConfirmButtonText = p13.freeConfirmButtonText
	else
		freeTitleText = p13.titleText
		freeDescriptionText = p13.descriptionText
		freeConfirmButtonText = p13.confirmButtonText
	end

	local v77 = freeDescriptionText:gsub("({itemName})", function() -- line: 301
		-- upvalues: v73 (copy)
		return v73
	end):gsub("({creatorName})", function() -- line: 304
		-- upvalues: v72 (copy)
		return v72
	end)
	local v78 = Cryo.Dictionary.join(p12.props.widgetInfo or {}, {
		itemId = p12.props.itemId,
		itemType = p12.props.itemType,
		assetType = if not p12.props.itemData then nil else p12.props.itemData.assetType,
		bundleType = if not p12.props.itemData then nil else p12.props.itemData.bundleType
	})

	return Roact.createElement(PurchasePromptInteractiveAlert, {
		priceInRobux = priceInRobux,
		showWearAfterPurchase = p12:showWearAfterPurchase(),
		isWearAfterPurchaseChecked = p12.state.isWearAfterPurchaseChecked,
		toggleWearAfterPurchase = p12.toggleWearAfterPurchase,
		titleText = freeTitleText,
		bodyText = v77,
		confirmButtonText = freeConfirmButtonText,
		onConfirm = p12.onConfirm,
		onCancel = p12.onCancel,
		isLoading = p12.props.fetchingState == RetrievalStatus.Fetching,
		defaultChildRef = p12.props.defaultChildRef,
		analyticsInfo = v78
	})
end
function v46.render(p14) -- line: 331
	-- upvalues: withLocalization (copy)
	local s1 = "Feature.Catalog.Label.BuyConfirmation"

	if p14.props.enablePurchasePromptIncludingWarning then
		s1 = "Feature.Catalog.Label.BuyConfirmationIncludingWarning"
	end

	return withLocalization({
		freeConfirmButtonText = "Feature.Catalog.Label.Get",
		freeDescriptionText = "Feature.Catalog.Label.FreeItemConfirmation",
		freeTitleText = "Feature.Catalog.Heading.FreeItemConfirmation",
		titleText = "Feature.Catalog.Heading.BuyItem",
		priceLabel = "Feature.Catalog.Label.PriceColon",
		confirmButtonText = "Feature.Catalog.Heading.BuyItem",
		cancelButtonText = "Feature.Catalog.Action.Cancel",
		wearItemLabel = "Feature.Catalog.Label.WearAfterPurchase",
		descriptionText = s1
	})(function(p15) -- line: 347
		-- upvalues: p14 (copy)
		return p14:renderAlertLocalized(p15)
	end)
end

local v47 = RoactAppPolicy.connect(function(p16, _) -- line: 351
	return {
		robloxSellerNameShouldBeLuobu = p16.getRobloxCreatedItemsCreatedByLuobu(),
		enablePurchasePromptIncludingWarning = p16.getPurchasePromptIncludingWarning()
	}
end)(v46)
local v48 = RoactRodux.connect(function(p18, p19) -- line: 358
	-- upvalues: ItemData (copy), CatalogUtils (copy), PerformFetch (copy), CatalogConstants (copy)
	local itemId = p19.itemId
	local itemType = p19.itemType
	local v87 = ItemData(p18.AvatarExperience.Common, itemId, itemType)
	local v88 = v87 and (v87.product and v87.product.id)
	local v89 = CatalogUtils.GetItemSubType(itemType, v87)

	return {
		itemData = v87,
		itemSubType = v89,
		fetchingState = PerformFetch.GetStatus(p18, CatalogConstants.PurchaseProductKey .. tostring(v88)),
		screenSize = p18.ScreenSize
	}
end, function(p20) -- line: 372
	-- upvalues: PurchaseProduct (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy)
	return {
		purchaseProduct = function(p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41) -- line: 374
			-- upvalues: p20 (copy), PurchaseProduct (copy)
			return p20(PurchaseProduct(p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41))
		end,
		openEconomicRestrictionPrompt = function(p42) -- line: 424
			-- upvalues: parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), p20 (copy), OpenCentralOverlayForEconomicRestrictionPrompt (copy)
			local v145 = parseEconomicRestrictionsFailureReason(p42)
			local v146 = parseEconomicRestrictionsExpirationTimeInMinutes(p42)

			return p20(OpenCentralOverlayForEconomicRestrictionPrompt(v145, v146))
		end
	}
end)(v47)
local u49 = withTriggerFeedback((withNavigation((withMappedNavigationParams((withOverlayFocusHandling((RoactServices.connect({
	networking = RoactNetworking,
	analytics = Analytics
})(v48)))))))))

local function PurchasePromptContainer(p43) -- line: 443
	-- upvalues: useAvatarSaveContext (copy), React (copy), u49 (ref), Cryo (copy)
	local v92 = useAvatarSaveContext()

	return React.createElement(u49, Cryo.Dictionary.join(p43, {
		avatarSaveContext = v92
	}))
end

return PurchasePromptContainer
