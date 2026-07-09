local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FitFrame = require(CorePackages.Packages.FitFrame)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local CompactInlineBanner = require(Modules.AvatarExperience.AvatarEditor.Components.AssetManagement.CompactInlineBanner)
local CompactInlineBannerPlacement = require(Modules.AvatarExperience.Common.Enum.CompactInlineBannerPlacement)
local CompactInlineBannerVariant = require(Modules.AvatarExperience.Common.Enum.CompactInlineBannerVariant)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local LoadableGridView = require(Modules.AvatarExperience.Common.Components.LoadableGridView)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local ItemInfoList = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemInfo.ItemInfoList)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants3 = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local NavigateDown = require(CorePackages.Workspace.Packages.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v26 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(CorePackages.Workspace.Packages.ToastRodux).Enums.ToastType
local InventoryItemAvailability = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Enums.InventoryItemAvailability
local withStyle = UIBlox.Style.withStyle
local getPageMargin = UIBlox.App.Container.getPageMargin
local LoadableImage = UIBlox.App.Loading.LoadableImage
local GridMetrics = UIBlox.App.Grid.GridMetrics
local ItemTile = UIBlox.Tile.ItemTile
local CatalogItemCard = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.CatalogItemCard.CatalogItemCard
local Foundation = require(CorePackages.Packages.Foundation)
local Skeleton = Foundation.Skeleton
local FitFrameVertical = FitFrame.FitFrameVertical
local FitTextLabel = FitFrame.FitTextLabel
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXModeratedItemsFlow = AvatarExperienceFlags.FFlagAXModeratedItemsFlow
local FFlagAXModeratedItemIconUpdates = AvatarExperienceFlags.FFlagAXModeratedItemIconUpdates
local FFlagAXFixGamepadNavigationOnOutfitManagement = AvatarExperienceFlags.FFlagAXFixGamepadNavigationOnOutfitManagement
local t1 = {
	toastMessage = "CommonUI.Messages.Label.ActionNotAvailableOnCurrentDevice",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local t2 = {
	minimumItemsPerRow = 3,
	minimumItemWidth = 110
}
local v47 = GridMetrics.makeCustomMetricsGetter(t2)
local v48 = Roact.PureComponent:extend("OutfitDetailsContainer")

v48.validateProps = t.strictInterface({
	outfitId = t.string,
	itemType = t.optional(t.string),
	itemsGridRef = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	showCustomOutfitNames = t.boolean,
	isWebViewSupported = t.boolean,
	outfitInfo = t.optional(t.table),
	outfitName = t.optional(t.string),
	itemsList = if not FFlagAXModeratedItemsFlow then t.optional(t.array(t.string)) else t.optional(t.array(t.tuple(t.union(t.string, t.table), t.optional(t.string)))),
	screenSize = t.Vector2,
	assetInfos = t.table,
	navigateDown = t.callback,
	setCurrentToastMessage = t.callback,
	bottomPadding = if not FFlagAXFixGamepadNavigationOnOutfitManagement then nil else t.optional(t.number)
})

function v48.init(p1) -- line: 128
	-- upvalues: Roact (copy), getPageMargin (copy), AppPage (copy), t1 (copy)
	p1.attributionRef = Roact.createRef()
	p1.itemsGridRef = p1.props.itemsGridRef or Roact.createRef()
	p1:setState({
		margin = getPageMargin(p1.props.screenSize.X)
	})

	function p1.containerSizeChanged(p2) -- line: 135
		-- upvalues: getPageMargin (copy), p1 (copy)
		local v113 = getPageMargin(p2.AbsoluteSize.X)

		if v113 ~= p1.state.margin then
			p1:setState({
				margin = v113
			})
		end
	end
	function p1.goToAppealsPortal() -- line: 144
		-- upvalues: p1 (copy), AppPage (copy), t1 (copy)
		if p1.props.isWebViewSupported then
			p1.props.navigateDown({
				detail = "https://www.roblox.com/report-appeals#/",
				name = AppPage.GenericWebPage,
				extraProps = {
					title = ""
				}
			})

			return
		end

		p1.props.setCurrentToastMessage(t1)
	end
end
function v48.renderOutfitName(p3, p4) -- line: 159
	-- upvalues: Roact (copy), FitTextLabel (copy), Skeleton (copy)
	local Theme = p4.Theme
	local p4Font = p4.Font

	if p3.props.outfitName then
		return Roact.createElement(FitTextLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			TextWrapped = true,
			width = UDim.new(1, 0),
			Text = p3.props.outfitName,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, p4Font.Header1.RelativeSize * p4Font.BaseSize),
			TextColor3 = Theme.TextEmphasis.Color,
			TextTransparency = Theme.TextEmphasis.Transparency,
			Font = p4Font.Header1.Font,
			TextSize = p4Font.Header1.RelativeSize * p4Font.BaseSize
		})
	end

	return Roact.createElement(Skeleton, {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, p4Font.Header1.RelativeSize * p4Font.BaseSize)
	})
end
function v48.renderOutfitThumbnail(p5) -- line: 186
	-- upvalues: Constants3 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Utils (copy), Constants (copy), Roact (copy), LoadableImage (copy)
	local Outfit = Constants3.RbxthumbTypes.Outfit
	local v60 = getRbxthumbWithTypeSizeAndOptions(p5.props.outfitId, Outfit, 420)
	local n1 = nil

	if Utils.isModerationPendingOrRejected(p5:getModerationStatus()) then
		v60 = Constants.BrokenAvatarThumbnail
		n1 = 0.25
	end

	return Roact.createElement("Frame", {
		LayoutOrder = 3,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -24, 0, 300)
	}, {
		AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		}),
		MaxSize = Roact.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(1e999, 300)
		}),
		LoadableImage = Roact.createElement(LoadableImage, {
			BackgroundTransparency = 1,
			useShimmerAnimationWhileLoading = true,
			ZIndex = 1,
			ImageTransparency = n1,
			Image = v60,
			Size = UDim2.fromScale(1, 1)
		})
	})
end
function v48.renderItemWithAvailabilityStatus(p6, p7) -- line: 223
	-- upvalues: Constants3 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Roact (copy), CatalogItemCard (copy), Foundation (copy), InventoryItemAvailability (copy), FFlagAXModeratedItemIconUpdates (copy)
	local v64 = p7[1]
	local v65 = p7[2]
	local v66 = nil
	local v67 = nil

	if typeof(v64) ~= "table" then
		local Asset = Constants3.RbxthumbTypes.Asset

		v67 = getRbxthumbWithTypeSizeAndOptions(v64, Asset, 150)

		local v69 = p6.props.assetInfos[v64]

		v66 = v69 and v69.name

		if v69 and v69.outfitModerationStatus then
			v67 ..= ("&filters=__%*__"):format(v69.outfitModerationStatus)
		end
	end

	return Roact.createElement(CatalogItemCard, {
		title = v66,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		presentationSlot = Roact.createElement(Foundation.Image, {
			tag = "size-full clip radius-medium",
			BackgroundTransparency = 1,
			Image = v67,
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Crop
		}),
		itemStatus = if v65 ~= InventoryItemAvailability.Unavailable then if v65 ~= InventoryItemAvailability.Revoked then nil else {
			type = "placeholder",
			iconType = "Error"
		} else {
			type = "placeholder",
			iconType = not FFlagAXModeratedItemIconUpdates and "Error" or "Unavailable"
		}
	})
end
function v48.renderItem(p8, p9) -- line: 267
	-- upvalues: Constants3 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Roact (copy), ItemTile (copy), Constants2 (copy)
	local v72 = nil
	local v73 = nil

	if typeof(p9) ~= "table" then
		local Asset = Constants3.RbxthumbTypes.Asset

		v73 = getRbxthumbWithTypeSizeAndOptions(p9, Asset, 150)

		local v75 = p8.props.assetInfos[p9]

		v72 = v75 and v75.name

		if v75 and v75.outfitModerationStatus then
			v73 ..= ("&filters=__%*__"):format(v75.outfitModerationStatus)
		end
	end

	return Roact.createElement(ItemTile, {
		name = v72,
		titleTextLineCount = Constants2.ItemTileTitleMaxLines,
		thumbnail = v73
	})
end
function v48.renderItemsGrid(p10, p11) -- line: 292
	-- upvalues: Constants2 (copy), Utils (copy), Roact (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FitFrameVertical (copy), Focusable (copy), LoadableGridView (copy), v47 (copy), FFlagAXModeratedItemsFlow (copy)
	local itemsList = p10.props.itemsList
	local ShimmerCardsToDisplay = Constants2.ShimmerCardsToDisplay
	local v80 = itemsList and #itemsList or ShimmerCardsToDisplay
	local p11Font = p11.Font
	local v82 = p11Font.BaseSize * p11Font.Header2.RelativeSize
	local BundleItemTile = Constants2.ItemTileType.BundleItemTile
	local v84 = Utils.GridItemHeightGetter(BundleItemTile, v82)

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable[FitFrameVertical] else FitFrameVertical, {
		width = UDim.new(1, 0),
		LayoutOrder = 4,
		BackgroundTransparency = 1,
		[Roact.Ref] = p10.itemsGridRef,
		NextSelectionDown = if not FFlagAXMigrateAXToGlobalAutofocus then p10.attributionRef else nil,
		NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then p10.props.NextSelectionUp else nil
	}, {
		LoadableGridView = Roact.createElement(LoadableGridView, {
			getItemMetrics = v47,
			items = itemsList,
			totalNumItems = v80,
			renderItem = not FFlagAXModeratedItemsFlow and function(p12) -- line: 325
				-- upvalues: p10 (copy)
				return p10:renderItem(p12)
			end or function(p13) -- line: 322
				-- upvalues: p10 (copy)
				return p10:renderItemWithAvailabilityStatus(p13)
			end,
			getItemHeight = v84,
			windowHeight = p10.props.screenSize.Y
		})
	})
end
function v48.getModerationStatus(p14) -- line: 335
	local outfitInfo = p14.props.outfitInfo

	if outfitInfo then
		return outfitInfo.moderationStatus
	end

	return nil
end
function v48.renderWithProviders(t3: {[any]: any}, p15, t4: {[any]: any}) -- line: 344
	-- upvalues: FFlagAXFixGamepadNavigationOnOutfitManagement (copy), FitFrame (copy), Utils (copy), Roact (copy), FitFrameVertical (copy), CompactInlineBanner (copy), CompactInlineBannerVariant (copy), CompactInlineBannerPlacement (copy), ItemInfoList (copy)
	local outfitInfo = t3.props.outfitInfo
	local v91 = outfitInfo and outfitInfo.creatingUniverseId or nil
	local Theme = p15.Theme
	local v93 = if not FFlagAXFixGamepadNavigationOnOutfitManagement then FitFrame.Rect.square(t3.state.margin) else FitFrame.Rect.quad(t3.state.margin, t3.state.margin, t3.props.bottomPadding or t3.state.margin, t3.state.margin)
	local v94 = t3:getModerationStatus()
	local v95 = Utils.isModerationPendingOrRejected(v94)
	local v96 = v94 == Enum.ModerationStatus.ReviewedRejected

	return Roact.createElement(FitFrameVertical, {
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = Theme.BackgroundDefault.Transparency,
		BorderSizePixel = 0,
		width = UDim.new(1, 0),
		contentPadding = UDim.new(0, 24),
		margin = v93,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		[Roact.Change.AbsoluteSize] = t3.containerSizeChanged
	}, {
		ItemName = t3.props.showCustomOutfitNames and t3:renderOutfitName(p15),
		FullBleedFrame = v95 and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, v93.left + v93.right, 0, 0),
			Position = UDim2.fromOffset(-v93.left, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			ModerationStatusBanner = if not v96 then Roact.createElement(CompactInlineBanner, {
				contentText = t4.pending,
				variant = CompactInlineBannerVariant.Default,
				placement = CompactInlineBannerPlacement.Bleed
			}) else Roact.createElement(CompactInlineBanner, {
				contentText = t4.moderated,
				variant = CompactInlineBannerVariant.Alert,
				placement = CompactInlineBannerPlacement.Bleed,
				actionText = t4.details,
				onActivated = t3.goToAppealsPortal
			})
		}),
		ItemThumbnail = t3:renderOutfitThumbnail(t4),
		ItemsGrid = t3:renderItemsGrid(p15),
		ItemInfoList = if not v91 then nil else Roact.createElement(ItemInfoList, {
			LayoutOrder = 5,
			itemId = t3.props.outfitId,
			outfitInfo = t3.props.outfitInfo,
			itemType = t3.props.itemType,
			attributionRef = t3.attributionRef,
			NextSelectionUp = if not FFlagAXFixGamepadNavigationOnOutfitManagement then t3.itemsGridRef else nil
		})
	})
end
function v48.render(p16) -- line: 420
	-- upvalues: withStyle (copy), withLocalization (copy)
	return withStyle(function(p17) -- line: 421
		-- upvalues: withLocalization (copy), p16 (copy)
		return withLocalization({
			details = "Feature.Avatar.Label.DetailsButton",
			moderated = "Feature.Catalog.Message.AvatarModerationModerated",
			pending = "Feature.Catalog.Message.AvatarModerationPending"
		})(function(t5: {[any]: any}) -- line: 426
			-- upvalues: p16 (copy), p17 (copy)
			return p16:renderWithProviders(p17, t5)
		end)
	end)
end

local v49 = RoactAppPolicy.connect(function(p18, _) -- line: 432
	return {
		showCustomOutfitNames = p18.getCustomOutfitNames(),
		isWebViewSupported = p18.getWebViewSupport()
	}
end)(v48)
local v50 = memoize(function(p20) -- line: 439
	-- upvalues: FFlagAXModeratedItemsFlow (copy)
	local t6 = {}

	for _, v103 in p20 do
		for v104, v105 in v103 do
			table.insert(t6, if not FFlagAXModeratedItemsFlow then v104 else {
				v104,
				v105.availabilityStatus
			})
		end
	end

	return t6
end)

local function mapStateToProps(p21, p22) -- line: 453
	-- upvalues: v50 (copy)
	local OutfitInfos = p21.AvatarExperience.AvatarEditor.OutfitInfos
	local name = nil
	local v110 = nil

	if OutfitInfos[p22.outfitId] then
		name = OutfitInfos[p22.outfitId].name
		v110 = v50(OutfitInfos[p22.outfitId].assets)
	end

	return {
		outfitInfo = OutfitInfos[p22.outfitId],
		outfitName = name,
		itemsList = v110,
		screenSize = p21.ScreenSize,
		assetInfos = p21.AvatarExperience.Common.AssetInfos
	}
end
local function mapDispatchToProps(p23) -- line: 472
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v26 (copy), NavigateDown (copy), SetCurrentToastMessage (copy)
	return {
		navigateDown = function(p24) -- line: 474
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v26 (copy), p23 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v26.down(v26.fromLegacyPage(p24))

				return
			end

			p23(NavigateDown(p24))
		end,
		setCurrentToastMessage = function(p25) -- line: 481
			-- upvalues: p23 (copy), SetCurrentToastMessage (copy)
			p23(SetCurrentToastMessage(p25))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v49)
