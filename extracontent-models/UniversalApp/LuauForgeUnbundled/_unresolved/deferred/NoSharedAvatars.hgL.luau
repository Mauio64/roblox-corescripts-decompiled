local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local fFlagSignalsNavP3gAvatarExperience = SharedFlags.FFlagSignalsNavP3gAvatarExperience
local getLegacyNavigationStore

if fFlagSignalsNavP3gAvatarExperience then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local flexLayout = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.FlexLayout

local module2 = require("@luauforge/bundled/dXh")

local function NoSharedAvatars(p2)
	local v5 = useStyle()
	local v6 = useDesignTokens()
	local v7 = useLocalization({
		shareAvatarMsg = "Feature.Avatar.Message.ShareAvatarWithCommunity",
		shareCurrentAvatar = "Feature.Avatar.Action.ShareCurrentAvatar"
	})
	local v8

	if fFlagSignalsNavP3gAvatarExperience then
		v8 = nil
	else
		v8 = useSelector(function(p3)
			if fFlagUseNavigationSelectors then
				return selectors.selectLegacyHistory(p3)
			end

			return p3.Navigation.history
		end)
	end

	local v9 = useNavigation()

	local font = v5.Font
	local theme = v5.Theme

	local v10 = React.useCallback(function()
		local v11

		if fFlagSignalsNavP3gAvatarExperience then
			v11 = getLegacyNavigationStore(false).getHistory(false)
		else
			v11 = v8
		end

		module2.closeMySharedAvatars(v9)
		v9.navigate(avatarScreen.LookComposerPage, {
			prevNavPage = avatarScreen.AvatarEditor,
			prevNavHistory = v11
		})
	end, { v9, v8 })

	return React.createElement(flexLayout, {
		padding = { top = v6.Size.Size_1200 },
		flexSlot = React.createElement(focusable.Frame, {
			BorderSizePixel = 0,
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, v6.Size.Size_500)
			}),
			NoSharedAvatarPrompt = React.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				TextSize = font.BaseSize * font.Header1.RelativeSize,
				FontFace = normalizeFontFace(v6.Typography.HeadingSmall.Font),
				TextColor3 = theme.IconEmphasis.Color,
				TextTransparency = theme.IconEmphasis.Transparency,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextWrapped = true,
				Text = v7.shareAvatarMsg
			}),
			CreateAvatarButton = React.createElement("TextButton", {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = theme.BackgroundUIContrast.Transparency,
				BackgroundColor3 = theme.BackgroundUIContrast.Color,
				BorderSizePixel = 0,
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = "",
				LayoutOrder = 2,
				[React.Event.Activated] = v10
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v6.Size.Size_1200)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, v6.Size.Size_250)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v6.Size.Size_500),
					PaddingRight = UDim.new(0, v6.Size.Size_500),
					PaddingTop = UDim.new(0, v6.Size.Size_250),
					PaddingBottom = UDim.new(0, v6.Size.Size_250)
				}),
				PlusIcon = React.createElement(imageSetLabel, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Image = images["icons/common/plus"],
					ImageColor3 = theme.IconEmphasis.Color,
					ImageTransparency = theme.IconEmphasis.Transparency,
					LayoutOrder = 1,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 36, 0, 36)
				}),
				Text = React.createElement("TextLabel", {
					Size = UDim2.new(0, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 2,
					LayoutOrder = 2,
					TextSize = font.BaseSize * font.Header2.RelativeSize,
					FontFace = normalizeFontFace(v6.Typography.TitleLarge.Font),
					TextColor3 = theme.SystemPrimaryDefault.Color,
					TextTransparency = theme.SystemPrimaryDefault.Transparency,
					TextTruncate = Enum.TextTruncate.None,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextWrapped = false,
					Text = v7.shareCurrentAvatar
				})
			})
		})
	})
end

return NoSharedAvatars
