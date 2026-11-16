local GuiService = game:GetService("GuiService")

local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior
local restoreSelectionIfStranded = require(ChatUIPrimitives.Hooks.restoreSelectionIfStranded)

local FFlagExpChatMemoizeExpressionTrayFocusRootRender = require(ChatUIPrimitives.Flags.FFlagExpChatMemoizeExpressionTrayFocusRootRender)

local FFlagExpChatExpressionTrayRestoreGatedByInputMode = require(ChatUIPrimitives.Flags.FFlagExpChatExpressionTrayRestoreGatedByInputMode)

local function ExpressionTrayFocusRoot(p)
	local FocusNavigationUtils = require(parent.FocusNavigationUtils)
	local useFocusRoot = FocusNavigationUtils.useFocusRoot
	local useLastInputMode = FocusNavigationUtils.useLastInputMode
	local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

	local ref = React.useRef(nil)

	local v = useLastInputMode()
	local ref2 = React.useRef(false)
	React.useEffect(function(): nil
		if
			ref2.current
			and not p.isOpen
			and (not FFlagExpChatExpressionTrayRestoreGatedByInputMode or v == "Focus")
		then
			restoreSelectionIfStranded(GuiService, ref.current)
		end

		ref2.current = p.isOpen
		return nil
	end, { p.isOpen, v })

	local defaultFocusRef, containerRef = useDefaultFocusBehavior((useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = p.isOpen,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false
	})))

	if not FFlagExpChatMemoizeExpressionTrayFocusRootRender then
		return p.render({
			entryButtonRef = ref,
			defaultFocusRef = defaultFocusRef,
			containerRef = containerRef
		})
	end

	local render = p.render
	return React.useMemo(function()
		return render({
			entryButtonRef = ref,
			defaultFocusRef = defaultFocusRef,
			containerRef = containerRef
		})
	end, { render, defaultFocusRef, containerRef })
end

return ExpressionTrayFocusRoot
