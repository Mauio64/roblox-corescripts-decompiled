local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation

local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local roactFitComponents = AvatarExperienceDeps.RoactFitComponents
local fitFrameVertical = roactFitComponents.FitFrameVertical

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/bundled/dME")
local module2 = require("@luauforge/deferred/gnD")

local fitTextLabel = roactFitComponents.FitTextLabel

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local extended = Roact.PureComponent:extend("CurrentlySellingList")

function extended:init()
	function self.removeSoldItem(p2)
		local itemId = self.props.itemId
		local onOverlayClosed = self.props.onOverlayClosed
		self.props.navigation.navigate(avatarScreen.RemoveCurrentlySellingItemPrompt, {
			itemId = itemId,
			userAssetId = p2,
			onOverlayClosed = onOverlayClosed
		})

		self:setState({ restorePreviousChildFocus = false })
	end

	self:setState({ restorePreviousChildFocus = true })

	function self.onFocusGained()
		if not self.state.restorePreviousChildFocus then
			self:setState({ restorePreviousChildFocus = true })
		end
	end

	self.focusableRefs = RoactGamepad.createRefCache()
end

function extended:createRemovableList(p2)
	local assetInfo = self.props.assetInfo
	local currentlySellingList = self.props.currentlySellingList

	local itemRestrictions = assetInfo and assetInfo.itemRestrictions
	local v5 = itemRestrictions and itemRestrictions[module.ItemRestrictions.LimitedUnique]

	local function getItemIndexRef(p3)
		return p3 >= 1 and p3 <= #currentlySellingList and self.focusableRefs[p3] or nil
	end

	local children = {}

	if not currentlySellingList then
		return children
	end

	for k, currentlySelling in currentlySellingList do
		local v6 = "CurrentlySellingRow" .. k
		local createElement = Roact.createElement
		local v8 = {
			width = UDim.new(1, 0),
			contentPadding = UDim.new(0, 8),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			BackgroundTransparency = 1,
			LayoutOrder = k
		}

		local createElement2 = Roact.createElement
		local v10 = {
			["isLimitedUnique"] = nil,
			["isLimitedUnique"] = nil,
			["isLimitedUnique"] = nil,
			["isLimitedUnique"] = nil,
			isLimitedUnique = v5,
			horizontalPadding = 24,
			LayoutOrder = 1,
			onActivated = function()
				self.removeSoldItem(currentlySelling)
			end,
			userAssetId = currentlySelling
		}

		local v11 = k - 1
		local v12 = v11 >= 1 and v11 <= #currentlySellingList
		local v13 = if v12 then self.focusableRefs[v11] or nil else nil

		v10.NextSelectionUp = v13
		local v14 = k + 1
		local v15 = v14 >= 1 and v14 <= #currentlySellingList
		local v16 = if v15 then self.focusableRefs[v14] or nil else nil

		v10.NextSelectionDown = v16
		local ref = Roact.Ref
		local v17 = k >= 1 and k <= #currentlySellingList
		local v18 = if v17 then self.focusableRefs[k] or nil else nil

		v10[ref] = v18

		v10.onFocusGained = self.onFocusGained
		children[v6] = createElement(fitFrameVertical, v8, {
			CurrentlySellingRow = createElement2(module2, v10),
			Divider = Roact.createElement("Frame", {
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

function extended:renderLocalized(p2)
	local layoutOrder = self.props.LayoutOrder
	local currentlySellingList = self.props.currentlySellingList

	return withStyle(function(p3)
		local font = p3.Font
		local theme = p3.Theme
		local v5 = font.BaseSize * font.CaptionSubHeader.RelativeSize
		local removableList = self:createRemovableList(theme)

		local forwardRef = self.props.forwardRef

		return Roact.createElement(focusable[fitFrameVertical], {
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
			defaultChild = currentlySellingList and #currentlySellingList > 0 and self.focusableRefs[1] or nil,
			restorePreviousChildFocus = self.state.restorePreviousChildFocus
		}, {
			CurrentlySellingLabelContainer = Roact.createElement(
				fitFrameVertical,
				{
					width = UDim.new(1, 0),
					margin = roactFitComponents.Rect.quad(0, 0, 0, 24),
					BackgroundTransparency = 1,
					LayoutOrder = 1
				},
				{
					CurrentlySellingLabel = Roact.createElement(fitTextLabel, {
						width = UDim.new(1, 0),
						Font = font.CaptionSubHeader.Font,
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Text = p2.headerText,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextSize = v5,
						TextColor3 = theme.TextEmphasis.Color
					})
				}
			),
			CurrentlySellingRowContainer = Roact.createElement(fitFrameVertical, {
				width = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2
			}, removableList)
		})
	end)
end

function extended:render()
	local currentlySellingList = self.props.currentlySellingList

	if currentlySellingList and #currentlySellingList ~= 0 then
		return withLocalization({ headerText = "Feature.Catalog.Label.OnSale" })(function(p2)
			return self:renderLocalized(p2)
		end)
	end
end

local v5 = withNavigation((RoactRodux.connect(function(p2, p3)
	return {
		assetInfo = p2.AvatarExperience.Common.AssetInfos[p3.itemId],
		currentlySellingList = p2.AvatarExperience.Catalog.Sell.CurrentlySellingAssets[p3.itemId]
	}
end, nil)(extended)))

return Roact.forwardRef(function(p2, p3)
	return Roact.createElement(v5, Cryo.Dictionary.join(p2, { forwardRef = p3 }))
end)
