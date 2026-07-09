local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local FFlagSignalsNavP3gAvatarExperience = SharedFlags.FFlagSignalsNavP3gAvatarExperience
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v19 = if not FFlagSignalsNavP3gAvatarExperience then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local FlexLayout = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.FlexLayout
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)

local function NoSharedAvatars(_) -- line: 38
	-- upvalues: useStyle (copy), useDesignTokens (copy), useLocalization (copy), FFlagSignalsNavP3gAvatarExperience (copy), v19 (copy), useSignalState (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), useNavigation (copy), React (copy), NavigationUtils (copy), AvatarScreen (copy), FlexLayout (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Focusable (copy), ImageSetLabel (copy), Images (copy)
	local v26 = useStyle()
	local v27 = useDesignTokens()
	local v28 = useLocalization({
		shareAvatarMsg = "Feature.Avatar.Message.ShareAvatarWithCommunity",
		shareCurrentAvatar = "Feature.Avatar.Action.ShareCurrentAvatar"
	})
	local u30

	if FFlagSignalsNavP3gAvatarExperience then
		local v29 = v19(false)

		u30 = useSignalState(v29.getHistory)
	else
		u30 = useSelector(function(p2) -- line: 50
			-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
			if FFlagUseNavigationSelectors then
				return Selectors.selectLegacyHistory(p2)
			end

			return p2.Navigation.history
		end)
	end

	local v31 = useNavigation()
	local Font = v26.Font
	local Theme = v26.Theme
	local v34 = React.useCallback(function() -- line: 62
		-- upvalues: NavigationUtils (copy), v31 (copy), AvatarScreen (copy), u30 (ref)
		NavigationUtils.closeMySharedAvatars(v31)
		v31.navigate(AvatarScreen.LookComposerPage, {
			prevNavPage = AvatarScreen.AvatarEditor,
			prevNavHistory = u30
		})
	end, {
		v31,
		u30
	})

	return React.createElement(FlexLayout, {
		padding = {
			top = if not FFlagRenameDeprecatedUIBloxTokens then v27.Global.Space_600 else v27.Size.Size_1200
		},
		flexSlot = React.createElement(Focusable.Frame, {
			BorderSizePixel = 0,
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v27.Global.Space_250 else v27.Size.Size_500)
			}),
			NoSharedAvatarPrompt = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextSize = Font.BaseSize * Font.Header1.RelativeSize,
				Font = Font.Header1.Font,
				TextColor3 = Theme.IconEmphasis.Color,
				TextTransparency = Theme.IconEmphasis.Transparency,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Text = v28.shareAvatarMsg
			}),
			CreateAvatarButton = React.createElement("TextButton", {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = Theme.BackgroundUIContrast.Transparency,
				BackgroundColor3 = Theme.BackgroundUIContrast.Color,
				BorderSizePixel = 0,
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = "",
				LayoutOrder = 2,
				[React.Event.Activated] = v34
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v27.Global.Size_600 else v27.Size.Size_1200)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v27.Global.Space_125 else v27.Size.Size_250)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v27.Global.Space_250 else v27.Size.Size_500),
					PaddingRight = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v27.Global.Space_250 else v27.Size.Size_500),
					PaddingTop = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v27.Global.Space_125 else v27.Size.Size_250),
					PaddingBottom = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v27.Global.Space_125 else v27.Size.Size_250)
				}),
				PlusIcon = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = Images["icons/common/plus"],
					ImageColor3 = Theme.IconEmphasis.Color,
					ImageTransparency = Theme.IconEmphasis.Transparency,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 36, 0, 36)
				}),
				Text = React.createElement("TextLabel", {
					BackgroundTransparency = 2,
					LayoutOrder = 2,
					TextWrapped = false,
					Size = UDim2.new(0, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = Font.BaseSize * Font.Header2.RelativeSize,
					Font = Font.Header2.Font,
					TextColor3 = Theme.SystemPrimaryDefault.Color,
					TextTransparency = Theme.SystemPrimaryDefault.Transparency,
					TextTruncate = Enum.TextTruncate.None,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					Text = v28.shareCurrentAvatar
				})
			})
		})
	})
end

return NoSharedAvatars
