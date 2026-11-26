local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Display")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ReactRoblox")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local BuildPillMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildPillMenu")
local BuildPillMenuPageHost = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildPillMenuPageHost")
local GetBuildPillMenuPortalStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildPillMenuPortalStore")
local FFlagBuildPublishNavigationSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildPublishNavigationSheet")

local v5 = if FFlagBuildPublishNavigationSheet then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PublishSheet/PublishSheetController") else nil

local view = Foundation.View
local useOverlay = Foundation.Hooks.useOverlay
local useStyleSheet = Foundation.Hooks.useStyleSheet
local useTokens = Foundation.Hooks.useTokens

local function isSideSheet(p2, p3): boolean
	return p2 ~= Enum.DisplaySize.Small or p3.X > p3.Y
end

local function getOverlayPosition(p2, guiObject)
	local v6 = if guiObject:IsA("GuiObject") then guiObject.AbsolutePosition else Vector2.zero
	local v7 = p2.AbsolutePosition - v6

	return UDim2.fromOffset(v7.X, v7.Y)
end

local function BuildPillMenuPortal(props)
	local v6 = GetBuildPillMenuPortalStore()
	local v7 = SignalsReact.useSignalState(v6.getPortalTarget)
	local guiObject = useOverlay()
	local v8 = useStyleSheet()
	local v9 = useTokens()
	local displayStore = Display.GetDisplayStore(false)
	local v10 = SignalsReact.useSignalState(displayStore.getDisplaySize)
	local v11 = SignalsReact.useSignalState(displayStore.getViewportSize)
	local ref = React.useRef(nil)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local sheet

	if props.sheet == nil or v10 == Enum.DisplaySize.Small and not (v11.X > v11.Y) then
		sheet = nil
	else
		sheet = props.sheet
	end

	local v12 = React.useCallback(function()
		local current = ref.current

		if v7 == nil or guiObject == nil or current == nil then
			return
		end

		local guiObject2 = guiObject
		local v14 = if guiObject2:IsA("GuiObject") then guiObject2.AbsolutePosition else Vector2.zero
		local v15 = v7.AbsolutePosition - v14

		current.Position = UDim2.fromOffset(v15.X, v15.Y)
	end, { v7, guiObject })

	local v13 = React.useCallback(function(current)
		ref.current = current
		v12()
	end, { v12 })

	local v14 = React.useCallback(function(p2)
		if FFlagBuildPublishNavigationSheet and p2 == "publish" then
			setState2(true)
		else
			setState({ type = "overflow", page = p2 })
		end
	end, {})

	local v15 = React.useCallback(function()
		setState({ type = "agents" })
	end, {})

	local v16 = React.useCallback(function()
		setState({ type = "invitePicker" })
	end, {})

	local v17 = React.useCallback(function()
		setState({ type = "playtestManagement" })
	end, {})

	local v18 = React.useCallback(function()
		setState({ type = "creator-credit" })
	end, {})

	local v19 = React.useCallback(function()
		setState(nil)
	end, {})

	local v20 = React.useCallback(function(p2)
		v19()

		if props.onOpenChat ~= nil then
			props.onOpenChat(p2)
		end
	end, { v19, props.onOpenChat })

	local v21 = React.useCallback(function()
		setState2(false)
	end, {})

	local v22 = React.useCallback(function(p2, data)
		setState({
			type = "screen",
			screen = p2,
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
		if sheet ~= nil or (v7 == nil or guiObject == nil) then
			return
		end

		v12()

		local absolutePositionChangedConnection = v7:GetPropertyChangedSignal("AbsolutePosition"):Connect(v12)
		local absolutePositionChangedConnection2

		if guiObject:IsA("GuiObject") then
			absolutePositionChangedConnection2 = guiObject:GetPropertyChangedSignal("AbsolutePosition"):Connect(v12)
		else
			absolutePositionChangedConnection2 = nil
		end

		return function()
			absolutePositionChangedConnection:Disconnect()

			if absolutePositionChangedConnection2 ~= nil then
				absolutePositionChangedConnection2:Disconnect()
			end
		end
	end, { sheet, v7, guiObject, v12 })

	if v7 == nil or guiObject == nil then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v24 = {
		StyleLink = React.createElement("StyleLink", { StyleSheet = v8 }),
		Container = 0
	}

	local createElement2 = React.createElement
	local v27 = if sheet == nil then v7.AnchorPoint else Vector2.new(1, 0)
	local v28 = if sheet ~= nil then UDim2.fromOffset(-v9.Padding.Large, 0) else nil

	if sheet ~= nil then
		v13 = nil
	end

	v24.Container = createElement2(view, {
		AnchorPoint = v27,
		Position = v28,
		ref = v13,
		ZIndex = 999,
		tag = "auto-xy",
		testId = "build-pill-menu-overlay-container"
	}, {
		Pill = React.createElement(BuildPillMenu, {
			target = props.target,
			testId = props.testId,
			onOpenPage = v14,
			onOpenInvitePicker = v16,
			onOpenPlaytestManagement = v17,
			onOpenAgentsPage = v15,
			onOpenCreatorCreditPage = v18
		})
	})
	local element = createElement(fragment, nil, v24)

	local createElement3 = React.createElement
	local fragment2 = React.Fragment
	local createPortal = ReactRoblox.createPortal
	local v31 = if sheet == nil then guiObject else sheet
	local v30 = {
		Pill = createPortal(element, v31),
		Page = React.createElement(BuildPillMenuPageHost, {
			activePage = state,
			target = props.target,
			onClose = v19,
			onOpenChat = v20,
			onInvitesSent = v17,
			onOpenInvitePicker = v16
		}),
		PublishSheet = 0
	}

	local v32 = if FFlagBuildPublishNavigationSheet then React.createElement(v5, {
		isOpen = state2,
		target = props.target,
		onClose = v21,
		navigateToSubPage = v22,
		showPreviewButton = false
	}) else nil
	v30.PublishSheet = v32
	return createElement3(fragment2, nil, v30)
end

return React.memo(BuildPillMenuPortal)
