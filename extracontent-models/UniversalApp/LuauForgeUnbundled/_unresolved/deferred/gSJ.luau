local CoreGui = game:GetService("CoreGui")

local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)

local cursorKind = UIBlox.App.SelectionImage.CursorKind
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local text = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Text
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local withStyle = UIBlox.Style.withStyle
local interactable = UIBlox.Core.Control.Interactable

local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial
local module = require("@luauforge/deferred/gSK")

local module2 = require("@luauforge/deferred/gSL")

local axTooltip = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.AXTooltip

local module3 = require("@luauforge/bundled/dMB")
local module4 = require("@luauforge/bundled/dOp")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXMigrateCategoryTooltip = AvatarExperienceFlags.FFlagAXMigrateCategoryTooltip
local fFlagAXAddHDCatalogTooltip = AvatarExperienceFlags.FFlagAXAddHDCatalogTooltip

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module6 = require("@luauforge/bundled/gfm")

local module7 = require("@luauforge/bundled/ede")
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local popover = Foundation.Popover
local popoverSide = Foundation.Enums.PopoverSide
local popoverAlign = Foundation.Enums.PopoverAlign
local radius = Foundation.Enums.Radius
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize

local extended = Roact.PureComponent:extend("CategoryButton")

function extended:renderButtonChild(p2, p3, callback, p4, callback2)
	local font = p3.Font
	local theme = p3.Theme
	local isSelected = self.props.isSelected

	local font2 = font.Header2.Font
	local v5 = font.BaseSize * font.Header2.RelativeSize
	local v6

	if foundationFontFaceMigration then
		local v8

		if fFlagAXCatalogCategoriesSDUI and self.props.localizedCategoryTitle then
			v8 = self.props.localizedCategoryTitle
		else
			v8 = p2.title
		end

		v6 = getTextSize(
			v8,
			v5,
			self.props.foundationTokens.Typography.TitleLarge.Font,
			Vector2.new(10000, 10000)
		).X
	else
		local getTextWidth = text.GetTextWidth
		local v7

		if fFlagAXCatalogCategoriesSDUI and self.props.localizedCategoryTitle then
			v7 = self.props.localizedCategoryTitle
		else
			v7 = p2.title
		end

		v6 = getTextWidth(v7, font2, v5)
	end

	local color = isSelected and theme.TextEmphasis.Color or theme.TextMuted.Color
	local transparency = isSelected and theme.TextEmphasis.Transparency or theme.TextMuted.Transparency

	local v7 = v6 + 20

	local hasNewItemNotification = self.props.hasNewItemNotification
	local forwardRef = self.props.forwardRef

	local frameRef = self.props.frameRef

	local createElement = Roact.createElement
	local v9 = {
		Size = UDim2.new(0, v7, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = self.props.layoutOrder,
		[Roact.Change.AbsoluteSize] = p4,
		[Roact.Change.AbsolutePosition] = function(p5)
			if self.delayedSetReadyToShowTooltip then
				self.delayedSetReadyToShowTooltip()
			end

			if callback2 then
				callback2(p5)
			end
		end,
		[Roact.Ref] = frameRef
	}

	local createElement2 = Roact.createElement
	local v11 = focusable[interactable]
	local v12 = {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		[Roact.Event.Activated] = self.onActivated,
		[Roact.Ref] = forwardRef,
		NextSelectionLeft = self.props.NextSelectionLeft,
		NextSelectionRight = self.props.NextSelectionRight,
		NextSelectionUp = self.props.NextSelectionUp,
		NextSelectionDown = self.props.NextSelectionDown,
		SelectionImageObject = callback(cursorKind.NavHighlight)
	}

	local createElement3 = Roact.createElement
	local v15 = if fFlagAXCatalogCategoriesSDUI and self.props.localizedCategoryTitle then self.props.localizedCategoryTitle else p2.title

	if foundationFontFaceMigration then
		font2 = nil
	end

	local v16 = if foundationFontFaceMigration then normalizeFontFace(self.props.foundationTokens.Typography.TitleLarge.Font) else nil
	return createElement("Frame", v9, {
		Button = createElement2(v11, v12, createElement3("TextLabel", {
			Text = v15,
			TextSize = v5,
			TextColor3 = color,
			TextTransparency = transparency,
			Font = font2,
			FontFace = v16,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		})),
		NewItemNotification = hasNewItemNotification and Roact.createElement(module2, {
			isSelected = isSelected
		})
	})
end

function extended:tryDismissTooltip()
	local readyToShowTooltipFromTimestamp = self.state.readyToShowTooltipFromTimestamp

	if
		not readyToShowTooltipFromTimestamp
		or self.state.isTooltipDismissed
		or os.difftime(os.time(), readyToShowTooltipFromTimestamp) < 3
	then
		return
	end

	if self.props.onTooltipDismiss then
		self.props.onTooltipDismiss()
	end

	self:setState({ isTooltipDismissed = true })
end

function extended:renderButtonWithTooltip(p2, p3, p4)
	return withTooltip({ bodyText = self.props.tooltipTitle, useLargeDropShadow = true }, {
		triggerPointName = `{self.props.categoryName}-Tooltip`,
		preferredOrientation = tooltipOrientation.Bottom,
		guiTarget = CoreGui,
		DisplayOrder = 100,
		active = not self.props.isHidden and self.state.readyToShowTooltipFromTimestamp and not self.state.isTooltipDismissed
	}, function(p5)
		return Roact.createFragment({
			CategoryButton = self:renderButtonChild(p2, p3, p4, p5, p5),
			OnInputBegan = Roact.createElement(externalEventConnection, {
				event = UserInputService.InputBegan,
				callback = function()
					self:tryDismissTooltip()
				end
			})
		})
	end)
end

function extended:renderWithLocalized(p2)
	return withStyle(function(p3)
		local font = p3.Font
		local theme = p3.Theme

		local isSelected = self.props.isSelected

		local font2 = font.Header2.Font
		local v5 = font.BaseSize * font.Header2.RelativeSize
		local v6

		if foundationFontFaceMigration then
			local v8

			if fFlagAXCatalogCategoriesSDUI and self.props.localizedCategoryTitle then
				v8 = self.props.localizedCategoryTitle
			else
				v8 = p2.title
			end

			v6 = getTextSize(
				v8,
				v5,
				self.props.foundationTokens.Typography.TitleLarge.Font,
				Vector2.new(10000, 10000)
			).X
		else
			local getTextWidth = text.GetTextWidth
			local v7

			if fFlagAXCatalogCategoriesSDUI and self.props.localizedCategoryTitle then
				v7 = self.props.localizedCategoryTitle
			else
				v7 = p2.title
			end

			v6 = getTextWidth(v7, font2, v5)
		end

		local color = isSelected and theme.TextEmphasis.Color or theme.TextMuted.Color
		local transparency = isSelected and theme.TextEmphasis.Transparency or theme.TextMuted.Transparency

		local v7 = v6 + 20

		local hasNewItemNotification = self.props.hasNewItemNotification
		local forwardRef = self.props.forwardRef

		local frameRef = self.props.frameRef
		return withSelectionCursorProvider(function(callback)
			if fFlagAXMigrateCategoryTooltip or not self.props.tooltipOpen then
				if
					module4.isEnabled()
					and self.enableHeadCategoryCombine
					and self.props.tooltipTitle
					and not self.props.isSpatial
				then
					return self:renderButtonWithTooltip(p2, p3, callback)
				end

				local createElement = Roact.createElement
				local frameRefsByRef = {
					Size = UDim2.new(0, v7, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = self.props.layoutOrder,
					[Roact.Ref] = frameRef
				}

				local createElement2 = Roact.createElement
				local v10 = focusable[interactable]
				local v11 = {
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					[Roact.Event.Activated] = self.onActivated,
					[Roact.Ref] = forwardRef,
					NextSelectionLeft = self.props.NextSelectionLeft,
					NextSelectionRight = self.props.NextSelectionRight,
					NextSelectionUp = self.props.NextSelectionUp,
					NextSelectionDown = self.props.NextSelectionDown,
					SelectionImageObject = callback(cursorKind.NavHighlight)
				}

				local v13 = fFlagAXMigrateCategoryTooltip

				if v13 then
					local createElement3 = Roact.createElement
					local v15 = {
						popoverSide = not fFlagAXAddHDCatalogTooltip and "Top" or self.props.popoverSide,
						tooltipLocalizationKey = self.props.categoryTooltipLocalizationKey,
						tooltipStorageKey = self.props.categoryTooltipKey or "",
						dismissTooltipRef = self.props.dismissTooltipRef,
						showTooltip = self.props.showTooltip,
						localizedText = 0
					}

					local v16 = if fFlagAXCatalogCategoriesSDUI then self.props.categoryLocalizedTooltipBody else nil
					v15.localizedText = v16
					v13 = createElement3(axTooltip, v15)
				end

				local createElement3 = Roact.createElement
				local v16 = if fFlagAXCatalogCategoriesSDUI and self.props.localizedCategoryTitle then self.props.localizedCategoryTitle else p2.title
				local v15 = {
					Text = v16,
					TextSize = v5,
					TextColor3 = color,
					TextTransparency = transparency,
					Font = if not foundationFontFaceMigration then font2 else nil,
					FontFace = 0,
					Size = 0,
					BackgroundTransparency = 1
				}

				local v18 = if foundationFontFaceMigration then normalizeFontFace(self.props.foundationTokens.Typography.TitleLarge.Font) else nil
				v15.FontFace = v18

				v15.Size = UDim2.new(1, 0, 1, 0)
				return createElement("Frame", frameRefsByRef, {
					Button = createElement2(v10, v11, {
						AXTooltip = v13,
						createElement3("TextLabel", v15)
					}),
					NewItemNotification = hasNewItemNotification and Roact.createElement(module2, {
						isSelected = isSelected
					})
				})
			else
				local createElement = Roact.createElement

				local frameRefsByRef = {
					Size = UDim2.new(0, v7, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = self.props.layoutOrder,
					[Roact.Ref] = frameRef
				}

				local createElement2 = Roact.createElement
				local root = popover.Root

				local createElement3 = Roact.createElement
				local anchor = popover.Anchor
				local createElement4 = Roact.createElement
				local v12 = focusable[interactable]
				local onActivatedsByActivated = {
					AnchorPoint = Vector2.new(0, 0),
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(0, v7, 0, self.props.navBarHeight),
					BackgroundTransparency = 1,
					[Roact.Event.Activated] = self.onActivated,
					ref = forwardRef,
					NextSelectionLeft = self.props.NextSelectionLeft,
					NextSelectionRight = self.props.NextSelectionRight,
					NextSelectionUp = self.props.NextSelectionUp,
					NextSelectionDown = self.props.NextSelectionDown,
					SelectionImageObject = callback(cursorKind.NavHighlight)
				}

				local createElement5 = Roact.createElement

				local v15 = if fFlagAXCatalogCategoriesSDUI and self.props.localizedCategoryTitle then self.props.localizedCategoryTitle else p2.title
				local v14 = {
					Text = v15,
					TextSize = v5,
					TextColor3 = color,
					TextTransparency = transparency,
					Font = if not foundationFontFaceMigration then font2 else nil,
					FontFace = 0,
					Size = 0,
					BackgroundTransparency = 1
				}

				local v17 = if foundationFontFaceMigration then normalizeFontFace(self.props.foundationTokens.Typography.TitleLarge.Font) else nil
				v14.FontFace = v17

				v14.Size = UDim2.new(1, 0, 1, 0)
				return createElement("Frame", frameRefsByRef, createElement2(root, {
					isOpen = true
				}, {
					Anchor = createElement3(anchor, nil, {
						Button = createElement4(
							v12,
							onActivatedsByActivated,
							createElement5("TextLabel", v14)
						),
						NewItemNotification = hasNewItemNotification and Roact.createElement(module2, {
							isSelected = isSelected
						})
					}),
					Content = Roact.createElement(
						popover.Content,
						{
							align = popoverAlign.Center,
							side = popoverSide.Top,
							backgroundStyle = self.props.foundationTokens.Color.System.Contrast,
							radius = radius.Medium
						},
						{ Roact.createElement(
								Foundation.View,
								{
									tag = "col gap-xsmall padding-y-small padding-x-medium auto-xy"
								},
								{
									CategoryButtonTooltipTitle = Roact.createElement(
										Foundation.Text,
										{
											Text = p2.tooltipTitle,
											tag = "auto-xy text-title-medium content-inverse-emphasis"
										},
										{
											TooltipOverlayButton = Roact.createElement("TextButton", {
												Transparency = 1,
												[Roact.Event.Activated] = self.props.tooltipActivated,
												Size = UDim2.fromScale(1, 1)
											})
										}
									)
								}
							) }
					)
				}))
			end
		end)
	end)
end

function extended:render()
	local v7 = if not (fFlagAXCatalogCategoriesSDUI and self.props.localizedCategoryTitle) then self.props.categoryTitle else nil
	return withLocalization({ title = v7, tooltipTitle = self.props.tooltipText })(function(p2)
		return self:renderWithLocalized(p2)
	end)
end

function extended:init()
	if module4.isEnabled() then
		self.enableHeadCategoryCombine = module3.readTestVariable(module4.EnableHeadCategoryCombination)
		self.state = {
			readyToShowTooltipFromTimestamp = nil,
			isTooltipDismissed = false
		}

		self.delayedSetReadyToShowTooltip = module7(function()
			if self.state.readyToShowTooltipFromTimestamp then
				return
			end

			self:setState({ readyToShowTooltipFromTimestamp = os.time() })
		end, 0.5)
	end

	function self.onActivated()
		if fFlagAXMigrateCategoryTooltip and self.props.dismissTooltipRef.current then
			self.props.dismissTooltipRef.current()
		end

		if self.props.shouldUseCategoryId then
			self.props.onActivate(self.props.categoryId)
		else
			self.props.onActivate(self.props.categoryIndex)
		end
	end
end

return Roact.forwardRef(function(props, p2)
	local v5 = useIsSpatial()
	local v6 = if fFlagAXAddHDCatalogTooltip then useSelector(module6) else nil
	local v7, v8, v9, v10

	if not fFlagAXMigrateCategoryTooltip then
		v10, v9, v8 = module(props.categoryId, props.avatarScreenOfOrigin, props.categoryTooltipKey)
		v7 = useTokens()
	end

	if foundationFontFaceMigration and fFlagAXMigrateCategoryTooltip then
		v7 = useTokens()
	end

	local ref, v11

	if fFlagAXMigrateCategoryTooltip then
		ref = Roact.createRef()
		v11 = not (props.categoryTooltipKey == nil) and props.categoryTooltipLocalizationKey ~= nil

		if fFlagAXCatalogCategoriesSDUI then
			v11 = v11
				and (props.categoryLocalizedTooltipBody ~= nil or props.categoryTooltipLocalizationKey ~= nil)
		end
	end

	local v12 = fFlagAXAddHDCatalogTooltip and (v6 and "Top" or "Bottom") or "Top"
	local createElement = Roact.createElement

	local join = Cryo.Dictionary.join

	if fFlagAXMigrateCategoryTooltip then
		v10 = nil
	end

	if fFlagAXMigrateCategoryTooltip then
		v9 = nil
	end

	if fFlagAXMigrateCategoryTooltip and not foundationFontFaceMigration then
		v7 = nil
	end

	if fFlagAXMigrateCategoryTooltip then
		v8 = nil
	end

	if not fFlagAXMigrateCategoryTooltip then
		ref = nil
	end

	if not fFlagAXMigrateCategoryTooltip then
		v11 = nil
	end

	if not fFlagAXAddHDCatalogTooltip then
		v12 = nil
	end

	return createElement(extended, join(props, {
		forwardRef = p2,
		isSpatial = v5,
		tooltipOpen = v10,
		tooltipActivated = v9,
		foundationTokens = v7,
		tooltipText = v8,
		dismissTooltipRef = ref,
		showTooltip = v11,
		popoverSide = v12
	}))
end)
