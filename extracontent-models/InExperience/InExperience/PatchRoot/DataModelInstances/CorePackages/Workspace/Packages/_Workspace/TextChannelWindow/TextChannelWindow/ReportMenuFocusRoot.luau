local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent
local React = require(parent.React)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local restoreSelectionIfStranded = ChatUIPrimitives.Hooks.restoreSelectionIfStranded

local function ReportMenuFocusRoot(p)
	local FocusNavigationUtils = require(parent.FocusNavigationUtils)
	local useFocusRoot = FocusNavigationUtils.useFocusRoot
	local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

	local ref = React.useRef(nil)

	local ref2 = React.useRef(p.isOpen)
	React.useEffect(function(): nil
		if ref2.current and not p.isOpen then
			restoreSelectionIfStranded(GuiService, ref.current)
		end

		ref2.current = p.isOpen
		return nil
	end, { p.isOpen })

	local containerRef = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = p.isOpen,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false
	})

	return p.render({ triggerRef = ref, containerRef = containerRef })
end

return ReportMenuFocusRoot
