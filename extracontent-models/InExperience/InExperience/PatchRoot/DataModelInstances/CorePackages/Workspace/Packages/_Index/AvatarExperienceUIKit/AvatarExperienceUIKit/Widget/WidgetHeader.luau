local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local UIBlox = require(Parent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local IconWithTooltip = require(Parent.AppBlox).IconWithTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local useDesignTokens = require(Parent.Style).useDesignTokens
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local FFlagAXWidgetHeaderTreatEmptyTextAsNil = AvatarExperienceFlags.FFlagAXWidgetHeaderTreatEmptyTextAsNil
local FFlagAXCatalogItemInformationPopover = AvatarExperienceFlags.FFlagAXCatalogItemInformationPopover

local function nonEmptyOrNil(s1: string?) -- line: 41
	if s1 ~= nil and s1 ~= "" then
		return s1
	end

	return nil
end
local function WidgetHeader(t1: {[any]: any}) -- line: 45
	-- upvalues: React (copy), useDesignTokens (copy), useLocalization (copy), FFlagAXWidgetHeaderTreatEmptyTextAsNil (copy), FFlagAXCatalogItemInformationPopover (copy), FFlagRenameDeprecatedUIBloxTokens (copy), IconWithTooltip (copy), TooltipOrientation (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy)
	local v19, v20 = React.useBinding(Vector2.new())
	local v21 = useDesignTokens()
	local v22 = useLocalization({
		seeAllButtonText = "Feature.Catalog.ActionSeeAll",
		title = t1.titleKey,
		description = t1.descriptionKey
	})
	local v24, v27

	if FFlagAXWidgetHeaderTreatEmptyTextAsNil then
		local titleText = t1.titleText

		v24 = if titleText == nil or titleText == "" then nil else titleText

		if not v24 then
			local title = v22.title

			v24 = if title == nil or title == "" then nil else title
		end

		local descriptionText = t1.descriptionText

		v27 = if descriptionText == nil or descriptionText == "" then nil else descriptionText

		if not v27 then
			local description = v22.description

			v27 = if description == nil or description == "" then nil else description
		end
	else
		v24 = if not t1.titleText then v22.title else t1.titleText
		v27 = if not t1.descriptionText then v22.description else t1.descriptionText
	end

	local v29 = FFlagAXCatalogItemInformationPopover and (t1.informationPopoverText ~= nil and (t1.informationPopoverText ~= "" and t1.onInformationIconActivated ~= nil))
	local v30 = if not v24 then nil else React.createElement("TextLabel", {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Text = v24,
		Font = if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Typography.Header.Font else v21.Typography.HeadingSmall.Font,
		TextSize = if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Typography.Header.FontSize else v21.Typography.HeadingSmall.FontSize,
		LineHeight = if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Typography.Header.LineHeight else v21.Typography.HeadingSmall.LineHeight,
		TextColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Color.Text.Emphasis else v21.Color.Content.Emphasis)).Color3,
		TextTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Color.Text.Emphasis else v21.Color.Content.Emphasis)).Transparency,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Size = if not v29 then UDim2.fromScale(1, 0) else UDim2.fromOffset(0, 0),
		AutomaticSize = if not v29 then Enum.AutomaticSize.Y else Enum.AutomaticSize.XY,
		TextXAlignment = Enum.TextXAlignment.Left
	}, {
		UIFlexItem = if not v29 then nil else React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Shrink
		}),
		UISizeConstraint = if not t1.seeAllCallback then nil else React.createElement("UISizeConstraint", {
			MinSize = v19:map(function(vector2: Vector2) -- line: 106
				return Vector2.new(0, vector2.Y)
			end)
		})
	})
	local v31 = if not v24 then nil else if not v29 then v30 else React.createElement("Frame", {
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
			Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Space_50 else v21.Size.Size_100)
		}),
		Title = v30,
		InformationIcon = React.createElement(IconWithTooltip, {
			layoutOrder = 2,
			triggerPointName = "CatalogItemInformationTooltip",
			supportTenFootUi = true,
			supportVR = true,
			tooltipOrientation = TooltipOrientation.Right,
			hoverText = t1.informationPopoverText,
			onActivateTooltip = t1.onInformationIconActivated
		})
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.LayoutOrder
	}, {
		TitleDescriptionFrame = if not v24 and not v27 then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = if not t1.seeAllCallback then UDim2.new(1, 0, 0, 0) else v19:map(function(vector2: Vector2) -- line: 171
				-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy), v21 (copy)
				return UDim2.new(1, 0 - (vector2.X + if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Space_150 else v21.Size.Size_300), 0, 0)
			end),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Space_50 else v21.Size.Size_100)
			}),
			Title = v31,
			Description = if not v27 then nil else React.createElement("TextLabel", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Text = v27,
				Font = if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Typography.Body.Font else v21.Typography.BodyLarge.Font,
				TextSize = if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Typography.Body.FontSize else v21.Typography.BodyLarge.FontSize,
				TextColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Color.Text.Default else v21.Color.Content.Default)).Color3,
				TextTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Color.Text.Default else v21.Color.Content.Default)).Transparency,
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
			text = v22.seeAllButtonText,
			fitContent = true,
			standardSize = StandardButtonSize.XSmall,
			onActivated = t1.seeAllCallback,
			buttonRef = t1.seeAllRef,
			[React.Change.AbsoluteSize] = function(p1) -- line: 236
				-- upvalues: v20 (copy)
				v20(p1.AbsoluteSize)
			end,
			NextSelectionDown = t1.NextSelectionDown,
			NextSelectionUp = t1.NextSelectionUp
		})
	})
end

return WidgetHeader
