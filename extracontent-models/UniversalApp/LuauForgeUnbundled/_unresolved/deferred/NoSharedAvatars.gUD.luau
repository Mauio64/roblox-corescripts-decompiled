local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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

local module2 = require("@luauforge/bundled/dTM")

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

	local createElement = React.createElement
	local v12 = {
		padding = { top = v6.Size.Size_1200 },
		flexSlot = 0
	}

	local createElement2 = React.createElement
	local frame = focusable.Frame
	local v13 = {
		BorderSizePixel = 0,
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, v6.Size.Size_500)
		}),
		NoSharedAvatarPrompt = 0,
		CreateAvatarButton = 0
	}

	local createElement3 = React.createElement
	local v15 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		TextSize = font.BaseSize * font.Header1.RelativeSize,
		Font = 0,
		FontFace = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextTruncate = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		TextWrapped = true,
		Text = 0
	}
	local v16 = if not foundationFontFaceMigration then font.Header1.Font else nil
	v15.Font = v16

	local v17 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.HeadingSmall.Font) else nil
	v15.FontFace = v17

	v15.TextColor3 = theme.IconEmphasis.Color
	v15.TextTransparency = theme.IconEmphasis.Transparency
	v15.TextTruncate = Enum.TextTruncate.AtEnd
	v15.TextXAlignment = Enum.TextXAlignment.Center
	v15.TextYAlignment = Enum.TextYAlignment.Center

	v15.Text = v7.shareAvatarMsg
	children.NoSharedAvatarPrompt = createElement3("TextLabel", v15)

	local createElement4 = React.createElement
	local v19 = {
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
	}
	local v20 = {
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
		Text = 0
	}

	local createElement5 = React.createElement
	local v22 = {
		Size = UDim2.new(0, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 2,
		LayoutOrder = 2,
		TextSize = font.BaseSize * font.Header2.RelativeSize,
		Font = 0,
		FontFace = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextTruncate = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		TextWrapped = false,
		Text = 0
	}
	local v23 = if not foundationFontFaceMigration then font.Header2.Font else nil
	v22.Font = v23

	local v24 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.TitleLarge.Font) else nil
	v22.FontFace = v24

	v22.TextColor3 = theme.SystemPrimaryDefault.Color
	v22.TextTransparency = theme.SystemPrimaryDefault.Transparency
	v22.TextTruncate = Enum.TextTruncate.None
	v22.TextXAlignment = Enum.TextXAlignment.Left
	v22.TextYAlignment = Enum.TextYAlignment.Center

	v22.Text = v7.shareCurrentAvatar
	v20.Text = createElement5("TextLabel", v22)
	children.CreateAvatarButton = createElement4("TextButton", v19, v20)
	v12.flexSlot = createElement2(frame, v13, children)
	return createElement(flexLayout, v12)
end

return NoSharedAvatars
