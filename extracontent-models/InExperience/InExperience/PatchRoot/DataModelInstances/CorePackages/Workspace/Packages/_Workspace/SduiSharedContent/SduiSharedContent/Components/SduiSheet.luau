local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
require(parent.ReactFocusNavigation)

local Sheet = Foundation.Sheet
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function SduiSheet(props)
	local state, setState = React.useState(false)

	local ref = React.useRef(false)
	React.useEffect(function()
		if props.isOpen ~= false then
			ref.current = false
		end

		setState(false)
	end, { props.isOpen })

	local onClose = React.useCallback(function()
		if ref.current then
			return
		end

		ref.current = true
		setState(true)

		if props.onClose then
			props.onClose()
		end
	end, { props.onClose })
	local v

	if props.isOpen == false then
		v = false
	else
		v = not state
	end

	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onClose()
					object:cancel()
				end)
			}
		}
	end, { onClose })
	local ref2 = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		isFocusable = v,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers
	})

	local fn = props.onSnapPointChanged and function(snapPoint: number, snapPointIndex: number)
		props.onSnapPointChanged(nil, nil, {
			snapPoint = snapPoint,
			snapPointIndex = snapPointIndex
		})
	end or nil

	local createElement = React.createElement
	local root = Sheet.Root
	local v2 = {
		ref = ref2,
		isOpen = v,
		preferCenterSheet = props.preferCenterSheet,
		size = props.size,
		onClose = onClose,
		centerSheetHeight = props.centerSheetHeight,
		snapPoints = props.snapPoints,
		defaultSnapPointIndex = props.defaultSnapPointIndex,
		onSnapPointChanged = fn,
		testId = props.testId
	}
	local header

	if props.headerComponent then
		header = React.createElement(Sheet.Header, {
			hasCloseAffordance = props.headerHasCloseAffordance == true
		}, { Content = props.headerComponent })
	end

	local fullBleed

	if props.fullBleedComponent then
		fullBleed = React.createElement(Sheet.FullBleed, nil, { Content = props.fullBleedComponent })
	end

	local content

	if props.contentComponents then
		content = React.createElement(
			Sheet.Content,
			{ isContentFullBleed = props.contentIsFullBleed, isReversed = props.contentIsReversed },
			props.contentComponents
		)
	end

	local actions

	if props.actionComponents then
		actions = React.createElement(Sheet.Actions, nil, props.actionComponents)
	end

	return createElement(root, v2, {
		Header = header,
		FullBleed = fullBleed,
		Content = content,
		Actions = actions
	})
end

return React.memo(SduiSheet)
