local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Display = require(parent.Display)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local SignalsReact = require(parent.SignalsReact)

local BuildPillMenu = require(script.Parent.BuildPillMenu)
local BuildPillMenuPageHost = require(script.Parent.BuildPillMenuPageHost)
local GetBuildPillMenuPortalStore = require(BuildExperience.Stores.GetBuildPillMenuPortalStore)
local FFlagBuildPublishNavigationSheet = require(BuildExperience.Flags.FFlagBuildPublishNavigationSheet)
local PublishSheetController

if FFlagBuildPublishNavigationSheet then
	PublishSheetController = require(BuildExperience.Components.PublishSheet.PublishSheetController)
else
	PublishSheetController = nil
end

local View = Foundation.View
local useOverlay = Foundation.Hooks.useOverlay
local useStyleSheet = Foundation.Hooks.useStyleSheet
local useTokens = Foundation.Hooks.useTokens

local function isSideSheet(p, vector2: Vector2): boolean
	return p ~= Enum.DisplaySize.Small or vector2.X > vector2.Y
end

local function getOverlayPosition(p, guiObject) -- 1 equivalent call inferred from this helper
	local v

	if guiObject:IsA("GuiObject") then
		v = guiObject.AbsolutePosition
	else
		v = Vector2.zero
	end

	local v2 = p.AbsolutePosition - v

	return UDim2.fromOffset(v2.X, v2.Y)
end

local function BuildPillMenuPortal(props)
	local buildPillMenuPortalStore = GetBuildPillMenuPortalStore()
	local v = SignalsReact.useSignalState(buildPillMenuPortalStore.getPortalTarget)
	local guiObject = useOverlay()
	local styleSheet = useStyleSheet()
	local v2 = useTokens()
	local displayStore = Display.GetDisplayStore(false)
	local v3 = SignalsReact.useSignalState(displayStore.getDisplaySize)
	local v4 = SignalsReact.useSignalState(displayStore.getViewportSize)
	local ref = React.useRef(nil)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local sheet

	if props.sheet == nil or v3 == Enum.DisplaySize.Small and not (v4.X > v4.Y) then
		sheet = nil
	else
		sheet = props.sheet
	end

	local v5 = React.useCallback(function()
		local current = ref.current

		if v == nil or guiObject == nil or current == nil then
			return
		end

		current.Position = getOverlayPosition(v, guiObject) -- inferred equivalent call
	end, { v, guiObject })

	local ref2 = React.useCallback(function(current)
		ref.current = current
		v5()
	end, { v5 })

	local onOpenPage = React.useCallback(function(page)
		if FFlagBuildPublishNavigationSheet and page == "publish" then
			setState2(true)
		else
			setState({ type = "overflow", page = page })
		end
	end, {})

	local onOpenAgentsPage = React.useCallback(function()
		setState({ type = "agents" })
	end, {})

	local onOpenInvitePicker = React.useCallback(function()
		setState({ type = "invitePicker" })
	end, {})

	local v6 = React.useCallback(function()
		setState({ type = "playtestManagement" })
	end, {})

	local onOpenCreatorCreditPage = React.useCallback(function()
		setState({ type = "creator-credit" })
	end, {})

	local onClose = React.useCallback(function()
		setState(nil)
	end, {})

	local onOpenChat = React.useCallback(function(p: string)
		onClose()

		if props.onOpenChat ~= nil then
			props.onOpenChat(p)
		end
	end, { onClose, props.onOpenChat })

	local onClose2 = React.useCallback(function()
		setState2(false)
	end, {})

	local navigateToSubPage = React.useCallback(function(screen: string, data)
		setState({
			type = "screen",
			screen = screen,
			target = {
				universeId = data.universeId,
				placeId = data.placeId,
				sessionId = data.sessionId,
				isNewGameTarget = data.isNewGameTarget or false
			}
		})
	end, {})

	React.useLayoutEffect(function()
		if sheet == nil then
			return
		end

		local clipsDescendants = sheet.ClipsDescendants

		sheet.ClipsDescendants = false

		return function()
			sheet.ClipsDescendants = clipsDescendants
		end
	end, { sheet })

	React.useLayoutEffect(function()
		if sheet ~= nil or (v == nil or guiObject == nil) then
			return
		end

		v5()

		local absolutePositionChangedConnection = v:GetPropertyChangedSignal("AbsolutePosition"):Connect(v5)
		local absolutePositionChangedConnection2

		if guiObject:IsA("GuiObject") then
			absolutePositionChangedConnection2 = guiObject:GetPropertyChangedSignal("AbsolutePosition"):Connect(v5)
		else
			absolutePositionChangedConnection2 = nil
		end

		return function()
			absolutePositionChangedConnection:Disconnect()

			if absolutePositionChangedConnection2 ~= nil then
				absolutePositionChangedConnection2:Disconnect()
			end
		end
	end, { sheet, v, guiObject, v5 })

	if v == nil or guiObject == nil then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v7 = {
		StyleLink = React.createElement("StyleLink", { StyleSheet = styleSheet }),
		Container = 0
	}

	local createElement2 = React.createElement
	local anchorPoint

	if sheet == nil then
		anchorPoint = v.AnchorPoint
	else
		anchorPoint = Vector2.new(1, 0)
	end

	local position

	if sheet ~= nil then
		position = UDim2.fromOffset(-v2.Padding.Large, 0)
	end

	if sheet ~= nil then
		ref2 = nil
	end

	v7.Container = createElement2(View, {
		AnchorPoint = anchorPoint,
		Position = position,
		ref = ref2,
		ZIndex = 999,
		tag = "auto-xy",
		testId = "build-pill-menu-overlay-container"
	}, {
		Pill = React.createElement(BuildPillMenu, {
			target = props.target,
			testId = props.testId,
			onOpenPage = onOpenPage,
			onOpenInvitePicker = onOpenInvitePicker,
			onOpenPlaytestManagement = v6,
			onOpenAgentsPage = onOpenAgentsPage,
			onOpenCreatorCreditPage = onOpenCreatorCreditPage
		})
	})
	local element = createElement(fragment, nil, v7)

	local createElement3 = React.createElement
	local fragment2 = React.Fragment
	local createPortal = ReactRoblox.createPortal
	local v8 = if sheet == nil then guiObject else sheet
	local v9 = {
		Pill = createPortal(element, v8),
		Page = React.createElement(BuildPillMenuPageHost, {
			activePage = state,
			target = props.target,
			onClose = onClose,
			onOpenChat = onOpenChat,
			onInvitesSent = v6,
			onOpenInvitePicker = onOpenInvitePicker
		}),
		PublishSheet = 0
	}
	local publishSheet

	if FFlagBuildPublishNavigationSheet then
		publishSheet = React.createElement(PublishSheetController, {
			isOpen = state2,
			target = props.target,
			onClose = onClose2,
			navigateToSubPage = navigateToSubPage,
			showPreviewButton = false
		})
	end

	v9.PublishSheet = publishSheet
	return createElement3(fragment2, nil, v9)
end

return React.memo(BuildPillMenuPortal)
