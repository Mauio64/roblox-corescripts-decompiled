local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UIBlox = require(parent.UIBlox)
local AppBlox = require(parent.AppBlox)
local IconWithTooltip = AppBlox.IconWithTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation

local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXWidgetHeaderTreatEmptyTextAsNil = AvatarExperienceFlags.FFlagAXWidgetHeaderTreatEmptyTextAsNil
local FFlagAXCatalogItemInformationPopover = AvatarExperienceFlags.FFlagAXCatalogItemInformationPopover
local FFlagAXWidgetHeaderFlexLayout = AvatarExperienceFlags.FFlagAXWidgetHeaderFlexLayout

local function nonEmptyOrNil(p: string?) -- 4 equivalent calls inferred from this helper
	return if not (p == nil or p == "") then p else nil
end

local function WidgetHeader(props)
	local v, v2 = React.useBinding(Vector2.new())
	local v3 = useDesignTokens()
	local v4 = useLocalization({
		title = props.titleKey,
		description = props.descriptionKey,
		seeAllButtonText = "Feature.Catalog.ActionSeeAll"
	})
	local text, text2

	if FFlagAXWidgetHeaderTreatEmptyTextAsNil then
		text = props.titleText
		text = nonEmptyOrNil(text) -- inferred equivalent call

		if not text then
			text = v4.title
			text = nonEmptyOrNil(text) -- inferred equivalent call
		end

		text2 = props.descriptionText
		text2 = nonEmptyOrNil(text2) -- inferred equivalent call

		if not text2 then
			text2 = v4.description
			text2 = nonEmptyOrNil(text2) -- inferred equivalent call
		end
	else
		text = if props.titleText then props.titleText else v4.title

		if props.descriptionText then
			text2 = props.descriptionText
		else
			text2 = v4.description
		end
	end

	local v5 = FFlagAXCatalogItemInformationPopover

	if v5 then
		if props.informationPopoverText == nil or props.informationPopoverText == "" then
			v5 = false
		else
			v5 = props.onInformationIconActivated ~= nil
		end
	end

	local title

	if text then
		local createElement = React.createElement
		local v6 = {
			LayoutOrder = 1,
			Text = text,
			FontFace = normalizeFontFace(v3.Typography.HeadingSmall.Font),
			TextSize = v3.Typography.HeadingSmall.FontSize,
			LineHeight = v3.Typography.HeadingSmall.LineHeight,
			TextColor3 = v3.Color.Content.Emphasis.Color3,
			TextTransparency = v3.Color.Content.Emphasis.Transparency,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Size = 0,
			AutomaticSize = 0,
			TextXAlignment = 0,
			BackgroundTransparency = 1
		}
		local size

		if v5 then
			size = UDim2.fromOffset(0, 0)
		else
			size = UDim2.fromScale(1, 0)
		end

		v6.Size = size
		local automaticSize

		if v5 then
			automaticSize = Enum.AutomaticSize.XY
		else
			automaticSize = Enum.AutomaticSize.Y
		end

		v6.AutomaticSize = automaticSize
		v6.TextXAlignment = Enum.TextXAlignment.Left
		local uiFlexItem

		if v5 then
			uiFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Shrink })
		end

		local uiSizeConstraint

		if not (FFlagAXWidgetHeaderFlexLayout or not props.seeAllCallback) then
			uiSizeConstraint = React.createElement("UISizeConstraint", {
				MinSize = v:map(function(vector2: Vector2)
					return Vector2.new(0, vector2.Y)
				end)
			})
		end

		title = createElement("TextLabel", v6, {
			UIFlexItem = uiFlexItem,
			UISizeConstraint = uiSizeConstraint
		})
	end

	if text then
		if v5 then
			title = React.createElement("Frame", {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, v3.Size.Size_100)
				}),
				Title = title,
				InformationIcon = React.createElement("Frame", {
					LayoutOrder = 2,
					Size = UDim2.fromOffset(0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					BorderSizePixel = 0
				}, {
					UIFlexItem = React.createElement("UIFlexItem", {
						FlexMode = Enum.UIFlexMode.None
					}),
					Icon = React.createElement(IconWithTooltip, {
						tooltipOrientation = TooltipOrientation.Right,
						hoverText = props.informationPopoverText,
						onActivateTooltip = props.onInformationIconActivated,
						triggerPointName = "CatalogItemInformationTooltip",
						supportTenFootUi = true,
						supportVR = true
					})
				})
			})
		end
	else
		title = nil
	end

	local createElement = React.createElement
	local v6 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder
	}
	local uiListLayout

	if FFlagAXWidgetHeaderFlexLayout then
		uiListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v3.Size.Size_300)
		})
	end

	local titleDescriptionFrame

	if text or text2 then
		local createElement2 = React.createElement
		local v7 = {
			LayoutOrder = FFlagAXWidgetHeaderFlexLayout and 1 or nil,
			Size = 0,
			AutomaticSize = 0,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}
		local size

		if FFlagAXWidgetHeaderFlexLayout then
			size = UDim2.new(1, 0, 0, 0)
		elseif props.seeAllCallback then
			size = v:map(function(vector2: Vector2)
				return UDim2.new(1, 0 - (vector2.X + v3.Size.Size_300), 0, 0)
			end)
		else
			size = UDim2.new(1, 0, 0, 0)
		end

		v7.Size = size

		v7.AutomaticSize = Enum.AutomaticSize.Y
		local uiFlexItem

		if FFlagAXWidgetHeaderFlexLayout then
			uiFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Shrink })
		end

		local v8 = {
			UIFlexItem = uiFlexItem,
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v3.Size.Size_100)
			}),
			Title = title,
			Description = 0
		}
		local description

		if text2 then
			description = React.createElement("TextLabel", {
				LayoutOrder = 2,
				Text = text2,
				FontFace = normalizeFontFace(v3.Typography.BodyLarge.Font),
				TextSize = v3.Typography.BodyLarge.FontSize,
				TextColor3 = v3.Color.Content.Default.Color3,
				TextTransparency = v3.Color.Content.Default.Transparency,
				TextTruncate = Enum.TextTruncate.SplitWord,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1
			})
		end

		v8.Description = description
		titleDescriptionFrame = createElement2("Frame", v7, v8)
	end

	local seeAll

	if FFlagAXWidgetHeaderFlexLayout and props.seeAllCallback then
		seeAll = React.createElement(Button, {
			buttonType = ButtonType.Secondary,
			layoutOrder = 2,
			text = v4.seeAllButtonText,
			fitContent = true,
			standardSize = StandardButtonSize.XSmall,
			onActivated = props.seeAllCallback,
			buttonRef = props.seeAllRef,
			NextSelectionDown = props.NextSelectionDown,
			NextSelectionUp = props.NextSelectionUp
		})
	elseif props.seeAllCallback then
		seeAll = React.createElement(Button, {
			buttonType = ButtonType.Secondary,
			anchorPoint = Vector2.new(1, 0),
			position = UDim2.fromScale(1, 0),
			text = v4.seeAllButtonText,
			fitContent = true,
			standardSize = StandardButtonSize.XSmall,
			onActivated = props.seeAllCallback,
			buttonRef = props.seeAllRef,
			[React.Change.AbsoluteSize] = function(p)
				v2(p.AbsoluteSize)
			end,
			NextSelectionDown = props.NextSelectionDown,
			NextSelectionUp = props.NextSelectionUp
		})
	end

	return createElement("Frame", v6, {
		UIListLayout = uiListLayout,
		TitleDescriptionFrame = titleDescriptionFrame,
		SeeAll = seeAll
	})
end

return WidgetHeader
