local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation").Utility.normalizeFontFace
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Localization").Hooks.useLocalization
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/UIBlox")
local iconWithTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AppBlox").IconWithTooltip
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation

local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local standardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Style").useDesignTokens

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/AvatarExperienceFlags")
local fFlagAXWidgetHeaderTreatEmptyTextAsNil = AvatarExperienceFlags.FFlagAXWidgetHeaderTreatEmptyTextAsNil
local fFlagAXCatalogItemInformationPopover = AvatarExperienceFlags.FFlagAXCatalogItemInformationPopover
local fFlagAXWidgetHeaderFlexLayout = AvatarExperienceFlags.FFlagAXWidgetHeaderFlexLayout

local function nonEmptyOrNil(p2)
	if p2 == nil or p2 == "" then
		return nil
	end

	return p2
end

local function WidgetHeader(props)
	local v5, v6 = React.useBinding(Vector2.new())
	local v7 = useDesignTokens()
	local v8 = useLocalization({
		title = props.titleKey,
		description = props.descriptionKey,
		seeAllButtonText = "Feature.Catalog.ActionSeeAll"
	})
	local v9, v10

	if fFlagAXWidgetHeaderTreatEmptyTextAsNil then
		v9 = props.titleText

		if v9 == nil or v9 == "" then
			v9 = nil
		end

		if not v9 then
			v9 = v8.title

			if v9 == nil or v9 == "" then
				v9 = nil
			end
		end

		v10 = props.descriptionText

		if v10 == nil or v10 == "" then
			v10 = nil
		end

		if not v10 then
			v10 = v8.description

			if v10 == nil or v10 == "" then
				v10 = nil
			end
		end
	else
		v9 = if props.titleText then props.titleText else v8.title
		v10 = if props.descriptionText then props.descriptionText else v8.description
	end

	local v11 = fFlagAXCatalogItemInformationPopover

	if v11 then
		if props.informationPopoverText == nil or props.informationPopoverText == "" then
			v11 = false
		else
			v11 = props.onInformationIconActivated ~= nil
		end
	end

	local v12

	if v9 then
		local createElement = React.createElement
		local v14 = {
			LayoutOrder = 1,
			Text = v9,
			FontFace = normalizeFontFace(v7.Typography.HeadingSmall.Font),
			TextSize = v7.Typography.HeadingSmall.FontSize,
			LineHeight = v7.Typography.HeadingSmall.LineHeight,
			TextColor3 = v7.Color.Content.Emphasis.Color3,
			TextTransparency = v7.Color.Content.Emphasis.Transparency,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Size = 0,
			AutomaticSize = 0,
			TextXAlignment = 0,
			BackgroundTransparency = 1
		}
		local v15 = if v11 then UDim2.fromOffset(0, 0) else UDim2.fromScale(1, 0)
		v14.Size = v15
		local v16 = if v11 then Enum.AutomaticSize.XY else Enum.AutomaticSize.Y
		v14.AutomaticSize = v16
		v14.TextXAlignment = Enum.TextXAlignment.Left

		local v18 = if v11 then React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Shrink
		}) else nil
		local v19

		if not (fFlagAXWidgetHeaderFlexLayout or not props.seeAllCallback) then
			v19 = React.createElement("UISizeConstraint", {
				MinSize = v5:map(function(p2)
					return Vector2.new(0, p2.Y)
				end)
			})
		end

		v12 = createElement("TextLabel", v14, {
			UIFlexItem = v18,
			UISizeConstraint = v19
		})
	end

	if v9 then
		if v11 then
			v12 = React.createElement("Frame", {
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
					Padding = UDim.new(0, v7.Size.Size_100)
				}),
				Title = v12,
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
					Icon = React.createElement(iconWithTooltip, {
						tooltipOrientation = tooltipOrientation.Right,
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
		v12 = nil
	end

	local createElement = React.createElement
	local v14 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder
	}

	local v16 = if fFlagAXWidgetHeaderFlexLayout then React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, v7.Size.Size_300)
	}) else nil
	local v17

	if v9 or v10 then
		local createElement2 = React.createElement
		local v19 = {
			LayoutOrder = fFlagAXWidgetHeaderFlexLayout and 1 or nil,
			Size = 0,
			AutomaticSize = 0,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}
		local v20

		if fFlagAXWidgetHeaderFlexLayout then
			v20 = UDim2.new(1, 0, 0, 0)
		elseif props.seeAllCallback then
			v20 = v5:map(function(p2)
				return UDim2.new(1, 0 - (p2.X + v7.Size.Size_300), 0, 0)
			end)
		else
			v20 = UDim2.new(1, 0, 0, 0)
		end

		v19.Size = v20

		v19.AutomaticSize = Enum.AutomaticSize.Y

		local v22 = if fFlagAXWidgetHeaderFlexLayout then React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Shrink
		}) else nil
		local v21 = {
			UIFlexItem = v22,
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v7.Size.Size_100)
			}),
			Title = v12,
			Description = 0
		}

		local v23 = if v10 then React.createElement("TextLabel", {
			LayoutOrder = 2,
			Text = v10,
			FontFace = normalizeFontFace(v7.Typography.BodyLarge.Font),
			TextSize = v7.Typography.BodyLarge.FontSize,
			TextColor3 = v7.Color.Content.Default.Color3,
			TextTransparency = v7.Color.Content.Default.Transparency,
			TextTruncate = Enum.TextTruncate.SplitWord,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1
		}) else nil
		v21.Description = v23
		v17 = createElement2("Frame", v19, v21)
	end

	local v18

	if fFlagAXWidgetHeaderFlexLayout and props.seeAllCallback then
		v18 = React.createElement(button, {
			buttonType = buttonType.Secondary,
			layoutOrder = 2,
			text = v8.seeAllButtonText,
			fitContent = true,
			standardSize = standardButtonSize.XSmall,
			onActivated = props.seeAllCallback,
			buttonRef = props.seeAllRef,
			NextSelectionDown = props.NextSelectionDown,
			NextSelectionUp = props.NextSelectionUp
		})
	elseif props.seeAllCallback then
		v18 = React.createElement(button, {
			buttonType = buttonType.Secondary,
			anchorPoint = Vector2.new(1, 0),
			position = UDim2.fromScale(1, 0),
			text = v8.seeAllButtonText,
			fitContent = true,
			standardSize = standardButtonSize.XSmall,
			onActivated = props.seeAllCallback,
			buttonRef = props.seeAllRef,
			[React.Change.AbsoluteSize] = function(p2)
				v6(p2.AbsoluteSize)
			end,
			NextSelectionDown = props.NextSelectionDown,
			NextSelectionUp = props.NextSelectionUp
		})
	end

	return createElement("Frame", v14, {
		UIListLayout = v16,
		TitleDescriptionFrame = v17,
		SeeAll = v18
	})
end

return WidgetHeader
