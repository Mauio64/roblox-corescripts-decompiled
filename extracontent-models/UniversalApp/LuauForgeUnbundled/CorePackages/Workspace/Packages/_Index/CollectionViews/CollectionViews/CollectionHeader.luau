local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Cryo")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/UIBlox")
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Style").useDesignTokens
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Foundation").Hooks.useTokens
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Foundation").Utility.normalizeFontFace
local iconWithTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/AppBlox").IconWithTooltip
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local checkAndFormatPossibleLink = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/checkAndFormatPossibleLink")
require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/SeeAllButtonType_Legacy")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/SharedFlags")
local fFlagLuaAppSortHeaderAnchorTag = SharedFlags.FFlagLuaAppSortHeaderAnchorTag
local fFlagSduiComponentsUseFoundationTokens = SharedFlags.FFlagSduiComponentsUseFoundationTokens

local iconsactionstruncationCollapse_small = images["icons/actions/truncationCollapse_small"]
local iconsactionscycleRight = images["icons/actions/cycleRight"]

local v5 = {
	AutomaticSize = Enum.AutomaticSize.Y,
	Size = UDim2.new(1, 0, 0, 0),
	tooltipSupportsVR = true,
	tooltipSupportsTenFootUi = true
}

local function HeaderButton(props)
	local v6 = if fFlagSduiComponentsUseFoundationTokens then useTokens() else useDesignTokens()
	local size_400 = v6.Size.Size_400
	local emphasis = v6.Color.Content.Emphasis
	local image = props.image
	return React.createElement(imageSetLabel, {
		Size = props.Size or UDim2.new(0, size_400, 0, size_400),
		BackgroundTransparency = 1,
		Image = image,
		ImageColor3 = emphasis.Color3,
		ImageTransparency = emphasis.Transparency,
		LayoutOrder = props.LayoutOrder,
		Rotation = props.Rotation,
		AnchorPoint = props.AnchorPoint,
		Position = props.Position
	})
end

local function CollectionHeader(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v6, v7 = React.useBinding(0)
	local v8 = React.useCallback(function(p3)
		v7(p3.AbsoluteSize.X)
	end, {})

	local v9 = usePreferredInput()

	local v10 = if fFlagSduiComponentsUseFoundationTokens then useTokens() else useDesignTokens()
	local titleTypography = joined.titleTypography or v10.Typography.HeadingSmall
	local titleColor = joined.titleColor or v10.Color.Content.Emphasis

	local subtitleTypography = joined.subtitleTypography or v10.Typography.BodySmall

	local fontSize = joined.subtitleTypography and joined.subtitleTypography.FontSize
		or 17.64 * v10.Stroke.Standard
	local subtitleColor = joined.subtitleColor or v10.Color.Content.Default

	local size_50 = v10.Size.Size_50

	local size_300 = v10.Size.Size_300

	local v11 = not joined.hideButton and v9 ~= Responsive.Input.Directional and joined.onActivate and true
		or false

	local size_700 = v10.Size.Size_700

	local size_100 = v10.Size.Size_100

	local size_500 = v10.Size.Size_500

	local v12 = joined.tooltipInfoText ~= nil
	local v13 = not v11 and 0 or size_500
	local v14 = not v12 and 0 or size_700 + size_300

	local v16 = not (joined.subtitle == nil) and joined.subtitle ~= ""
	local v17, v18 = checkAndFormatPossibleLink(joined.subtitle)

	local v19 = if joined.onActivateSubtitle then joined.onActivateSubtitle else joined.onActivate
	local v20 = joined.onActivateSubtitle and true or v17

	local v21 = v20 and not (joined.hideSubtitleChevron or v11)
	local size_250 = v10.Size.Size_250
	local v22 = not v21 and 0 or size_250
	local v23 = v20 and v19 ~= nil
	local createElement = React.createElement
	local v25 = {
		["Position"] = nil,
		["Position"] = nil,
		Position = joined.Position,
		AutomaticSize = joined.AutomaticSize,
		Size = joined.Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = joined.LayoutOrder,
		ZIndex = joined.ZIndex
	}
	local tag = React.Tag
	local v26 = if fFlagLuaAppSortHeaderAnchorTag then joined.headerTag else nil
	v25[tag] = v26
	v25[React.Change.AbsoluteSize] = v8

	local createElement2 = React.createElement
	local v29 = {}
	v29.Text = v11 and "" or nil
	v29.Size = UDim2.new(1, -(not v12 and 0 or v14), 0, 0)
	v29.AutomaticSize = Enum.AutomaticSize.Y
	v29.BackgroundTransparency = 1
	v29.AnchorPoint = joined.AnchorPoint
	v29.BorderSizePixel = 0
	v29.AutoButtonColor = if v11 then false else nil
	local activated = React.Event.Activated
	local v31 = if v11 then joined.onActivate else nil
	v29[activated] = v31
	v29.Active = v11
	v29.Selectable = v11
	local v32 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, size_50),
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		TitleContainer = 0,
		SubtitleFrame = 0
	}

	local createElement3 = React.createElement
	local v34 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v35 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, size_100),
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Title = 0,
		SeeAllButton = 0
	}
	local v36

	if typeof(joined.title) == "string" then
		v36 = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = joined.title,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.new(0, 0, 0, 0),
			FontFace = normalizeFontFace(titleTypography.Font),
			TextSize = titleTypography.FontSize,
			TextTransparency = titleColor.Transparency,
			TextColor3 = titleColor.Color3,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 1
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = v6:map(function(p3)
					local v37 = p3 - v13 - v14

					if v37 > 0 then
						return Vector2.new(v37, 1e999)
					end

					return nil
				end)
			})
		})
	elseif typeof(joined.title) == "function" then
		v36 = joined.title()
	end

	v35.Title = v36

	v35.SeeAllButton = v11
		and React.createElement(HeaderButton, {
			LayoutOrder = 2,
			Size = UDim2.fromOffset(size_500, size_500),
			image = iconsactionscycleRight
		})
		or nil
	v32.TitleContainer = createElement3("Frame", v34, v35)
	local v37

	if v16 then
		local createElement4 = React.createElement
		local v39 = {}
		v39.LayoutOrder = 2
		v39.Text = v23 and "" or nil
		v39.Size = UDim2.new(1, 0, 0, 0)
		v39.AutomaticSize = Enum.AutomaticSize.Y
		v39.BackgroundTransparency = 1
		v39.BorderSizePixel = 0
		v39.AutoButtonColor = if v23 then false else nil
		local activated2 = React.Event.Activated

		if not v23 then
			v19 = nil
		end

		v39[activated2] = v19
		v39.Active = v23
		v39.Selectable = v23
		v37 = createElement4(v23 and "TextButton" or "Frame", v39, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v10.Size.Size_50),
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Subtitle = React.createElement("TextLabel", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Text = v18,
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.new(0, 0, 0, 0),
				FontFace = normalizeFontFace(subtitleTypography.Font),
				TextSize = fontSize,
				TextTransparency = titleColor.Transparency,
				TextColor3 = subtitleColor.Color3,
				TextWrapped = false,
				TextTruncate = Enum.TextTruncate.SplitWord,
				TextXAlignment = Enum.TextXAlignment.Left,
				RichText = v20
			}, {
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = v6:map(function(p3)
						local v41 = p3 - v22

						if v41 > 0 then
							return Vector2.new(v41, 1e999)
						end

						return nil
					end)
				})
			}),
			SubtitleLinkArrow = v21 and React.createElement(
				"Frame",
				{
					LayoutOrder = 2,
					Size = UDim2.fromOffset(v22, v22),
					BackgroundTransparency = 1,
					ClipsDescendants = true
				},
				{
					Icon = React.createElement(HeaderButton, {
						image = iconsactionstruncationCollapse_small,
						Size = UDim2.new(1, v10.Size.Size_50, 1, v10.Size.Size_50),
						Rotation = 90,
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				}
			) or nil
		}) or nil
	end

	v32.SubtitleFrame = v37
	local v27 = {
		LeftContentFrame = createElement2(v11 and "TextButton" or "Frame", v29, v32),
		IconWithTooltip = 0
	}
	local v38

	if v12 then
		local createElement4 = React.createElement
		local v40 = {
			tooltipOrientation = tooltipOrientation.Bottom,
			hoverText = joined.tooltipInfoText,
			triggerPointName = "IconWithTooltip",
			onActivateTooltip = joined.onActivateInfoIcon,
			supportVR = joined.tooltipSupportsVR,
			supportTenFootUi = joined.tooltipSupportsTenFootUi,
			size = UDim2.new(0, size_700, 0, size_700),
			position = 0,
			anchorPoint = 0
		}
		local v41 = if v16 then UDim2.new(1, 0, 0, 0) else UDim2.new(1, 0, 0.5, 0)
		v40.position = v41
		local v42 = if v16 then Vector2.new(1, 0) else Vector2.new(1, 0.5)
		v40.anchorPoint = v42
		v38 = createElement4(iconWithTooltip, v40) or nil
	end

	v27.IconWithTooltip = v38
	return createElement("Frame", v25, v27)
end

return React.memo(CollectionHeader)
