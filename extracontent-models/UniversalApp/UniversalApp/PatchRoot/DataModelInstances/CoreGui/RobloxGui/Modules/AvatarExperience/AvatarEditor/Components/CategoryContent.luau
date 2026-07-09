local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local withStyle = UIBlox.Style.withStyle

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXGeneralizeInventoryItemsList = AvatarExperienceFlags.FFlagAXGeneralizeInventoryItemsList
local FFlagAXAddInventoryItemsListProps = AvatarExperienceFlags.FFlagAXAddInventoryItemsListProps
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local BodyColorsFrame = require(Modules.AvatarExperience.AvatarEditor.Components.BodyColorsFrame)
local AvatarSwitcherFrame = require(Modules.AvatarExperience.AvatarEditor.Components.AvatarSwitcherFrame)
local MakeupOutfitSwitcherFrame = require(Modules.AvatarExperience.OutfitSwitcher.MakeupOutfitSwitcherFrame.MakeupOutfitSwitcherFrame)
local useAvatarSwitcherFrameProps = require(Modules.AvatarExperience.AvatarEditor.Components.useAvatarSwitcherFrameProps)
local AvatarSwitcherFrameContainer = require(Modules.AvatarExperience.AvatarEditor.Components.AvatarSwitcherFrameContainer)
local AvatarOutfitSwitcherFrame = require(Modules.AvatarExperience.OutfitSwitcher.AvatarOutfitSwitcherFrame.AvatarOutfitSwitcherFrame)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local v36 = if not (GetFFlagAXEnableSlotBasedEditor() and game:DefineFastFlag("AXRefactorEmotesPageToFunctional2", false)) then require(Modules.AvatarExperience.AvatarEditor.Components.EmotesPage_DEPRECATED) else require(Modules.AvatarExperience.AvatarEditor.Components.EmotesPage)
local ItemsList = require(Modules.AvatarExperience.AvatarEditor.Components.ItemsList)
local InventoryItemsListContainer = require(Modules.AvatarExperience.SlotBasedEditor.Components.InventoryItemsList.InventoryItemsListContainer)
local v39 = if not (GetFFlagAXEnableSlotBasedEditor() and game:DefineFastFlag("AXRefactorScalesPageToFunctional2", false)) then require(Modules.AvatarExperience.AvatarEditor.Components.ScalesPage_DEPRECATED) else require(Modules.AvatarExperience.AvatarEditor.Components.ScalesPage)
local GetFFlagAXEnableNewInventoryItemsList = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableNewInventoryItemsList)
local FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad
local FFlagAXItemsViewContentSizeBinding = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXItemsViewContentSizeBinding
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagLuaAppsDefaultSelection = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppsDefaultSelection
local v47 = Roact.PureComponent:extend("CategoryContent")
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack
}

local function useFocusNavigationBindings(p1, p2: ((...any) -> ...any)) -- line: 101
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v55 = ReactFocusNavigation.useEventMap(t1, p1)
	local v56 = React.useMemo(function() -- line: 103
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(_) -- line: 106
					-- upvalues: p2 (copy)
					p2()
				end)
			}
		}
	end, { p2 })

	return ReactFocusNavigation.useEventHandlerMap(v56, v55)
end

function v47.init(p4) -- line: 116
	-- upvalues: Roact (copy)
	p4.isMounted = false
	p4.connections = {}
	p4.isTouched = false
	p4.ref = Roact.createRef()
	p4.state = {
		enableNavigation = true
	}

	function p4.lockNavigationCallback() -- line: 127
		-- upvalues: p4 (copy)
		if not p4.isMounted then
			return
		end

		p4:setState({
			enableNavigation = false
		})
	end
	function p4.unlockNavigationCallback() -- line: 137
		-- upvalues: p4 (copy)
		if not p4.isMounted then
			return
		end

		p4:setState({
			enableNavigation = true
		})
	end
end
function v47.renderWithProviders(p5, p6, p7) -- line: 150
	-- upvalues: Constants (copy), Roact (copy), v36 (copy), v39 (copy), GetFFlagAXEnableSlotBasedEditor (copy), BodyColorsFrame (copy), FFlagAXItemsViewContentSizeBinding (copy), FFlagAXCustomizeMakeupSupport (copy), AvatarOutfitSwitcherFrame (copy), FFlagAXInventoryDurablesSupport (copy), AvatarSwitcherFrameContainer (copy), AvatarSwitcherFrame (copy), MakeupOutfitSwitcherFrame (copy), GetFFlagAXEnableNewInventoryItemsList (copy), FFlagAXGeneralizeInventoryItemsList (copy), FFlagAXAddInventoryItemsListProps (copy), Foundation (copy), InventoryItemsListContainer (copy), ItemsList (copy), FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), RoactGamepad (copy)
	local Theme = p6.Theme
	local categoryInfo = p5.props.categoryInfo
	local subcategoryFilter = p5.props.subcategoryFilter
	local v64 = p5.props.size or UDim2.new(1, 0, 1, -Constants.PeekHeaderHeight)
	local v65 = nil

	if categoryInfo.PageType == Constants.PageType.Emotes then
		v65 = Roact.createElement(v36, {
			enableNavigation = p5.state.enableNavigation,
			lockNavigationCallback = p5.lockNavigationCallback,
			unlockNavigationCallback = p5.unlockNavigationCallback,
			categoryInfo = categoryInfo,
			NextSelectionUp = p5.props.NextSelectionUp,
			restorePreviousChildFocus = p5.props.restorePreviousChildFocus
		})
	elseif categoryInfo.PageType == Constants.PageType.BodyStyle then
		v65 = Roact.createElement(v39, {
			enableNavigation = p5.state.enableNavigation,
			lockNavigationCallback = p5.lockNavigationCallback,
			unlockNavigationCallback = p5.unlockNavigationCallback,
			NextSelectionUp = p5.props.NextSelectionUp,
			onCanvasPositionChanged = if not GetFFlagAXEnableSlotBasedEditor() then nil else p5.props.onContentScroll
		})
	elseif categoryInfo.PageType == Constants.PageType.BodyColors then
		v65 = Roact.createElement(BodyColorsFrame, {
			Size = if not FFlagAXItemsViewContentSizeBinding then v64 else UDim2.new(1, 0, 1, -Constants.PeekHeaderHeight),
			onContentScroll = if not GetFFlagAXEnableSlotBasedEditor() then nil else p5.props.onContentScroll,
			NextSelectionUp = p5.props.NextSelectionUp
		})
	elseif GetFFlagAXEnableSlotBasedEditor() and categoryInfo.PageType == Constants.PageType.Avatars then
		v65 = Roact.createElement(if not FFlagAXCustomizeMakeupSupport then if not FFlagAXInventoryDurablesSupport then AvatarSwitcherFrame else AvatarSwitcherFrameContainer else AvatarOutfitSwitcherFrame, p5.props.avatarSwitcherProps)
	elseif FFlagAXCustomizeMakeupSupport and categoryInfo.PageType == Constants.PageType.MakeupLooks then
		v65 = Roact.createElement(MakeupOutfitSwitcherFrame)
	elseif categoryInfo.RenderItemTiles then
		v65 = if not GetFFlagAXEnableNewInventoryItemsList() then Roact.createElement(ItemsList, {
			backToTopSignal = p5.props.backToTopSignal,
			NextSelectionUp = p5.props.NextSelectionUp,
			tagBasedImpressionsDetectorExtensions = {}
		}) else if not FFlagAXGeneralizeInventoryItemsList then if not FFlagAXAddInventoryItemsListProps then Roact.createElement(InventoryItemsListContainer) else Roact.createElement(InventoryItemsListContainer, {
			showRecommendedItems = true,
			categoryInfo = categoryInfo,
			subcategoryFilter = subcategoryFilter,
			onContentScroll = if not GetFFlagAXEnableSlotBasedEditor() then nil else p5.props.onContentScroll
		}) else if not FFlagAXAddInventoryItemsListProps then Roact.createElement(Foundation.View, {
			tag = "size-full bg-surface-0 padding-x-medium"
		}, {
			InventoryItemsListContainer = Roact.createElement(InventoryItemsListContainer)
		}) else Roact.createElement(Foundation.View, {
			tag = "size-full bg-surface-0 padding-x-medium"
		}, { Roact.createElement(InventoryItemsListContainer, {
			showRecommendedItems = true,
			categoryInfo = categoryInfo,
			subcategoryFilter = subcategoryFilter,
			onContentScroll = if not GetFFlagAXEnableSlotBasedEditor() then nil else p5.props.onContentScroll
		}) })
	end

	local v66 = if not FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then p5.props.frameRef else p5.props.focusNavigationRef

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		Active = true,
		Size = if not FFlagAXItemsViewContentSizeBinding then v64 else p5.props.Size,
		BorderSizePixel = 0,
		BackgroundColor3 = Theme.BackgroundDefault.Color,
		BackgroundTransparency = Theme.BackgroundDefault.Transparency,
		LayoutOrder = p5.props.LayoutOrder,
		inputBindings = if not FFlagAXMigrateAXToGlobalAutofocus and not FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then {
			NavUp = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 251
				-- upvalues: p5 (copy), p7 (copy)
				if p5.props.NextSelectionUp then
					p7.moveFocusTo(p5.props.NextSelectionUp)
				end
			end)
		} else nil,
		[Roact.Ref] = v66 or p5.ref
	}, {
		PageContent = v65
	})
end
function v47.render(p8) -- line: 263
	-- upvalues: withStyle (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy)
	return withStyle(function(p9) -- line: 264
		-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), p8 (copy), RoactGamepad (copy)
		if FFlagAXMigrateAXToGlobalAutofocus then
			return p8:renderWithProviders(p9)
		end

		return RoactGamepad.withFocusController(function(p10) -- line: 268
			-- upvalues: p8 (copy), p9 (copy)
			return p8:renderWithProviders(p9, p10)
		end)
	end)
end
function v47.didMount(p11) -- line: 274
	p11.isMounted = true
end
function v47.willUnmount(p12) -- line: 278
	p12.isMounted = false
	p12:disconnectListeners()
end
function v47.disconnectListeners(p13) -- line: 283
	for _, v72 in p13.connections do
		v72:disconnect()
	end

	p13.connections = {}
	p13.isTouched = false
end
function v47.didUpdate(p14, p15, _) -- line: 292
	-- upvalues: AvatarScreen (copy), UserInputService (copy)
	local name = p14.props.avatarRoute.current.name
	local name2 = p15.avatarRoute.current.name

	if name == AvatarScreen.AvatarEditor and name ~= name2 then
		local connection = UserInputService.TouchMoved:Connect(function(...) -- line: 297
			-- upvalues: p14 (copy)
			p14:onTouchMoved(...)
		end)
		local connection2 = UserInputService.TouchSwipe:Connect(function(...) -- line: 300
			-- upvalues: p14 (copy)
			p14:onTouchSwipe(...)
		end)

		p14.connections[#p14.connections + 1] = connection
		p14.connections[#p14.connections + 1] = connection2

		return
	end

	if name2 == AvatarScreen.AvatarEditor and name ~= AvatarScreen.AvatarEditor and name ~= name2 then
		p14:disconnectListeners()
	end
end
function v47.onTouchMoved(p17, p18, _) -- line: 314
	-- upvalues: FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad (copy)
	p17.isTouched = false

	local v83 = if not FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then p17.props.frameRef else p17.props.focusNavigationRef
	local v84 = v83 and v83.current or p17.ref.current

	if not v84 or not p17.state.enableNavigation then
		return
	end

	local AbsolutePosition = v84.AbsolutePosition
	local AbsoluteSize = v84.AbsoluteSize
	local vector2 = Vector2.new(AbsolutePosition.X + AbsoluteSize.X, AbsolutePosition.Y + AbsoluteSize.Y)

	if p18.Position.X > v84.AbsolutePosition.X and p18.Position.Y > v84.AbsolutePosition.Y and p18.Position.X < vector2.X and p18.Position.Y < vector2.Y then
		p17.isTouched = true
	end
end
function v47.onTouchSwipe(p20, p21, p22, _) -- line: 341
	if p22 ~= 1 then
		return
	end

	if not p20.isTouched or not p20.state.enableNavigation then
		return
	end

	if p21 == Enum.SwipeDirection.Right then
		if p20.props.navigateLeft then
			p20.props.navigateLeft()

			return
		end
	elseif p21 == Enum.SwipeDirection.Left and p20.props.navigateRight then
		p20.props.navigateRight()
	end
end

local v50 = RoactServices.connect({
	avatarExperienceAnalytics = Analytics
})(v47)

local function mapStateToProps(p24, _) -- line: 365
	-- upvalues: Utils (copy), FFlagAXGeneralizeInventoryItemsList (copy)
	local v94 = Utils.getAvatarEditorCategoryInfoFromState(p24)
	local v95 = if not FFlagAXGeneralizeInventoryItemsList then nil else Utils.getAvatarEditorSubcategoryFilterFromState(p24)

	return {
		categoryInfo = v94,
		subcategoryFilter = v95,
		deviceOrientation = p24.DeviceOrientation,
		screenSize = p24.ScreenSize
	}
end

local u52 = withAvatarRoute((RoactRodux.connect(mapStateToProps, nil)(v50)))

if FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then
	return function(p26) -- line: 384
		-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), useFocusGuiObject (copy), React (copy), FFlagAXInventoryDurablesSupport (copy), FFlagAXCustomizeMakeupSupport (copy), GetFFlagAXEnableSlotBasedEditor (copy), useAvatarSwitcherFrameProps (copy), useFocusNavigationBindings (copy), FFlagLuaAppsDefaultSelection (copy), useTableWrappedCallbackRef (copy), u52 (ref), Cryo (copy)
		local v97 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useFocusController() else nil
		local v98 = if not FFlagAXMigrateAXToGlobalAutofocus then nil else useFocusGuiObject()
		local v99 = React.useCallback(function() -- line: 388
			-- upvalues: p26 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v98 (copy), v97 (copy)
			if p26.NextSelectionUp then
				if FFlagAXMigrateAXToGlobalAutofocus then
					if v98 and p26.NextSelectionUp.current then
						v98(p26.NextSelectionUp.current)

						return
					end
				else
					v97.moveFocusTo(p26.NextSelectionUp)
				end
			end
		end, {
			p26.NextSelectionUp,
			p26.buttonBInputRef,
			if not FFlagAXMigrateAXToGlobalAutofocus then v97 else v98
		})
		local v100 = if FFlagAXInventoryDurablesSupport or (FFlagAXCustomizeMakeupSupport or not GetFFlagAXEnableSlotBasedEditor()) then nil else useAvatarSwitcherFrameProps()
		local v101 = useFocusNavigationBindings(p26.frameRef, v99)
		local v102 = nil

		if FFlagLuaAppsDefaultSelection then
			v102 = React.useCallback(function(p27) -- line: 420
				-- upvalues: v101 (copy), p26 (copy)
				if type(v101) == "function" then
					v101(p27)
				elseif type(v101) == "table" then
					v101.current = p27
				end

				if p26.defaultFocusRef then
					p26.defaultFocusRef(p27)
				end
			end, {
				p26.defaultFocusRef,
				v101
			})
		end

		local v103 = useTableWrappedCallbackRef(if not FFlagLuaAppsDefaultSelection then v101 else v102)

		return React.createElement(u52, Cryo.Dictionary.join(p26, {
			avatarSwitcherProps = if FFlagAXInventoryDurablesSupport or FFlagAXCustomizeMakeupSupport then nil else v100,
			focusNavigationRef = v103
		}))
	end
end

if GetFFlagAXEnableSlotBasedEditor() then
	return function(p28) -- line: 446
		-- upvalues: FFlagAXInventoryDurablesSupport (copy), FFlagAXCustomizeMakeupSupport (copy), React (copy), u52 (ref), useAvatarSwitcherFrameProps (copy), Cryo (copy)
		if FFlagAXInventoryDurablesSupport or FFlagAXCustomizeMakeupSupport then
			return React.createElement(u52, p28)
		end

		local v105 = useAvatarSwitcherFrameProps()

		return React.createElement(u52, Cryo.Dictionary.join(p28, {
			avatarSwitcherProps = v105
		}))
	end
end

return u52
