local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withClosableOverlayBackdrop = require(Modules.AvatarExperience.Common.Components.withClosableOverlayBackdrop)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useShareButton = require(Modules.AvatarExperience.Common.Hooks.useShareButton)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local CommunityAvatarLookImageFrame = require(Modules.AvatarExperience.Catalog.Components.LookDetails.CommunityAvatarLookImageFrame)
local GetFFlagAXShareAvatarPromptEasyDismiss = require(Modules.AvatarExperience.Flags.GetFFlagAXShareAvatarPromptEasyDismiss)

local function v27(p1) -- line: 45
	return p1.ScreenSize
end
local function CommunityAvatarSharePrompt(t1: {[any]: any}) -- line: 49
	-- upvalues: useNavigation (copy), useRoactService (copy), Analytics (copy), useLocalization (copy), useStyle (copy), useDesignTokens (copy), getIconSize (copy), IconSize (copy), useShareButton (copy), Constants (copy), useSelector (copy), v27 (copy), React (copy), NavigationUtils (copy), PartialPageModal (copy), ButtonType (copy), FFlagRenameDeprecatedUIBloxTokens (copy), CommunityAvatarLookImageFrame (copy), ImageSetLabel (copy), Images (copy)
	local v32 = useNavigation()
	local v33 = useRoactService(Analytics)
	local v34 = useLocalization({
		titleText = "Feature.Avatar.Heading.SharePublicAvatar",
		messageText = "Feature.Avatar.Message.SharePublicAvatar",
		disclaimerText = "Feature.Avatar.Message.ShareAvatarWithCommunityDisclaimer"
	})
	local v35 = useStyle()
	local v36 = useDesignTokens()
	local Theme = v35.Theme
	local Font = v35.Font
	local v39 = getIconSize(IconSize.Small)
	local lookId = t1.lookId
	local v41 = useShareButton(lookId, Constants.ItemType.Look, true, nil, nil)
	local v42 = useSelector(v27)
	local v43 = React.useCallback(function() -- line: 83
		-- upvalues: NavigationUtils (copy), v32 (copy)
		NavigationUtils.closeOverlay(v32)
	end, { v32 })

	React.useEffect(function() -- line: 87
		-- upvalues: v41 (copy), v43 (copy)
		if v41 == nil then
			v43()
		end
	end, {
		v41,
		v43
	})

	local v44 = React.useCallback(function() -- line: 94
		-- upvalues: v41 (copy)
		v41.onActivated()
	end, {
		lookId,
		v33,
		v41
	})

	return React.createElement(PartialPageModal, {
		title = v34.titleText,
		screenSize = v42,
		buttonStackProps = {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = v44,
					text = v41.text
				}
			}}
		},
		onCloseClicked = v43
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		CommunityAvatarSharePromptBodyText = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			LayoutOrder = 1,
			Size = UDim2.new(0, 0, 0, 0),
			Text = v34.messageText,
			TextTruncate = Enum.TextTruncate.AtEnd,
			AutomaticSize = Enum.AutomaticSize.XY,
			Font = Font.Body.Font,
			TextSize = Font.Body.RelativeSize * Font.BaseSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Theme.TextDefault.Color
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v36.Global.Space_200 else v36.Size.Size_400)
			})
		}),
		AvatarImage = React.createElement(CommunityAvatarLookImageFrame, {
			size = 300,
			layoutOrder = 2,
			lookId = t1.lookId
		}),
		CommunityAvatarSharePromptDisclaimer = React.createElement("Frame", {
			ClipsDescendants = true,
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v36.Global.Space_75 else v36.Size.Size_150),
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			Padding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v36.Global.Space_200 else v36.Size.Size_400)
			}),
			CommunityAvatarSharePromptDisclaimerIcon = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(v39, v39),
				Image = Images["icons/actions/info_small"],
				ImageColor3 = Theme.IconEmphasis.Color,
				ImageTransparency = Theme.IconEmphasis.Transparency
			}),
			CommunityAvatarSharePromptDisclaimerText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				Text = v34.disclaimerText,
				TextTruncate = Enum.TextTruncate.AtEnd,
				AutomaticSize = Enum.AutomaticSize.XY,
				Font = Font.Footer.Font,
				TextSize = Font.Footer.RelativeSize * Font.BaseSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = Theme.TextDefault.Color
			})
		})
	})
end

local v29 = withMappedNavigationParams((withOverlayFocusHandling(CommunityAvatarSharePrompt)))

if GetFFlagAXShareAvatarPromptEasyDismiss() then
	v29 = withClosableOverlayBackdrop(v29)
end

return v29
