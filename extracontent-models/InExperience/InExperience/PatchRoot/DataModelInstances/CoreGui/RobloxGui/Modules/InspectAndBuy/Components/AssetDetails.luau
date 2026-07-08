local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ParentParent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local DetailsText = require(ParentParent.Components.DetailsText)
local DetailsThumbnail = require(ParentParent.Components.DetailsThumbnail)
local DetailsDescription = require(ParentParent.Components.DetailsDescription)
local DetailsButtons = require(ParentParent.Components.DetailsButtons)
local TryOnViewport = require(ParentParent.Components.TryOnViewport)
local OpenOverlay = require(ParentParent.Actions.OpenOverlay)
local Overlay = require(ParentParent.Enums.Overlay)
local GetAssetBundles = require(ParentParent.Thunks.GetAssetBundles)
local ReportOpenDetailsPage = require(ParentParent.Thunks.ReportOpenDetailsPage)
local GetEconomyProductInfo = require(ParentParent.Thunks.GetEconomyProductInfo)
local GetCollectibleResellableInstances = require(ParentParent.Thunks.GetCollectibleResellableInstances)
local Colors = require(ParentParent.Colors)
local Constants = require(ParentParent.Constants)
local UtilityFunctions = require(ParentParent.UtilityFunctions)
local tutils = require(CorePackages.Packages.tutils)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ItemInfoList = require(CorePackages.Workspace.Packages.ItemDetails).ItemInfoList
local AttributionConstants = require(ParentParent.AttributionConstants)
local InspectAndBuyContext = require(ParentParent.Components.InspectAndBuyContext)
local GetFFlagDisplayCollectiblesIcon = require(ParentParent.Flags.GetFFlagDisplayCollectiblesIcon)
local GetItemDetails = require(ParentParent.Thunks.GetItemDetails)
local SetAssetFromBundleInfo = require(ParentParent.Actions.SetAssetFromBundleInfo)
local Modules = CoreGui.RobloxGui.Modules
local Theme = require(Modules.Settings.Theme)
local ControllerBarHeight = require(CoreGui.RobloxGui.Modules.InGameMenuConstants).ControllerBarHeight
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local v37 = Roact.PureComponent:extend("AssetDetails")

function v37.setScrollingEnabled(p1, p2) -- line: 48
	if p2 ~= p1.state.scrollingEnabled then
		p1:setState({
			scrollingEnabled = p2
		})
	end
end
function v37.getInfoRowProps(p3) -- line: 58
	-- upvalues: RobloxTranslator (copy), AttributionConstants (copy), Overlay (copy), Roact (copy), Constants (copy)
	local v41 = p3.props.assetInfo or {}
	local locale = p3.props.locale
	local v43 = v41.parentBundleId ~= nil
	local t1 = {
		LayoutOrder = 1,
		Selectable = false,
		infoName = RobloxTranslator:FormatByKeyForLocale("Feature.Catalog.Label.Filter.Creator", locale),
		infoData = v41.creatorName or "",
		hasVerifiedBadge = v41.creatorHasVerifiedBadge
	}
	local t2 = nil
	local creatingUniverseId = v41.creatingUniverseId

	if creatingUniverseId then
		local v47 = p3.props.creatingExperiences[creatingUniverseId]

		if v47 then
			local playabilityStatus = v47.playabilityStatus

			if AttributionConstants.ShowPlayableAttributionMapper[playabilityStatus] then
				local v49 = v47.name or ""

				t2 = {
					infoName = RobloxTranslator:FormatByKeyForLocale("Feature.Catalog.Label.Attribution", locale),
					infoData = v49,
					onActivate = function() -- line: 91
						-- upvalues: p3 (copy), Overlay (copy), v47 (copy)
						p3.props.openOverlay(Overlay.AttributionTraversal, v47)
					end,
					LayoutOrder = 2,
					[Roact.Ref] = p3.attributionRef,
					Selectable = true
				}
			end
		end
	end

	local v50 = nil

	if v43 then
		v50 = RobloxTranslator:FormatByKeyForLocale("Feature.Catalog.Label.Bundle", locale)
	else
		local v51 = Constants.AssetTypeIdToCategory[v41.assetTypeId]
		local v52 = Constants.AssetCategoriesLocalized[v51]
		local v53 = Constants.AssetTypeIdToTypeLocalized[v41.assetTypeId]

		if v52 and v53 then
			v50 = RobloxTranslator:FormatByKeyForLocale(v52, locale) .. " | " .. RobloxTranslator:FormatByKeyForLocale(v53, locale)
		end
	end

	return {
		t1,
		t2,
		{
			LayoutOrder = 3,
			Selectable = false,
			infoName = RobloxTranslator:FormatByKeyForLocale("Feature.Catalog.Label.CategoryType", locale),
			infoData = v50
		}
	}
end
function v37.init(p4) -- line: 135
	-- upvalues: Roact (copy)
	p4.state = {
		scrollingEnabled = true
	}
	p4.attributionRef = Roact.createRef()
end
function v37.willUpdate(p5, p6) -- line: 143
	-- upvalues: UtilityFunctions (copy), tutils (copy)
	if UtilityFunctions.isCollectibles(p5.props.assetInfo) then
		local collectibleItemId = p5.props.assetInfo.collectibleItemId
		local resellableInstances = p5.props.resellableInstances
		local resellableInstances2 = p6.resellableInstances

		if resellableInstances and (resellableInstances[collectibleItemId] and (resellableInstances2 and resellableInstances2[collectibleItemId])) and tutils.fieldCount(resellableInstances[collectibleItemId]) ~= tutils.fieldCount(resellableInstances2[collectibleItemId]) then
			p5:setState({})
		end
	end

	local v60 = p5.props.assetInfo and p5.props.assetInfo.parentBundleId
	local bundles = p5.props.bundles
	local bundles2 = p6.bundles

	if v60 and bundles and bundles[v60] and bundles2 and bundles2[v60] and bundles2[v60] ~= bundles[v60] then
		p5.props.setAssetFromBundleInfo(p5.props.assetInfo.assetId, bundles2[v60])
	end
end
function v37.didUpdate(p7, p8) -- line: 176
	-- upvalues: UtilityFunctions (copy)
	local reportOpenDetailsPage = p7.props.reportOpenDetailsPage
	local assetInfo = p7.props.assetInfo
	local assetInfo2 = p8.assetInfo

	if assetInfo and assetInfo ~= assetInfo2 then
		local bundles = p7.props.bundles
		local v69 = assetInfo.parentBundleId ~= nil
		local v70 = v69 and UtilityFunctions.getBundleId(assetInfo)

		if not v69 and assetInfo.owned == nil or v69 and bundles[v70].owned == nil then
			local assetId = assetInfo.assetId
			local Asset = Enum.AvatarItemType.Asset

			if v69 then
				assetId = v70
				Asset = Enum.AvatarItemType.Bundle
			end

			p7.props.getItemDetails(assetId, Asset)
		end
	end

	if p7.props.detailsInformation.viewingDetails and not p8.detailsInformation.viewingDetails then
		reportOpenDetailsPage(assetInfo)
	end
end
function v37.render(p9) -- line: 214
	-- upvalues: Images (copy), Roact (copy), InspectAndBuyContext (copy), GetFFlagDisplayCollectiblesIcon (copy), UtilityFunctions (copy), Players (copy), tutils (copy), ControllerBarHeight (copy), Theme (copy), Colors (copy), DetailsButtons (copy), DetailsThumbnail (copy), isInExperienceUIVREnabled (copy), TryOnViewport (copy), DetailsText (copy), ImageSetLabel (copy), RobloxTranslator (copy), AppFonts (copy), DetailsDescription (copy), ItemInfoList (copy)
	local view = p9.props.view
	local detailsInformation = p9.props.detailsInformation
	local v76 = p9.props.assetInfo or {}
	local localPlayerModel = p9.props.localPlayerModel
	local scrollingEnabled = p9.state.scrollingEnabled
	local locale = p9.props.locale
	local v80 = Images["icons/status/item/owned"]
	local v81 = v80 and v80.ImageRectSize / Images.ImagesResolutionScale or Vector2.new(0, 0)

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p10) -- line: 225
			-- upvalues: view (copy), GetFFlagDisplayCollectiblesIcon (copy), UtilityFunctions (copy), v76 (copy), p9 (copy), Players (copy), tutils (copy), ControllerBarHeight (copy), Theme (copy), Roact (copy), Colors (copy), detailsInformation (copy), DetailsButtons (copy), localPlayerModel (copy), scrollingEnabled (copy), DetailsThumbnail (copy), isInExperienceUIVREnabled (copy), TryOnViewport (copy), DetailsText (copy), v81 (copy), ImageSetLabel (copy), v80 (copy), RobloxTranslator (copy), locale (copy), AppFonts (copy), DetailsDescription (copy), ItemInfoList (copy)
			local v87 = p10[view]
			local n1 = 0
			local n2 = 0

			if GetFFlagDisplayCollectiblesIcon() and UtilityFunctions.isCollectibles(v76) then
				local getCollectibleResellableInstances = p9.props.getCollectibleResellableInstances
				local resellableInstances = p9.props.resellableInstances
				local v92 = Players.LocalPlayer and Players.LocalPlayer.UserId

				getCollectibleResellableInstances(v76.collectibleItemId, v92)
				n2 = resellableInstances and (not not resellableInstances[v76.collectibleItemId] and tutils.fieldCount(resellableInstances[v76.collectibleItemId])) or 0
			end

			local v93 = UtilityFunctions.isLimited2Point0_Or_LimitedCollectible(v76)

			if p9.props.gamepadEnabled then
				n1 = -1 * ControllerBarHeight
			end

			local v94 = n1 + -Theme.DefaultCornerRadius.Offset

			return Roact.createElement("Frame", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Position = UDim2.new(0, v87.BorderPaddingSize, 0, 0),
				Size = UDim2.new(1, -(2 * v87.BorderPaddingSize), 1, v94),
				BackgroundColor3 = Colors.Carbon,
				Visible = detailsInformation.viewingDetails
			}, {
				DetailsButtons = Roact.createElement(DetailsButtons, {
					localPlayerModel = localPlayerModel
				}),
				Container = Roact.createElement("ScrollingFrame", {
					BackgroundTransparency = 1,
					ScrollBarThickness = 0,
					Selectable = false,
					Size = UDim2.new(1, 0, 1, -55),
					ScrollingEnabled = scrollingEnabled,
					CanvasSize = UDim2.new(1, 0, 0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 10)
					}),
					DetailsThumbnail = Roact.createElement(DetailsThumbnail),
					TryOnViewport = if not isInExperienceUIVREnabled then localPlayerModel and Roact.createElement(TryOnViewport, {
						localPlayerModel = localPlayerModel,
						setScrollingEnabled = function(p11) -- line: 286
							-- upvalues: p9 (copy)
							p9:setScrollingEnabled(p11)
						end
					}) else if not detailsInformation.viewingDetails or not localPlayerModel then nil else Roact.createElement(TryOnViewport, {
						localPlayerModel = localPlayerModel,
						setScrollingEnabled = function(p12) -- line: 279
							-- upvalues: p9 (copy)
							p9:setScrollingEnabled(p12)
						end
					}),
					DetailsText = Roact.createElement(DetailsText, {
						localPlayerModel = localPlayerModel
					}),
					ItemOwnedLabelContainer = v93 and Roact.createElement("Frame", {
						BorderSizePixel = 0,
						LayoutOrder = 3,
						Size = UDim2.new(1, 0, 0, v81.Y + 20),
						BackgroundColor3 = Color3.fromRGB(57, 59, 61)
					}, {
						Corner = Roact.createElement("UICorner", {
							CornerRadius = UDim.new(0, 8)
						}),
						OwnedIcon = Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Size = UDim2.new(0, v81.X, 0, v81.Y),
							Position = UDim2.new(0, 12, 0, 10),
							Image = v80
						}),
						ItemOwnedLabel = Roact.createElement("TextLabel", {
							TextSize = 12,
							BackgroundTransparency = 1,
							Size = UDim2.new(0, v81.X, 0, v81.Y),
							Position = UDim2.new(0, v81.X + 60, 0, 10),
							Text = RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.OwnedItems", locale, {
								QUANTITY = tostring(n2)
							}),
							Font = AppFonts.default:getDefault(),
							TextColor3 = Color3.new(1, 1, 1)
						})
					}),
					DetailsDescription = Roact.createElement(DetailsDescription),
					ItemInfoList = Roact.createElement(ItemInfoList, {
						LayoutOrder = 5,
						rowData = p9:getInfoRowProps()
					})
				})
			})
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(p13, _) -- line: 335
	local assetId = p13.detailsInformation.assetId

	return {
		view = p13.view,
		detailsInformation = p13.detailsInformation,
		assetInfo = p13.assets[assetId],
		bundles = p13.bundles,
		gamepadEnabled = p13.gamepadEnabled,
		locale = p13.locale,
		resellableInstances = p13.collectibleResellableInstances,
		creatingExperiences = p13.creatingExperiences
	}
end, function(p15) -- line: 348
	-- upvalues: GetAssetBundles (copy), GetEconomyProductInfo (copy), ReportOpenDetailsPage (copy), GetCollectibleResellableInstances (copy), OpenOverlay (copy), GetItemDetails (copy), SetAssetFromBundleInfo (copy)
	return {
		getAssetBundles = function(p16) -- line: 350
			-- upvalues: p15 (copy), GetAssetBundles (copy)
			p15(GetAssetBundles(p16))
		end,
		getEconomyProductInfo = function(p17, p18, p19) -- line: 353
			-- upvalues: p15 (copy), GetEconomyProductInfo (copy)
			p15(GetEconomyProductInfo(p17, p18, p19))
		end,
		reportOpenDetailsPage = function(p20) -- line: 356
			-- upvalues: p15 (copy), ReportOpenDetailsPage (copy)
			p15(ReportOpenDetailsPage(p20))
		end,
		getCollectibleResellableInstances = function(p21, p22) -- line: 359
			-- upvalues: p15 (copy), GetCollectibleResellableInstances (copy)
			p15(GetCollectibleResellableInstances(p21, p22))
		end,
		openOverlay = function(p23, p24) -- line: 362
			-- upvalues: p15 (copy), OpenOverlay (copy)
			p15(OpenOverlay(p23, p24))
		end,
		getItemDetails = function(p25, p26) -- line: 365
			-- upvalues: p15 (copy), GetItemDetails (copy)
			p15(GetItemDetails(p25, p26))
		end,
		setAssetFromBundleInfo = function(p27, p28) -- line: 368
			-- upvalues: p15 (copy), SetAssetFromBundleInfo (copy)
			p15(SetAssetFromBundleInfo(p27, p28))
		end
	}
end)(v37)
