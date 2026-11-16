local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FitFrame = require(CorePackages.Packages.FitFrame)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local module = require("@luauforge/deferred/gne")
local module2 = require("@luauforge/deferred/gnh")
local NavigationTabLayout = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Navigation/Enum/NavigationTabLayout")
local BadgeVariant = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Indicator/Enum/BadgeVariant")

local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local DefaultMetricsGridView = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Grid/DefaultMetricsGridView")
require("@luauforge/bundled/dHK")
local module6 = require("@luauforge/deferred/gkv")

local module7 = require("@luauforge/bundled/dNQ")

local module8 = require("@luauforge/bundled/fuD")
local module9 = require("@luauforge/bundled/dMx")

local module10 = require("@luauforge/bundled/cgr")
local constants = module10.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = module10.Utils.getRbxthumbWithTypeSizeAndOptions
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local module11 = require("@luauforge/bundled/dCh")
local toastType = require("@luauforge/bundled/dwC").Enums.ToastType
local inventoryItemAvailability = require("@luauforge/bundled/fuM").Enums.InventoryItemAvailability

local withStyle = UIBlox.Style.withStyle
local getPageMargin = UIBlox.App.Container.getPageMargin
local loadableImage = UIBlox.App.Loading.LoadableImage
local gridMetrics = UIBlox.App.Grid.GridMetrics
local itemTile = UIBlox.Tile.ItemTile
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local catalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local normalizeBackgroundId = AvatarExperienceCommon.Backgrounds.normalizeBackgroundId
local Foundation = require(CorePackages.Packages.Foundation)
local skeleton = Foundation.Skeleton

local fitFrameVertical = FitFrame.FitFrameVertical
local fitTextLabel = FitFrame.FitTextLabel

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXModeratedItemsFlow = AvatarExperienceFlags.FFlagAXModeratedItemsFlow
local fFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates
local fFlagAXBackgroundsInOutfitDetails = AvatarExperienceFlags.FFlagAXBackgroundsInOutfitDetails

local v5 = {
	toastMessage = "CommonUI.Messages.Label.ActionNotAvailableOnCurrentDevice",
	isLocalized = false,
	toastType = toastType.InformationMessage
}

local customMetricsGetter = gridMetrics.makeCustomMetricsGetter({
	minimumItemsPerRow = 3,
	minimumItemWidth = 110
})

local extended = Roact.PureComponent:extend("OutfitDetailsContainer")

local strictInterface = t.strictInterface
local v6 = {
	outfitId = t.string,
	itemType = t.optional(t.string),
	itemsGridRef = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	showCustomOutfitNames = t.boolean,
	isWebViewSupported = t.boolean,
	outfitInfo = t.optional(t.table),
	outfitName = t.optional(t.string),
	itemsList = 0,
	screenSize = 0,
	assetInfos = 0,
	backgroundAssetId = 0,
	navigateDown = 0,
	setCurrentToastMessage = 0,
	bottomPadding = 0
}

local v7 = if fFlagAXModeratedItemsFlow then t.optional(t.array(t.tuple(t.union(t.string, t.table), t.optional(t.string)))) else t.optional(t.array(t.string))
v6.itemsList = v7

v6.screenSize = t.Vector2
v6.assetInfos = t.table
local v8 = if fFlagAXBackgroundsInOutfitDetails then t.optional(t.string) else nil
v6.backgroundAssetId = v8

v6.navigateDown = t.callback
v6.setCurrentToastMessage = t.callback
v6.bottomPadding = t.optional(t.number)
extended.validateProps = strictInterface(v6)

function extended:init()
	self.attributionRef = Roact.createRef()
	self.itemsGridRef = self.props.itemsGridRef or Roact.createRef()
	self:setState({
		margin = getPageMargin(self.props.screenSize.X)
	})

	function self.containerSizeChanged(p2)
		local pageMargin = getPageMargin(p2.AbsoluteSize.X)

		if pageMargin ~= self.state.margin then
			self:setState({ margin = pageMargin })
		end
	end

	function self.goToAppealsPortal()
		if self.props.isWebViewSupported then
			self.props.navigateDown({
				name = appPage.GenericWebPage,
				detail = "https://www.roblox.com/report-appeals#/",
				extraProps = { title = "" }
			})
		else
			self.props.setCurrentToastMessage(v5)
		end
	end
end

function extended:renderOutfitName(p3)
	local theme = p3.Theme
	local font = p3.Font

	if self.props.outfitName then
		return Roact.createElement(fitTextLabel, {
			width = UDim.new(1, 0),
			BackgroundTransparency = 1,
			Text = self.props.outfitName,
			LayoutOrder = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, font.Header1.RelativeSize * font.BaseSize),
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			TextWrapped = true,
			Font = font.Header1.Font,
			TextSize = font.Header1.RelativeSize * font.BaseSize
		})
	end

	return Roact.createElement(skeleton, {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, font.Header1.RelativeSize * font.BaseSize)
	})
end

function extended:renderOutfitThumbnail()
	local outfit = constants.RbxthumbTypes.Outfit

	local v9 = getRbxthumbWithTypeSizeAndOptions(self.props.outfitId, outfit, 420)
	local v10

	if module8.isModerationPendingOrRejected(self:getModerationStatus()) then
		v9 = module7.BrokenAvatarThumbnail
		v10 = 0.25
	end

	return Roact.createElement(
		"Frame",
		{
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -24, 0, 300)
		},
		{
			AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			}),
			MaxSize = Roact.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(1e999, 300)
			}),
			LoadableImage = Roact.createElement(loadableImage, {
				BackgroundTransparency = 1,
				ImageTransparency = v10,
				Image = v9,
				Size = UDim2.fromScale(1, 1),
				useShimmerAnimationWhileLoading = true,
				ZIndex = 1
			})
		}
	)
end

function extended:renderItemWithAvailabilityStatus(list, p3)
	local item = list[1]
	local item2 = list[2]
	local v9

	if typeof(item) == "table" then
		p3 = nil
	else
		v9 = getRbxthumbWithTypeSizeAndOptions(item, constants.RbxthumbTypes.Asset, 150)

		local assetInfo = self.props.assetInfos[item]
		local name = assetInfo and assetInfo.name

		if fFlagAXBackgroundsInOutfitDetails and name == nil and self.props.backgroundAssetId ~= nil then
			if item ~= self.props.backgroundAssetId then
				p3 = nil
			end
		else
			p3 = name
		end

		if assetInfo and assetInfo.outfitModerationStatus then
			v9 ..= `&filters=__{assetInfo.outfitModerationStatus}__`
		end
	end

	local createElement = Roact.createElement
	local v11 = {
		title = p3,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		presentationSlot = Roact.createElement(Foundation.Image, {
			tag = "size-full clip radius-medium",
			Image = v9,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Crop
		}),
		itemStatus = 0
	}

	local v12 = if item2 == inventoryItemAvailability.Unavailable then {
		type = "placeholder",
		iconType = fFlagAXModeratedItemIconUpdates and "Unavailable" or "Error"
	} else item2 == inventoryItemAvailability.Revoked and {
		type = "placeholder",
		iconType = "Error"
	} or nil
	v11.itemStatus = v12
	return createElement(catalogItemCard, v11)
end

function extended.renderItem(p2, p3, p4)
	local v9

	if typeof(p3) == "table" then
		p4 = nil
	else
		v9 = getRbxthumbWithTypeSizeAndOptions(p3, constants.RbxthumbTypes.Asset, 150)

		local assetInfo = p2.props.assetInfos[p3]
		local name = assetInfo and assetInfo.name

		if fFlagAXBackgroundsInOutfitDetails and name == nil and p2.props.backgroundAssetId ~= nil then
			if p3 ~= p2.props.backgroundAssetId then
				p4 = nil
			end
		else
			p4 = name
		end

		if assetInfo and assetInfo.outfitModerationStatus then
			v9 ..= `&filters=__{assetInfo.outfitModerationStatus}__`
		end
	end

	return Roact.createElement(itemTile, {
		name = p4,
		titleTextLineCount = module9.ItemTileTitleMaxLines,
		thumbnail = v9
	})
end

function extended:renderItemsGrid(p2, p3)
	local itemsList = self.props.itemsList
	local shimmerCardsToDisplay = module9.ShimmerCardsToDisplay
	local v9 = itemsList and (#itemsList or shimmerCardsToDisplay) or shimmerCardsToDisplay

	local font = p2.Font
	local v10 = font.BaseSize * font.Header2.RelativeSize

	local bundleItemTile = module9.ItemTileType.BundleItemTile
	local gridItemHeightGetter = module8.GridItemHeightGetter(bundleItemTile, v10)

	return Roact.createElement(
		fitFrameVertical,
		{
			width = UDim.new(1, 0),
			LayoutOrder = 4,
			BackgroundTransparency = 1,
			[Roact.Ref] = self.itemsGridRef
		},
		{
			LoadableGridView = Roact.createElement(DefaultMetricsGridView, {
				getItemMetrics = customMetricsGetter,
				items = itemsList,
				totalNumItems = v9,
				renderItem = fFlagAXModeratedItemsFlow and function(p4)
					return self:renderItemWithAvailabilityStatus(p4, p3)
				end or function(p4)
					return self:renderItem(p4, p3)
				end,
				getItemHeight = gridItemHeightGetter,
				windowHeight = self.props.screenSize.Y
			})
		}
	)
end

function extended:getModerationStatus()
	local outfitInfo = self.props.outfitInfo

	if outfitInfo then
		return outfitInfo.moderationStatus
	end

	return nil
end

function extended:renderWithProviders(p2, props2)
	local outfitInfo = self.props.outfitInfo
	local creatingUniverseId = outfitInfo and outfitInfo.creatingUniverseId or nil
	local theme = p2.Theme

	local quad = FitFrame.Rect.quad(
		self.state.margin,
		self.state.margin,
		self.props.bottomPadding or self.state.margin,
		self.state.margin
	)

	local moderationStatus = self:getModerationStatus()
	local v9 = module8.isModerationPendingOrRejected(moderationStatus)
	local v10 = moderationStatus == Enum.ModerationStatus.ReviewedRejected

	local background = if fFlagAXBackgroundsInOutfitDetails then props2.background else nil

	local createElement = Roact.createElement
	local containerSizeChangedsByAbsoluteSize = {
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		width = UDim.new(1, 0),
		contentPadding = UDim.new(0, 24),
		margin = quad,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		[Roact.Change.AbsoluteSize] = self.containerSizeChanged
	}
	local v12 = {
		ItemName = self.props.showCustomOutfitNames and self:renderOutfitName(p2),
		FullBleedFrame = 0,
		ItemThumbnail = 0,
		ItemsGrid = 0,
		ItemInfoList = 0
	}

	if v9 then
		local createElement2 = Roact.createElement
		local v14 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, quad.left + quad.right, 0, 0),
			Position = UDim2.fromOffset(-quad.left, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2
		}

		local v16 = if v10 then Roact.createElement(module, {
			contentText = props2.moderated,
			variant = BadgeVariant.Alert,
			placement = NavigationTabLayout.Bleed,
			actionText = props2.details,
			onActivated = self.goToAppealsPortal
		}) else Roact.createElement(module, {
			contentText = props2.pending,
			variant = BadgeVariant.Default,
			placement = NavigationTabLayout.Bleed
		})
		v9 = createElement2("Frame", v14, { ModerationStatusBanner = v16 })
	end

	v12.FullBleedFrame = v9

	v12.ItemThumbnail = self:renderOutfitThumbnail(props2)

	v12.ItemsGrid = self:renderItemsGrid(p2, background)

	local v13 = if creatingUniverseId then Roact.createElement(module6, {
		itemId = self.props.outfitId,
		outfitInfo = self.props.outfitInfo,
		itemType = self.props.itemType,
		LayoutOrder = 5,
		attributionRef = self.attributionRef
	}) else nil
	v12.ItemInfoList = v13
	return createElement(fitFrameVertical, containerSizeChangedsByAbsoluteSize, v12)
end

function extended:render()
	return withStyle(function(p2)
		return withLocalization({
			details = "Feature.Avatar.Label.DetailsButton",
			moderated = "Feature.Catalog.Message.AvatarModerationModerated",
			pending = "Feature.Catalog.Message.AvatarModerationPending",
			background = "Feature.Avatar.Label.Backgrounds"
		})(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

local v9 = roactAppPolicy.connect(function(p2, p3)
	return {
		showCustomOutfitNames = p2.getCustomOutfitNames(),
		isWebViewSupported = p2.getWebViewSupport()
	}
end)(extended)

local function mapStateToProps(p2, p3)
	local outfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos

	local v10 = nil
	local name, v11

	if outfitInfos[p3.outfitId] then
		local outfitInfo = outfitInfos[p3.outfitId]
		name = outfitInfo.name
		local v12

		if fFlagAXBackgroundsInOutfitDetails then
			v12 = normalizeBackgroundId(outfitInfo.profileConfiguration and outfitInfo.profileConfiguration.BackgroundAssetId)
		end

		v11 = module2(outfitInfo.assets, v12)

		if fFlagAXBackgroundsInOutfitDetails and v12 ~= nil then
			v10 = tostring(v12)
		end
	end

	return {
		outfitInfo = outfitInfos[p3.outfitId],
		outfitName = name,
		itemsList = v11,
		backgroundAssetId = v10,
		screenSize = p2.ScreenSize,
		assetInfos = p2.AvatarExperience.Common.AssetInfos
	}
end

local function mapDispatchToProps(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(navigateDown(p2))
			end
		end,
		setCurrentToastMessage = function(p2)
			callback(module11(p2))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v9)
