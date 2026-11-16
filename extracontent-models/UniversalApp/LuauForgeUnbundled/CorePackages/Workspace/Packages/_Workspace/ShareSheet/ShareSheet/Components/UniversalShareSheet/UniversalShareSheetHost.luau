local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ReactRoblox")
local ShareSheetView = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetView")
local useShareSheetViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/useShareSheetViewModel")
local useUniversalShareSheetViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/UniversalShareSheet/useUniversalShareSheetViewModel")

local defineFastInt = game:DefineFastInt("ShareSheetSnackbarAutoDismissSeconds", 5)

local useOverlay = Foundation.Hooks.useOverlay
local useTokens = Foundation.Hooks.useTokens

local function UniversalShareSheetContent(p2)
	local v5 = useShareSheetViewModel(p2)
	return React.createElement(ShareSheetView, v5)
end

local function UniversalShareSheetHost()
	local state, setState = React.useState(nil)
	local v5 = useOverlay()
	local v6 = useTokens()
	local v7 = useUniversalShareSheetViewModel()
	local v8 = React.useCallback(function()
		setState(nil)
	end, {})
	React.useEffect(function()
		if state == nil then
			return
		end

		local thread = task.delay(defineFastInt, v8)
		return function()
			task.cancel(thread)
		end
	end, { state, v8 })
	local action = if state then state.action else nil

	local v9 = action and {
		onActivated = function(): nil
			v8()
			action.onActivated()
			return nil
		end,
		text = action.text
	} or nil

	local createElement = React.createElement
	local fragment = React.Fragment

	local v12 = if v7 then React.createElement(UniversalShareSheetContent, {
		context = v7.context,
		formatSuccessSnackbarText = v7.formatSuccessSnackbarText,
		isOpen = v7.isOpen,
		messagePlaceholder = v7.messagePlaceholder,
		onCloseWithReason = v7.onCloseWithReason,
		onShareSendResultSnackbar = setState,
		recipientSource = v7.recipientSource,
		telemetryId = v7.telemetryId,
		url = v7.url
	}) else nil

	local v13 = if state and v5 then ReactRoblox.createPortal(React.createElement(Foundation.Snackbar, {
		action = v9,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -v6.Padding.XLarge),
		testId = "share-sheet-snackbar",
		title = state.title,
		ZIndex = 999
	}), v5) else nil
	return createElement(fragment, nil, {
		ShareSheet = v12,
		ShareSendResultSnackbar = v13
	})
end

return React.memo(UniversalShareSheetHost)
