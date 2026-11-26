local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/createCoachmarkImpressionCache")
local usePersistentCoachmarkViewModel = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/PersistentCoachmark/usePersistentCoachmarkViewModel")

local educationalTooltip = Foundation.EducationalTooltip

local function PersistentCoachmark(props)
	local v5 = usePersistentCoachmarkViewModel({
		impressionCache = props.impressionCache,
		maxImpressions = props.maxImpressions,
		autoDismissSeconds = props.autoDismissSeconds,
		isSessionHandled = props.isSessionHandled,
		onSessionHandled = props.onSessionHandled,
		onImpression = props.onImpression,
		onDismissed = props.onDismissed
	})

	return React.createElement(educationalTooltip, {
		LayoutOrder = props.layoutOrder,
		isOpen = v5.isOpen and not props.hidden,
		onClose = v5.onClose,
		side = props.side or Foundation.Enums.PopoverSide.Bottom,
		align = props.align or Foundation.Enums.PopoverAlign.End,
		title = props.title,
		text = props.text
	}, props.children)
end

return PersistentCoachmark
