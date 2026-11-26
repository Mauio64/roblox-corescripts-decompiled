local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local AppStorageService = game:GetService("AppStorageService")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local withNavigation = RoactNavigation.withNavigation
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagAXUseSignalsForLayeredClothingCurrentSort = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingCurrentSort
local getLayeredClothingCurrentSortStore

if fFlagAXUseSignalsForLayeredClothingCurrentSort then
	getLayeredClothingCurrentSortStore = AvatarExperienceCommon.Stores.getLayeredClothingCurrentSortStore
else
	getLayeredClothingCurrentSortStore = nil
end

local module3 = require("@luauforge/bundled/dFs")

local module4 = require("@luauforge/deferred/hiC")

local module5 = require("@luauforge/deferred/hiD")
local module6 = require("@luauforge/deferred/hiE")
local module7 = require("@luauforge/deferred/gLv")
local module8 = require("@luauforge/bundled/dRT")
local gamepadUtils = require("@luauforge/bundled/fCf").Gamepad.GamepadUtils
local module9 = require("@luauforge/bundled/dRZ")
local setOrderForTryOns = require("@luauforge/bundled/dKU").Actions.SetOrderForTryOns
local module10 = require("@luauforge/bundled/dWW")

local module11 = require("@luauforge/deferred/hiF")
local module12 = require("@luauforge/bundled/fAe")

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module13 = require("@luauforge/deferred/gKK")
local module14 = require("@luauforge/deferred/gKL")

local avatarLastEquippedStateStore = AvatarExperienceCommon.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore

local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup

local udim = UDim.new(0, 10)

local udim2 = UDim2.new(1, -module7.RightMargin, 0, 0)

local extended = Roact.PureComponent:extend("VerticalClothingList")

local strictInterface = t.strictInterface
local v5 = {
	lastInputIsGamepad = t.boolean,
	topBarRef = t.optional(t.table),
	onDragChange = t.optional(t.callback),
	focusGuiObject = t.callback,
	currentSort = t.optional(t.table),
	equippedAssets = t.table,
	equippedLayeredAssetIdsOrdered = t.table,
	tryOnItems = t.table,
	currentPage = 0,
	setOrder = 0,
	setOrderForTryOns = 0,
	setCurrentSort = 0,
	sendAnalytics = 0,
	avatarRoute = 0,
	navigation = 0,
	forwardRef = 0,
	analytics = 0,
	NextSelectionLeft = 0,
	NextSelectionRight = 0,
	NextSelectionDown = 0,
	NextSelectionUp = 0
}
local v6 = if fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then t.string else nil
v5.currentPage = v6

v5.setOrder = t.callback
v5.setOrderForTryOns = t.callback
v5.setCurrentSort = t.callback
v5.sendAnalytics = t.callback

v5.avatarRoute = t.table

v5.navigation = t.table

v5.forwardRef = t.optional(t.table)

v5.analytics = t.table

v5.NextSelectionLeft = t.optional(t.table)
v5.NextSelectionRight = t.optional(t.table)
v5.NextSelectionDown = t.optional(t.table)
v5.NextSelectionUp = t.optional(t.table)
extended.validateProps = strictInterface(v5)

extended.defaultProps = { lastInputIsGamepad = false }

function extended:isVisible(): boolean
	return self.props.avatarRoute.opaque.name == avatarScreen.LayeredClothingSort
end

function extended:init()
	self.listRef = self.props.forwardRef or Roact.createRef()
	self.scrollingFrameRef = Roact.createRef()
	self.toolTipFrameRef = Roact.createRef()

	self.rootRefCache = RoactGamepad.createRefCache()
	self.tileRefCache = RoactGamepad.createRefCache()

	self.dragStartPosition = nil
	self.frameStartPositionYOffset = nil
	self.canvasStartHeight = nil
	self.dragging = false
	self.stickNeedsToReset = false

	self.moveConnection = nil
	self.focusLostConnection = nil
	self.releaseConnection = nil
	self.clickAndHoldConn = nil
	self.scrollConnection = nil

	local binding, v7 = Roact.createBinding(Vector2.new(0, 0))
	self.canvasPosition = binding
	self.updateCanvasPosition = v7
	local binding2, v8 = Roact.createBinding(UDim2.fromOffset(module7.Tile.Padding, 0))
	self.draggedTilePos = binding2
	self.updateDraggedTilePos = v8
	local binding3, v9 = Roact.createBinding(false)
	self.contextualOptionsVisible = binding3
	self.updateContextualOptionsVisible = v9

	self:setState({
		draggingTileOrdering = self.props.equippedLayeredAssetIdsOrdered,
		orderingOnSelectWithGamepad = self.props.equippedLayeredAssetIdsOrdered,
		triggerSize = Vector2.new(0, 0),
		showToolTip = not isVRAppBuild() and AppStorageService:GetItem("ShowTooltipLCSortPage") == "true"
	})

	function self.onToolTipSizeChange(p2)
		self:setState({ triggerSize = p2.AbsoluteSize })
	end

	function self.onTooltipDismiss()
		self:setState({ showToolTip = false })

		AppStorageService:SetItem("ShowTooltipLCSortPage", "false")
		AppStorageService:flush()
	end

	function self.isExceedingBottomThresh(p2): boolean
		local value = self.tileRefCache[p2]:getValue()
		local value2 = self.scrollingFrameRef:getValue()

		if value and value2 then
			return (value2 and value2.AbsolutePosition.Y + value2.AbsoluteWindowSize.Y or 0) < value.AbsolutePosition.Y + module7.Tile.Size
		end

		return false
	end

	function self.isExceedingTopThresh(p2): boolean
		local value = self.tileRefCache[p2]:getValue()
		local value2 = self.scrollingFrameRef:getValue()

		if value and value2 then
			return value2.AbsolutePosition.Y > value.AbsolutePosition.Y
		end

		return false
	end

	function self.resetSelectedTile()
		self:setState({ selectedAssetId = Roact.None })
	end

	function self.selectTile(p2)
		local v12 = self:getTileOffsetsTable(self.state.draggingTileOrdering)[p2.id]
		self.updateDraggedTilePos(UDim2.fromOffset(
			module7.Tile.Padding + module7.Tile.Size / 2,
			v12 + module7.Tile.Size / 2
		))

		self:setState({ selectedAssetId = p2.id })

		if self.state.showToolTip then
			self.onTooltipDismiss()
		end
	end

	function self.initializeDrag(p2, inputObject, p3, p4, value)
		self.frameStartPositionYOffset = p2.Position.Y.Offset - (value or 0)
		self.dragStartPosition = inputObject.Position
		self.canvasStartHeight = self.scrollingFrameRef:getValue().CanvasPosition.Y
		self.inputObject = inputObject
		self:startListeningForDrag(p3, p4)
	end

	function self.onDismiss()
		self.updateContextualOptionsVisible(false)
		self.resetSelectedTile()
	end

	function self.onOverlayClosed()
		return function() end
	end

	function self.onSelectTile(p2)
		self.selectTile(p2)
		self:setState({
			orderingOnSelectWithGamepad = self.props.equippedLayeredAssetIdsOrdered
		})
	end
	function self.onConfirmTile()
		self.resetSelectedTile()
		self:confirmAndSetOrder()
	end
	function self.onMoveTileUpOne(p2, p3)
		self:moveTileUpOneGamepad(p2, p3)
	end
	function self.onMoveTileDownOne(p2, p3)
		self:moveTileDownOneGamepad(p2, p3)
	end
	function self.onCancelAndReset()
		self.resetSelectedTile()
		self:setState({ draggingTileOrdering = self.state.orderingOnSelectWithGamepad })
	end
	function self.onRemoveClothingTile(p2)
		self.props.navigation.navigate(avatarScreen.RemoveItemPrompt, {
			onOverlayClosed = self.onOverlayClosed(),
			asset = p2,
			onUnequip = self.resetSelectedTile
		})
	end
	function self.onMoveThumbstickInput(p2, p3, p4)
		self:handleThumbstickInput(p2, p3, p4)
	end
end

function extended:getTileOrderingAfterMove(p3, p4, p5, p6, list)
	local tileOrderingAfterMove = {}

	for k, item in list do
		if k ~= p3 then
			table.insert(tileOrderingAfterMove, item)
		end
	end

	table.insert(tileOrderingAfterMove, math.max(1, (math.min(p3 + p4 * p5, #list))), p6)

	return tileOrderingAfterMove
end

function extended:updateDraggingTileOrdering(p2)
	if p2 and self:shouldUpdateOrder(p2) then
		self:setState({ draggingTileOrdering = p2 })
	end
end

function extended:moveTileDownOneGamepad(p2, p3)
	self:updateDraggingTileOrdering((self:getTileOrderingAfterMove(
		p2,
		1,
		1,
		p3,
		self.state.draggingTileOrdering
	)))
	local value = self.tileRefCache[p3.id]:getValue()
	local value2 = self.scrollingFrameRef:getValue()
	local v7 = value2 and value2.AbsolutePosition.Y + value2.AbsoluteWindowSize.Y or 0
	local v8 = value.AbsolutePosition.Y + module7.Tile.SelectedSize + module7.Tile.Size + module7.Tile.Padding

	if value and value2 and v7 < v8 then
		local y = value2.CanvasPosition.Y
		local v9 = v8 - v7 + module7.Tile.Padding
		self.updateCanvasPosition(Vector2.new(0, y + v9))
	end
end

function extended:moveTileUpOneGamepad(p2, p3)
	self:updateDraggingTileOrdering((self:getTileOrderingAfterMove(
		p2,
		1,
		-1,
		p3,
		self.state.draggingTileOrdering
	)))
	local value = self.tileRefCache[p3.id]:getValue()
	local value2 = self.scrollingFrameRef:getValue()
	local y = value2.AbsolutePosition.Y
	local v7 = value.AbsolutePosition.Y - module7.Tile.Size - module7.Tile.Padding

	if value and value2 and v7 < y then
		local y2 = value2.CanvasPosition.Y
		local v8 = v7 - y - module7.Tile.Padding
		self.updateCanvasPosition(Vector2.new(0, y2 + v8))
	end
end

function extended:handleThumbstickInput(p2, p3, p4)
	local position = p2.Position
	local stickByDeadzone = gamepadUtils.normalizeStickByDeadzone(position, 0.6)

	if stickByDeadzone.Y > 0 and not self.stickNeedsToReset then
		self:moveTileUpOneGamepad(p3, p4)
		self.stickNeedsToReset = true
	elseif stickByDeadzone.Y < 0 and not self.stickNeedsToReset then
		self:moveTileDownOneGamepad(p3, p4)
		self.stickNeedsToReset = true
	elseif stickByDeadzone.Y == 0 and self.stickNeedsToReset then
		self.stickNeedsToReset = false
	end
end

function extended:getTileOffsetsTable(items)
	local tileOffsetsTable = {}

	for k, item in items do
		tileOffsetsTable[item.id] = (k - 1) * (module7.Tile.Size + module7.Tile.Padding)
	end

	return tileOffsetsTable
end

function extended:shouldUpdateOrder(list): boolean
	if #list ~= #self.state.draggingTileOrdering then
		return true
	end

	for i = 1, #list do
		if list[i].id ~= self.state.draggingTileOrdering[i].id then
			return true
		end
	end

	return false
end

function extended:normalizeDraggedPosition(value)
	local count = #self.state.draggingTileOrdering
	local v7 = count * (module7.Tile.Size + module7.Tile.Padding)

	local v8 = -module7.VerticalList.Padding
	local v9 = v7 - module7.Tile.Size

	if v9 < v8 then
		module3(string.format(
			"VerticalClothingList invalid argument #3 to 'clamp' (max must be greater than or equal to min)\n  numTiles: %s, canvasHeight(maxDragHeight): %s, AbsoluteCanvasSize: %s, maximumDragHeight: %s",
			tostring(count),
			tostring(v7),
			tostring(self.scrollingFrameRef:getValue().AbsoluteCanvasSize.Y),
			(tostring(v9))
		))

		return value
	end

	return (math.clamp(value, v8, v9))
end

function extended:createScrollConnection(p2)
	if not self.scrollingFrameRef:getValue() then
		return
	end

	self.scrollConnection = RunService.RenderStepped:connect(function(p3)
		local value = self.scrollingFrameRef:getValue()

		if value then
			local y = value.CanvasPosition.Y

			if
				y < value.AbsoluteCanvasSize.Y - value.AbsoluteWindowSize.Y and p2 == 1
				or y > 0 and p2 == -1
			then
				self.updateDraggedTilePos(UDim2.fromOffset(
					module7.Tile.Padding + module7.Tile.Size / 2,
					self:normalizeDraggedPosition(self.draggedTilePos:getValue().Y.Offset + math.ceil(50 * p3) * p2)
				))

				self.updateCanvasPosition(Vector2.new(0, y + math.ceil(50 * p3) * p2))
			end
		else
			self.scrollConnection:Disconnect()
			self.scrollConnection = nil
		end
	end)
end

function extended:processDrag(p2, p3, p4)
	local value = self.scrollingFrameRef:getValue()

	if not value then
		return
	end

	local y = value.CanvasPosition.Y
	local v7 = p2.y - self.dragStartPosition.Y + (y - self.canvasStartHeight)
	local v8 = self.frameStartPositionYOffset + v7
	local id = p3.id

	local v9 = self.props.equippedLayeredAssetIdsOrdered
	local v10 = module7.Tile.Size / 2 + module7.Tile.Padding

	local v11 = math.floor((math.abs(v7) - v10) / (module7.Tile.Size + module7.Tile.Padding)) + 1
	local v12 = v10 < v7 and 1 or -1

	if v10 < math.abs(v7) then
		v9 = self:getTileOrderingAfterMove(p4, v11, v12, p3, self.props.equippedLayeredAssetIdsOrdered)
	end

	self:updateDraggingTileOrdering(v9)

	self.updateDraggedTilePos(UDim2.fromOffset(
		module7.Tile.Padding + module7.Tile.Size / 2,
		self:normalizeDraggedPosition(v8) + module7.Tile.Size / 2
	))

	if self.isExceedingTopThresh(id) or self.isExceedingBottomThresh(id) then
		if not self.scrollConnection then
			self:createScrollConnection(self.isExceedingBottomThresh(id) and 1 or -1)
		end
	elseif self.scrollConnection ~= nil then
		self.scrollConnection:Disconnect()
		self.scrollConnection = nil
	end
end

function extended:removeConnections()
	if self.moveConnection ~= nil then
		self.moveConnection:Disconnect()
		self.moveConnection = nil
	end

	if self.releaseConnection ~= nil then
		self.releaseConnection:Disconnect()
		self.releaseConnection = nil
	end

	if self.focusLostConnection ~= nil then
		self.focusLostConnection:Disconnect()
		self.focusLostConnection = nil
	end

	if self.scrollConnection ~= nil then
		self.scrollConnection:Disconnect()
		self.scrollConnection = nil
	end
end

function extended:confirmAndSetOrder()
	local formatForSetOrderWithTryOns, v7 = module8.formatForSetOrderWithTryOns(
		self.state.draggingTileOrdering,
		self.props.equippedAssets,
		self.props.tryOnItems
	)

	if
		fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
		and self.props.currentPage == avatarScreen.LayeredMakeupSort
		and #Cryo.Dictionary.keys(self.props.tryOnItems) > 0
	then
		avatarLastEquippedStateStore.setChangedLayeredMakeupSorting(true)
	end

	self.props.setOrder(formatForSetOrderWithTryOns)

	self.props.setOrderForTryOns(v7)

	self.props.setCurrentSort(self.state.draggingTileOrdering)

	self.props.sendAnalytics(self.props.analytics.avatarRefineAutosaved)
end

function extended:stopListeningForDrag(p2)
	self.dragging = false

	if self.props.onDragChange then
		self.props.onDragChange(false)
	end

	self.inputObject = nil

	self:removeConnections()

	self.resetSelectedTile()

	self:confirmAndSetOrder()
end

function extended:startListeningForDrag(p2, p3)
	if self.rootRefCache[p2.id]:getValue() == nil or self.dragging then
		return
	end

	if self.props.onDragChange then
		self.props.onDragChange(true)
	end

	self.dragging = true

	self.updateContextualOptionsVisible(false)

	self.moveConnection = UserInputService.InputChanged:Connect(function(input)
		if not self.dragging then
			return
		end

		local userInputType = input.UserInputType

		if
			userInputType ~= Enum.UserInputType.MouseMovement and userInputType ~= Enum.UserInputType.Touch
			or input.UserInputState ~= Enum.UserInputState.Change
			or input ~= self.inputObject and userInputType == Enum.UserInputType.Touch
		then
			return
		end

		self:processDrag(input.Position, p2, p3)
	end)

	self.releaseConnection = UserInputService.InputEnded:Connect(function(input)
		local userInputType = input.UserInputType

		if
			userInputType ~= Enum.UserInputType.MouseButton1 and userInputType ~= Enum.UserInputType.Touch
			or input ~= self.inputObject and userInputType == Enum.UserInputType.Touch
		then
			return
		end

		self:stopListeningForDrag(p2)
	end)

	self.focusLostConnection = UserInputService.WindowFocusReleased:Connect(function()
		self:stopListeningForDrag(p2)
	end)

	self.selectTile(p2)
end

function extended:render()
	return withStyle(function(p2)
		return withLocalization({
			tooltipText = "Feature.Avatar.Message.LCSortListTooltip"
		})(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

function extended:renderWithProviders(p2, p3)
	local theme = p2.Theme

	local tileOffsetsTable = self:getTileOffsetsTable(self.state.draggingTileOrdering)
	local children = {}

	for k, v7 in self.state.draggingTileOrdering do
		local id = v7.id
		children[id] = Roact.createElement(module11, {
			asset = v7,
			selectedAssetId = self.state.selectedAssetId,
			positionYOffset = tileOffsetsTable[v7.id],
			dragging = self.dragging,
			positionBinding = self.draggedTilePos,
			isTileSelected = self.state.selectedAssetId == v7.id,
			tileIndex = k,
			contextualOptionsVisible = self.contextualOptionsVisible,
			updateContextualOptionsVisible = self.updateContextualOptionsVisible,
			resetSelectedTile = self.resetSelectedTile,
			initializeDrag = self.initializeDrag,
			onEndClick = self.selectTile,
			tileRef = self.tileRefCache[v7.id],
			lastInputIsGamepad = self.props.lastInputIsGamepad,
			[Roact.Ref] = self.rootRefCache[v7.id],
			onSelectTile = self.onSelectTile,
			onConfirmTile = self.onConfirmTile,
			onMoveTileUpOne = self.onMoveTileUpOne,
			onMoveTileDownOne = self.onMoveTileDownOne,
			onCancelAndReset = self.onCancelAndReset,
			onRemoveClothingTile = self.onRemoveClothingTile,
			onMoveThumbstickInput = self.onMoveThumbstickInput
		})
	end

	local count = #self.state.draggingTileOrdering
	local v7 = count * (module7.Tile.Size + module7.Tile.Padding)
	local v8 = #self.props.equippedLayeredAssetIdsOrdered > 0

	local frame = v8 and RoactGamepad.Focusable.Frame or "Frame"

	local v9 = { bodyText = p3.tooltipText, useLargeDropShadow = true }

	local v10 = {
		preferredOrientation = tooltipOrientation.Left,
		guiTarget = CoreGui,
		triggerPointName = "RoundedFrame",
		active = self.state.showToolTip and self:isVisible()
	}

	local v11 = module7.VerticalList.Width + module7.Tile.ContextWidth

	local createFragment = Roact.createFragment
	local createElement = Roact.createElement

	if isVRAppBuild() then
	end

	local listRefsByRef = {
		["AnchorPoint"] = nil,
		["AnchorPoint"] = nil,
		["AnchorPoint"] = nil,
		["AnchorPoint"] = nil,
		["AnchorPoint"] = nil,
		["AnchorPoint"] = nil,
		["AnchorPoint"] = nil,
		["AnchorPoint"] = nil,
		AnchorPoint = Vector2.new(1, 0)
	}
	local v12 = if isVRAppBuild() then UDim2.new(
		1,
		0,
		0,
		module7.Tile.MoreIconSize + module7.VerticalList.Padding
	) else udim2
	listRefsByRef.Position = v12

	listRefsByRef.BackgroundTransparency = 1
	listRefsByRef.Size = UDim2.new(0, v11, module7.VerticalList.HeightScale, 0)
	listRefsByRef.ClipsDescendants = true
	listRefsByRef.Visible = count > 0
	listRefsByRef.ZIndex = 3
	listRefsByRef[Roact.Ref] = self.listRef
	listRefsByRef.restorePreviousChildFocus = v8 and true or nil
	return createFragment({
		VerticalClothingList = createElement(frame, listRefsByRef, {
			RoundedFrame = withTooltip(v9, v10, function(p4)
				local createElement2 = Roact.createElement

				if isVRAppBuild() then
				end

				local v14 = {}
				v14.AnchorPoint = Vector2.new(1, 0)

				if isVRAppBuild() then
				end

				v14.Position = UDim2.fromScale(1, 0)
				v14.Size = UDim2.new(0, module7.VerticalList.Width, 1, 0)
				v14.BackgroundTransparency = self.state.selectedAssetId == nil and 0.2 or 0.5
				v14.BackgroundColor3 = theme.BackgroundDefault.Color
				v14.ZIndex = 1
				v14[Roact.Change.AbsoluteSize] = p4
				v14[Roact.Change.AbsolutePosition] = p4
				return createElement2("Frame", v14, {
					UISizeConstraint = Roact.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(module7.VerticalList.Width, v7 + module7.VerticalList.Padding)
					}),
					UICorner = Roact.createElement("UICorner", { CornerRadius = udim }),
					ScrollingFrame = Roact.createElement("ScrollingFrame", {
						Size = UDim2.new(1, 0, 1, 0),
						CanvasPosition = self.canvasPosition,
						CanvasSize = UDim2.new(1, 0, 0, v7 + module7.VerticalList.Padding),
						BackgroundTransparency = 1,
						ScrollBarThickness = 0,
						ScrollingDirection = Enum.ScrollingDirection.Y,
						ScrollingEnabled = self.state.selectedAssetId == nil and not self.props.lastInputIsGamepad,
						[Roact.Ref] = self.scrollingFrameRef,
						ClipsDescendants = false,
						Selectable = false
					}, {
						UIPadding = Roact.createElement("UIPadding", {
							PaddingBottom = UDim.new(0, module7.VerticalList.Padding),
							PaddingTop = UDim.new(0, module7.VerticalList.Padding)
						}),
						LCTiles = Roact.createFragment(children),
						DismissMenuBackgroundScrollingFrame = Roact.createElement(module6, {
							Visible = self.contextualOptionsVisible,
							ZIndex = self.state.selectedAssetId == nil and 1 or 5,
							onDismiss = self.onDismiss
						})
					})
				})
			end)
		}),
		DismissMenuBackgroundPage = Roact.createElement(module6, {
			Visible = self.contextualOptionsVisible,
			ZIndex = 2,
			onDismiss = self.onDismiss
		})
	})
end

function extended:didUpdate(p2, p3)
	if self.props.currentSort ~= p2.currentSort and self:shouldUpdateOrder(self.props.currentSort) then
		self:setState({ draggingTileOrdering = self.props.currentSort })
	end

	if self.state.selectedAssetId ~= p3.selectedAssetId then
		if self.state.selectedAssetId then
			self.props.focusGuiObject(self.rootRefCache[self.state.selectedAssetId].current)
		else
			self.props.focusGuiObject(self.rootRefCache[p3.selectedAssetId].current)
		end
	end
end

function extended:willUnmount()
	self:removeConnections()
end

local function mapStateToProps(p2, p3)
	local v7 = if p3.avatarRoute.opaque.name == avatarScreen.LayeredMakeupSort then module5(p2) else module4(p2)

	local v8 = {
		equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		equippedLayeredAssetIdsOrdered = v7,
		currentSort = 0,
		tryOnItems = 0,
		currentPage = 0
	}

	local v9 = if not fFlagAXUseSignalsForLayeredClothingCurrentSort then p2.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList else nil
	v8.currentSort = v9

	v8.tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	local v10 = if fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then p3.avatarRoute.opaque.name else nil
	v8.currentPage = v10
	return v8
end

local function mapDispatchToProps(callback)
	return {
		setOrder = function(p2)
			callback(module9(p2))
		end,
		setOrderForTryOns = function(p2)
			callback(setOrderForTryOns(p2))
		end,
		setCurrentSort = function(p2)
			if fFlagAXUseSignalsForLayeredClothingCurrentSort then
				getLayeredClothingCurrentSortStore(false).setCurrentSort(p2)
			else
				callback(module10(p2))
			end
		end,
		sendAnalytics = function(p2)
			callback(module14(p2))
		end
	}
end

local v7 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)

local v8 = v7

local function VerticalClothingListWithSignals(p2)
	local v9 = useSignalState(getLayeredClothingCurrentSortStore(false).getOrderedList)
	return React.createElement(v8, Cryo.Dictionary.union(p2, { currentSort = v9 }))
end

if fFlagAXUseSignalsForLayeredClothingCurrentSort then
	v7 = React.memo(VerticalClothingListWithSignals)
end

local v9 = module12((withNavigation(v7, nil)))

local v10 = roactServices.connect({ analytics = module13 })(v9)

return Roact.forwardRef(function(p2, p3)
	local v11 = useFocusGuiObject()
	return Roact.createElement(v10, Cryo.Dictionary.join(p2, {
		forwardRef = p3,
		focusGuiObject = v11
	}))
end)
