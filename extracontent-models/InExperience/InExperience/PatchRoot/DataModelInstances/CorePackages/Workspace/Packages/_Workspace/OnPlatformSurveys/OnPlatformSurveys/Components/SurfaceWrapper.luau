local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View

local Surface = require(OnPlatformSurveys.Enums.Surface)
local SurveyModal = require(OnPlatformSurveys.Components.SurveyModal)

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

	return React.createElement(View, { tag = "size-full-0 auto-y" }, props.children)
end

return React.memo(SurfaceWrapper)
