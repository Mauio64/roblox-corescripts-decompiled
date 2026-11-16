local parent = script:FindFirstAncestor("ShareSheet").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local ShareSheetView = require(script.Parent.Parent.ShareSheetView)
local useShareSheetViewModel = require(script.Parent.Parent.useShareSheetViewModel)
local useUniversalShareSheetViewModel = require(script.Parent.useUniversalShareSheetViewModel)

local defineFastInt = game:DefineFastInt("ShareSheetSnackbarAutoDismissSeconds", 5)

local useOverlay = Foundation.Hooks.useOverlay
local useTokens = Foundation.Hooks.useTokens

local function UniversalShareSheetContent(p)
	local v = useShareSheetViewModel(p)
	return React.createElement(ShareSheetView, v)
end

local function UniversalShareSheetHost()
	local state, setState = React.useState(nil)
	local v = useOverlay()
	local v2 = useTokens()
	local v3 = useUniversalShareSheetViewModel()
	local v4 = React.useCallback(function()
		setState(nil)
	end, {})
	React.useEffect(function()
		if state == nil then
			return
		end

		local thread = task.delay(defineFastInt, v4)
		return function()
			task.cancel(thread)
		end
	end, { state, v4 })
	local action

	if state then
		action = state.action
	else
		action = nil
	end

	local action2 = action and {
		onActivated = function(): nil
			v4()
			action.onActivated()
			return nil
		end,
		text = action.text
	} or nil

	local createElement = React.createElement
	local fragment = React.Fragment
	local shareSheet

	if v3 then
		shareSheet = React.createElement(UniversalShareSheetContent, {
			context = v3.context,
			formatSuccessSnackbarText = v3.formatSuccessSnackbarText,
			isOpen = v3.isOpen,
			messagePlaceholder = v3.messagePlaceholder,
			onCloseWithReason = v3.onCloseWithReason,
			onShareSendResultSnackbar = setState,
			recipientSource = v3.recipientSource,
			telemetryId = v3.telemetryId,
			url = v3.url
		})
	end

	local shareSendResultSnackbar

	if state and v then
		shareSendResultSnackbar = ReactRoblox.createPortal(React.createElement(Foundation.Snackbar, {
			action = action2,
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -v2.Padding.XLarge),
			testId = "share-sheet-snackbar",
			title = state.title,
			ZIndex = 999
		}), v)
	end

	return createElement(fragment, nil, {
		ShareSheet = shareSheet,
		ShareSendResultSnackbar = shareSendResultSnackbar
	})
end

return React.memo(UniversalShareSheetHost)
