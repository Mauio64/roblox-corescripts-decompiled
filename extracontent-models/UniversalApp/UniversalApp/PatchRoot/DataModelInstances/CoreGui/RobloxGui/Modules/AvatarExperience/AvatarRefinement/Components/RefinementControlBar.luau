local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceControlBar = require(CorePackages.Workspace.Packages.AvatarExperienceControlBar)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local selectTopBarHeight = require(Modules.LuaApp.Components.TopBar.Utils.selectTopBarHeight)
local useTokens = Foundation.Hooks.useTokens
local useAvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Hooks.useAvatarRoute
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local AdvancedCustomizationControlBar = AvatarExperienceControlBar.AdvancedCustomizationControlBar
local UndoRedoBar = AvatarExperienceControlBar.UndoRedoBar
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXResetAvatarButton = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXResetAvatarButton

local function RefinementControlBar(t1: {[any]: any}, p1) -- line: 34
	-- upvalues: useTokens (copy), useAvatarRoute (copy), useSelector (copy), selectIsPortrait (copy), selectTopBarHeight (copy), React (copy), Foundation (copy), AdvancedCustomizationControlBar (copy), FFlagAXRootSlotBasedEditorFlag (copy), FFlagAXResetAvatarButton (copy), UndoRedoBar (copy)
	local v19 = useTokens()
	local v20 = useAvatarRoute()
	local v21 = useSelector(selectIsPortrait)
	local v22 = useSelector(selectTopBarHeight)

	return React.createElement(Foundation.View, {
		tag = "auto-xy col gap-medium",
		ZIndex = 2,
		ref = p1,
		Position = if not v21 then UDim2.new(0, v19.Size.Size_700, 0, v22 + v19.Size.Size_500) else UDim2.fromOffset(v19.Size.Size_500, v22),
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown,
		NextSelectionLeft = t1.NextSelectionLeft,
		NextSelectionRight = t1.NextSelectionRight
	}, {
		AdvancedCustomizationControlBar = React.createElement(AdvancedCustomizationControlBar, {
			LayoutOrder = 1,
			avatarRoute = v20
		}),
		UndoRedoBar = if not FFlagAXRootSlotBasedEditorFlag or (FFlagAXResetAvatarButton or t1.hideUndoRedo) then nil else React.createElement(UndoRedoBar, {
			direction = "vertical",
			LayoutOrder = 2
		})
	})
end

return React.memo(React.forwardRef(RefinementControlBar))
