local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges")
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local module2 = require("@luauforge/bundled/gxM")

local iconsnavigationpushRight_small = images["icons/navigation/pushRight_small"]
	or "LuaApp/icons/GameDetails/navigation/pushRight_small"

local vector2 = Vector2.new(14, 14)

local iconsactionsinfo_small = images["icons/actions/info_small"]
	or "LuaApp/icons/GameDetails/actions/info_small"
local vector2_2 = Vector2.new(18, 18)

local function fn(p2)
	return p2.ScreenSize
end

return (React.forwardRef(function(props, ref)
	local layoutOrder = props.LayoutOrder
	local infoName = props.infoName
	local infoNameDetails = props.infoNameDetails
	local infoData = props.infoData
	local onActivate = props.onActivate
	local hasVerifiedBadge = props.hasVerifiedBadge
	local infoNameDetailsSections

	if props.infoNameDetailsSections and #props.infoNameDetailsSections > 0 then
		infoNameDetailsSections = props.infoNameDetailsSections
	else
		infoNameDetailsSections = nil
	end

	local infoNameDetailsTitle = props.infoNameDetailsTitle
	local wrapInfoData = props.wrapInfoData

	local v5 = useNavigation()
	local v6 = useSelector(fn)

	local v7 = useStyle()
	local theme = v7.Theme
	local font = v7.Font

	local v8 = infoNameDetailsSections or infoNameDetailsTitle

	local v9 = useSelectionCursor(cursorKind.RoundedRect)

	local v10 = module2({ name = infoName })

	local color = theme.TextEmphasis.Color
	local v11 = font.BaseSize * font.Body.RelativeSize
	local v12 = -11 - vector2.X
	local v13 = ref ~= nil
	local v14 = not v13 and "ImageButton" or focusable.ImageButton

	local v15 = React.useCallback(function()
		v5.navigate(avatarScreen.ItemInfoRowPrompt, {
			screenSize = v6,
			message = infoNameDetails or RoactNavigation.None,
			sections = infoNameDetailsSections or RoactNavigation.None,
			title = infoNameDetailsTitle or RoactNavigation.None,
			confirmButtonText = "CommonUI.Controls.Action.OK"
		})
	end, { v5, v6, infoNameDetails, infoNameDetailsSections, infoNameDetailsTitle })

	if not (infoNameDetails or v8) then
		v15 = nil
	end

	local function renderLabelWithInfoIcon()
		local createElement = React.createElement
		local v17 = {
			["BackgroundTransparency"] = nil,
			BackgroundTransparency = 1,
			Size = UDim2.new(0.5, 0, 1, 0)
		}

		local activated = React.Event.Activated
		v17[activated] = if v15 then v15 else onActivate
		return createElement("ImageButton", v17, {
			HorizontalLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			}),
			InfoNameTextLabel = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				FontFace = normalizeFontFace(v7.Tokens.Typography.BodyLarge.Font),
				AutomaticSize = Enum.AutomaticSize.X,
				Text = v10.name,
				TextColor3 = theme.TextDefault.Color,
				TextSize = v11,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			}),
			InfoIcon = (infoNameDetails or v8) and React.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(vector2_2.X, vector2_2.Y),
				Image = iconsactionsinfo_small,
				ImageColor3 = color,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 1
			})
		})
	end

	local createElement = React.createElement

	local v16 = if wrapInfoData then UDim2.new(1, 0, 0, 0) else UDim2.new(1, 0, 0, props.hideDivider and 52 or 53)
	local v17 = if wrapInfoData then Enum.AutomaticSize.Y else Enum.AutomaticSize.None
	local onActivatesByActivated = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		Size = v16,
		AutomaticSize = v17,
		[React.Event.Activated] = onActivate,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		NextSelectionLeft = props.NextSelectionLeft,
		NextSelectionRight = props.NextSelectionRight,
		ref = ref,
		SelectionImageObject = v13 and v9 or nil
	}

	local createElement2 = React.createElement

	local v21 = if wrapInfoData then UDim2.new(1, 0, 0, 0) else UDim2.new(1, 0, 1, props.hideDivider and 0 or -1)
	local v22 = if wrapInfoData then Enum.AutomaticSize.Y else Enum.AutomaticSize.None

	local v24 = if wrapInfoData then React.createElement("UIPadding", {
		PaddingTop = UDim.new(0, v7.Tokens.Padding.Large),
		PaddingBottom = UDim.new(0, v7.Tokens.Padding.Large)
	}) else nil
	local v23 = {
		Padding = v24,
		InfoNameTextLabelContainer = renderLabelWithInfoIcon(),
		InfoDataWithEmoji = 0,
		InfoDataTextLabel = 0,
		LinkIcon = 0
	}
	local v25

	if hasVerifiedBadge then
		local createElement3 = React.createElement
		local emojiWrapper = VerifiedBadges.EmojiWrapper
		local v26 = {
			emoji = VerifiedBadges.emoji.verified,
			font = 0,
			anchorPoint = 0,
			position = 0,
			size = 0,
			automaticSize = 0,
			horizontalAlignment = 0,
			verticalAlignment = 0
		}
		local v27 = if onActivate then font.Header2.Font else font.Body.Font
		v26.font = v27
		v26.anchorPoint = Vector2.new(1, 0)
		v26.position = UDim2.new(1, not onActivate and 0 or v12, 0, 0)
		v26.size = UDim2.new(0.5, 0, 1, 0)
		v26.automaticSize = Enum.AutomaticSize.None
		v26.horizontalAlignment = Enum.HorizontalAlignment.Right
		v26.verticalAlignment = Enum.VerticalAlignment.Center

		local createElement4 = React.createElement
		local v32

		if onActivate then
			v32 = v7.Tokens.Typography.TitleLarge.Font
		else
			v32 = v7.Tokens.Typography.BodyLarge.Font
		end

		local v30 = {
			BackgroundTransparency = 1,
			FontFace = normalizeFontFace(v32),
			Size = UDim2.new(0, 0, 1, 0),
			Text = v10.data or infoData,
			TextColor3 = 0,
			TextSize = 0,
			TextTruncate = 0,
			TextScaled = 0,
			AutomaticSize = 0,
			TextXAlignment = 0
		}
		local v33 = if onActivate then theme.TextEmphasis.Color else theme.TextDefault.Color
		v30.TextColor3 = v33
		v30.TextSize = v11
		v30.TextTruncate = Enum.TextTruncate.AtEnd
		v30.TextScaled = props.TextScaled
		v30.AutomaticSize = Enum.AutomaticSize.X
		v30.TextXAlignment = Enum.TextXAlignment.Left
		v25 = createElement3(emojiWrapper, v26, {
			InfoDataTextLabel = createElement4("TextLabel", v30)
		})
	else
		v25 = hasVerifiedBadge
	end

	v23.InfoDataWithEmoji = v25

	local v26 = not hasVerifiedBadge

	if v26 then
		local createElement3 = React.createElement
		local v28 = {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, not onActivate and 0 or v12, 0, 0),
			BackgroundTransparency = 1,
			FontFace = 0,
			Size = 0,
			AutomaticSize = 0,
			Text = 0,
			TextColor3 = 0,
			TextSize = 0,
			TextWrapped = 0,
			TextTruncate = 0,
			TextScaled = 0,
			TextXAlignment = 0,
			TextYAlignment = 0
		}
		local v30

		if onActivate then
			v30 = v7.Tokens.Typography.TitleLarge.Font
		else
			v30 = v7.Tokens.Typography.BodyLarge.Font
		end

		v28.FontFace = normalizeFontFace(v30)

		local v31 = if wrapInfoData then UDim2.new(0.5, 0, 0, 0) else UDim2.new(0.5, 0, 1, 0)
		v28.Size = v31
		local v32 = if wrapInfoData then Enum.AutomaticSize.Y else Enum.AutomaticSize.None
		v28.AutomaticSize = v32
		v28.Text = v10.data or infoData
		local v33 = if onActivate then theme.TextEmphasis.Color else theme.TextDefault.Color
		v28.TextColor3 = v33
		v28.TextSize = v11
		v28.TextWrapped = wrapInfoData and true or nil
		local v34 = if wrapInfoData then Enum.TextTruncate.None else Enum.TextTruncate.AtEnd
		v28.TextTruncate = v34
		v28.TextScaled = props.TextScaled
		v28.TextXAlignment = Enum.TextXAlignment.Right
		v28.TextYAlignment = Enum.TextYAlignment.Center
		v26 = createElement3("TextLabel", v28, {
			TextSizeConstraint = props.TextScaled and React.createElement("UITextSizeConstraint", {
				MaxTextSize = v11
			})
		})
	end

	v23.InfoDataTextLabel = v26

	v23.LinkIcon = onActivate and React.createElement(imageSetLabel, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(vector2.X, vector2.Y),
		Image = iconsnavigationpushRight_small,
		ImageColor3 = color,
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	})
	return createElement(v14, onActivatesByActivated, {
		Container = createElement2(
			"Frame",
			{ BackgroundTransparency = 1, Size = v21, AutomaticSize = v22 },
			v23
		),
		Divider = not props.hideDivider and React.createElement("Frame", {
			BackgroundColor3 = theme.Divider.Color,
			BackgroundTransparency = theme.Divider.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, -1)
		})
	})
end))
