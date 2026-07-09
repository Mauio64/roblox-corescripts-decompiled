local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UIBlox = require(CorePackages.Packages.UIBlox)
local ItemTile = UIBlox.Tile.ItemTile
local ItemTileEnums = UIBlox.Tile.ItemTileEnums
local SaveTile = UIBlox.Tile.SaveTile
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local Focusable = RoactGamepad.Focusable
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local withLastInputGroup = require(Modules.AvatarExperience.Common.Components.withLastInputGroup)
local withAdaptiveScrolling = AvatarExperienceCommon.Hooks.withAdaptiveScrolling
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local logOnOverlayClosed = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Debug.logOnOverlayClosed

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.Common.Services.Analytics)
local ItemTileDetailButton = require(Modules.AvatarExperience.Common.Components.ItemTileDetailButton)
local Constants2 = require(Modules.LuaApp.Constants)
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)
local EquipOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.EquipOutfit)
local SendAnalytics = require(Modules.AvatarExperience.AvatarEditor.Thunks.SendAnalytics)
local ToggleEquipAsset = require(Modules.AvatarExperience.AvatarEditor.Thunks.ToggleEquipAsset)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local Constants3 = require(Modules.AvatarExperience.Common.Constants)
local Constants4 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local FullView = AvatarExperienceCommon.Enums.FullView
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local OpenItemDetails = require(Modules.AvatarExperience.Common.Thunks.OpenItemDetails)
local Analytics3 = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local CatalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local CatalogItemCardStatusIconTypeEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum

require(Modules.AvatarExperience.Common.Types)

local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants5 = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local ImpressionsUtil = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).ImpressionsReporter.ImpressionsUtil
local OrganicEventImpressionsSchema = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).ImpressionsReporter.OrganicEventImpressionsSchema
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local addUnifiedEventLogging = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).addUnifiedEventLogging
local UnifiedEventLogConstants = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogConstants
local selectHasAvatarData = require(Modules.AvatarExperience.Common.Selectors.selectHasAvatarData)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXNegativeAvatarSequenceFeatures = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXNegativeAvatarSequenceFeatures
local v63 = game:DefineFastFlag("AXItemCardShouldNotBeAbleToActivateUntilReady", false)
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local FFlagAXMISEnableMultiShoppingUnifiedEvents = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShoppingUnifiedEvents
local v66 = GuiService:IsTenFootInterface()
local AddOutfitButton = Constants4.AddOutfitButton
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local v69 = Roact.PureComponent:extend("ItemCard")

v69.validateProps = t.strictInterface({
	itemId = t.optional(t.string),
	isOutfit = t.boolean,
	isWearingAssetOrOutfit = t.optional(t.boolean),
	titleFontStyle = t.optional(t.table),
	hasItemFromCurrentPageEquipped = t.optional(t.boolean),
	itemDetailsPeekViewRefs = t.table,
	resultsListRef = t.table,
	impressionsTag = t.optional(t.string),
	impressionsSchema = t.optional(t.string),
	gridInformation = t.optional(t.table),
	assetTypeId = t.optional(t.string),
	name = t.optional(t.string),
	thumbnail = t.optional(t.string),
	isUIFullView = t.boolean,
	outfitInfo = t.optional(t.table),
	categoryInfo = t.table,
	lastInputGroup = t.string,
	avatarType = t.string,
	hasAvatarData = t.boolean,
	itemData = t.optional(t.table),
	itemType = t.optional(t.string),
	isEditable = t.optional(t.boolean),
	isPortrait = t.boolean,
	disabled = if not v63 then nil else t.boolean,
	fetchItemInfo = t.callback,
	toggleEquipAsset = t.callback,
	equipOutfitThunk = t.callback,
	sendAnalytics = t.callback,
	setFullView = t.callback,
	navigateWithLock = t.callback,
	openItemDetails = t.callback,
	appAnalytics = t.table,
	analytics = t.table,
	avatarExperienceAnalytics = t.table,
	networking = t.callback,
	catalogAnalytics = t.table,
	navigation = t.table,
	avatarRoute = t.table,
	adaptiveScrolling = t.optional(t.table),
	focusController = if not FFlagAXMigrateAXToGlobalAutofocus then t.optional(t.table) else nil
})

function v69.shouldShowConfirmationDialog(p1) -- line: 166
	-- upvalues: Constants3 (copy)
	local v75 = not p1.props.hasItemFromCurrentPageEquipped

	if p1.props.outfitInfo.outfitType == Constants3.OutfitTypes.DynamicHead and not p1.props.outfitInfo.isEditable then
		v75 = false
	end

	return v75
end
function v69.getItemIconType(p2) -- line: 178
	-- upvalues: Utils (copy), ItemTileEnums (copy)
	local isOutfit = p2.props.isOutfit
	local outfitInfo = p2.props.outfitInfo
	local v79 = if not isOutfit or not outfitInfo then isOutfit and ItemTileEnums.ItemIconType.Bundle or nil else Utils.getItemIconTypeFromOutfit(outfitInfo)

	if v79 == ItemTileEnums.ItemIconType.Bundle then
		return nil
	end

	return v79
end
function v69.getItemStatusStyle(p3) -- line: 196
	-- upvalues: Utils (copy)
	local isOutfit = p3.props.isOutfit
	local outfitInfo = p3.props.outfitInfo

	if isOutfit and outfitInfo then
		return Utils.getItemStatusStyleFromOutfit(outfitInfo)
	end

	return nil
end
function v69.isEquippable(p4) -- line: 207
	return p4:getItemStatusStyle() == nil
end
function v69.init(p5) -- line: 211
	-- upvalues: Roact (copy), NavigationUtils (copy), AvatarScreen (copy), CatalogUtils (copy), Constants2 (copy), logOnOverlayClosed (copy), Constants3 (copy), Utils (copy), FFlagAXModeratedItemsFlow (copy), v63 (copy)
	p5.addOutfitButtonRef = Roact.createRef()
	p5.thumbnailRef = Roact.createRef()
	p5.textButtonRef = Roact.createRef()

	function p5.activateDetailsButton() -- line: 216
		-- upvalues: p5 (copy), NavigationUtils (copy), AvatarScreen (copy), CatalogUtils (copy)
		if p5:isOutfit() then
			local navigation = p5.props.navigation
			local t1 = {
				ZIndex = 2,
				renderBottomBar = false,
				outfitId = p5.props.itemId,
				showFullWithNoPeekView = not p5.props.isPortrait,
				NextSelectionLeft = not p5.props.isPortrait and p5.props.resultsListRef or nil,
				outfitDetailsPeekViewRefs = p5.props.itemDetailsPeekViewRefs
			}

			p5.props.navigateWithLock(function() -- line: 229
				-- upvalues: NavigationUtils (copy), navigation (copy), AvatarScreen (copy), t1 (copy)
				NavigationUtils.closeFiltersAndItemDetails(navigation)
				NavigationUtils.closeTryOnManager(navigation)
				navigation.navigate(AvatarScreen.OutfitDetails, t1)
			end)

			return
		end

		local v152 = CatalogUtils.GetItemSubType(p5.props.itemType, p5.props.itemData)
		local v153 = if not p5.props.itemData then nil else p5.props.itemData.priceInRobux
		local itemType = p5.props.itemType
		local t2 = {
			mountAsFullView = nil,
			showFullWithNoPeekView = true,
			closePreviousItemDetails = true,
			itemId = p5.props.itemId,
			itemType = itemType,
			itemSubType = v152,
			priceInRobux = v153,
			catalogAnalytics = p5.props.catalogAnalytics,
			avatarRoute = p5.props.avatarRoute,
			navigation = p5.props.navigation,
			itemDetailsPeekViewRefs = p5.props.itemDetailsPeekViewRefs,
			resultsListRef = p5.props.resultsListRef
		}

		p5.props.openItemDetails(t2)
	end
	function p5.onOverlayClosed() -- line: 263
		-- upvalues: p5 (copy), Constants2 (copy), logOnOverlayClosed (copy)
		local v156 = p5.props.lastInputGroup == Constants2.InputType.Gamepad

		logOnOverlayClosed("ItemCard", v156)

		if v156 then
			p5.props.focusController.captureFocus()
		end
	end
	function p5.maybeShowNonBlockingR15Prompt() -- line: 275
		-- upvalues: p5 (copy), Constants3 (copy), AvatarScreen (copy)
		if p5.props.avatarType ~= Constants3.AvatarType.R6 then
			return
		end

		local v157 = false
		local s1 = nil

		if p5.props.categoryInfo.PageType == Constants3.PageType.Animation then
			v157 = true
			s1 = "Feature.Avatar.Message.R15AnimationsPrompt"
		elseif p5.props.categoryInfo.PageType == Constants3.PageType.Emotes then
			v157 = true
			s1 = "Feature.Avatar.Message.R15EmotesPrompt"
		end

		if v157 then
			p5.props.navigateWithLock(function() -- line: 299
				-- upvalues: p5 (copy), AvatarScreen (copy), s1 (ref)
				p5.props.navigation.navigate(AvatarScreen.R15UpgradePrompt, {
					onOverlayClosed = p5.onOverlayClosed,
					bodyTextKey = s1
				})
			end)
		end
	end
	function p5.toggleAdaptiveScrollingSelectedItem(b1: boolean, b2: boolean?) -- line: 309
		-- upvalues: p5 (copy)
		local adaptiveScrolling = p5.props.adaptiveScrolling

		if not adaptiveScrolling then
			return
		end

		if b1 then
			adaptiveScrolling.setSelectedItemInstance(nil)

			return
		end

		local current = p5.thumbnailRef.current

		if current and b2 then
			adaptiveScrolling.setSelectedItemInstance(current)
		end
	end
	function p5.onItemClick() -- line: 327
		-- upvalues: p5 (copy), Utils (copy), FFlagAXModeratedItemsFlow (copy), Constants3 (copy), AvatarScreen (copy), v63 (copy)
		local itemData = p5.props.itemData

		if itemData and Utils.isModerationPendingOrRejected(itemData.moderationStatus) then
			local v164 = nil

			if FFlagAXModeratedItemsFlow then
				v164 = not p5.props.assetType and "Feature.Catalog.Label.Bundle" or Constants3.AssetTypeLocalized[p5.props.assetTypeId]
			end

			p5.props.navigation.navigate(AvatarScreen.ItemsUnavailablePrompt, {
				items = {{
					category = p5.props.itemType,
					categoryLoc = v164,
					itemName = itemData.name
				}},
				messageType = Utils.getMessageTypeFromModerationStatus(itemData.moderationStatus)
			})

			return
		end

		if v63 then
			if p5.props.disabled then
				return
			end
		else
			if not p5.props.itemId then
				return
			end

			if not p5.props.hasAvatarData then
				return
			end
		end

		if p5:isEquippable() then
			p5:toggleEquip()

			return
		end

		p5.activateDetailsButton()
	end
end
function v69.toggleEquip(p6) -- line: 372
	-- upvalues: Constants4 (copy), Constants3 (copy), AvatarScreen (copy), Logging (copy), GetFFlagAXEnableSlotBasedEditor (copy), FullView (copy)
	local itemId = p6.props.itemId
	local isWearingAssetOrOutfit = p6.props.isWearingAssetOrOutfit
	local toggleEquipAsset = p6.props.toggleEquipAsset
	local sendAnalytics = p6.props.sendAnalytics
	local analytics = p6.props.analytics
	local equipOutfitThunk = p6.props.equipOutfitThunk
	local isUIFullView = p6.props.isUIFullView
	local navigation = p6.props.navigation
	local v94 = p6:isOutfit() and Constants4.Outfits or p6.props.assetTypeId

	local function v95() -- line: 391
		-- upvalues: toggleEquipAsset (copy), v94 (copy), itemId (copy), navigation (copy), p6 (copy), isWearingAssetOrOutfit (copy)
		local v165 = toggleEquipAsset(v94, itemId, navigation)

		p6.toggleAdaptiveScrollingSelectedItem(isWearingAssetOrOutfit, v165)
	end

	p6.maybeShowNonBlockingR15Prompt()

	local v96 = p6.props.avatarType == Constants3.AvatarType.R6
	local v97 = v94 == Constants3.AssetTypeIdStrings.HairAccessory
	local v98 = Constants3.LayeredAssetTypes[v94] ~= nil and not v97

	if v96 and (not isWearingAssetOrOutfit and v98) then
		p6.props.navigateWithLock(function() -- line: 408
			-- upvalues: p6 (copy), AvatarScreen (copy), v95 (copy)
			p6.props.navigation.navigate(AvatarScreen.R15UpgradePrompt, {
				bodyTextKey = "Feature.Avatar.Label.LayeredClothingR15Warning",
				onOverlayClosed = p6.onOverlayClosed,
				onSwitchSelected = v95
			})
		end)

		return
	end

	if p6:isOutfit() then
		local outfitInfo = p6.props.outfitInfo

		if outfitInfo then
			if p6:shouldShowConfirmationDialog() then
				p6.props.navigateWithLock(function() -- line: 423
					-- upvalues: p6 (copy), AvatarScreen (copy), outfitInfo (copy), isWearingAssetOrOutfit (copy)
					p6.props.navigation.navigate(AvatarScreen.EquipOutfitConfirmation, {
						onOverlayClosed = p6.onOverlayClosed,
						outfitInfo = outfitInfo,
						onEquip = function(b3: boolean?) -- line: 427
							-- upvalues: p6 (copy), isWearingAssetOrOutfit (copy)
							p6.toggleAdaptiveScrollingSelectedItem(isWearingAssetOrOutfit, b3)
						end
					})
				end)
			else
				local v100 = equipOutfitThunk(outfitInfo, analytics, navigation, isWearingAssetOrOutfit)

				p6.toggleAdaptiveScrollingSelectedItem(isWearingAssetOrOutfit, v100)
			end
		else
			Logging.warn("Tried equipping a costume without any costume data!")
		end
	else
		if v94 then
			if not isWearingAssetOrOutfit then
				sendAnalytics(analytics.equipAsset, itemId, v94)
			else
				sendAnalytics(analytics.unequipAsset, itemId, v94)
			end
		end

		local v101 = toggleEquipAsset(v94, itemId, navigation)

		p6.toggleAdaptiveScrollingSelectedItem(isWearingAssetOrOutfit, v101)
	end

	if not isWearingAssetOrOutfit and isUIFullView then
		if GetFFlagAXEnableSlotBasedEditor() then
			p6.props.setFullView(p6.props.avatarExperienceAnalytics, p6.props.avatarRoute.opaque.name, FullView.None)

			return
		end

		p6.props.setFullView(p6.props.avatarExperienceAnalytics, AvatarScreen.AvatarEditor, FullView.None)
	end
end
function v69.isOutfit(p7) -- line: 465
	return p7.props.isOutfit
end
function v69.wasCreatedInExperience(p8) -- line: 469
	local outfitInfo = p8.props.outfitInfo

	return outfitInfo and (outfitInfo.creatingUniverseId ~= nil and string.len(outfitInfo.creatingUniverseId) > 0)
end
function v69.shouldProvideControlsToViewItemDetails(p9) -- line: 476
	if p9:isOutfit() and not p9:wasCreatedInExperience() then
		return false
	end

	if not p9.props.isWearingAssetOrOutfit then
		return false
	end

	return true
end
function v69.renderDetailsButton(p10, _, _) -- line: 493
	-- upvalues: v66 (copy), Roact (copy), ItemTileDetailButton (copy)
	if not p10:shouldProvideControlsToViewItemDetails() then
		return nil
	end

	if v66 then
		return nil
	end

	return Roact.createElement(ItemTileDetailButton, {
		activateButton = p10.activateDetailsButton
	})
end
function v69.render(p13) -- line: 510
	-- upvalues: withLocalization (copy), withStyle (copy)
	return withLocalization({
		more = "CommonUI.Features.Label.More"
	})(function(p14) -- line: 513
		-- upvalues: withStyle (copy), p13 (copy)
		return withStyle(function(p15) -- line: 514
			-- upvalues: p13 (copy), p14 (copy)
			return p13:renderWithProviders(p14, p15)
		end)
	end)
end
function v69.renderWithProviders(p16, p17, p18) -- line: 520
	-- upvalues: RoactGamepad (copy), AddOutfitButton (copy), Roact (copy), SaveTile (copy), Images (copy), Constants2 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Constants3 (copy), Utils (copy), CatalogItemCardStatusIconTypeEnum (copy), React (copy), CatalogItemCard (copy), Focusable (copy), ItemTile (copy)
	local itemId = p16.props.itemId
	local name = p16.props.name
	local thumbnail = p16.props.thumbnail
	local isWearingAssetOrOutfit = p16.props.isWearingAssetOrOutfit
	local itemData = p16.props.itemData

	return RoactGamepad.withFocusController(function(p19) -- line: 527
		-- upvalues: itemId (copy), AddOutfitButton (copy), Roact (copy), SaveTile (copy), Images (copy), p16 (copy), Constants2 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Constants3 (copy), isWearingAssetOrOutfit (copy), RoactGamepad (copy), itemData (copy), Utils (copy), CatalogItemCardStatusIconTypeEnum (copy), React (copy), CatalogItemCard (copy), Focusable (copy), ItemTile (copy), name (copy), thumbnail (copy), p17 (copy), p18 (copy)
		if itemId == AddOutfitButton then
			return Roact.createElement(SaveTile, {
				thumbnail = Images["icons/menu/customize"],
				onActivated = function() -- line: 531
					-- upvalues: p16 (copy), Constants2 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), p19 (copy)
					p16:openCreateOrUpdateCostumeMenu(function() -- line: 532
						-- upvalues: p16 (copy), Constants2 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), p19 (copy)
						local v197 = p16.props.lastInputGroup == Constants2.InputType.Gamepad

						if not FFlagAXMigrateAXToGlobalAutofocus and v197 then
							p19.captureFocus()
						end
					end)
				end,
				thumbnailTransparency = 0,
				[Roact.Ref] = p16.addOutfitButtonRef
			})
		end

		local v168 = if p16.props.categoryInfo.PageType ~= Constants3.PageType.Emotes then nil else not isWearingAssetOrOutfit and "Feature.Avatar.Action.SlotEmote" or "Feature.Avatar.Action.UnslotEmote"
		local v169 = p16:shouldProvideControlsToViewItemDetails()
		local t3 = {
			SelectSlot = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, p16.onItemClick, {
				key = v168
			}),
			MoreDetails = if not v169 then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonX, p16.activateDetailsButton, {
				key = "CommonUI.Features.Label.More"
			})
		}
		local n1 = 0
		local titleFontStyle = nil

		if not p16.props.categoryInfo.HideTextUnderTile then
			n1 = Constants3.ItemTileTitleMaxLines
			titleFontStyle = p16.props.titleFontStyle
		end

		if itemData and Utils.isModerationPendingOrRejected(itemData.moderationStatus) then
			local v173 = if itemData.moderationStatus ~= Enum.ModerationStatus.NotReviewed then CatalogItemCardStatusIconTypeEnum.Moderated else CatalogItemCardStatusIconTypeEnum.PendingModeration

			return React.createElement(CatalogItemCard, {
				Size = UDim2.fromScale(1, 1),
				AutomaticSize = Enum.AutomaticSize.Y,
				isSelected = isWearingAssetOrOutfit,
				onActivated = p16.onItemClick,
				ref = p16.textButtonRef,
				itemStatus = {
					type = "placeholder",
					iconType = v173
				}
			})
		end

		return Roact.createElement(Focusable[ItemTile], {
			LayoutOrder = p16.props.layoutOrder,
			isSelected = isWearingAssetOrOutfit,
			itemIconType = p16:getItemIconType(),
			onActivated = p16.onItemClick,
			name = name,
			titleTextLineCount = n1,
			titleFontStyle = titleFontStyle,
			thumbnail = thumbnail,
			renderTileInset = function() -- line: 597
				-- upvalues: p16 (copy), p17 (copy), p18 (copy)
				return p16:renderDetailsButton(p17, p18)
			end,
			inputBindings = t3,
			statusStyle = p16:getItemStatusStyle(),
			key = itemId,
			textButtonRef = p16.textButtonRef,
			[Roact.Ref] = p16.thumbnailRef,
			[React.Tag] = p16.props.impressionsTag
		})
	end)
end
function v69.openCreateOrUpdateCostumeMenu(p20, p21) -- line: 612
	-- upvalues: AvatarScreen (copy)
	local v120 = p20.addOutfitButtonRef:getValue()

	if not v120 then
		return
	end

	local v121 = v120.AbsolutePosition + v120.AbsoluteSize * Vector2.new(0.5, 0.5)

	p20.props.navigateWithLock(function() -- line: 620
		-- upvalues: p20 (copy), AvatarScreen (copy), v121 (copy), p21 (copy)
		p20.props.navigation.navigate(AvatarScreen.CreateOrUpdateOutfitMenu, {
			saveTilePosition = v121,
			onOverlayClosed = p21
		})
	end)
end
function v69.checkFetchInfo(p22) -- line: 629
	-- upvalues: AddOutfitButton (copy), Constants3 (copy)
	if p22:isOutfit() then
		return
	end

	local itemId = p22.props.itemId

	if itemId == AddOutfitButton then
		return
	end

	if itemId and not p22.props.name then
		p22.props.fetchItemInfo(p22.props.networking, p22.props.appAnalytics, itemId, Constants3.ItemType.Asset)
	end
end
function v69.setImpressionAttributes(p23) -- line: 645
	-- upvalues: OrganicEventImpressionsSchema (copy), ImpressionsUtil (copy)
	local v125 = p23.thumbnailRef and p23.thumbnailRef:getValue()

	if p23.props.impressionsTag and v125 then
		v125:SetAttribute(p23.props.impressionsTag, p23.props.itemId)

		local v126 = OrganicEventImpressionsSchema[p23.props.impressionsSchema]

		ImpressionsUtil.writeItemAttributes(v126, v125, p23.props)
	end
end
function v69.addUnifiedEventLogging(p24) -- line: 655
	-- upvalues: addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), Utils (copy), FFlagAXNegativeAvatarSequenceFeatures (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLogConstants (copy)
	addUnifiedEventLogging(p24.textButtonRef, {
		action = if not p24.props.isWearingAssetOrOutfit then UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED else UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_DESELECTED,
		itemId = p24.props.itemId,
		itemType = if p24.props.itemType ~= "Asset" then UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE else UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET,
		assetType = p24.props.itemData and p24.props.itemData.assetType or nil,
		gridPositionRow = if not p24.props.gridInformation then nil else p24.props.gridInformation.row,
		gridPositionColumn = if not p24.props.gridInformation then nil else p24.props.gridInformation.column,
		category = if not p24.props.categoryInfo.Category then nil else Utils.getAvatarEditorCategoryInfo(p24.props.categoryInfo.Category).Name,
		subcategory = if not p24.props.categoryInfo.Category or not p24.props.categoryInfo.Subcategory then nil else Utils.getAvatarEditorCategoryInfo(p24.props.categoryInfo.Category, p24.props.categoryInfo.Subcategory).Name,
		isOwnedItem = not not FFlagAXNegativeAvatarSequenceFeatures or nil
	}, {
		hasDeferredActions = not FFlagAXMISEnableMultiShoppingUnifiedEvents or nil,
		sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
	})
end
function v69.didUpdate(p25, p26) -- line: 683
	p25:setImpressionAttributes()
	p25:addUnifiedEventLogging()

	if p26.itemId == p25.props.itemId then
		return
	end

	p25:checkFetchInfo()
end
function v69.didMount(p27) -- line: 698
	p27:setImpressionAttributes()
	p27:addUnifiedEventLogging()
	p27:checkFetchInfo()
end

local v70 = RoactServices.connect({
	appAnalytics = RoactAnalytics,
	analytics = Analytics,
	catalogAnalytics = Analytics3,
	avatarExperienceAnalytics = Analytics2,
	networking = RoactNetworking
})(v69)

local function mapStateToProps(p28, p29) -- line: 714
	-- upvalues: Utils (copy), v63 (copy), Constants3 (copy), ItemData (copy), selectHasAvatarData (copy), Constants5 (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy), AvatarScreen (copy), FullView (copy), GetFFlagAXEnableSlotBasedEditor (copy), selectIsPortrait (copy)
	local itemId = p29.itemId
	local v134 = Utils.getAvatarEditorCategoryInfoFromState(p28)
	local v135 = p28.AvatarExperience.AvatarEditor.OutfitInfos[itemId]
	local v136 = not not v63 or nil
	local v137 = nil
	local v138 = nil
	local v139 = nil
	local v140 = if not p29.isOutfit then Constants3.ItemType.Asset else Constants3.ItemType.Bundle
	local v141 = ItemData(p28.AvatarExperience.Common, p29.itemId, v140)
	local v142 = not not v135 and v135.isEditable
	local v143 = if not v63 then nil else selectHasAvatarData(p28)

	if itemId then
		if p29.isOutfit then
			v138 = v135 and v135.name or nil

			local Outfit = Constants5.RbxthumbTypes.Outfit

			v139 = getRbxthumbWithTypeSizeAndOptions(itemId, Outfit, 150)

			if v135 then
				v139 ..= "&filters=" .. v135.updateCounter

				if Utils.isModerationPendingOrRejected(v135.moderationStatus) then
					v139 = Constants.BrokenAvatarThumbnail
				end
			end

			v136 = if not v63 then nil else not v143
		else
			v137 = v141 and v141.assetType or nil
			v138 = v141 and v141.name or nil

			local Asset = Constants5.RbxthumbTypes.Asset

			v139 = getRbxthumbWithTypeSizeAndOptions(itemId, Asset, 150)

			if v141 and v141.outfitModerationStatus then
				v139 ..= ("&filters=__%*__"):format(v141.outfitModerationStatus)
			end

			if v141 and v141.moderationStatus then
				v139 ..= "&filters=" .. (v141.updateCounter or 0)
			end

			v136 = if not v63 then nil else not v141 or not v143
		end
	end

	local AvatarType = p28.AvatarExperience.AvatarEditor.Character.AvatarType
	local v147 = p28.AvatarExperience.Common.FullView[AvatarScreen.AvatarEditor] == FullView.UIFullView

	if GetFFlagAXEnableSlotBasedEditor() then
		v147 = p28.AvatarExperience.Common.FullView[p29.avatarRoute.opaque.name] == FullView.UIFullView
	end

	return {
		itemData = v141,
		itemType = v140,
		isEditable = v142,
		assetTypeId = v137,
		name = v138,
		thumbnail = v139,
		isUIFullView = v147,
		outfitInfo = v135,
		categoryInfo = v134,
		avatarType = AvatarType,
		hasAvatarData = if not v63 then selectHasAvatarData(p28) else v143,
		isPortrait = selectIsPortrait(p28),
		disabled = if not v63 then nil else v136
	}
end
local function mapDispatchToProps(p30) -- line: 790
	-- upvalues: FetchAssetOrBundleInfo (copy), ToggleEquipAsset (copy), EquipOutfit (copy), SendAnalytics (copy), SetFullView (copy), NavigateWithLock (copy), OpenItemDetails (copy)
	return {
		fetchItemInfo = function(p31, p32, p33, p34) -- line: 792
			-- upvalues: p30 (copy), FetchAssetOrBundleInfo (copy)
			return p30(FetchAssetOrBundleInfo(p31, p32, p33, p34))
		end,
		toggleEquipAsset = function(p35, p36, p37) -- line: 795
			-- upvalues: p30 (copy), ToggleEquipAsset (copy)
			return p30(ToggleEquipAsset(p35, p36, p37))
		end,
		equipOutfitThunk = function(p38, p39, p40, p41) -- line: 798
			-- upvalues: p30 (copy), EquipOutfit (copy)
			local t4 = {
				outfitInfo = p38,
				analytics = p39,
				navigation = p40,
				isSelected = p41
			}

			return p30(EquipOutfit(t4))
		end,
		sendAnalytics = function(p42, p43, p44) -- line: 807
			-- upvalues: p30 (copy), SendAnalytics (copy)
			p30(SendAnalytics(p42, p43, p44))
		end,
		setFullView = function(p45, p46, p47) -- line: 810
			-- upvalues: p30 (copy), SetFullView (copy)
			p30(SetFullView(p45, p46, p47))
		end,
		navigateWithLock = function(p48) -- line: 813
			-- upvalues: p30 (copy), NavigateWithLock (copy)
			p30(NavigateWithLock(p48))
		end,
		openItemDetails = function(p49) -- line: 816
			-- upvalues: p30 (copy), OpenItemDetails (copy)
			p30(OpenItemDetails(p49))
		end
	}
end

local u73 = withAdaptiveScrolling((withLastInputGroup((withAvatarRoute((withNavigation(RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v70), nil)))))))

if FFlagAXMigrateAXToGlobalAutofocus then
	return u73
end

return function(p50) -- line: 833
	-- upvalues: RoactGamepad (copy), Roact (copy), u73 (ref), Cryo (copy)
	return RoactGamepad.withFocusController(function(p51) -- line: 834
		-- upvalues: Roact (copy), u73 (ref), Cryo (copy), p50 (copy)
		return Roact.createElement(u73, Cryo.Dictionary.join(p50, {
			focusController = p51
		}))
	end)
end
