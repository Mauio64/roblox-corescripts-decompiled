local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/React")

local dialogSize = Foundation.Enums.DialogSize
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View
local useScaledValue = Foundation.Hooks.useScaledValue

local useSurveyFocusRefs = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Hooks/useSurveyFocusRefs")

local function SurveyModal(props)
	local isOpen = props.isOpen ~= false
	local onClose = props.onClose

	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local v5 = React.useCallback(function(p2)
		setState(p2.AbsoluteSize.Y)
	end, {})
	local v6 = React.useCallback(function(p2)
		setState2(p2.AbsoluteSize.Y)
	end, {})

	local v7 = useScaledValue(116)
	local v8 = (not props.children and 0 or state) + v7 + (not props.footer and 0 or state2)
	local v9 = React.useMemo(function()
		return { v8 }
	end, { v8 })

	local v10 = useSurveyFocusRefs(focusNavigableSurfaceIdentifierEnum.CentralOverlay, onClose)

	local createElement = React.createElement
	local root = sheet.Root
	local v11 = {
		isOpen = isOpen,
		onClose = onClose,
		preferCenterSheet = true,
		size = dialogSize.Large,
		centerSheetHeight = v8,
		snapPoints = v9,
		ref = v10
	}

	local createElement2 = React.createElement
	local header = sheet.Header

	local v14 = if props.title then React.createElement(text, {
		Text = props.title,
		tag = "fill auto-y text-heading-small text-wrap text-align-x-left content-emphasis"
	}) or nil else nil
	return createElement(root, v11, {
		Header = createElement2(header, { hasCloseAffordance = true }, { Title = v14 }),
		Content = React.createElement(sheet.Content, {}, {
			Body = React.createElement(
				view,
				{
					tag = "col size-full-0 auto-y padding-bottom-small",
					onAbsoluteSizeChanged = v5
				},
				props.children
			)
		}),
		Actions = props.footer and React.createElement(sheet.Actions, {}, {
			Footer = React.createElement(
				view,
				{ tag = "row size-full-0 auto-y", onAbsoluteSizeChanged = v6 },
				props.footer
			)
		}) or nil
	})
end

return React.memo(SurveyModal)
