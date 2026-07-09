local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local IconSize = UIBlox.App.Constant.IconSize
local Interactable = UIBlox.Core.Control.Interactable
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local Constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local FFlagAXMigrateQuickButtonsToGlobalAutoFocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateQuickButtonsToGlobalAutoFocus
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagSignalsNavP3gAvatarExperience = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3gAvatarExperience
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v23 = if not FFlagSignalsNavP3gAvatarExperience then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local uDim = UDim.new(0, 8)
local uDim2 = UDim.new(0, uDim.Offset - (44 - IconSize.Regular) / 2)
local AvatarHeadShot = Constants.RbxthumbTypes.AvatarHeadShot
local t1 = {
	[AvatarScreen.AvatarEditor] = true,
	[AvatarScreen.Catalog] = true,
	[AvatarScreen.MySharedAvatars] = true
}

local function isVisible(t2: {[any]: any}, p1) -- line: 67
	-- upvalues: t1 (copy)
	return t1[p1.opaque.name] ~= nil and (not t2.isUIFullView and not t2.isSceneFullView)
end

return (React.forwardRef(function(t3: {[any]: any}, p2) -- line: 74
	-- upvalues: useStyle (copy), useAvatarRoute (copy), useNavigation (copy), FFlagSignalsNavP3gAvatarExperience (copy), v23 (copy), useSignalState (copy), useSelector (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), useSelectionCursor (copy), CursorKind (copy), getRbxthumbWithTypeSizeAndOptions (copy), AvatarHeadShot (copy), React (copy), AvatarScreen (copy), FFlagAXMigrateQuickButtonsToGlobalAutoFocus (copy), RoactGamepad (copy), t1 (copy), uDim (copy), Interactable (copy), IconSize (copy), uDim2 (copy)
	local Theme = useStyle().Theme
	local v34 = useAvatarRoute()
	local v35 = useNavigation()
	local u37

	if FFlagSignalsNavP3gAvatarExperience then
		local v36 = v23(false)

		u37 = useSignalState(v36.getHistory)
	else
		u37 = useSelector(function(p3) -- line: 85
			-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
			if FFlagUseNavigationSelectors then
				return (Selectors.selectLegacyHistory(p3))
			end

			return p3.Navigation.history
		end)
	end

	local v38 = useSelectionCursor(CursorKind.RoundedRect)
	local v39 = useSelector(function(p4) -- line: 92
		return p4.LocalUserId
	end)
	local v40 = getRbxthumbWithTypeSizeAndOptions(v39, AvatarHeadShot, 150)
	local v41 = React.useCallback(function() -- line: 99
		-- upvalues: v34 (copy), u37 (ref), v35 (copy), AvatarScreen (copy)
		local t4 = {
			prevNavPage = v34.opaque.name,
			prevNavHistory = u37
		}

		v35.navigate(AvatarScreen.ProfilePictureEditorEmotes, t4)
	end, {
		v35,
		v34,
		u37
	})

	return React.createElement(if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then RoactGamepad.Focusable.Frame else "Frame", {
		Size = UDim2.fromOffset(44, 44),
		BackgroundColor3 = Theme.BackgroundMuted.Color,
		BackgroundTransparency = Theme.BackgroundMuted.Transparency,
		Visible = t1[v34.opaque.name] ~= nil and (not t3.isUIFullView and not t3.isSceneFullView),
		LayoutOrder = t3.layoutOrder,
		NextSelectionUp = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t3.NextSelectionUp else nil,
		NextSelectionDown = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t3.NextSelectionDown else nil,
		NextSelectionLeft = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t3.NextSelectionLeft else nil,
		NextSelectionRight = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t3.NextSelectionRight else nil,
		ref = p2
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = uDim
		}),
		Button = React.createElement(if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then RoactGamepad.Focusable[Interactable] else Interactable, {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(IconSize.Regular, IconSize.Regular),
			BackgroundTransparency = 1,
			Image = v40,
			ZIndex = 2,
			SelectionImageObject = v38,
			[React.Event.Activated] = v41
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = uDim2
			})
		})
	})
end))
