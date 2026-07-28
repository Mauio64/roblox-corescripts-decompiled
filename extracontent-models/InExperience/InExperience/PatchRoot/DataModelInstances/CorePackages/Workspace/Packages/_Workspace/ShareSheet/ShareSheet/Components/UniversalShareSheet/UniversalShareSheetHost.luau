local Parent = script:FindFirstAncestor("ShareSheet").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local ReactRoblox = require(Parent.ReactRoblox)
local ShareSheetView = require(script.Parent.Parent.ShareSheetView)
local useShareSheetViewModel = require(script.Parent.Parent.useShareSheetViewModel)
local useUniversalShareSheetViewModel = require(script.Parent.useUniversalShareSheetViewModel)
local v8 = game:DefineFastInt("ShareSheetSnackbarAutoDismissSeconds", 5)
local useOverlay = Foundation.Hooks.useOverlay
local useTokens = Foundation.Hooks.useTokens

local function UniversalShareSheetContent(p1) -- line: 21
	-- upvalues: useShareSheetViewModel (copy), React (copy), ShareSheetView (copy)
	local v14 = useShareSheetViewModel(p1)

	return React.createElement(ShareSheetView, v14)
end
local function UniversalShareSheetHost() -- line: 26
	-- upvalues: React (copy), useOverlay (copy), useTokens (copy), useUniversalShareSheetViewModel (copy), v8 (copy), UniversalShareSheetContent (copy), ReactRoblox (copy), Foundation (copy)
	local v15, v16 = React.useState(nil)
	local v17 = useOverlay()
	local v18 = useTokens()
	local v19 = useUniversalShareSheetViewModel()
	local v20 = React.useCallback(function() -- line: 32
		-- upvalues: v16 (copy)
		v16(nil)
	end, {})

	React.useEffect(function() -- line: 35
		-- upvalues: v15 (copy), v8 (copy), v20 (copy)
		if v15 == nil then
			return
		end

		local thread = task.delay(v8, v20)

		return function() -- line: 41
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {
		v15,
		v20
	})

	local v21 = if not v15 then nil else v15.action
	local v22 = if not v21 then nil else {
		onActivated = function() -- line: 48
			-- upvalues: v20 (copy), v21 (copy)
			v20()
			v21.onActivated()

			return nil
		end,
		text = v21.text
	}

	return React.createElement(React.Fragment, nil, {
		ShareSheet = if not v19 then nil else React.createElement(UniversalShareSheetContent, {
			context = v19.context,
			formatSuccessSnackbarText = v19.formatSuccessSnackbarText,
			isOpen = v19.isOpen,
			messagePlaceholder = v19.messagePlaceholder,
			onClose = v19.onClose,
			onShareSendResultSnackbar = v16,
			url = v19.url
		}),
		ShareSendResultSnackbar = if not v15 or not v17 then nil else ReactRoblox.createPortal(React.createElement(Foundation.Snackbar, {
			testId = "share-sheet-snackbar",
			ZIndex = 999,
			action = v22,
			AnchorPoint = Vector2.new(0.5, 1),
			onClose = v20,
			Position = UDim2.new(0.5, 0, 1, -v18.Padding.XLarge),
			title = v15.title
		}), v17)
	})
end

return React.memo(UniversalShareSheetHost)
