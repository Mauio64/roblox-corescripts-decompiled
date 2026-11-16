local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameVertical = roactFitComponents.FitFrameVertical
local fitTextLabel = roactFitComponents.FitTextLabel

local module = require("@luauforge/bundled/dME")
local module2 = require("@luauforge/deferred/gnA")

local module3 = require("@luauforge/deferred/gnB")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local extended = Roact.PureComponent:extend("AvailableToSellList")

function extended:init()
	function self.sellLimitedUniqueItem(p3)
		local itemId = self.props.itemId
		local itemType = self.props.itemType
		local onOverlayClosed = self.props.onOverlayClosed
		self.props.navigation.navigate(avatarScreen.SellItemPrompt, {
			itemId = itemId,
			itemType = itemType,
			userAssetId = p3,
			onOverlayClosed = onOverlayClosed
		})
	end

	function self.sellLimitedItem()
		local v5 = self.props.availableItemsToSell[1]
		local itemId = self.props.itemId
		local itemType = self.props.itemType
		local onOverlayClosed = self.props.onOverlayClosed
		self.props.navigation.navigate(avatarScreen.SellItemPrompt, {
			itemId = itemId,
			itemType = itemType,
			userAssetId = v5,
			onOverlayClosed = onOverlayClosed
		})
	end

	self.focusableRefs = RoactGamepad.createRefCache()
end

function extended:createAvailableToSellLimitedUniqueList(p2)
	local availableItemsToSell = self.props.availableItemsToSell

	local function getItemIndexRef(p3)
		return p3 >= 1 and p3 <= #availableItemsToSell and self.focusableRefs[p3] or nil
	end

	local children = {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	local count = 0

	if not availableItemsToSell then
		return children
	end

	for k, v5 in availableItemsToSell do
		local v6 = k < #availableItemsToSell
		count += 1

		local v7 = "AvailableToSellLimitedUniqueRow" .. k
		local createElement = Roact.createElement
		local v9 = {
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, 8),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			BackgroundTransparency = 1,
			LayoutOrder = k
		}

		local createElement2 = Roact.createElement
		local v11 = {}
		v11.horizontalPadding = 24
		v11.LayoutOrder = 1

		function v11.onActivated()
			self.sellLimitedUniqueItem(v5)
		end

		v11.userAssetId = v5
		local v12 = k - 1
		local v13 = v12 >= 1 and v12 <= #availableItemsToSell
		local v14 = if v13 then self.focusableRefs[v12] or nil else nil

		v11.NextSelectionUp = v14
		local v15 = k + 1
		local v16 = v15 >= 1 and v15 <= #availableItemsToSell
		local v17 = if v16 then self.focusableRefs[v15] or nil else nil

		v11.NextSelectionDown = v17
		local ref = Roact.Ref
		local v18 = k >= 1 and k <= #availableItemsToSell
		local v19 = if v18 then self.focusableRefs[k] or nil else nil

		v11[ref] = v19
		children[v7] = createElement(fitFrameVertical, v9, {
			AvailableToSellLimitedUniqueRow = createElement2(module3, v11),
			Divider = v6 and Roact.createElement("Frame", {
				BackgroundColor3 = p2.Divider.Color,
				BackgroundTransparency = p2.Divider.Transparency,
				BorderSizePixel = 0,
				LayoutOrder = 2,
				Size = UDim2.new(1, -24, 0, 1)
			})
		})
	end

	return children
end

function extended:renderLocalized(data)
	local availableItemsToSell = self.props.availableItemsToSell
	local layoutOrder = self.props.LayoutOrder
	local itemRestrictions = self.props.itemRestrictions

	local v5 = itemRestrictions and itemRestrictions[module.ItemRestrictions.LimitedUnique]
	local v6 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Limited]
	local v7 = availableItemsToSell and #availableItemsToSell or 0

	local v8 = if v7 == 1 then data.itemCountSingularLabel else data.itemCountPluralLabel

	local v9 = v8:gsub("({itemCount})", v7)

	return withStyle(function(p2)
		local font = p2.Font
		local theme = p2.Theme
		local v10 = font.BaseSize * font.CaptionSubHeader.RelativeSize
		local v11 = v5 and self:createAvailableToSellLimitedUniqueList(theme)

		local forwardRef = self.props.forwardRef

		local createElement = Roact.createElement
		local v12 = focusable[fitFrameVertical]
		local forwardRefsByRef = {
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, 6),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder,
			NextSelectionLeft = self.props.NextSelectionLeft,
			NextSelectionRight = self.props.NextSelectionRight,
			NextSelectionUp = self.props.NextSelectionUp,
			NextSelectionDown = self.props.NextSelectionDown,
			[Roact.Ref] = forwardRef,
			defaultChild = availableItemsToSell and #availableItemsToSell > 0 and self.focusableRefs[1] or nil
		}
		local v13 = {
			AvailableForSaleLabelContainer = Roact.createElement(
				fitFrameVertical,
				{
					width = UDim.new(1, 0),
					margin = roactFitComponents.Rect.quad(0, 0, 0, 24),
					BackgroundTransparency = 1,
					LayoutOrder = 1
				},
				{
					AvailableForSaleLabel = Roact.createElement(fitTextLabel, {
						width = fitTextLabel.Width.FitToText,
						Font = font.CaptionSubHeader.Font,
						BackgroundTransparency = 1,
						Text = data.headerText,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextSize = v10,
						TextColor3 = theme.TextEmphasis.Color
					})
				}
			),
			LimitedCountRow = 0,
			LimitedUniqueRowConatiner = 0
		}

		local v14 = v6

		if v14 then
			v14 = Roact.createElement(module2, {
				horizontalPadding = 24,
				LayoutOrder = 2,
				onActivated = self.sellLimitedItem,
				Text = v9,
				[Roact.Ref] = self.focusableRefs[1]
			})
		end

		v13.LimitedCountRow = v14

		v13.LimitedUniqueRowConatiner = v5
			and Roact.createElement(
				fitFrameVertical,
				{ width = UDim.new(1, 0), BackgroundTransparency = 1, LayoutOrder = 2 },
				v11
			)
		return createElement(v12, forwardRefsByRef, v13)
	end)
end

function extended:render()
	local availableItemsToSell = self.props.availableItemsToSell

	if availableItemsToSell and #availableItemsToSell ~= 0 then
		return withLocalization({
			headerText = "Feature.Catalog.Label.AvailableForSale",
			itemCountPluralLabel = "Feature.Catalog.Label.ItemsCount",
			itemCountSingularLabel = "Feature.Catalog.Label.ItemCount"
		})(function(p2)
			return self:renderLocalized(p2)
		end)
	end
end

local v5 = withNavigation((RoactRodux.connect(function(p2, p3)
	local assetInfo = p2.AvatarExperience.Common.AssetInfos[p3.itemId]
	return {
		itemRestrictions = assetInfo and assetInfo.itemRestrictions,
		availableItemsToSell = p2.AvatarExperience.Catalog.Sell.AvailableToSellAssets[p3.itemId]
	}
end, nil)(extended)))

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v5, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
