local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Focusable = RoactGamepad.Focusable
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local useStyle = UIBlox.Core.Style.useStyle
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useHeadRefinementEntryTooltip = require(Modules.AvatarExperience.AvatarRefinement.HeadRefinement.Hooks.useHeadRefinementEntryTooltip)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local withNavigationFocus = require(CorePackages.Packages.RoactNavigation).withNavigationFocus
local withAppRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAppRoute)
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local IconSize = UIBlox.App.Constant.IconSize
local Analytics = require(Modules.AvatarExperience.LayeredClothingSort.Services.Analytics)
local NavigateIntoRefinementPage = require(Modules.AvatarExperience.LayeredClothingSort.Thunks.NavigateIntoRefinementPage)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local FFlagAXMigrateQuickButtonsToGlobalAutoFocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateQuickButtonsToGlobalAutoFocus
local v29 = Images["icons/actions/adjust"]

local function isVisible(p1) -- line: 64
	-- upvalues: Utils (copy)
	return (Utils.isAvatarSceneButtonsVisible(p1.avatarRoute, p1.isFocused, p1.isUIFullView, p1.isSceneFullView, p1.navigation))
end
local function RefinementEntryButton(t1: {[any]: any}) -- line: 75
	-- upvalues: useDispatch (copy), useStyle (copy), FFlagAXMigrateQuickButtonsToGlobalAutoFocus (copy), React (copy), useRoactService (copy), Analytics (copy), useIsSpatial (copy), useSelectionCursor (copy), CursorKind (copy), useLocalization (copy), useHeadRefinementEntryTooltip (copy), Utils (copy), NavigateIntoRefinementPage (copy), ImageSetButton (copy), Focusable (copy), IconSize (copy), v29 (copy), Roact (copy), withTooltip (copy), TooltipOrientation (copy), CoreGui (copy)
	local v35 = useDispatch()
	local Theme = useStyle().Theme
	local v37 = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then React.useRef(nil) else nil
	local forwardRef = t1.forwardRef
	local v39 = useRoactService(Analytics)
	local v40 = useIsSpatial()
	local v41 = useSelectionCursor(CursorKind.RoundedRect)
	local v42 = useLocalization({
		headRefinementTooltip = "Feature.Avatar.Label.HeadRefinement.Adjust.Tooltip"
	})
	local v43, v44 = useHeadRefinementEntryTooltip({
		avatarRoute = t1.avatarRoute,
		shouldBeVisible = Utils.isAvatarSceneButtonsVisible(t1.avatarRoute, t1.isFocused, t1.isUIFullView, t1.isSceneFullView, t1.navigation)
	})
	local v45 = React.useCallback(function() -- line: 95
		-- upvalues: v43 (copy), v44 (copy), v35 (copy), NavigateIntoRefinementPage (copy), t1 (copy), v39 (copy)
		if v43 and v44 then
			v44({
				saveDismissTime = true
			})
		end

		v35(NavigateIntoRefinementPage(t1.navigation, t1.avatarRoute, v39))
	end, {
		t1.navigation,
		t1.avatarRoute,
		v39,
		v44,
		v43
	})

	local function renderImageSetButton(p2: ((...any) -> ...any)?, p3: ((...any) -> ...any)?) -- line: 116
		-- upvalues: React (copy), FFlagAXMigrateQuickButtonsToGlobalAutoFocus (copy), ImageSetButton (copy), Focusable (copy), IconSize (copy), v29 (copy), Theme (copy), v45 (copy), Roact (copy), v37 (copy), t1 (copy), v41 (copy)
		return React.createElement(if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then Focusable[ImageSetButton] else ImageSetButton, {
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(IconSize.Regular, IconSize.Regular),
			BackgroundTransparency = 1,
			Image = v29,
			ImageColor3 = Theme.IconEmphasis.Color,
			ImageTransparency = 0,
			[React.Event.Activated] = v45,
			[Roact.Change.AbsoluteSize] = p2,
			[Roact.Change.AbsolutePosition] = p3,
			[Roact.Ref] = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then v37 else nil,
			NextSelectionLeft = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionLeft else nil,
			NextSelectionDown = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionDown else nil,
			NextSelectionUp = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionUp else nil,
			SelectionImageObject = v41
		})
	end
	local function renderImageSetButtonWithHeadRefinementTooltip() -- line: 146
		-- upvalues: withTooltip (copy), v42 (copy), TooltipOrientation (copy), CoreGui (copy), v43 (copy), renderImageSetButton (copy)
		return withTooltip({
			useLargeDropShadow = true,
			bodyText = v42.headRefinementTooltip
		}, {
			preferredOrientation = TooltipOrientation.Right,
			guiTarget = CoreGui,
			active = v43
		}, function(p4) -- line: 154
			-- upvalues: renderImageSetButton (copy)
			return renderImageSetButton(p4, p4)
		end)
	end

	return React.createElement(if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then Focusable.Frame else "Frame", {
		Size = UDim2.fromOffset(44, 44),
		Visible = Utils.isAvatarSceneButtonsVisible(t1.avatarRoute, t1.isFocused, t1.isUIFullView, t1.isSceneFullView, t1.navigation),
		BackgroundColor3 = Theme.BackgroundMuted.Color,
		BackgroundTransparency = Theme.BackgroundMuted.Transparency,
		LayoutOrder = t1.layoutOrder,
		[Roact.Ref] = forwardRef,
		defaultChild = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then v37 else nil
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		Image = if v40 then React.createElement(if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then Focusable[ImageSetButton] else ImageSetButton, {
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(IconSize.Regular, IconSize.Regular),
			BackgroundTransparency = 1,
			Image = v29,
			ImageColor3 = Theme.IconEmphasis.Color,
			ImageTransparency = 0,
			ZIndex = 2,
			[React.Event.Activated] = v45,
			[Roact.Ref] = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then v37 else nil,
			NextSelectionLeft = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionLeft else nil,
			SelectionImageObject = v41
		}) else renderImageSetButtonWithHeadRefinementTooltip()
	})
end

local u32 = withNavigationFocus((withAppRoute(RefinementEntryButton)))

return Roact.forwardRef(function(p5, p6) -- line: 199
	-- upvalues: Roact (copy), u32 (ref), Cryo (copy)
	return Roact.createElement(u32, Cryo.Dictionary.join(p5, {
		forwardRef = p6
	}))
end)
