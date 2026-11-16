local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local fFlagAXUseProfileIconEntryPoint = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseProfileIconEntryPoint

local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local iconSize = UIBlox.App.Constant.IconSize
local interactable = UIBlox.Core.Control.Interactable

local module2 = require("@luauforge/bundled/cgr")
local constants = module2.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = module2.Utils.getRbxthumbWithTypeSizeAndOptions
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3gAvatarExperience = SharedFlags.FFlagSignalsNavP3gAvatarExperience
local fFlagEditProfileImageV2Enabled = SharedFlags.FFlagEditProfileImageV2Enabled
local fFlagAXPPEReturnToEntrySurface = SharedFlags.FFlagAXPPEReturnToEntrySurface
local getLegacyNavigationStore

if fFlagSignalsNavP3gAvatarExperience then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local udim = UDim.new(0, 8)

local udim2 = UDim.new(0, udim.Offset - (44 - iconSize.Regular) / 2)
local avatarHeadShot = constants.RbxthumbTypes.AvatarHeadShot

local set = {
	[avatarScreen.AvatarEditor] = true,
	[avatarScreen.Catalog] = true,
	[avatarScreen.MySharedAvatars] = true
}

local function isVisible(p2, p3): boolean
	return set[p3.opaque.name] ~= nil and not (p2.isUIFullView or p2.isSceneFullView)
end

return (React.forwardRef(function(props, p2)
	local theme = useStyle().Theme

	local v5 = useAvatarRoute()
	local v6 = useNavigation()
	local v7

	if fFlagSignalsNavP3gAvatarExperience then
		v7 = nil
	else
		v7 = useSelector(function(p3)
			if fFlagUseNavigationSelectors then
				return (selectors.selectLegacyHistory(p3))
			end

			return p3.Navigation.history
		end)
	end

	local v8 = useSelectionCursor(cursorKind.RoundedRect)
	local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(useSelector(function(p3)
		return p3.LocalUserId
	end), avatarHeadShot, 150)

	local v9 = React.useCallback(function()
		if fFlagAXUseProfileIconEntryPoint then
			local name = v5.opaque.name

			if set[name] then
				v6.navigate(avatarScreen.Profile, {
					entryOrigin = { screenName = name, screenParams = v5.opaque.params }
				})

				return
			end
		end

		local v10 = { prevNavPage = v5.opaque.name, prevNavHistory = 0 }

		local v11 = if fFlagSignalsNavP3gAvatarExperience then getLegacyNavigationStore(false).getHistory(false) else v7
		v10.prevNavHistory = v11

		if not fFlagEditProfileImageV2Enabled then
			v6.navigate(avatarScreen.ProfilePictureEditorEmotes, v10)

			return
		end

		if fFlagAXPPEReturnToEntrySurface then
			v10.entryOrigin = {
				screenName = v5.opaque.name,
				screenParams = v5.opaque.params
			}
		end

		v6.navigate(avatarScreen.EditProfileImage, v10)
	end, { v6, v5, v7 })
	return React.createElement("Frame", {
		Size = UDim2.fromOffset(44, 44),
		BackgroundColor3 = theme.BackgroundMuted.Color,
		BackgroundTransparency = theme.BackgroundMuted.Transparency,
		Visible = set[v5.opaque.name] ~= nil and not (props.isUIFullView or props.isSceneFullView),
		LayoutOrder = props.layoutOrder,
		ref = p2
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = udim }),
		Button = React.createElement(interactable, {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(iconSize.Regular, iconSize.Regular),
			BackgroundTransparency = 1,
			Image = rbxthumbWithTypeSizeAndOptions,
			ZIndex = 2,
			SelectionImageObject = v8,
			[React.Event.Activated] = v9
		}, {
			Corner = React.createElement("UICorner", { CornerRadius = udim2 })
		})
	})
end))
