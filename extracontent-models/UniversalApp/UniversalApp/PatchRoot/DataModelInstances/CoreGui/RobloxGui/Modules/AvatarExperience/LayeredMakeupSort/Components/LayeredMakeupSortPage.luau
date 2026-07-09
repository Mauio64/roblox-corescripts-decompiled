local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Modules = CoreGui.RobloxGui.Modules
local VerticalClothingList = require(Modules.AvatarExperience.LayeredClothingSort.Components.VerticalClothingList)
local ResetButton = require(Modules.AvatarExperience.LayeredClothingSort.Components.ResetButton)
local SceneInteractionFrame = require(Modules.AvatarExperience.Common.Components.Scene.SceneInteractionFrame)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local VRAvatarRotateHandler = require(Modules.AvatarExperience.Common.Components.Scene.VRAvatarRotateHandler)
local Constants = require(Modules.AvatarExperience.AvatarRefinement.Constants)
local RefinementNavBar = require(Modules.AvatarExperience.AvatarRefinement.Components.RefinementNavBar)
local RefinementControlBar = require(Modules.AvatarExperience.AvatarRefinement.Components.RefinementControlBar)
local v19 = if not require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateSceneGamepadHandlerInputBindings then require(Modules.AvatarExperience.Common.Components.Scene.SceneGamepadHandler_DEPRECATED) else require(Modules.AvatarExperience.Common.Components.Scene.SceneGamepadHandler)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local t1 = {
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonY] = FocusNavigationEventNameEnum.OpenLayeredMakeupSortResetPrompt
}

local function useFocusNavigationBindings(p1, p2: ((...any) -> ...any), p3: ((...any) -> ...any)?) -- line: 68
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v34 = ReactFocusNavigation.useEventMap(t1, p1)
	local v35 = React.useMemo(function() -- line: 70
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy), p3 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p4) -- line: 73
					-- upvalues: p2 (copy)
					p4.cancelled = true
					p2()
				end)
			},
			[FocusNavigationEventNameEnum.OpenLayeredMakeupSortResetPrompt] = if not p3 then nil else {
				handler = InputHandlers.onRelease(p3)
			}
		}
	end, {
		p2,
		p3
	})

	return ReactFocusNavigation.useEventHandlerMap(v35, v34)
end

local v29 = Images["icons/menu/about_large"]
local uDim = UDim.new(0, 10)

return function(p5) -- line: 92
	-- upvalues: useStyle (copy), useTokens (copy), React (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), SceneInteractionFrame (copy), RoactGamepad (copy), VerticalClothingList (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), ResetButton (copy), VRAvatarRotateHandler (copy), Constants (copy), uDim (copy), ImageSetLabel (copy), v29 (copy), v19 (copy), TopBar (copy), GetFFlagAXEnableSlotBasedEditor (copy), RefinementControlBar (copy), RefinementNavBar (copy)
	local v37 = useStyle()
	local v38 = useTokens()
	local v39 = React.useRef(nil)
	local v40 = React.useRef(nil)
	local v41 = useFocusNavigationBindings(v39, p5.onGoBack, if not (#p5.equippedLayeredMakeupAssetIdsOrdered > 0) then nil else p5.onOpenResetPrompt)
	local v42 = useTableWrappedCallbackRef(v41)
	local v43 = not (#p5.equippedLayeredMakeupAssetIdsOrdered > 0) and #p5.equippedLayeredMakeupAssetIdsOrdered == 0
	local v44 = React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = UDim2.new(1, 0, 1, -p5.topBarHeight),
		Position = UDim2.fromOffset(0, p5.topBarHeight)
	}, {
		SceneInteractionFrame = React.createElement(SceneInteractionFrame),
		VerticalClothingList = not v43 and React.createElement(RoactGamepad.Focusable[VerticalClothingList], {
			lastInputIsGamepad = p5.isGamepad,
			topBarRef = v40,
			focusControllerProp = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.createFocusController() else nil,
			onDragChange = p5.onDragChange
		}),
		ResetButton = not v43 and React.createElement(ResetButton, {
			lastInputIsGamepad = p5.isGamepad,
			isDragging = p5.isDragging
		}),
		VRAvatarRotateHandler = if not p5.isSpatial then nil else React.createElement(VRAvatarRotateHandler),
		NoItemsMessage = v43 and React.createElement("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, Constants.NoItem.BottomPadding),
			Size = if not p5.isSpatial then UDim2.new(1, 0, 0, 100) else UDim2.new(1, 0, 0, 50),
			BackgroundColor3 = v37.Theme.BackgroundDefault.Color,
			BackgroundTransparency = not p5.isSpatial and 1 or 0
		}, {
			UICorner = if not p5.isSpatial then nil else React.createElement("UICorner", {
				CornerRadius = uDim
			}),
			NoItemsTextLabel = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				AutomaticSize = Enum.AutomaticSize.XY,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0, 0),
				Text = p5.localized.noItemText,
				Font = v37.Font.CaptionHeader.Font,
				TextSize = v38.Typography.BodyMedium.FontSize,
				TextColor3 = v37.Theme.IconEmphasis.Color,
				TextXAlignment = Enum.TextXAlignment.Left
			}, {
				NoItemsIcon = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = v29,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(0, -2, 0.5, 0),
					Size = UDim2.fromOffset(Constants.NoItem.IconSize, Constants.NoItem.IconSize),
					ImageColor3 = v37.Theme.IconEmphasis.Color
				})
			})
		})
	})

	if p5.isSpatial then
		return v44
	end

	return React.createElement(RoactGamepad.Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ref = v42
	}, {
		SceneGamepadHandler = React.createElement(v19, nil, {
			TopBar = React.createElement(TopBar.Container, {
				transparentBackground = true,
				ZIndex = 1,
				titleText = p5.localized.makeupSorting,
				hideSiteMessageBanner = p5.isPortrait,
				leftItem = p5.backButton,
				ref = v40
			}),
			RefinementControlBar = if not GetFFlagAXEnableSlotBasedEditor() then nil else React.createElement(RefinementControlBar, {
				hideUndoRedo = true
			}),
			RefinementNavBar = if not GetFFlagAXEnableSlotBasedEditor() then React.createElement(RefinementNavBar) else nil,
			LayeredMakeupSortPageFrame = v44
		})
	})
end
