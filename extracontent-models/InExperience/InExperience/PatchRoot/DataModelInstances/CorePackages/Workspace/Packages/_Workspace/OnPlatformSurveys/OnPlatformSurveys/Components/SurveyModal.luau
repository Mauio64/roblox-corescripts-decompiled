local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local DialogSize = Foundation.Enums.DialogSize
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View
local useScaledValue = Foundation.Hooks.useScaledValue

local useSurveyFocusRefs = require(OnPlatformSurveys.Hooks.useSurveyFocusRefs)

local function SurveyModal(props)
	local isOpen = props.isOpen ~= false
	local onClose = props.onClose

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		setState(p.AbsoluteSize.Y)
	end, {})
	local onAbsoluteSizeChanged2 = React.useCallback(function(p)
		setState2(p.AbsoluteSize.Y)
	end, {})

	local v = useScaledValue(116)
	local centerSheetHeight = (not props.children and 0 or state) + v + (not props.footer and 0 or state2)
	local snapPoints = React.useMemo(function()
		return { centerSheetHeight }
	end, { centerSheetHeight })

	local ref = useSurveyFocusRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, onClose)

	local createElement = React.createElement
	local root = Sheet.Root
	local v2 = {
		isOpen = isOpen,
		onClose = onClose,
		preferCenterSheet = true,
		size = DialogSize.Large,
		centerSheetHeight = centerSheetHeight,
		snapPoints = snapPoints,
		ref = ref
	}

	local createElement2 = React.createElement
	local header = Sheet.Header
	local title

	if props.title then
		title = React.createElement(Text, {
				Text = props.title,
				tag = "fill auto-y text-heading-small text-wrap text-align-x-left content-emphasis"
			})
			or nil
	end

	return createElement(root, v2, {
		Header = createElement2(header, { hasCloseAffordance = true }, { Title = title }),
		Content = React.createElement(Sheet.Content, {}, {
			Body = React.createElement(
				View,
				{
					tag = "col size-full-0 auto-y padding-bottom-small",
					onAbsoluteSizeChanged = onAbsoluteSizeChanged
				},
				props.children
			)
		}),
		Actions = props.footer and React.createElement(Sheet.Actions, {}, {
			Footer = React.createElement(
				View,
				{ tag = "row size-full-0 auto-y", onAbsoluteSizeChanged = onAbsoluteSizeChanged2 },
				props.footer
			)
		}) or nil
	})
end

return React.memo(SurveyModal)
