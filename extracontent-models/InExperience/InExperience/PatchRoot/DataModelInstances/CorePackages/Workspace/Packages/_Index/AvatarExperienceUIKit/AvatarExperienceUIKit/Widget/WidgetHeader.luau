local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local UIBlox = require(Parent.UIBlox)
local IconWithTooltip = require(Parent.AppBlox).IconWithTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local useDesignTokens = require(Parent.Style).useDesignTokens
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local FFlagAXWidgetHeaderTreatEmptyTextAsNil = AvatarExperienceFlags.FFlagAXWidgetHeaderTreatEmptyTextAsNil
local FFlagAXCatalogItemInformationPopover = AvatarExperienceFlags.FFlagAXCatalogItemInformationPopover

local function nonEmptyOrNil(s1: string?) -- line: 39
	if s1 ~= nil and s1 ~= "" then
		return s1
	end

	return nil
end
local function WidgetHeader(t1: {[any]: any}) -- line: 43
	-- upvalues: React (copy), useDesignTokens (copy), useLocalization (copy), FFlagAXWidgetHeaderTreatEmptyTextAsNil (copy), FFlagAXCatalogItemInformationPopover (copy), IconWithTooltip (copy), TooltipOrientation (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy)
	local v18, v19 = React.useBinding(Vector2.new())
	local v20 = useDesignTokens()
	local v21 = useLocalization({
		seeAllButtonText = "Feature.Catalog.ActionSeeAll",
		title = t1.titleKey,
		description = t1.descriptionKey
	})
	local v23, v26

	if FFlagAXWidgetHeaderTreatEmptyTextAsNil then
		local titleText = t1.titleText

		v23 = if titleText == nil or titleText == "" then nil else titleText

		if not v23 then
			local title = v21.title

			v23 = if title == nil or title == "" then nil else title
		end

		local descriptionText = t1.descriptionText

		v26 = if descriptionText == nil or descriptionText == "" then nil else descriptionText

		if not v26 then
			local description = v21.description

			v26 = if description == nil or description == "" then nil else description
		end
	else
		v23 = if not t1.titleText then v21.title else t1.titleText
		v26 = if not t1.descriptionText then v21.description else t1.descriptionText
	end

	local v28 = FFlagAXCatalogItemInformationPopover and (t1.informationPopoverText ~= nil and (t1.informationPopoverText ~= "" and t1.onInformationIconActivated ~= nil))
	local v29 = if not v23 then nil else React.createElement("TextLabel", {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Text = v23,
		Font = v20.Typography.HeadingSmall.Font,
		TextSize = v20.Typography.HeadingSmall.FontSize,
		LineHeight = v20.Typography.HeadingSmall.LineHeight,
		TextColor3 = v20.Color.Content.Emphasis.Color3,
		TextTransparency = v20.Color.Content.Emphasis.Transparency,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Size = if not v28 then UDim2.fromScale(1, 0) else UDim2.fromOffset(0, 0),
		AutomaticSize = if not v28 then Enum.AutomaticSize.Y else Enum.AutomaticSize.XY,
		TextXAlignment = Enum.TextXAlignment.Left
	}, {
		UIFlexItem = if not v28 then nil else React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Shrink
		}),
		UISizeConstraint = if not t1.seeAllCallback then nil else React.createElement("UISizeConstraint", {
			MinSize = v18:map(function(vector2: Vector2) -- line: 94
				return Vector2.new(0, vector2.Y)
			end)
		})
	})
	local v30 = if not v23 then nil else if not v28 then v29 else React.createElement("Frame", {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v20.Size.Size_100)
		}),
		Title = v29,
		InformationIcon = React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			UIFlexItem = React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.None
			}),
			Icon = React.createElement(IconWithTooltip, {
				triggerPointName = "CatalogItemInformationTooltip",
				supportTenFootUi = true,
				supportVR = true,
				tooltipOrientation = TooltipOrientation.Right,
				hoverText = t1.informationPopoverText,
				onActivateTooltip = t1.onInformationIconActivated
			})
		})
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.LayoutOrder
	}, {
		TitleDescriptionFrame = if not v23 and not v26 then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = if not t1.seeAllCallback then UDim2.new(1, 0, 0, 0) else v18:map(function(vector2: Vector2) -- line: 172
				-- upvalues: v20 (copy)
				return UDim2.new(1, 0 - (vector2.X + v20.Size.Size_300), 0, 0)
			end),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v20.Size.Size_100)
			}),
			Title = v30,
			Description = if not v26 then nil else React.createElement("TextLabel", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Text = v26,
				Font = v20.Typography.BodyLarge.Font,
				TextSize = v20.Typography.BodyLarge.FontSize,
				TextColor3 = v20.Color.Content.Default.Color3,
				TextTransparency = v20.Color.Content.Default.Transparency,
				TextTruncate = Enum.TextTruncate.SplitWord,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		}),
		SeeAll = if not t1.seeAllCallback then nil else React.createElement(Button, {
			buttonType = ButtonType.Secondary,
			anchorPoint = Vector2.new(1, 0),
			position = UDim2.fromScale(1, 0),
			text = v21.seeAllButtonText,
			fitContent = true,
			standardSize = StandardButtonSize.XSmall,
			onActivated = t1.seeAllCallback,
			buttonRef = t1.seeAllRef,
			[React.Change.AbsoluteSize] = function(p1) -- line: 213
				-- upvalues: v19 (copy)
				v19(p1.AbsoluteSize)
			end,
			NextSelectionDown = t1.NextSelectionDown,
			NextSelectionUp = t1.NextSelectionUp
		})
	})
end

return WidgetHeader
