local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/InputHandlers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/ReactFocusNavigation")

local sheet = Foundation.Sheet
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
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

	local v5 = React.useCallback(function()
		if ref.current then
			return
		end

		ref.current = true
		setState(true)

		if props.onClose then
			props.onClose()
		end
	end, { props.onClose })
	local v6 = not (props.isOpen == false) and not state

	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					v5()
					object:cancel()
				end)
			}
		}
	end, { v5 })
	local v8 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		isFocusable = v6,
		eventMap = navigateBacks,
		eventHandlers = v7
	})

	local fn = props.onSnapPointChanged and function(p2, p3)
		props.onSnapPointChanged(nil, nil, { snapPoint = p2, snapPointIndex = p3 })
	end or nil

	local createElement = React.createElement
	local root = sheet.Root
	local v9 = {
		ref = v8,
		isOpen = v6,
		preferCenterSheet = props.preferCenterSheet,
		size = props.size,
		onClose = v5,
		centerSheetHeight = props.centerSheetHeight,
		snapPoints = props.snapPoints,
		defaultSnapPointIndex = props.defaultSnapPointIndex,
		onSnapPointChanged = fn,
		testId = props.testId
	}

	local v11 = if props.headerComponent then React.createElement(sheet.Header, {
		hasCloseAffordance = props.headerHasCloseAffordance == true
	}, { Content = props.headerComponent }) else nil

	local v12 = if props.fullBleedComponent then React.createElement(sheet.FullBleed, nil, {
		Content = props.fullBleedComponent
	}) else nil

	local v13 = if props.contentComponents then React.createElement(
		sheet.Content,
		{
			isContentFullBleed = props.contentIsFullBleed,
			isReversed = props.contentIsReversed
		},
		props.contentComponents
	) else nil

	local v14 = if props.actionComponents then React.createElement(
		sheet.Actions,
		nil,
		props.actionComponents
	) else nil
	return createElement(root, v9, {
		Header = v11,
		FullBleed = v12,
		Content = v13,
		Actions = v14
	})
end

return React.memo(SduiSheet)
