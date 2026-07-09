local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local RoactFitComponents = AvatarExperienceDeps.RoactFitComponents
local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitTextLabel = RoactFitComponents.FitTextLabel
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local AvailableToSellRow = require(Modules.AvatarExperience.Common.Components.ItemDetails.SellPage.AvailableToSellRow)
local AvailableToSellLimitedUniqueRow = require(Modules.AvatarExperience.Common.Components.ItemDetails.SellPage.AvailableToSellLimitedUniqueRow)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local v19 = Roact.PureComponent:extend("AvailableToSellList")

function v19.init(p1) -- line: 38
	-- upvalues: AvatarScreen (copy), RoactGamepad (copy)
	function p1.sellLimitedUniqueItem(p2) -- line: 39
		-- upvalues: p1 (copy), AvatarScreen (copy)
		local itemId = p1.props.itemId
		local itemType = p1.props.itemType
		local onOverlayClosed = p1.props.onOverlayClosed

		p1.props.navigation.navigate(AvatarScreen.SellItemPrompt, {
			itemId = itemId,
			itemType = itemType,
			userAssetId = p2,
			onOverlayClosed = onOverlayClosed
		})
	end
	function p1.sellLimitedItem() -- line: 52
		-- upvalues: p1 (copy), AvatarScreen (copy)
		local v61 = p1.props.availableItemsToSell[1]
		local itemId = p1.props.itemId
		local itemType = p1.props.itemType
		local onOverlayClosed = p1.props.onOverlayClosed

		p1.props.navigation.navigate(AvatarScreen.SellItemPrompt, {
			itemId = itemId,
			itemType = itemType,
			userAssetId = v61,
			onOverlayClosed = onOverlayClosed
		})
	end

	p1.focusableRefs = RoactGamepad.createRefCache()
end
function v19.createAvailableToSellLimitedUniqueList(p3, p4) -- line: 70
	-- upvalues: Roact (copy), FitFrameVertical (copy), AvailableToSellLimitedUniqueRow (copy)
	local availableItemsToSell = p3.props.availableItemsToSell

	local function getItemIndexRef(p5) -- line: 73
		-- upvalues: availableItemsToSell (copy), p3 (copy)
		return p5 >= 1 and p5 <= #availableItemsToSell and p3.focusableRefs[p5] or nil
	end

	local t1 = {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}
	local n1 = 0

	if availableItemsToSell then
		for v28, v29 in availableItemsToSell do
			local v30 = v28 < #availableItemsToSell

			n1 += 1

			local v31 = "AvailableToSellLimitedUniqueRow" .. v28
			local createElement = Roact.createElement
			local v33 = FitFrameVertical
			local t2 = {
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 8),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				LayoutOrder = v28
			}
			local t3 = {}
			local createElement2 = Roact.createElement
			local v37 = AvailableToSellLimitedUniqueRow
			local t4 = {
				horizontalPadding = 24,
				LayoutOrder = 1,
				onActivated = function() -- line: 104
					-- upvalues: p3 (copy), v29 (copy)
					p3.sellLimitedUniqueItem(v29)
				end,
				userAssetId = v29
			}
			local v39 = v28 - 1

			t4.NextSelectionUp = v39 >= 1 and v39 <= #availableItemsToSell and p3.focusableRefs[v39] or nil

			local v40 = v28 + 1

			t4.NextSelectionDown = v40 >= 1 and v40 <= #availableItemsToSell and p3.focusableRefs[v40] or nil
			t4[Roact.Ref] = v28 >= 1 and v28 <= #availableItemsToSell and p3.focusableRefs[v28] or nil
			t3.AvailableToSellLimitedUniqueRow = createElement2(v37, t4)
			t3.Divider = v30 and Roact.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 2,
				BackgroundColor3 = p4.Divider.Color,
				BackgroundTransparency = p4.Divider.Transparency,
				Size = UDim2.new(1, -24, 0, 1)
			})
			t1[v31] = createElement(v33, t2, t3)
		end
	end

	return t1
end
function v19.renderLocalized(p6, p7) -- line: 126
	-- upvalues: CatalogConstants (copy), withStyle (copy), Roact (copy), Focusable (copy), FitFrameVertical (copy), RoactFitComponents (copy), FitTextLabel (copy), AvailableToSellRow (copy)
	local availableItemsToSell = p6.props.availableItemsToSell
	local propsLayoutOrder = p6.props.LayoutOrder
	local itemRestrictions = p6.props.itemRestrictions
	local v46 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.LimitedUnique]
	local v47 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Limited]
	local v48 = availableItemsToSell and #availableItemsToSell or 0
	local v49 = ((if v48 ~= 1 then p7.itemCountPluralLabel else p7.itemCountSingularLabel)):gsub("({itemCount})", v48)

	return withStyle(function(p8) -- line: 143
		-- upvalues: v46 (copy), p6 (copy), Roact (copy), Focusable (copy), FitFrameVertical (copy), propsLayoutOrder (copy), availableItemsToSell (copy), RoactFitComponents (copy), FitTextLabel (copy), p7 (copy), v47 (copy), AvailableToSellRow (copy), v49 (copy)
		local p8Font = p8.Font
		local Theme = p8.Theme
		local v69 = p8Font.BaseSize * p8Font.CaptionSubHeader.RelativeSize
		local v70 = v46 and p6:createAvailableToSellLimitedUniqueList(Theme)
		local forwardRef = p6.props.forwardRef

		return Roact.createElement(Focusable[FitFrameVertical], {
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, 6),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			BackgroundTransparency = 1,
			LayoutOrder = propsLayoutOrder,
			NextSelectionLeft = p6.props.NextSelectionLeft,
			NextSelectionRight = p6.props.NextSelectionRight,
			NextSelectionUp = p6.props.NextSelectionUp,
			NextSelectionDown = p6.props.NextSelectionDown,
			[Roact.Ref] = forwardRef,
			defaultChild = availableItemsToSell and (#availableItemsToSell > 0 and p6.focusableRefs[1]) or nil
		}, {
			AvailableForSaleLabelContainer = Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				width = UDim.new(1, 0),
				margin = RoactFitComponents.Rect.quad(0, 0, 0, 24)
			}, {
				AvailableForSaleLabel = Roact.createElement(FitTextLabel, {
					BackgroundTransparency = 1,
					width = FitTextLabel.Width.FitToText,
					Font = p8Font.CaptionSubHeader.Font,
					Text = p7.headerText,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextSize = v69,
					TextColor3 = Theme.TextEmphasis.Color
				})
			}),
			LimitedCountRow = v47 and Roact.createElement(AvailableToSellRow, {
				horizontalPadding = 24,
				LayoutOrder = 2,
				onActivated = p6.sellLimitedItem,
				Text = v49,
				[Roact.Ref] = p6.focusableRefs[1]
			}),
			LimitedUniqueRowConatiner = v46 and Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				width = UDim.new(1, 0)
			}, v70)
		})
	end)
end
function v19.render(p9) -- line: 204
	-- upvalues: withLocalization (copy)
	local availableItemsToSell = p9.props.availableItemsToSell

	if not availableItemsToSell or #availableItemsToSell == 0 then
		return
	end

	return withLocalization({
		headerText = "Feature.Catalog.Label.AvailableForSale",
		itemCountPluralLabel = "Feature.Catalog.Label.ItemsCount",
		itemCountSingularLabel = "Feature.Catalog.Label.ItemCount"
	})(function(p10) -- line: 213
		-- upvalues: p9 (copy)
		return p9:renderLocalized(p10)
	end)
end

local u20 = withNavigation((RoactRodux.connect(function(p11, p12) -- line: 219
	local v54 = p11.AvatarExperience.Common.AssetInfos[p12.itemId]

	return {
		itemRestrictions = v54 and v54.itemRestrictions,
		availableItemsToSell = p11.AvatarExperience.Catalog.Sell.AvailableToSellAssets[p12.itemId]
	}
end, nil)(v19)))

return Roact.forwardRef(function(p13, p14) -- line: 229
	-- upvalues: Roact (copy), u20 (ref), Cryo (copy)
	return Roact.createElement(u20, Cryo.Dictionary.join(p13, {
		forwardRef = p14
	}))
end)
