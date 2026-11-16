local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)

local TraversalLeaveConfirmation = require(script.Parent.TraversalLeaveConfirmation)

local parent = script.Parent.Parent.Parent
local EnumReactPage = require(parent.EnumReactPage)
local ReactPageSignal = require(parent.ReactPageSignal)
local Utility = require(parent.Utility)

local View = Foundation.View
local ThumbnailType = Foundation.Enums.ThumbnailType
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local getRbxThumb = Foundation.Utility.getRbxThumb
local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal
local Traversal = CoreScriptsRoactCommon.Traversal
local default = Traversal.LocalTraversalHistory.default
local GetInputModeStore = Responsive.GetInputModeStore
local Input = Responsive.Input
local Constants = Traversal.Constants
local HistoryMenu = Traversal.HistoryMenu
local useHistoryItems = Traversal.useHistoryItems
local useTokens = Foundation.Hooks.useTokens
local FFlagAddTraversalHistoryReactMenuButtons = require(parent.Flags.FFlagAddTraversalHistoryReactMenuButtons)

local function historyToMenuItems(items)
	local result = {}

	for _, item in items do
		table.insert(result, {
			universeId = item.universeId,
			text = item.name,
			icon = getRbxThumb(ThumbnailType.GameIcon, item.universeId, ThumbnailSize.Small)
		})
	end

	return result
end

local function TraversalHistoryMenu(props, _)
	local ref = React.useRef(props.anchorParent)

	if FFlagAddTraversalHistoryReactMenuButtons and props.anchorRef then
		ref = props.anchorRef
	end

	local v = useHistoryItems()
	local historyItems = React.useMemo(function()
		return historyToMenuItems(v)
	end, { v })
	local v2

	if props.idleButtonStateIsDown == nil then
		v2 = Constants.DEFAULT_CHEVRON_BUTTON_STATE
	else
		v2 = props.idleButtonStateIsDown
	end

	local v3, v4 = React.useBinding(Enum.SelectionBehavior.Stop)
	local selectionGroup = React.useMemo(function()
		local selectionBehaviorUp

		if v2 then
			selectionBehaviorUp = v3
		else
			selectionBehaviorUp = Enum.SelectionBehavior.Stop
		end

		local selectionBehaviorDown

		if v2 then
			selectionBehaviorDown = Enum.SelectionBehavior.Stop
		else
			selectionBehaviorDown = v3
		end

		return {
			SelectionBehaviorUp = selectionBehaviorUp,
			SelectionBehaviorDown = selectionBehaviorDown
		}
	end, { v2 })
	local v5 = useTokens()
	local state, setState = React.useState(Constants.NO_UNIVERSE_ID)
	local v6 = SignalsReact.useSignalState(ReactPageSignal)
	local closeMenuConn = React.useCallback(function(callback)
		local v7 = {}
		v7.onSettingsVisible = SettingsShowSignal:connect(function(p)
			if not p then
				callback()
			end
		end)
		local onPageChanged

		if not (FFlagAddTraversalHistoryReactMenuButtons and not props.currentPageChangeSignal) then
			onPageChanged = props.currentPageChangeSignal:connect(function()
				callback()
			end)
		end

		v7.onPageChanged = onPageChanged

		v7.onNativeClose = GuiService.NativeClose:Connect(function()
			callback()
		end)

		return v7
	end, { props.currentPageChangeSignal, SettingsShowSignal, GuiService.NativeClose })

	local onMenuItemSelected = React.useCallback(function(p: number)
		setState(p)
		v4(Enum.SelectionBehavior.Stop)
	end, { setState })

	local v7 = React.useCallback(function()
		setState(Constants.NO_UNIVERSE_ID)
		local lastInputType = UserInputService:GetLastInputType()
		local lastInputType2 = GetInputModeStore().getLastInputType()
		local v7

		if lastInputType2 == Input.Directional then
			v7 = true
		elseif lastInputType2 == Input.Pointer then
			v7 = lastInputType == Enum.UserInputType.Keyboard
		else
			v7 = false
		end

		if v7 and ref.current then
			GuiService.SelectedCoreObject = ref.current
		end
	end, {})

	local onMenuToggled = React.useCallback(function(flag: boolean)
		if flag then
			v4(Enum.SelectionBehavior.Escape)
		else
			v4(Enum.SelectionBehavior.Stop)
		end
	end, {})

	local backgroundStyle = React.useMemo(function()
		if FFlagAddTraversalHistoryReactMenuButtons and props.isDarkOnDarkMode then
			return v5.Color.Surface.Surface_0
		end

		return { Color3 = v5.Color.Stroke.Default.Color3, Transparency = 0.33 }
	end, {})

	local isSmallTouchScreen = Utility:IsSmallTouchScreen()
	local historyButtonTags = React.useMemo(function()
		return {
			["padding-small"] = isSmallTouchScreen,
			["padding-medium"] = not isSmallTouchScreen
		}
	end, { isSmallTouchScreen })

	local onHistorySelected = React.useCallback(function()
		v6.setCurrentReactPage(EnumReactPage.TraversalHistory)
		v4(Enum.SelectionBehavior.Stop)
	end, { v6 })

	local v8 = React.useMemo(function(): boolean
		return #default:getUniverseHistory() > 0
	end, {})

	if not v8 then
		return v8
	end

	local createElement = React.createElement
	local ref2

	if FFlagAddTraversalHistoryReactMenuButtons and not (props.anchorRef or props.anchorParent) then
		ref2 = ref
	end

	return (createElement(
		View,
		{
			tag = "auto-xy row align-y-center size-0-full",
			selectionGroup = selectionGroup,
			ref = ref2
		},
		{
			DividerLeft = React.createElement(View, {
				Size = UDim2.new(0, v5.Stroke.Thick, 1, 0),
				backgroundStyle = backgroundStyle
			}),
			HistoryMenu = React.createElement(HistoryMenu, {
				historyButtonTags = historyButtonTags,
				historyItems = historyItems,
				onHistorySelected = onHistorySelected,
				onMenuItemSelected = onMenuItemSelected,
				onMenuToggled = onMenuToggled,
				closeMenuConn = closeMenuConn,
				menuSide = props.menuSide,
				ref = ref
			})
		},
		{
			Dialog = React.createElement(TraversalLeaveConfirmation, {
				isDialogOpen = Constants.NO_UNIVERSE_ID < state,
				onCancel = v7,
				onClose = v7,
				universeId = state,
				source = "history_dropdown"
			})
		}
	))
end

return React.memo(React.forwardRef(TraversalHistoryMenu))
