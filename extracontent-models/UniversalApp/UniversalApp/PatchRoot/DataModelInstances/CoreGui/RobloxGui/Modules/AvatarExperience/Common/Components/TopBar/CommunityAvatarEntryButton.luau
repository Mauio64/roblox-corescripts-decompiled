local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Common = Modules.AvatarExperience.Common
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local useCommunityAvatarEntryButtonTooltip = require(Common.Components.TopBar.useCommunityAvatarEntryButtonTooltip)
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local FFlagEnableAppNavGamepadRemoval = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAppNavGamepadRemoval
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization

local function CommunityAvatarEntryButton(p1) -- line: 43
	-- upvalues: TopBar (copy), useStyle (copy), useNavigation (copy), useDispatch (copy), FFlagEnableAppNavGamepadRemoval (copy), React (copy), useCommunityAvatarEntryButtonTooltip (copy), AvatarScreen (copy), NavigateWithLock (copy), useLocalization (copy), CoreGui (copy), TooltipOrientation (copy), withTooltip (copy), IconButton (copy), Images (copy), IconSize (copy), Roact (copy)
	local v24 = TopBar.getIconButtonSize(p1.formFactor)
	local v25 = useStyle()
	local v26 = useNavigation()
	local v27 = useDispatch()
	local Theme = v25.Theme
	local v29 = if not FFlagEnableAppNavGamepadRemoval then nil else React.useRef(nil)
	local v30, v31 = useCommunityAvatarEntryButtonTooltip({})
	local v32 = if not FFlagEnableAppNavGamepadRemoval then React.useCallback(function() -- line: 81
		-- upvalues: p1 (copy), v31 (copy), v26 (copy), AvatarScreen (copy), v27 (copy), NavigateWithLock (copy)
		if not p1.buttonRef or not p1.buttonRef.current then
			return
		end

		v31({
			saveDismissTime = true
		})

		local current = p1.buttonRef.current
		local v38 = current.AbsolutePosition + current.AbsoluteSize * Vector2.new(0.5, 0.5)

		v27(NavigateWithLock(function() -- line: 92
			-- upvalues: v26 (copy), AvatarScreen (copy), v38 (copy)
			v26.navigate(AvatarScreen.CommunityAvatarEntryMenu, {
				entryButtonPosition = v38
			})
		end))
	end, {
		p1.buttonRef,
		v31
	}) else React.useCallback(function() -- line: 57
		-- upvalues: v29 (copy), v31 (copy), v26 (copy), AvatarScreen (copy), v27 (copy), NavigateWithLock (copy)
		if not v29 or not v29.current then
			return
		end

		v31({
			saveDismissTime = true
		})

		local current = v29.current
		local v36 = current.AbsolutePosition + current.AbsoluteSize * Vector2.new(0.5, 0.5)

		v27(NavigateWithLock(function() -- line: 68
			-- upvalues: v26 (copy), AvatarScreen (copy), v36 (copy)
			v26.navigate(AvatarScreen.CommunityAvatarEntryMenu, {
				entryButtonPosition = v36
			})
		end))
	end, {
		v29,
		v31
	})
	local v33 = useLocalization({
		sharePublicAvatarTooltip = "Feature.Avatar.Label.SharePublicAvatar.Tooltip"
	})
	local t1 = {
		DisplayOrder = 10,
		guiTarget = CoreGui,
		active = v30,
		preferredOrientation = TooltipOrientation.Bottom
	}

	return withTooltip({
		useLargeDropShadow = true,
		bodyText = v33.sharePublicAvatarTooltip
	}, t1, function(p2) -- line: 122
		-- upvalues: React (copy), IconButton (copy), v24 (copy), Images (copy), IconSize (copy), Theme (copy), Roact (copy), v32 (copy), FFlagEnableAppNavGamepadRemoval (copy), v29 (copy), p1 (copy)
		return React.createElement(IconButton, {
			size = UDim2.new(0, v24, 1, 0),
			icon = Images["icons/actions/edit/add"],
			iconSize = IconSize.Medium,
			iconColor3 = Theme.SystemPrimaryDefault.Color,
			iconTransparency = Theme.SystemPrimaryDefault.Transparency,
			onAbsolutePositionChanged = p2,
			[Roact.Change.AbsoluteSize] = p2,
			onActivated = v32,
			buttonRef = if not FFlagEnableAppNavGamepadRemoval then p1.buttonRef else v29
		})
	end)
end

return CommunityAvatarEntryButton
