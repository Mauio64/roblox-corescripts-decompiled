local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local parent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local DetailsText = require(parent.Components.DetailsText)
local DetailsThumbnail = require(parent.Components.DetailsThumbnail)
local DetailsDescription = require(parent.Components.DetailsDescription)
local DetailsButtons = require(parent.Components.DetailsButtons)
local TryOnViewport = require(parent.Components.TryOnViewport)
local OpenOverlay = require(parent.Actions.OpenOverlay)
local Overlay = require(parent.Enums.Overlay)
local GetAssetBundles = require(parent.Thunks.GetAssetBundles)
local ReportOpenDetailsPage = require(parent.Thunks.ReportOpenDetailsPage)
local GetEconomyProductInfo = require(parent.Thunks.GetEconomyProductInfo)
local GetCollectibleResellableInstances = require(parent.Thunks.GetCollectibleResellableInstances)
local Colors = require(parent.Colors)
local Constants = require(parent.Constants)
local UtilityFunctions = require(parent.UtilityFunctions)
local tutils = require(CorePackages.Packages.tutils)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ItemDetails = require(CorePackages.Workspace.Packages.ItemDetails)
local ItemInfoList = ItemDetails.ItemInfoList
local AttributionConstants = require(parent.AttributionConstants)

local InspectAndBuyContext = require(parent.Components.InspectAndBuyContext)
local GetFFlagDisplayCollectiblesIcon = require(parent.Flags.GetFFlagDisplayCollectiblesIcon)
local GetItemDetails = require(parent.Thunks.GetItemDetails)
local SetAssetFromBundleInfo = require(parent.Actions.SetAssetFromBundleInfo)

local Modules = CoreGui.RobloxGui.Modules
local Theme = require(Modules.Settings.Theme)

local InGameMenuConstants = require(CoreGui.RobloxGui.Modules.InGameMenuConstants)
local ControllerBarHeight = InGameMenuConstants.ControllerBarHeight

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled

local extended = Roact.PureComponent:extend("AssetDetails")

function extended:setScrollingEnabled(scrollingEnabled)
	if self.state.scrollingEnabled ~= scrollingEnabled then
		self:setState({ scrollingEnabled = scrollingEnabled })
	end
end

function extended:getInfoRowProps()
	local assetInfo = self.props.assetInfo or {}
	local locale = self.props.locale

	local v = assetInfo.parentBundleId ~= nil

	local v2 = {
		infoName = RobloxTranslator:FormatByKeyForLocale("Feature.Catalog.Label.Filter.Creator", locale),
		infoData = assetInfo.creatorName or "",
		hasVerifiedBadge = assetInfo.creatorHasVerifiedBadge,
		LayoutOrder = 1,
		Selectable = false
	}

	local attributionRefsByRef = nil

	local creatingUniverseId = assetInfo.creatingUniverseId

	if creatingUniverseId then
		local creatingExperience = self.props.creatingExperiences[creatingUniverseId]

		if creatingExperience then
			local playabilityStatus = creatingExperience.playabilityStatus

			if AttributionConstants.ShowPlayableAttributionMapper[playabilityStatus] then
				local name = creatingExperience.name or ""

				attributionRefsByRef = {
					["infoName"] = nil,
					infoName = RobloxTranslator:FormatByKeyForLocale("Feature.Catalog.Label.Attribution", locale),
					infoData = name,
					onActivate = function()
						self.props.openOverlay(Overlay.AttributionTraversal, creatingExperience)
					end,
					LayoutOrder = 2
				}

				attributionRefsByRef[Roact.Ref] = self.attributionRef
				attributionRefsByRef.Selectable = true
			end
		end
	end

	local infoData = nil

	if v then
		infoData = RobloxTranslator:FormatByKeyForLocale("Feature.Catalog.Label.Bundle", locale)
	else
		local category = Constants.AssetTypeIdToCategory[assetInfo.assetTypeId]
		local v3 = Constants.AssetCategoriesLocalized[category]
		local typeLocalized = Constants.AssetTypeIdToTypeLocalized[assetInfo.assetTypeId]

		if v3 and typeLocalized then
			infoData = RobloxTranslator:FormatByKeyForLocale(v3, locale) .. " | " .. RobloxTranslator:FormatByKeyForLocale(typeLocalized, locale)
		end
	end

	return {
		v2,
		attributionRefsByRef,
		{
			infoName = RobloxTranslator:FormatByKeyForLocale("Feature.Catalog.Label.CategoryType", locale),
			infoData = infoData,
			LayoutOrder = 3,
			Selectable = false
		}
	}
end

function extended:init()
	self.state = { scrollingEnabled = true }

	self.attributionRef = Roact.createRef()
end

function extended.willUpdate(object, p)
	if UtilityFunctions.isCollectibles(object.props.assetInfo) then
		local collectibleItemId = object.props.assetInfo.collectibleItemId
		local resellableInstances = object.props.resellableInstances
		local resellableInstances2 = p.resellableInstances

		if
			resellableInstances
			and resellableInstances[collectibleItemId]
			and resellableInstances2
			and resellableInstances2[collectibleItemId]
			and tutils.fieldCount(resellableInstances[collectibleItemId]) ~= tutils.fieldCount(resellableInstances2[collectibleItemId])
		then
			object:setState({})
		end
	end

	local parentBundleId = object.props.assetInfo and object.props.assetInfo.parentBundleId
	local bundles = object.props.bundles
	local bundles2 = p.bundles

	if
		parentBundleId
		and bundles
		and bundles[parentBundleId]
		and bundles2
		and bundles2[parentBundleId]
		and bundles2[parentBundleId] ~= bundles[parentBundleId]
	then
		object.props.setAssetFromBundleInfo(object.props.assetInfo.assetId, bundles2[parentBundleId])
	end
end

function extended.didUpdate(p, p2)
	local reportOpenDetailsPage = p.props.reportOpenDetailsPage
	local assetInfo = p.props.assetInfo
	local assetInfo2 = p2.assetInfo

	if assetInfo and assetInfo ~= assetInfo2 then
		local bundles = p.props.bundles
		local v = assetInfo.parentBundleId ~= nil
		local v2 = v and UtilityFunctions.getBundleId(assetInfo)

		if not v and assetInfo.owned == nil or v and bundles[v2].owned == nil then
			local v3 = assetInfo.assetId
			local v4 = Enum.AvatarItemType.Asset

			if v then
				v4 = Enum.AvatarItemType.Bundle
				v3 = v2
			end

			p.props.getItemDetails(v3, v4)
		end
	end

	if p.props.detailsInformation.viewingDetails and not p2.detailsInformation.viewingDetails then
		reportOpenDetailsPage(assetInfo)
	end
end

function extended:render()
	local view = self.props.view
	local detailsInformation = self.props.detailsInformation
	local assetInfo = self.props.assetInfo or {}
	local localPlayerModel = self.props.localPlayerModel
	local scrollingEnabled = self.state.scrollingEnabled
	local locale = self.props.locale
	local iconsstatusitemowned = Images["icons/status/item/owned"]
	local v = iconsstatusitemowned and iconsstatusitemowned.ImageRectSize / Images.ImagesResolutionScale
		or Vector2.new(0, 0)

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p)
			local v2 = p[view]
			local v3 = 0
			local v4

			if GetFFlagDisplayCollectiblesIcon() and UtilityFunctions.isCollectibles(assetInfo) then
				local getCollectibleResellableInstances = self.props.getCollectibleResellableInstances
				local resellableInstances = self.props.resellableInstances
				local userId = Players.LocalPlayer and Players.LocalPlayer.UserId

				getCollectibleResellableInstances(assetInfo.collectibleItemId, userId)

				v4 = resellableInstances
					and resellableInstances[assetInfo.collectibleItemId]
					and tutils.fieldCount(resellableInstances[assetInfo.collectibleItemId])
					or 0
			else
				v4 = 0
			end

			local limited2Point0_Or_LimitedCollectible = UtilityFunctions.isLimited2Point0_Or_LimitedCollectible(assetInfo)

			if self.props.gamepadEnabled then
				v3 = -1 * ControllerBarHeight
			end

			local v5 = v3 + -Theme.DefaultCornerRadius.Offset

			local createElement = Roact.createElement
			local v6 = {
				Position = UDim2.new(0, v2.BorderPaddingSize, 0, 0),
				Size = UDim2.new(1, -(2 * v2.BorderPaddingSize), 1, v5),
				BackgroundTransparency = 0,
				BackgroundColor3 = Colors.Carbon,
				BorderSizePixel = 0,
				Visible = detailsInformation.viewingDetails
			}
			local v7 = {
				DetailsButtons = Roact.createElement(DetailsButtons, {
					localPlayerModel = localPlayerModel
				}),
				Container = 0
			}

			local createElement2 = Roact.createElement
			local v8 = {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				Size = UDim2.new(1, 0, 1, -55),
				ScrollingEnabled = scrollingEnabled,
				Selectable = false,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y
			}
			local children = {
				UIListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 10)
				}),
				DetailsThumbnail = Roact.createElement(DetailsThumbnail),
				TryOnViewport = 0,
				DetailsText = 0,
				ItemOwnedLabelContainer = 0,
				DetailsDescription = 0,
				ItemInfoList = 0
			}
			local tryOnViewport

			if isInExperienceUIVREnabled then
				if detailsInformation.viewingDetails and localPlayerModel then
					tryOnViewport = Roact.createElement(TryOnViewport, {
						localPlayerModel = localPlayerModel,
						setScrollingEnabled = function(p2)
							self:setScrollingEnabled(p2)
						end
					})
				end
			else
				tryOnViewport = localPlayerModel and Roact.createElement(TryOnViewport, {
					localPlayerModel = localPlayerModel,
					setScrollingEnabled = function(p2)
						self:setScrollingEnabled(p2)
					end
				})
			end

			children.TryOnViewport = tryOnViewport

			children.DetailsText = Roact.createElement(DetailsText, {
				localPlayerModel = localPlayerModel
			})

			children.ItemOwnedLabelContainer = limited2Point0_Or_LimitedCollectible and Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, v.Y + 20),
				BorderSizePixel = 0,
				LayoutOrder = 3,
				BackgroundColor3 = Color3.fromRGB(57, 59, 61)
			}, {
				Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
				OwnedIcon = Roact.createElement(ImageSetLabel, {
					Size = UDim2.new(0, v.X, 0, v.Y),
					Position = UDim2.new(0, 12, 0, 10),
					Image = iconsstatusitemowned,
					BackgroundTransparency = 1,
					BorderSizePixel = 0
				}),
				ItemOwnedLabel = Roact.createElement("TextLabel", {
					Size = UDim2.new(0, v.X, 0, v.Y),
					Position = UDim2.new(0, v.X + 60, 0, 10),
					Text = RobloxTranslator:FormatByKeyForLocale("InGame.InspectMenu.Label.OwnedItems", locale, {
						QUANTITY = tostring(v4)
					}),
					Font = AppFonts.default:getDefault(),
					TextSize = 12,
					TextColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 1
				})
			})

			children.DetailsDescription = Roact.createElement(DetailsDescription)
			children.ItemInfoList = Roact.createElement(ItemInfoList, {
				rowData = self:getInfoRowProps(),
				LayoutOrder = 5
			})
			v7.Container = createElement2("ScrollingFrame", v8, children)
			return createElement("Frame", v6, v7)
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	local assetId = data.detailsInformation.assetId

	return {
		view = data.view,
		detailsInformation = data.detailsInformation,
		assetInfo = data.assets[assetId],
		bundles = data.bundles,
		gamepadEnabled = data.gamepadEnabled,
		locale = data.locale,
		resellableInstances = data.collectibleResellableInstances,
		creatingExperiences = data.creatingExperiences
	}
end, function(callback)
	return {
		getAssetBundles = function(p)
			callback(GetAssetBundles(p))
		end,
		getEconomyProductInfo = function(p, p2, p3)
			callback(GetEconomyProductInfo(p, p2, p3))
		end,
		reportOpenDetailsPage = function(p)
			callback(ReportOpenDetailsPage(p))
		end,
		getCollectibleResellableInstances = function(p, p2)
			callback(GetCollectibleResellableInstances(p, p2))
		end,
		openOverlay = function(p, p2)
			callback(OpenOverlay(p, p2))
		end,
		getItemDetails = function(p, p2)
			callback(GetItemDetails(p, p2))
		end,
		setAssetFromBundleInfo = function(p, p2)
			callback(SetAssetFromBundleInfo(p, p2))
		end
	}
end)(extended)
