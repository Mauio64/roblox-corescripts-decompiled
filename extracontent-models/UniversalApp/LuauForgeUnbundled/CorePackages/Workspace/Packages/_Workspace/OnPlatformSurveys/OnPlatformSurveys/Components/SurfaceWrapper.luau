local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/React")

local view = Foundation.View

local Surface = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Enums/Surface")
local SurveyModal = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Components/SurveyModal")

local function SurfaceWrapper(props)
	if props.surface == Surface.Modal then
		return React.createElement(SurveyModal, {
			isOpen = props.isOpen,
			onClose = props.onClose,
			title = props.title,
			footer = props.footer,
			children = props.children
		})
	end

	return React.createElement(view, { tag = "size-full-0 auto-y" }, props.children)
end

return React.memo(SurfaceWrapper)
