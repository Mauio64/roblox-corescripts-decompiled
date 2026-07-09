local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local AppStorageService = game:GetService("AppStorageService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local withNavigation = RoactNavigation.withNavigation
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useFocusGuiObject = require(CorePackages.Packages.ReactFocusNavigation).useFocusGuiObject
local Modules = CoreGui.RobloxGui.Modules
local mutedError = require(Modules.LuaApp.mutedError)
local selectEquippedLCAccessoriesOrdered = require(Modules.AvatarExperience.LayeredClothingSort.Selectors.selectEquippedLCAccessoriesOrdered)
local selectEquippedLayeredMakeupOrdered = require(Modules.AvatarExperience.LayeredMakeupSort.Selectors.selectEquippedLayeredMakeupOrdered)
local DismissMenuBackground = require(Modules.AvatarExperience.LayeredClothingSort.Components.DismissMenuBackground)
local Constants = require(Modules.AvatarExperience.AvatarRefinement.Constants)
local LayeredClothingSortUtils = require(Modules.AvatarExperience.LayeredClothingSort.LayeredClothingSortUtils)
local GamepadUtils = require(CorePackages.Workspace.Packages.InputUi).Gamepad.GamepadUtils
local SetOrder = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetOrder)
local SetOrderForTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.SetOrderForTryOns
local SetCurrentSort = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetCurrentSort)
local VerticalClothingListTileContainer = require(Modules.AvatarExperience.LayeredClothingSort.Components.VerticalClothingListTileContainer)
local withAvatarRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAvatarRoute)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Analytics = require(Modules.AvatarExperience.LayeredClothingSort.Services.Analytics)
local SendRefinementAnalytics = require(Modules.AvatarExperience.LayeredClothingSort.Thunks.SendRefinementAnalytics)
local avatarLastEquippedStateStore = AvatarExperienceCommon.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
local uDim = UDim.new(0, 10)
local uDim2 = UDim2.new(1, -Constants.RightMargin, 0, 0)
local v44 = Roact.PureComponent:extend("VerticalClothingList")

v44.validateProps = t.strictInterface({
	lastInputIsGamepad = t.boolean,
	topBarRef = t.optional(t.table),
	onDragChange = t.optional(t.callback),
	focusGuiObject = t.callback,
	currentSort = t.optional(t.table),
	equippedAssets = t.table,
	equippedLayeredAssetIdsOrdered = t.table,
	tryOnItems = t.table,
	currentPage = if not FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then nil else t.string,
	setOrder = t.callback,
	setOrderForTryOns = t.callback,
	setCurrentSort = t.callback,
	sendAnalytics = t.callback,
	avatarRoute = t.table,
	navigation = t.table,
	forwardRef = t.optional(t.table),
	analytics = t.table,
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionUp = t.optional(t.table)
})
v44.defaultProps = {
	lastInputIsGamepad = false
}

function v44.isVisible(p1) -- line: 114
	-- upvalues: AvatarScreen (copy)
	return p1.props.avatarRoute.opaque.name == AvatarScreen.LayeredClothingSort
end
function v44.init(p2) -- line: 121
	-- upvalues: Roact (copy), RoactGamepad (copy), Constants (copy), IsVRAppBuild (copy), AppStorageService (copy), AvatarScreen (copy)
	p2.listRef = p2.props.forwardRef or Roact.createRef()
	p2.scrollingFrameRef = Roact.createRef()
	p2.toolTipFrameRef = Roact.createRef()
	p2.rootRefCache = RoactGamepad.createRefCache()
	p2.tileRefCache = RoactGamepad.createRefCache()
	p2.dragStartPosition = nil
	p2.frameStartPositionYOffset = nil
	p2.canvasStartHeight = nil
	p2.dragging = false
	p2.stickNeedsToReset = false
	p2.moveConnection = nil
	p2.focusLostConnection = nil
	p2.releaseConnection = nil
	p2.clickAndHoldConn = nil
	p2.scrollConnection = nil

	local v51, v52 = Roact.createBinding(Vector2.new(0, 0))

	p2.canvasPosition = v51
	p2.updateCanvasPosition = v52

	local v53, v54 = Roact.createBinding(UDim2.fromOffset(Constants.Tile.Padding, 0))

	p2.draggedTilePos = v53
	p2.updateDraggedTilePos = v54

	local v55, v56 = Roact.createBinding(false)

	p2.contextualOptionsVisible = v55
	p2.updateContextualOptionsVisible = v56
	p2:setState({
		draggingTileOrdering = p2.props.equippedLayeredAssetIdsOrdered,
		orderingOnSelectWithGamepad = p2.props.equippedLayeredAssetIdsOrdered,
		triggerSize = Vector2.new(0, 0),
		showToolTip = not IsVRAppBuild() and AppStorageService:GetItem("ShowTooltipLCSortPage") == "true"
	})

	function p2.onToolTipSizeChange(p3) -- line: 164
		-- upvalues: p2 (copy)
		p2:setState({
			triggerSize = p3.AbsoluteSize
		})
	end
	function p2.onTooltipDismiss() -- line: 170
		-- upvalues: p2 (copy), AppStorageService (copy)
		p2:setState({
			showToolTip = false
		})
		AppStorageService:SetItem("ShowTooltipLCSortPage", "false")
		AppStorageService:flush()
	end
	function p2.isExceedingBottomThresh(p4) -- line: 182
		-- upvalues: p2 (copy), Constants (copy)
		local v159 = p2.tileRefCache[p4]:getValue()
		local v160 = p2.scrollingFrameRef:getValue()

		if not v159 or not v160 then
			return false
		end

		return (v160 and v160.AbsolutePosition.Y + v160.AbsoluteWindowSize.Y or 0) < v159.AbsolutePosition.Y + Constants.Tile.Size
	end
	function p2.isExceedingTopThresh(p5) -- line: 199
		-- upvalues: p2 (copy)
		local v162 = p2.tileRefCache[p5]:getValue()
		local v163 = p2.scrollingFrameRef:getValue()

		if not v162 or not v163 then
			return false
		end

		return v163.AbsolutePosition.Y > v162.AbsolutePosition.Y
	end
	function p2.resetSelectedTile() -- line: 214
		-- upvalues: p2 (copy), Roact (copy)
		p2:setState({
			selectedAssetId = Roact.None
		})
	end
	function p2.selectTile(p6) -- line: 225
		-- upvalues: p2 (copy), Constants (copy)
		local v165 = p2:getTileOffsetsTable(p2.state.draggingTileOrdering)[p6.id]

		p2.updateDraggedTilePos(UDim2.fromOffset(Constants.Tile.Padding + Constants.Tile.Size / 2, v165 + Constants.Tile.Size / 2))
		p2:setState({
			selectedAssetId = p6.id
		})

		if p2.state.showToolTip then
			p2.onTooltipDismiss()
		end
	end
	function p2.initializeDrag(p7, p8, p9, p10, p11) -- line: 243
		-- upvalues: p2 (copy)
		local v171 = p11 or 0

		p2.frameStartPositionYOffset = p7.Position.Y.Offset - v171
		p2.dragStartPosition = p8.Position
		p2.canvasStartHeight = p2.scrollingFrameRef:getValue().CanvasPosition.Y
		p2.inputObject = p8
		p2:startListeningForDrag(p9, p10)
	end
	function p2.onDismiss() -- line: 257
		-- upvalues: p2 (copy)
		p2.updateContextualOptionsVisible(false)
		p2.resetSelectedTile()
	end
	function p2.onOverlayClosed() -- line: 262
		return function() -- line: 263
		end
	end
	function p2.onSelectTile(p12) -- line: 266
		-- upvalues: p2 (copy)
		p2.selectTile(p12)
		p2:setState({
			orderingOnSelectWithGamepad = p2.props.equippedLayeredAssetIdsOrdered
		})
	end
	function p2.onConfirmTile() -- line: 272
		-- upvalues: p2 (copy)
		p2.resetSelectedTile()
		p2:confirmAndSetOrder()
	end
	function p2.onMoveTileUpOne(p13, p14) -- line: 276
		-- upvalues: p2 (copy)
		p2:moveTileUpOneGamepad(p13, p14)
	end
	function p2.onMoveTileDownOne(p15, p16) -- line: 279
		-- upvalues: p2 (copy)
		p2:moveTileDownOneGamepad(p15, p16)
	end
	function p2.onCancelAndReset() -- line: 282
		-- upvalues: p2 (copy)
		p2.resetSelectedTile()
		p2:setState({
			draggingTileOrdering = p2.state.orderingOnSelectWithGamepad
		})
	end
	function p2.onRemoveClothingTile(p17) -- line: 288
		-- upvalues: p2 (copy), AvatarScreen (copy)
		p2.props.navigation.navigate(AvatarScreen.RemoveItemPrompt, {
			onOverlayClosed = p2.onOverlayClosed(),
			asset = p17,
			onUnequip = p2.resetSelectedTile
		})
	end
	function p2.onMoveThumbstickInput(p18, p19, p20) -- line: 295
		-- upvalues: p2 (copy)
		p2:handleThumbstickInput(p18, p19, p20)
	end
end
function v44.getTileOrderingAfterMove(_, p22, p23, p24, p25, p26) -- line: 305
	local t1 = {}

	for v64, v65 in p26 do
		if v64 ~= p22 then
			table.insert(t1, v65)
		end
	end

	table.insert(t1, math.max(1, (math.min(p22 + p23 * p24, #p26))), p25)

	return t1
end
function v44.updateDraggingTileOrdering(p27, p28) -- line: 322
	if p28 and p27:shouldUpdateOrder(p28) then
		p27:setState({
			draggingTileOrdering = p28
		})
	end
end
function v44.moveTileDownOneGamepad(p29, p30, p31) -- line: 333
	-- upvalues: Constants (copy)
	p29:updateDraggingTileOrdering((p29:getTileOrderingAfterMove(p30, 1, 1, p31, p29.state.draggingTileOrdering)))

	local v71 = p29.tileRefCache[p31.id]:getValue()
	local v72 = p29.scrollingFrameRef:getValue()
	local v73 = v72 and v72.AbsolutePosition.Y + v72.AbsoluteWindowSize.Y or 0
	local v74 = v71.AbsolutePosition.Y + Constants.Tile.SelectedSize + Constants.Tile.Size + Constants.Tile.Padding

	if v71 and (v72 and v73 < v74) then
		local CanvasPositionY = v72.CanvasPosition.Y
		local v76 = v74 - v73 + Constants.Tile.Padding

		p29.updateCanvasPosition(Vector2.new(0, CanvasPositionY + v76))
	end
end
function v44.moveTileUpOneGamepad(p32, p33, p34) -- line: 353
	-- upvalues: Constants (copy)
	p32:updateDraggingTileOrdering((p32:getTileOrderingAfterMove(p33, 1, -1, p34, p32.state.draggingTileOrdering)))

	local v80 = p32.tileRefCache[p34.id]:getValue()
	local v81 = p32.scrollingFrameRef:getValue()
	local AbsolutePositionY = v81.AbsolutePosition.Y
	local v83 = v80.AbsolutePosition.Y - Constants.Tile.Size - Constants.Tile.Padding

	if v80 and (v81 and v83 < AbsolutePositionY) then
		local CanvasPositionY = v81.CanvasPosition.Y
		local v85 = v83 - AbsolutePositionY - Constants.Tile.Padding

		p32.updateCanvasPosition(Vector2.new(0, CanvasPositionY + v85))
	end
end
function v44.handleThumbstickInput(p35, p36, p37, p38) -- line: 371
	-- upvalues: GamepadUtils (copy)
	local p36Position = p36.Position
	local v91 = GamepadUtils.normalizeStickByDeadzone(p36Position, 0.6)

	if v91.Y > 0 and not p35.stickNeedsToReset then
		p35:moveTileUpOneGamepad(p37, p38)
		p35.stickNeedsToReset = true

		return
	end

	if v91.Y < 0 and not p35.stickNeedsToReset then
		p35:moveTileDownOneGamepad(p37, p38)
		p35.stickNeedsToReset = true

		return
	end

	if v91.Y == 0 and p35.stickNeedsToReset then
		p35.stickNeedsToReset = false
	end
end
function v44.getTileOffsetsTable(_, p40) -- line: 390
	-- upvalues: Constants (copy)
	local t2 = {}

	for v95, v96 in p40 do
		t2[v96.id] = (v95 - 1) * (Constants.Tile.Size + Constants.Tile.Padding)
	end

	return t2
end
function v44.shouldUpdateOrder(p41, p42) -- line: 403
	if #p42 ~= #p41.state.draggingTileOrdering then
		return true
	end

	for i = 1, #p42 do
		if p42[i].id ~= p41.state.draggingTileOrdering[i].id then
			return true
		end
	end

	return false
end
function v44.normalizeDraggedPosition(p43, p44) -- line: 421
	-- upvalues: Constants (copy), mutedError (copy)
	local v102 = #p43.state.draggingTileOrdering
	local v103 = v102 * (Constants.Tile.Size + Constants.Tile.Padding)
	local v104 = -Constants.VerticalList.Padding
	local v105 = v103 - Constants.Tile.Size

	if v105 < v104 then
		mutedError(string.format("VerticalClothingList invalid argument #3 to 'clamp' (max must be greater than or equal to min)\n  numTiles: %s, canvasHeight(maxDragHeight): %s, AbsoluteCanvasSize: %s, maximumDragHeight: %s", tostring(v102), tostring(v103), tostring(p43.scrollingFrameRef:getValue().AbsoluteCanvasSize.Y), (tostring(v105))))

		return p44
	end

	return (math.clamp(p44, v104, v105))
end
function v44.createScrollConnection(p45, p46) -- line: 447
	-- upvalues: RunService (copy), Constants (copy)
	if not p45.scrollingFrameRef:getValue() then
		return
	end

	p45.scrollConnection = RunService.RenderStepped:connect(function(p47) -- line: 452
		-- upvalues: p45 (copy), p46 (copy), Constants (copy)
		local v182 = p45.scrollingFrameRef:getValue()

		if not v182 then
			p45.scrollConnection:Disconnect()
			p45.scrollConnection = nil

			return
		end

		local CanvasPositionY = v182.CanvasPosition.Y

		if CanvasPositionY < v182.AbsoluteCanvasSize.Y - v182.AbsoluteWindowSize.Y and p46 == 1 or CanvasPositionY > 0 and p46 == -1 then
			p45.updateDraggedTilePos(UDim2.fromOffset(Constants.Tile.Padding + Constants.Tile.Size / 2, p45:normalizeDraggedPosition(p45.draggedTilePos:getValue().Y.Offset + math.ceil(50 * p47) * p46)))
			p45.updateCanvasPosition(Vector2.new(0, CanvasPositionY + math.ceil(50 * p47) * p46))
		end
	end)
end
function v44.processDrag(p48, p49, p50, p51) -- line: 482
	-- upvalues: Constants (copy)
	local v112 = p48.scrollingFrameRef:getValue()

	if not v112 then
		return
	end

	local CanvasPositionY = v112.CanvasPosition.Y
	local v114 = p49.y - p48.dragStartPosition.Y + (CanvasPositionY - p48.canvasStartHeight)
	local v115 = p48.frameStartPositionYOffset + v114
	local id = p50.id
	local equippedLayeredAssetIdsOrdered = p48.props.equippedLayeredAssetIdsOrdered
	local v118 = Constants.Tile.Size / 2 + Constants.Tile.Padding
	local v119 = math.floor((math.abs(v114) - v118) / (Constants.Tile.Size + Constants.Tile.Padding)) + 1
	local v120 = not (v118 < v114) and -1 or 1

	if v118 < math.abs(v114) then
		equippedLayeredAssetIdsOrdered = p48:getTileOrderingAfterMove(p51, v119, v120, p50, p48.props.equippedLayeredAssetIdsOrdered)
	end

	p48:updateDraggingTileOrdering(equippedLayeredAssetIdsOrdered)
	p48.updateDraggedTilePos(UDim2.fromOffset(Constants.Tile.Padding + Constants.Tile.Size / 2, p48:normalizeDraggedPosition(v115) + Constants.Tile.Size / 2))

	if p48.isExceedingTopThresh(id) or p48.isExceedingBottomThresh(id) then
		if not p48.scrollConnection then
			p48:createScrollConnection(not p48.isExceedingBottomThresh(id) and -1 or 1)

			return
		end
	elseif p48.scrollConnection ~= nil then
		p48.scrollConnection:Disconnect()
		p48.scrollConnection = nil
	end
end
function v44.removeConnections(p52) -- line: 539
	if p52.moveConnection ~= nil then
		p52.moveConnection:Disconnect()
		p52.moveConnection = nil
	end

	if p52.releaseConnection ~= nil then
		p52.releaseConnection:Disconnect()
		p52.releaseConnection = nil
	end

	if p52.focusLostConnection ~= nil then
		p52.focusLostConnection:Disconnect()
		p52.focusLostConnection = nil
	end

	if p52.scrollConnection ~= nil then
		p52.scrollConnection:Disconnect()
		p52.scrollConnection = nil
	end
end
function v44.confirmAndSetOrder(p53) -- line: 562
	-- upvalues: LayeredClothingSortUtils (copy), FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup (copy), AvatarScreen (copy), Cryo (copy), avatarLastEquippedStateStore (copy)
	local v123, v124 = LayeredClothingSortUtils.formatForSetOrderWithTryOns(p53.state.draggingTileOrdering, p53.props.equippedAssets, p53.props.tryOnItems)

	if FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup and (p53.props.currentPage == AvatarScreen.LayeredMakeupSort and #Cryo.Dictionary.keys(p53.props.tryOnItems) > 0) then
		avatarLastEquippedStateStore.setChangedLayeredMakeupSorting(true)
	end

	p53.props.setOrder(v123)
	p53.props.setOrderForTryOns(v124)
	p53.props.setCurrentSort(p53.state.draggingTileOrdering)
	p53.props.sendAnalytics(p53.props.analytics.avatarRefineAutosaved)
end
function v44.stopListeningForDrag(p54, _) -- line: 589
	p54.dragging = false

	if p54.props.onDragChange then
		p54.props.onDragChange(false)
	end

	p54.inputObject = nil
	p54:removeConnections()
	p54.resetSelectedTile()
	p54:confirmAndSetOrder()
end
function v44.startListeningForDrag(p56, p57, p58) -- line: 605
	-- upvalues: UserInputService (copy)
	if p56.rootRefCache[p57.id]:getValue() == nil then
		return
	end

	if p56.dragging then
		return
	end

	if p56.props.onDragChange then
		p56.props.onDragChange(true)
	end

	p56.dragging = true
	p56.updateContextualOptionsVisible(false)
	p56.moveConnection = UserInputService.InputChanged:Connect(function(input) -- line: 622
		-- upvalues: p56 (copy), p57 (copy), p58 (copy)
		if not p56.dragging then
			return
		end

		local UserInputType = input.UserInputType

		if UserInputType ~= Enum.UserInputType.MouseMovement and UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if input.UserInputState ~= Enum.UserInputState.Change then
			return
		end

		if input ~= p56.inputObject and UserInputType == Enum.UserInputType.Touch then
			return
		end

		p56:processDrag(input.Position, p57, p58)
	end)
	p56.releaseConnection = UserInputService.InputEnded:Connect(function(input) -- line: 644
		-- upvalues: p56 (copy), p57 (copy)
		local UserInputType = input.UserInputType

		if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if input ~= p56.inputObject and UserInputType == Enum.UserInputType.Touch then
			return
		end

		p56:stopListeningForDrag(p57)
	end)
	p56.focusLostConnection = UserInputService.WindowFocusReleased:Connect(function() -- line: 661
		-- upvalues: p56 (copy), p57 (copy)
		p56:stopListeningForDrag(p57)
	end)
	p56.selectTile(p57)
end
function v44.render(p59) -- line: 669
	-- upvalues: withStyle (copy), withLocalization (copy)
	return withStyle(function(p60) -- line: 670
		-- upvalues: withLocalization (copy), p59 (copy)
		return withLocalization({
			tooltipText = "Feature.Avatar.Message.LCSortListTooltip"
		})(function(p61) -- line: 673
			-- upvalues: p59 (copy), p60 (copy)
			return p59:renderWithProviders(p60, p61)
		end)
	end)
end
function v44.renderWithProviders(p62, p63, p64) -- line: 679
	-- upvalues: Roact (copy), VerticalClothingListTileContainer (copy), Constants (copy), RoactGamepad (copy), TooltipOrientation (copy), CoreGui (copy), IsVRAppBuild (copy), uDim2 (copy), withTooltip (copy), uDim (copy), DismissMenuBackground (copy)
	local Theme = p63.Theme
	local t3 = {}
	local v136 = p62:getTileOffsetsTable(p62.state.draggingTileOrdering)

	for v137, v138 in p62.state.draggingTileOrdering do
		t3[v138.id] = Roact.createElement(VerticalClothingListTileContainer, {
			asset = v138,
			selectedAssetId = p62.state.selectedAssetId,
			positionYOffset = v136[v138.id],
			dragging = p62.dragging,
			positionBinding = p62.draggedTilePos,
			isTileSelected = p62.state.selectedAssetId == v138.id,
			tileIndex = v137,
			contextualOptionsVisible = p62.contextualOptionsVisible,
			updateContextualOptionsVisible = p62.updateContextualOptionsVisible,
			resetSelectedTile = p62.resetSelectedTile,
			initializeDrag = p62.initializeDrag,
			onEndClick = p62.selectTile,
			tileRef = p62.tileRefCache[v138.id],
			focusController = p62.props.focusControllerProp,
			lastInputIsGamepad = p62.props.lastInputIsGamepad,
			[Roact.Ref] = p62.rootRefCache[v138.id],
			onSelectTile = p62.onSelectTile,
			onConfirmTile = p62.onConfirmTile,
			onMoveTileUpOne = p62.onMoveTileUpOne,
			onMoveTileDownOne = p62.onMoveTileDownOne,
			onCancelAndReset = p62.onCancelAndReset,
			onRemoveClothingTile = p62.onRemoveClothingTile,
			onMoveThumbstickInput = p62.onMoveThumbstickInput
		})
	end

	local v139 = #p62.state.draggingTileOrdering
	local v140 = v139 * (Constants.Tile.Size + Constants.Tile.Padding)
	local v141 = #p62.props.equippedLayeredAssetIdsOrdered > 0
	local v142 = v141 and RoactGamepad.Focusable.Frame or "Frame"
	local t4 = {
		useLargeDropShadow = true,
		bodyText = p64.tooltipText
	}
	local t5 = {
		triggerPointName = "RoundedFrame",
		preferredOrientation = TooltipOrientation.Left,
		guiTarget = CoreGui,
		active = p62.state.showToolTip and p62:isVisible()
	}
	local v145 = Constants.VerticalList.Width + Constants.Tile.ContextWidth

	return Roact.createFragment({
		VerticalClothingList = Roact.createElement(v142, {
			AnchorPoint = if not IsVRAppBuild() then Vector2.new(1, 0) else Vector2.new(1, 0),
			Position = if not IsVRAppBuild() then uDim2 else UDim2.new(1, 0, 0, Constants.Tile.MoreIconSize + Constants.VerticalList.Padding),
			BackgroundTransparency = 1,
			Size = UDim2.new(0, v145, Constants.VerticalList.HeightScale, 0),
			ClipsDescendants = true,
			Visible = v139 > 0,
			ZIndex = 3,
			[Roact.Ref] = p62.listRef,
			restorePreviousChildFocus = not not v141 or nil
		}, {
			RoundedFrame = withTooltip(t4, t5, function(p65) -- line: 753
				-- upvalues: Roact (copy), IsVRAppBuild (copy), Constants (copy), p62 (copy), Theme (copy), v140 (copy), uDim (copy), t3 (copy), DismissMenuBackground (copy)
				return Roact.createElement("Frame", {
					AnchorPoint = if not IsVRAppBuild() then Vector2.new(1, 0) else Vector2.new(1, 0),
					Position = if not IsVRAppBuild() then UDim2.fromScale(1, 0) else UDim2.fromScale(1, 0),
					Size = UDim2.new(0, Constants.VerticalList.Width, 1, 0),
					BackgroundTransparency = p62.state.selectedAssetId ~= nil and 0.5 or 0.2,
					BackgroundColor3 = Theme.BackgroundDefault.Color,
					ZIndex = 1,
					[Roact.Change.AbsoluteSize] = p65,
					[Roact.Change.AbsolutePosition] = p65
				}, {
					UISizeConstraint = Roact.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(Constants.VerticalList.Width, v140 + Constants.VerticalList.Padding)
					}),
					UICorner = Roact.createElement("UICorner", {
						CornerRadius = uDim
					}),
					ScrollingFrame = Roact.createElement("ScrollingFrame", {
						Size = UDim2.new(1, 0, 1, 0),
						CanvasPosition = p62.canvasPosition,
						CanvasSize = UDim2.new(1, 0, 0, v140 + Constants.VerticalList.Padding),
						BackgroundTransparency = 1,
						ScrollBarThickness = 0,
						ScrollingDirection = Enum.ScrollingDirection.Y,
						ScrollingEnabled = p62.state.selectedAssetId == nil and not p62.props.lastInputIsGamepad,
						[Roact.Ref] = p62.scrollingFrameRef,
						ClipsDescendants = false,
						Selectable = false
					}, {
						UIPadding = Roact.createElement("UIPadding", {
							PaddingBottom = UDim.new(0, Constants.VerticalList.Padding),
							PaddingTop = UDim.new(0, Constants.VerticalList.Padding)
						}),
						LCTiles = Roact.createFragment(t3),
						DismissMenuBackgroundScrollingFrame = Roact.createElement(DismissMenuBackground, {
							Visible = p62.contextualOptionsVisible,
							ZIndex = p62.state.selectedAssetId ~= nil and 5 or 1,
							onDismiss = p62.onDismiss
						})
					})
				})
			end)
		}),
		DismissMenuBackgroundPage = Roact.createElement(DismissMenuBackground, {
			ZIndex = 2,
			Visible = p62.contextualOptionsVisible,
			onDismiss = p62.onDismiss
		})
	})
end
function v44.didUpdate(p66, p67, p68) -- line: 813
	if p66.props.currentSort ~= p67.currentSort and p66:shouldUpdateOrder(p66.props.currentSort) then
		p66:setState({
			draggingTileOrdering = p66.props.currentSort
		})
	end

	if p66.state.selectedAssetId ~= p68.selectedAssetId then
		if p66.state.selectedAssetId then
			p66.props.focusGuiObject(p66.rootRefCache[p66.state.selectedAssetId].current)

			return
		end

		p66.props.focusGuiObject(p66.rootRefCache[p68.selectedAssetId].current)
	end
end
function v44.willUnmount(p69) -- line: 831
	p69:removeConnections()
end

local function mapStateToProps(p70, p71) -- line: 835
	-- upvalues: FFlagAXCustomizeMakeupSupport (copy), AvatarScreen (copy), selectEquippedLayeredMakeupOrdered (copy), selectEquippedLCAccessoriesOrdered (copy), FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup (copy)
	local v152 = nil

	if FFlagAXCustomizeMakeupSupport then
		v152 = if p71.avatarRoute.opaque.name ~= AvatarScreen.LayeredMakeupSort then selectEquippedLCAccessoriesOrdered(p70) else selectEquippedLayeredMakeupOrdered(p70)
	end

	return {
		equippedAssets = p70.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		equippedLayeredAssetIdsOrdered = if not FFlagAXCustomizeMakeupSupport then selectEquippedLCAccessoriesOrdered(p70) else v152,
		currentSort = p70.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList,
		tryOnItems = p70.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems,
		currentPage = if not FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then nil else p71.avatarRoute.opaque.name
	}
end
local function mapDispatchToProps(p72) -- line: 860
	-- upvalues: SetOrder (copy), SetOrderForTryOns (copy), SetCurrentSort (copy), SendRefinementAnalytics (copy)
	return {
		setOrder = function(p73) -- line: 862
			-- upvalues: p72 (copy), SetOrder (copy)
			p72(SetOrder(p73))
		end,
		setOrderForTryOns = function(p74) -- line: 865
			-- upvalues: p72 (copy), SetOrderForTryOns (copy)
			p72(SetOrderForTryOns(p74))
		end,
		setCurrentSort = function(p75) -- line: 868
			-- upvalues: p72 (copy), SetCurrentSort (copy)
			p72(SetCurrentSort(p75))
		end,
		sendAnalytics = function(p76) -- line: 871
			-- upvalues: p72 (copy), SendRefinementAnalytics (copy)
			p72(SendRefinementAnalytics(p76))
		end
	}
end

local v47 = withAvatarRoute((withNavigation(RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v44), nil)))
local u48 = RoactServices.connect({
	analytics = Analytics
})(v47)

return Roact.forwardRef(function(p77, p78) -- line: 886
	-- upvalues: useFocusGuiObject (copy), Roact (copy), u48 (ref), Cryo (copy)
	local v156 = useFocusGuiObject()

	return Roact.createElement(u48, Cryo.Dictionary.join(p77, {
		forwardRef = p78,
		focusGuiObject = v156
	}))
end)
