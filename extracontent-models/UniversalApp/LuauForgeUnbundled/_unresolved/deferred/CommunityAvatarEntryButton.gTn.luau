local CoreGui = game:GetService("CoreGui")

local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock

local module = require("@luauforge/deferred/gTo")

local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize

local module2 = require("@luauforge/bundled/fox")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local function CommunityAvatarEntryButton(p2)
	local iconButtonSize = module2.getIconButtonSize(p2.formFactor)
	local v5 = useStyle()
	local v6 = useNavigation()
	local v7 = useDispatch()
	local theme = v5.Theme

	local ref = React.useRef(nil)

	local v8, v9 = module({})

	local v10 = React.useCallback(function()
		if not (ref and ref.current) then
			return
		end

		v9({ saveDismissTime = true })

		local current = ref.current

		local v11 = current.AbsolutePosition + current.AbsoluteSize * Vector2.new(0.5, 0.5)
		v7(navigateWithLock(function()
			v6.navigate(avatarScreen.CommunityAvatarEntryMenu, {
				entryButtonPosition = v11
			})
		end))
	end, { ref, v9 })

	local v11 = useLocalization({
		sharePublicAvatarTooltip = "Feature.Avatar.Label.SharePublicAvatar.Tooltip"
	})

	local v12 = {
		guiTarget = CoreGui,
		active = v8,
		DisplayOrder = 10,
		preferredOrientation = tooltipOrientation.Bottom
	}

	return withTooltip(
		{ bodyText = v11.sharePublicAvatarTooltip, useLargeDropShadow = true },
		v12,
		function(onAbsolutePositionChanged)
			return React.createElement(iconButton, {
				size = UDim2.new(0, iconButtonSize, 1, 0),
				icon = images["icons/actions/edit/add"],
				iconSize = iconSize.Medium,
				iconColor3 = theme.SystemPrimaryDefault.Color,
				iconTransparency = theme.SystemPrimaryDefault.Transparency,
				onAbsolutePositionChanged = onAbsolutePositionChanged,
				[Roact.Change.AbsoluteSize] = onAbsolutePositionChanged,
				onActivated = v10,
				buttonRef = ref
			})
		end
	)
end

return CommunityAvatarEntryButton
