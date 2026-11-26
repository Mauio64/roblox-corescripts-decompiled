local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local withStyle = UIBlox.Style.withStyle
require("@luauforge/bundled/dKT")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module = require("@luauforge/bundled/dPN")
local module2 = require("@luauforge/bundled/fCe")

local module3 = require("@luauforge/bundled/ehL")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module3.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXGeneralizeInventoryItemsList = AvatarExperienceFlags.FFlagAXGeneralizeInventoryItemsList
local fFlagAXAddInventoryItemsListProps = AvatarExperienceFlags.FFlagAXAddInventoryItemsListProps

local module5 = require("@luauforge/bundled/fAe")

local module6 = require("@luauforge/deferred/haz")

local module7 = require("@luauforge/deferred/haO")

local module8 = require("@luauforge/deferred/hcw")

local module9 = require("@luauforge/deferred/hcy")
local module10 = require("@luauforge/deferred/hcA")

local module11 = require("@luauforge/deferred/hcH")
local v5

if game:DefineFastFlag("AXRefactorScalesPageToFunctional2", false) then
	v5 = require("@luauforge/deferred/het")
else
	v5 = require("@luauforge/deferred/heB")
end

local module12 = require("@luauforge/bundled/dRr")

local fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad

local fFlagAXItemsViewContentSizeBinding = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXItemsViewContentSizeBinding

local fFlagAXMigrateOutfitsToUserInventory = AvatarExperienceFlags.FFlagAXMigrateOutfitsToUserInventory

local extended = Roact.PureComponent:extend("CategoryContent")

local navigateBacksByButtonB = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack
}

local function useFocusNavigationBindings(frameRef, callback)
	local v6 = ReactFocusNavigation.useEventMap(navigateBacksByButtonB, frameRef)
	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p2)
					callback()
				end)
			}
		}
	end, { callback })
	return ReactFocusNavigation.useEventHandlerMap(v7, v6)
end

function extended:init()
	self.isMounted = false

	self.connections = {}
	self.isTouched = false
	self.ref = Roact.createRef()

	self.state = { enableNavigation = true }

	function self.lockNavigationCallback()
		if not self.isMounted then
			return
		end

		self:setState({ enableNavigation = false })
	end

	function self.unlockNavigationCallback()
		if not self.isMounted then
			return
		end

		self:setState({ enableNavigation = true })
	end
end

function extended:renderWithProviders(p2)
	local theme = p2.Theme

	local categoryInfo = self.props.categoryInfo
	local subcategoryFilter = self.props.subcategoryFilter
	local size = self.props.size or UDim2.new(1, 0, 1, -module.PeekHeaderHeight)

	local v6 = nil

	if categoryInfo.PageType == module.PageType.Emotes then
		v6 = Roact.createElement(module9, {
			enableNavigation = self.state.enableNavigation,
			lockNavigationCallback = self.lockNavigationCallback,
			unlockNavigationCallback = self.unlockNavigationCallback,
			categoryInfo = categoryInfo,
			NextSelectionUp = self.props.NextSelectionUp,
			restorePreviousChildFocus = self.props.restorePreviousChildFocus
		})
	elseif categoryInfo.PageType == module.PageType.BodyStyle then
		v6 = Roact.createElement(v5, {
			enableNavigation = self.state.enableNavigation,
			lockNavigationCallback = self.lockNavigationCallback,
			unlockNavigationCallback = self.unlockNavigationCallback,
			NextSelectionUp = self.props.NextSelectionUp,
			onCanvasPositionChanged = self.props.onContentScroll
		})
	elseif categoryInfo.PageType == module.PageType.BodyColors then
		local createElement = Roact.createElement

		local v9 = if fFlagAXItemsViewContentSizeBinding then UDim2.new(1, 0, 1, -module.PeekHeaderHeight) else size
		v6 = createElement(module6, {
			Size = v9,
			onContentScroll = self.props.onContentScroll,
			NextSelectionUp = self.props.NextSelectionUp
		})
	elseif categoryInfo.PageType == module.PageType.Avatars then
		v6 = Roact.createElement(
			module8,
			fFlagAXMigrateOutfitsToUserInventory and { categoryInfo = categoryInfo } or nil
		)
	elseif categoryInfo.PageType == module.PageType.MakeupLooks then
		v6 = Roact.createElement(
			module7,
			fFlagAXMigrateOutfitsToUserInventory and { categoryInfo = categoryInfo } or nil
		)
	elseif categoryInfo.RenderItemTiles then
		if module12() then
			if fFlagAXGeneralizeInventoryItemsList then
				if fFlagAXAddInventoryItemsListProps then
					v6 = Roact.createElement(
						Foundation.View,
						{ tag = "size-full bg-surface-0 padding-x-medium" },
						{ Roact.createElement(module11, {
								categoryInfo = categoryInfo,
								subcategoryFilter = subcategoryFilter,
								showRecommendedItems = true,
								onContentScroll = self.props.onContentScroll
							}) }
					)
				else
					v6 = Roact.createElement(
						Foundation.View,
						{ tag = "size-full bg-surface-0 padding-x-medium" },
						{ InventoryItemsListContainer = Roact.createElement(module11) }
					)
				end
			elseif fFlagAXAddInventoryItemsListProps then
				v6 = Roact.createElement(module11, {
					categoryInfo = categoryInfo,
					subcategoryFilter = subcategoryFilter,
					showRecommendedItems = true,
					onContentScroll = self.props.onContentScroll
				})
			else
				v6 = Roact.createElement(module11)
			end
		else
			v6 = Roact.createElement(module10, {
				backToTopSignal = self.props.backToTopSignal,
				NextSelectionUp = self.props.NextSelectionUp,
				tagBasedImpressionsDetectorExtensions = {}
			})
		end
	end

	local v7

	if fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then
		v7 = self.props.focusNavigationRef
	else
		v7 = self.props.frameRef
	end

	local createElement = Roact.createElement

	if fFlagAXItemsViewContentSizeBinding then
		size = self.props.Size
	end

	return createElement("Frame", {
		Active = true,
		Size = size,
		BorderSizePixel = 0,
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BackgroundTransparency = theme.BackgroundDefault.Transparency,
		LayoutOrder = self.props.LayoutOrder,
		[Roact.Ref] = v7 or self.ref
	}, { PageContent = v6 })
end

function extended:render()
	return withStyle(function(p2)
		return self:renderWithProviders(p2)
	end)
end

function extended:didMount()
	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false
	self:disconnectListeners()
end

function extended:disconnectListeners()
	for k, connection in self.connections do
		connection:disconnect()
	end

	self.connections = {}
	self.isTouched = false
end

function extended:didUpdate(p2, p3)
	local name = self.props.avatarRoute.current.name
	local name2 = p2.avatarRoute.current.name

	if name == avatarScreen.AvatarEditor and name ~= name2 then
		local touchMovedConnection = UserInputService.TouchMoved:Connect(function(...)
			self:onTouchMoved(...)
		end)
		local touchSwipeConnection = UserInputService.TouchSwipe:Connect(function(...)
			self:onTouchSwipe(...)
		end)
		self.connections[#self.connections + 1] = touchMovedConnection
		self.connections[#self.connections + 1] = touchSwipeConnection
	elseif name2 == avatarScreen.AvatarEditor and name ~= avatarScreen.AvatarEditor and name ~= name2 then
		self:disconnectListeners()
	end
end

function extended:onTouchMoved(p2, p3)
	self.isTouched = false
	local v6

	if fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then
		v6 = self.props.focusNavigationRef
	else
		v6 = self.props.frameRef
	end

	local current = v6 and v6.current or self.ref.current

	if not (current and self.state.enableNavigation) then
		return
	end

	local absolutePosition = current.AbsolutePosition
	local absoluteSize = current.AbsoluteSize

	local vector2 = Vector2.new(absolutePosition.X + absoluteSize.X, absolutePosition.Y + absoluteSize.Y)

	if
		p2.Position.X > current.AbsolutePosition.X
		and p2.Position.Y > current.AbsolutePosition.Y
		and p2.Position.X < vector2.X
		and p2.Position.Y < vector2.Y
	then
		self.isTouched = true
	end
end

function extended:onTouchSwipe(p2, p3, p4)
	if not (p3 == 1 and (self.isTouched and self.state.enableNavigation)) then
		return
	end

	if p2 == Enum.SwipeDirection.Right then
		if self.props.navigateLeft then
			self.props.navigateLeft()
		end
	elseif p2 == Enum.SwipeDirection.Left and self.props.navigateRight then
		self.props.navigateRight()
	end
end

local v6 = roactServices.connect({
	avatarExperienceAnalytics = avatarExperienceAnalyticsService
})(extended)

local function mapStateToProps(p2, p3)
	local avatarEditorCategoryInfoFromState = module2.getAvatarEditorCategoryInfoFromState(p2)

	local v7 = if fFlagAXGeneralizeInventoryItemsList then module2.getAvatarEditorSubcategoryFilterFromState(p2) else nil

	return {
		categoryInfo = avatarEditorCategoryInfoFromState,
		subcategoryFilter = v7,
		deviceOrientation = p2.DeviceOrientation,
		screenSize = p2.ScreenSize
	}
end

local v7 = module5((RoactRodux.connect(mapStateToProps, nil)(v6)))

if fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then
	return function(props)
		local v8 = useFocusGuiObject()
		local v9 = React.useCallback(function()
			if props.NextSelectionUp and v8 and props.NextSelectionUp.current then
				v8(props.NextSelectionUp.current)
			end
		end, { props.NextSelectionUp, props.buttonBInputRef, v8 })

		local v10 = useFocusNavigationBindings(props.frameRef, v9)

		local v12 = useTableWrappedCallbackRef((React.useCallback(function(current)
			if type(v10) == "function" then
				v10(current)
			elseif type(v10) == "table" then
				v10.current = current
			end

			if props.defaultFocusRef then
				props.defaultFocusRef(current)
			end
		end, { props.defaultFocusRef, v10 })))

		return React.createElement(v7, Cryo.Dictionary.join(props, {
			focusNavigationRef = v12
		}))
	end
end

return function(p2)
	return React.createElement(v7, p2)
end
