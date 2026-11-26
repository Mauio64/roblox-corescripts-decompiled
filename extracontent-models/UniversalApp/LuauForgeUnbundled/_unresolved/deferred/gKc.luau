local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module = require("@luauforge/bundled/fDf")

local module2 = require("@luauforge/bundled/gxM")
local module3 = require("@luauforge/bundled/dPN")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local module4 = require("@luauforge/deferred/gJH")
local module5 = require("@luauforge/deferred/gJI")
local module6 = require("@luauforge/deferred/gKd")
local module7 = require("@luauforge/bundled/dXh")
local module8 = require("@luauforge/bundled/eie")
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module9 = require("@luauforge/deferred/gKe")

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local images = UIBlox.App.ImageSet.Images
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local useStyle = UIBlox.Core.Style.useStyle
local buttonType = UIBlox.App.Button.Enum.ButtonType
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal

local module10 = require("@luauforge/deferred/gKh")

local module11 = require("@luauforge/deferred/gKi")

local function fn(p2)
	return p2.ScreenSize
end

local function CommunityAvatarSharePrompt(p2)
	local v5 = useNavigation()
	local v6 = module8(module)
	local v7 = module2({
		titleText = "Feature.Avatar.Heading.SharePublicAvatar",
		messageText = "Feature.Avatar.Message.SharePublicAvatar",
		disclaimerText = "Feature.Avatar.Message.ShareAvatarWithCommunityDisclaimer"
	})

	local v8 = useStyle()
	local v9 = useDesignTokens()

	local theme = v8.Theme
	local font = v8.Font
	local iconSize2 = getIconSize(iconSize.Small)

	local lookId = p2.lookId

	local v10 = module9(lookId, module3.ItemType.Look, true, nil, nil)

	local v11 = useSelector(fn)

	local v12 = React.useCallback(function()
		module7.closeOverlay(v5)
	end, { v5 })

	React.useEffect(function()
		if v10 == nil then
			v12()
		end
	end, { v10, v12 })

	local v13 = React.useCallback(function()
		v10.onActivated()
	end, { lookId, v6, v10 })

	return React.createElement(partialPageModal, {
		title = v7.titleText,
		screenSize = v11,
		buttonStackProps = {
			buttons = {
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = v13, text = v10.text }
				}
			}
		},
		onCloseClicked = v12
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		CommunityAvatarSharePromptBodyText = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, 0),
			Text = v7.messageText,
			TextTruncate = Enum.TextTruncate.AtEnd,
			AutomaticSize = Enum.AutomaticSize.XY,
			FontFace = normalizeFontFace(v9.Typography.BodyLarge.Font),
			TextSize = font.Body.RelativeSize * font.BaseSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = theme.TextDefault.Color,
			TextWrapped = true,
			LayoutOrder = 1
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v9.Size.Size_400)
			})
		}),
		AvatarImage = React.createElement(module10, {
			size = 300,
			lookId = p2.lookId,
			layoutOrder = 2
		}),
		CommunityAvatarSharePromptDisclaimer = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			ClipsDescendants = true,
			BackgroundTransparency = 1,
			LayoutOrder = 3
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, v9.Size.Size_150),
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			Padding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, v9.Size.Size_400)
			}),
			CommunityAvatarSharePromptDisclaimerIcon = React.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(iconSize2, iconSize2),
				BackgroundTransparency = 1,
				Image = images["icons/actions/info_small"],
				ImageColor3 = theme.IconEmphasis.Color,
				ImageTransparency = theme.IconEmphasis.Transparency
			}),
			CommunityAvatarSharePromptDisclaimerText = React.createElement("TextLabel", {
				Text = v7.disclaimerText,
				BackgroundTransparency = 1,
				TextTruncate = Enum.TextTruncate.AtEnd,
				AutomaticSize = Enum.AutomaticSize.XY,
				FontFace = normalizeFontFace(v9.Typography.CaptionSmall.Font),
				TextSize = font.Footer.RelativeSize * font.BaseSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = theme.TextDefault.Color,
				TextWrapped = true
			})
		})
	})
end

local v5 = module4((module5(CommunityAvatarSharePrompt)))

if module11() then
	v5 = module6(v5)
end

return v5
