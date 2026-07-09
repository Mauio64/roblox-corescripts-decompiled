local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local useStyle = UIBlox.Core.Style.useStyle
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useProperty = require(CorePackages.Workspace.Packages.GuiObjectUtils).useProperty
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useAppliedDescriptionValueContext = require(Modules.AvatarExperience.Common.Context.AppliedDescription.useAppliedDescriptionValueContext)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local withNavigationFocus = require(CorePackages.Packages.RoactNavigation).withNavigationFocus
local withAppRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAppRoute)
local AccessoryAdjustmentUtils = require(Modules.AvatarExperience.AccessoryAdjustment.AccessoryAdjustmentUtils)
local LoadableImage = UIBlox.App.Loading.LoadableImage
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = UserLib.Utils.Constants
local SetSelectedAccessory = require(Modules.AvatarExperience.AccessoryAdjustment.Actions.SetSelectedAccessory)
local Constants2 = require(Modules.AvatarExperience.AvatarRefinement.Constants)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local Analytics = require(Modules.AvatarExperience.AccessoryAdjustment.Services.Analytics)
local SendRefinementAnalytics = require(Modules.AvatarExperience.AccessoryAdjustment.Thunks.SendRefinementAnalytics)
local Constants3 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local v31 = game:DefineFastFlag("AXVerticalDrawerCropTiles", false)
local v32 = game:DefineFastFlag("AXFixUndoRedoAccessoryAdjustment", false)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local uDim = UDim.new(0, 6)

local function selectTopbarHeight(p1) -- line: 67
	return p1.TopBar.topBarHeight
end
local function selectMaxScreenHeight(p2) -- line: 71
	-- upvalues: v31 (copy)
	local GlobalGuiInset = p2.GlobalGuiInset
	local ScreenSize = p2.ScreenSize
	local topBarHeight = p2.TopBar.topBarHeight
	local v46 = ScreenSize.Y - topBarHeight - GlobalGuiInset.bottom - GlobalGuiInset.top - 32 - 48

	if v31 and (v46 - 16) % 50 < 12.5 then
		v46 -= 25
	end

	return v46
end
local function selectAllowedAATypes(p3) -- line: 92
	-- upvalues: Constants3 (copy)
	return p3.AvatarExperience.AvatarEditor.AvatarSettings[Constants3.AvatarSettings.accessoryRefinementTypes]
end
local function getChildren(p4, p5, p6) -- line: 96
	-- upvalues: useSelector (copy), selectAllowedAATypes (copy), useAppliedDescriptionValueContext (copy), AccessoryAdjustmentUtils (copy), useStyle (copy), useDispatch (copy), useRoactService (copy), Analytics (copy), useSelectionCursor (copy), CursorKind (copy), React (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), v32 (copy), Roact (copy), Focusable (copy), AvatarScreen (copy), SendRefinementAnalytics (copy), SetSelectedAccessory (copy), LoadableImage (copy), uDim (copy)
	local t1 = {}
	local v52 = useSelector(selectAllowedAATypes)
	local v53 = useAppliedDescriptionValueContext().appliedDescriptionBinding:getValue()

	if v53 then
		t1 = AccessoryAdjustmentUtils.getAdjustableAccessories(v53, v52)
	end

	local t2 = {}
	local Theme = useStyle().Theme
	local v56 = useDispatch()
	local v57 = useRoactService(Analytics)
	local v58 = useSelectionCursor(CursorKind.RoundedRectNoInset)

	t2.UIListLayout = React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, 8),
		ref = p4
	})
	t2.UIPadding = React.createElement("UIPadding", {
		PaddingTop = UDim.new(0, 16),
		PaddingBottom = UDim.new(0, 16),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8)
	})

	for v59, v60 in t1 do
		local Asset = Constants.RbxthumbTypes.Asset
		local v62 = getRbxthumbWithTypeSizeAndOptions(v60, Asset, 150)

		t2[if not v32 then v60 else v59] = Roact.createElement(Focusable.ImageButton, {
			Size = UDim2.fromOffset(50, 50),
			BackgroundTransparency = 1,
			SizeConstraint = Enum.SizeConstraint.RelativeXX,
			LayoutOrder = v59,
			ref = p5[v59],
			[Roact.Event.Activated] = function() -- line: 141
				-- upvalues: p6 (copy), AvatarScreen (copy), v56 (copy), SendRefinementAnalytics (copy), v57 (copy), SetSelectedAccessory (copy), v60 (copy)
				p6.navigation.navigate(AvatarScreen.AdjustAccessoryView)
				v56(SendRefinementAnalytics(v57.avatarRefineAccessoryStart))
				v56(SetSelectedAccessory(v60))
			end,
			NextSelectionDown = v59 < #t1 and p5[v59 + 1] or nil,
			NextSelectionUp = v59 > 1 and p5[v59 - 1] or nil,
			SelectionImageObject = v58
		}, {
			BackgroundImage = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 0,
				BackgroundColor3 = Theme.PlaceHolder.Color,
				BackgroundTransparency = Theme.PlaceHolder.Transparency,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1)
			}, {
				Image = Roact.createElement(LoadableImage, {
					BackgroundTransparency = 1,
					ZIndex = 0,
					showFailedStateWhenLoadingFailed = true,
					useShimmerAnimationWhileLoading = true,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = v62,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.fromScale(1, 1),
					cornerRadius = uDim
				}),
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = uDim
				})
			})
		})
	end

	return t2
end
local function VerticalDrawer(t3: {[any]: any}) -- line: 182
	-- upvalues: useStyle (copy), RoactGamepad (copy), React (copy), useProperty (copy), useSelector (copy), selectMaxScreenHeight (copy), getChildren (copy), selectTopbarHeight (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), IsVRAppBuild (copy), Constants2 (copy)
	local Theme = useStyle().Theme
	local forwardRef = t3.forwardRef
	local v66 = RoactGamepad.useRefCache()
	local v67 = React.useRef(nil)
	local v68 = useProperty(v67, "AbsoluteContentSize") or Vector2.new(0, 0)

	local function useVerticalDrawerHeight() -- line: 194
		-- upvalues: useSelector (copy), selectMaxScreenHeight (copy), v68 (copy)
		return (math.min(useSelector(selectMaxScreenHeight), v68.Y + 32))
	end

	local v70 = math.min(useSelector(selectMaxScreenHeight), v68.Y + 32)
	local v71 = getChildren(v67, v66, t3)
	local v72 = useSelector(selectTopbarHeight)

	return React.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		ClipsDescendants = true,
		ZIndex = 3,
		AnchorPoint = if not IsVRAppBuild() then Vector2.new(1, 0) else Vector2.new(1, 0),
		Size = UDim2.new(0, 66, 0, v70),
		Position = if not IsVRAppBuild() then UDim2.new(1, -Constants2.RightMargin, 0, v72) else UDim2.new(1, 0, 0, Constants2.Tile.MoreIconSize + Constants2.VerticalList.Padding),
		BackgroundColor3 = Theme.BackgroundMuted.Color,
		BackgroundTransparency = Theme.BackgroundMuted.Transparency,
		defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then v66[1] else nil,
		ref = forwardRef,
		NextSelectionLeft = if not FFlagAXMigrateAXToGlobalAutofocus then t3.NextSelectionLeft else nil,
		restorePreviousChildFocus = not FFlagAXMigrateAXToGlobalAutofocus or nil
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		ScrollingFrame = React.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			ScrollBarThickness = 0,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(1, 0, 0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Size = UDim2.fromScale(1, 1),
			Selectable = not FFlagAXMigrateAXToGlobalAutofocus and nil
		}, v71)
	})
end

local u40 = withNavigationFocus((withAppRoute(VerticalDrawer)))

return Roact.forwardRef(function(p7, p8) -- line: 238
	-- upvalues: Roact (copy), u40 (ref), Cryo (copy)
	return Roact.createElement(u40, Cryo.Dictionary.join(p7, {
		forwardRef = p8
	}))
end)
