local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withNavigation = RoactNavigation.withNavigation
local t = require(CorePackages.Packages.t)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization
local Cryo = require(CorePackages.Packages.Cryo)

local withStyle = UIBlox.Core.Style.withStyle
local itemTile = UIBlox.Tile.ItemTile
local itemTileEnums = UIBlox.Tile.ItemTileEnums
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local colors = UIBlox.App.Style.Colors

local Foundation = require(CorePackages.Packages.Foundation)

local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local getIconRichText = Foundation.Utility.getIconRichText
local normalizeFontFace = Foundation.Utility.normalizeFontFace

require("@luauforge/bundled/dKT")

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egx")
local module2 = require("@luauforge/bundled/egY")
local module3 = require("@luauforge/bundled/ecq")
local module4 = require("@luauforge/bundled/dPN")
local module5 = require("@luauforge/bundled/dVl")
local module6 = require("@luauforge/deferred/gSv")
local module7 = require("@luauforge/bundled/dKU")
local setTryOnManagerPeekViewState = module7.Actions.SetTryOnManagerPeekViewState
local setSelectedTimedOption = module7.Actions.SetSelectedTimedOption
local peekViewState = require("@luauforge/bundled/dCI").PeekViewState
local module8 = require("@luauforge/bundled/fDf")
local getRbxthumbWithTypeSizeAndOptions = require("@luauforge/bundled/ciE").Utils.getRbxthumbWithTypeSizeAndOptions
require("@luauforge/bundled/dPs")
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module10 = require("@luauforge/bundled/fCe")

local wearTimeSelectedOptionInList = require("@luauforge/deferred/fDc").WearTimeSelectedOptionInList

local flexLayout = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.FlexLayout

local iconscommonrobux = images["icons/common/robux"]
local iconsstatuserror_large = images["icons/status/error_large"]

local extended = Roact.PureComponent:extend("LookDetailsTryOnElement")

extended.validateProps = t.strictInterface({
	tryOnItem = t.optional(t.table),
	itemInfo = t.table,
	layoutOrder = t.optional(t.number),
	allowAutomaticPeekViewStateChanges = t.optional(t.boolean),
	elementRef = t.optional(t.table),
	horizontalPadding = t.optional(t.number),
	disableInteractions = t.optional(t.boolean),
	forceShowPrice = t.optional(t.boolean),
	tokens = t.any,
	NextSelectionDown = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	playerMembership = t.optional(t.enum(Enum.MembershipType)),
	setEquippedInTryOnManager = t.callback,
	setTryOnManagerPeekViewState = t.optional(t.callback),
	setSelectedTimedOption = t.callback,
	networking = t.callback,
	appAnalytics = t.table,
	catalogAnalytics = t.table,
	localization = t.table,
	navigation = t.table
})

function extended:init()
	function self.onTileActivated()
		local tryOnItem = self.props.tryOnItem

		if not tryOnItem then
			return
		end

		local itemInfo = self.props.itemInfo

		if not module10.isItemSelectable(itemInfo) or self.props.disableInteractions then
			return
		end

		local itemId = tryOnItem.itemId
		local v5 = not tryOnItem.selectedInTryOnManager
		self.props.setEquippedInTryOnManager(itemId, v5, self.props.catalogAnalytics, tryOnItem.itemType)

		if self.props.allowAutomaticPeekViewStateChanges then
			self.props.setTryOnManagerPeekViewState(peekViewState.Brief)
		end
	end
end

function extended:getItemIconType()
	local tryOnItem = self.props.tryOnItem

	if tryOnItem.itemType ~= module4.ItemType.Bundle then
		return tryOnItem.itemType == module4.ItemType.Bundle and itemTileEnums.ItemIconType.Bundle or nil
	end

	if tryOnItem.itemSubType == module4.BundleTypeIdStrings.DynamicHead then
		return itemTileEnums.ItemIconType.DynamicHead
	end

	return nil
end

function extended.getItemInfo(p2, data, data2)
	local v5 = data.priceInRobux or nil

	if p2.props.tryOnItem.selectedTimedOptionIndex and data.timedOptions then
		local timedOption = data.timedOptions[p2.props.tryOnItem.selectedTimedOptionIndex]

		if timedOption then
			v5 = timedOption.price
		end
	end

	local v6 = data.quantityOwned > 0
	local noPriceStatus = data.noPriceStatus

	local v7 = false
	local v8 = ""
	local v9 = true
	local v10 = nil
	local v11 = nil

	if v6 and not p2.props.forceShowPrice then
		v8 = data2.ownedText
	elseif v5 == 0 then
		v8 = data2.freeText
	elseif v5 == nil then
		v10 = data2.offSaleText
		v9 = false
	else
		v8 = numberLocalization.localize(string.format("%.0f", v5), p2.props.localization:GetLocale())
		v7 = true
	end

	if noPriceStatus then
		if noPriceStatus == "OffSale" then
			v10 = data2.offSaleText
			v9 = false
		elseif noPriceStatus == "NoResellers" then
			v10 = data2.noResellersText
			v9 = false
		elseif noPriceStatus == "InExperience" then
			v10 = data2.inExperienceText
		elseif noPriceStatus == "Unavailable" then
			v10 = data2.contentDeletedText
			v9 = false
		end
	end

	local v12 = v6 and noPriceStatus ~= "Unavailable" and true or v9

	if not data.discountInformation or v6 then
		return v8, v7, v10, v12, v11
	end

	local originalPrice = data.discountInformation.originalPrice

	if p2.props.tryOnItem.selectedTimedOptionIndex and data.timedOptions then
		local timedOption = data.timedOptions[p2.props.tryOnItem.selectedTimedOptionIndex]

		if timedOption and timedOption.discountInformation then
			originalPrice = timedOption.discountInformation.originalPrice
		elseif timedOption and not timedOption.discountInformation and timedOption.days ~= 0 then
			originalPrice = nil
		end
	end

	if originalPrice then
		v11 = numberLocalization.localize(
			string.format("%.0f", originalPrice),
			p2.props.localization:GetLocale()
		)
	end

	return v8, v7, v10, v12, v11
end

function extended:renderElement(props, p2, p3)
	local tryOnItem = self.props.tryOnItem
	local theme = props.Theme
	local font = props.Font
	local fontSize_350 = self.props.tokens.FontSize.FontSize_350

	local fontSize_300 = self.props.tokens.FontSize.FontSize_300

	local v5 = tryOnItem.itemType == module4.ItemType.Bundle

	local itemInfo = self.props.itemInfo

	local itemInfo2, v6, v7, v8, v9 = self:getItemInfo(itemInfo, p2)

	local name = itemInfo.name
	local creator = itemInfo.creator
	local itemRestrictionsMap = itemInfo.itemRestrictionsMap

	local v10 = if v9 then `{getIconRichText(Foundation.Enums.IconName.Robux)} {v9}` else nil

	local count = 0

	if v5 then
		for k, v11 in tryOnItem.bundleInfo do
			count += 1
		end
	end

	local v11 = if tryOnItem.itemType then module5.GetRbxThumbType(tryOnItem.itemType) or nil else nil
	local v12

	if tryOnItem.itemId and v11 then
		v12 = getRbxthumbWithTypeSizeAndOptions(tryOnItem.itemId, v11, 150)
	end

	local itemSelectable = module10.isItemSelectable(itemInfo)

	local formatted = self.props.localization:Format("Feature.Catalog.Label.UsingBundleParts", {
		count = count
	})

	local size_1800 = self.props.tokens.Size.Size_1800
	local xLarge = self.props.tokens.Padding.XLarge
	local size_500 = self.props.tokens.Size.Size_500
	local size_800 = self.props.tokens.Size.Size_800

	local v13 = 0 - size_1800 - xLarge - xLarge + p3

	local createElement = Roact.createElement
	local v15 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1
	}

	local children = {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, xLarge)
		}),
		TryOnManagerTileFrame = 0,
		TryOnInfoFrame = 0
	}

	local createElement2 = Roact.createElement
	local v17 = {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(size_1800, size_1800),
		LayoutOrder = 1
	}

	local createElement3 = Roact.createElement
	local v20 = {
		itemIconType = self:getItemIconType(),
		restrictionTypes = itemRestrictionsMap,
		Selectable = itemSelectable,
		isSelected = 0,
		onActivated = 0,
		thumbnail = 0,
		titleTextLineCount = 0
	}

	local v21 = if itemSelectable then tryOnItem.selectedInTryOnManager else nil
	v20.isSelected = v21
	v20.onActivated = self.onTileActivated
	v20.thumbnail = v12
	local v18 = {
		TryOnManagerTile = createElement3(itemTile, v20),
		TryOnManagerTileAlertFrame = 0
	}

	local v22 = if not itemSelectable then Roact.createElement(
		"Frame",
		{
			BackgroundColor3 = theme.Overlay.Color,
			BackgroundTransparency = theme.Overlay.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0)
		},
		{
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 10)
			}),
			TryOnManagerTileAlert = Roact.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = iconsstatuserror_large,
				ImageColor3 = colors.White,
				ImageTransparency = theme.IconEmphasis.Transparency,
				Size = UDim2.fromOffset(size_800, size_800),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			})
		}
	) else nil
	v18.TryOnManagerTileAlertFrame = v22
	children.TryOnManagerTileFrame = createElement2("Frame", v17, v18)

	local createElement4 = Roact.createElement
	local v24 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, v13, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2
	}

	local v25 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, props.Tokens.Size.Size_100)
		}),
		TopTextRow = 0
	}

	local createElement5 = Roact.createElement
	local createElement6 = Roact.createElement
	local v28 = { BorderSizePixel = 0, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 0) }
	local v29 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, props.Tokens.Size.Size_250)
		}),
		ItemName = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			TextSize = fontSize_350,
			FontFace = normalizeFontFace(props.Tokens.Typography.HeadingSmall.Font),
			TextColor3 = self.props.tokens.Color.Content.Emphasis.Color3,
			TextTransparency = self.props.tokens.Color.Content.Emphasis.Transparency,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			Text = name
		}),
		VerifiedCreatorName = 0,
		UnverifiedCreatorName = 0,
		HorizontalContainer = 0,
		PriceStatusText = 0
	}

	local v30 = if creator and creator.hasVerifiedBadge == true and creator.name then Roact.createElement(VerifiedBadges.EmojiWrapper, {
		layoutOrder = 2,
		emoji = VerifiedBadges.emoji.verified,
		font = font.SubHeader1.Font,
		anchorPoint = Vector2.new(1, 0),
		position = UDim2.new(1, 0, 0, 0),
		size = UDim2.new(1, 0, 0, 0),
		automaticSize = Enum.AutomaticSize.Y,
		verticalAlignment = Enum.VerticalAlignment.Center
	}, {
		TextLabel = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
			Size = UDim2.new(0, 0, 1, 0),
			Text = creator.name,
			TextColor3 = self.props.tokens.Color.Content.Emphasis.Color3,
			TextSize = fontSize_300,
			TextTruncate = Enum.TextTruncate.AtEnd,
			AutomaticSize = Enum.AutomaticSize.XY
		})
	}) else nil
	v29.VerifiedCreatorName = v30

	local v31 = if creator and creator.hasVerifiedBadge ~= true and creator.name then Roact.createElement("TextLabel", {
		LayoutOrder = 2,
		AnchorPoint = Vector2.new(1, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, 0),
		FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
		TextColor3 = self.props.tokens.Color.Content.Emphasis.Color3,
		TextTransparency = self.props.tokens.Color.Content.Emphasis.Transparency,
		TextSize = fontSize_300,
		Text = creator.name,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextWrapped = true
	}) else nil
	v29.UnverifiedCreatorName = v31

	local createElement7 = Roact.createElement
	local v33 = {
		LayoutOrder = 3,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, 0)
	}
	local v34 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, self.props.tokens.Padding.Small),
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		WearTimeOptions = 0,
		BundleParts = 0
	}
	local v35

	if self.props.itemInfo.timedOptions then
		v35 = Roact.createElement(view, { tag = "auto-xy", LayoutOrder = 1 }, {
			WearTimeSelectedOptionInList = Roact.createElement(wearTimeSelectedOptionInList, {
				options = self.props.itemInfo.timedOptions,
				onOptionActivated = function(p4)
					for i, timedOption in ipairs(self.props.itemInfo.timedOptions) do
						timedOption.selected = i == p4
					end

					self.props.setSelectedTimedOption(
						self.props.tryOnItem.itemId,
						p4,
						self.props.tryOnItem.itemType
					)
				end
			})
		})
	end

	v34.WearTimeOptions = v35

	local v36 = if count > 0 then Roact.createElement("Frame", {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.XY,
		Transparency = self.props.tokens.Color.Shift.Shift_200.Transparency,
		BackgroundColor3 = self.props.tokens.Color.Shift.Shift_200.Color3,
		Size = UDim2.new(0, 0, 0, 0),
		BorderSizePixel = 0
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.Tokens.Size.Size_250)
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, self.props.tokens.Padding.Small),
			PaddingLeft = UDim.new(0, self.props.tokens.Padding.Medium),
			PaddingRight = UDim.new(0, self.props.tokens.Padding.Medium),
			PaddingBottom = UDim.new(0, self.props.tokens.Padding.Small)
		}),
		BundlePartsText2 = Roact.createElement("TextLabel", {
			AnchorPoint = Vector2.new(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(0, 0, 0, 0),
			FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
			TextColor3 = self.props.tokens.Color.Content.Emphasis.Color3,
			TextTransparency = self.props.tokens.Color.Content.Emphasis.Transparency,
			TextSize = fontSize_300,
			Text = formatted,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextWrapped = true
		})
	}) else nil
	v34.BundleParts = v36
	v29.HorizontalContainer = createElement7("Frame", v33, v34)

	local v37 = if v7 then Roact.createElement("TextLabel", {
		LayoutOrder = 4,
		AnchorPoint = Vector2.new(1, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, 0),
		FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
		TextColor3 = self.props.tokens.Color.Content.Muted.Color3,
		TextTransparency = self.props.tokens.Color.Content.Muted.Transparency,
		TextSize = fontSize_350,
		Text = v7,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextWrapped = true
	}) else nil
	v29.PriceStatusText = v37
	local children2 = {
		flexSlot = createElement6("Frame", v28, v29),
		rigidSlot = 0
	}

	local createElement8 = Roact.createElement
	local v39 = {
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.XY
	}
	local v40 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, 6)
		}),
		Icon = 0,
		Price = 0,
		OriginalPrice = 0
	}

	local v41 = if v6 and v8 then Roact.createElement(imageSetLabel, {
		Image = iconscommonrobux,
		ImageTransparency = self.props.tokens.Color.Content.Muted.Transparency,
		ImageColor3 = self.props.tokens.Color.Content.Muted.Color3,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(size_500, size_500),
		LayoutOrder = 1
	}) or nil else nil
	v40.Icon = v41

	local v42 = if v8 then Roact.createElement("TextLabel", {
		Size = UDim2.new(0, -size_500 - p3, 0, size_500),
		Text = itemInfo2,
		TextSize = fontSize_350,
		FontFace = normalizeFontFace(props.Tokens.Typography.HeadingSmall.Font),
		TextColor3 = self.props.tokens.Color.Content.Muted.Color3,
		TextTransparency = self.props.tokens.Color.Content.Muted.Transparency,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.X
	}) or nil else nil
	v40.Price = v42

	v40.OriginalPrice = v8 and v10 and Roact.createElement("TextLabel", {
		Size = UDim2.new(0, -size_500 - p3, 0, size_500),
		RichText = true,
		Text = "<s>" .. v10 .. "</s>",
		TextSize = fontSize_300,
		FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
		TextColor3 = self.props.tokens.Color.Content.Muted.Color3,
		TextTransparency = self.props.tokens.Color.Content.Muted.Transparency,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		AutomaticSize = Enum.AutomaticSize.X
	}) or nil
	children2.rigidSlot = createElement8("Frame", v39, v40)
	v25.TopTextRow = createElement5(flexLayout, children2)
	children.TryOnInfoFrame = createElement4("Frame", v24, v25)
	return createElement("Frame", v15, children)
end

function extended:renderWithProviders(p2, p3)
	local horizontalPadding = self.props.horizontalPadding or 0

	return Roact.createElement(focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = self.props.layoutOrder,
		ref = self.props.elementRef,
		NextSelectionDown = self.props.NextSelectionDown,
		NextSelectionUp = self.props.NextSelectionUp
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, self.props.tokens.Padding.Medium)
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, horizontalPadding),
			PaddingRight = UDim.new(0, horizontalPadding)
		}),
		LookDetailsTryOnElement = self:renderElement(p2, p3, horizontalPadding)
	})
end

function extended:render()
	return withStyle(function(p2)
		return withLocalization({
			noResellersText = "Feature.Catalog.LabelNoResellers",
			inExperienceTest = "Feature.Catalog.Label.InSingleExperience",
			inExperienceText = "Feature.Catalog.Label.InSingleExperience",
			offSaleText = "Feature.Catalog.LabelOffSale",
			freeText = "Feature.Catalog.LabelFree",
			ownedText = "Feature.Catalog.Label.Owned",
			contentDeletedText = "Feature.Catalog.LabelContentDeleted"
		})(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

local function mapStateToProps(p2, p3)
	local localUserId = p2.LocalUserId

	return {
		playerMembership = p2.Users[localUserId] and p2.Users[localUserId].membership or Enum.MembershipType.None
	}
end

local function mapDispatchToProps(callback)
	return {
		setEquippedInTryOnManager = function(p2, p3, p4, p5)
			return callback(module6(p2, p3, p4, p5, avatarScreen.LookDetails))
		end,
		setTryOnManagerPeekViewState = function(p2)
			callback(setTryOnManagerPeekViewState(p2))
		end,
		setSelectedTimedOption = function(p2, p3, p4)
			callback(setSelectedTimedOption(p2, p3, p4))
		end
	}
end

local v5 = withNavigation((roactServices.connect({
	appAnalytics = module3,
	catalogAnalytics = module8,
	networking = module,
	localization = module2
})(extended)))

local v6 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v5)

return function(p2)
	local v7 = useTokens()

	return Roact.createElement(v6, Cryo.Dictionary.join({ tokens = v7 }, p2))
end
