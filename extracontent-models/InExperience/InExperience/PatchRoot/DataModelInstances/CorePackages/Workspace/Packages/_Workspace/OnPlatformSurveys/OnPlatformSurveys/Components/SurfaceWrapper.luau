local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local Foundation = require(OnPlatformSurveysParent.Foundation)
local React = require(OnPlatformSurveysParent.React)
local View = Foundation.View
local Surface = require(OnPlatformSurveys.Enums.Surface)
local SurveyModal = require(OnPlatformSurveys.Components.SurveyModal)

local function SurfaceWrapper(t1: {[any]: any}) -- line: 24
	-- upvalues: Surface (copy), React (copy), SurveyModal (copy), View (copy)
	if t1.surface == Surface.Modal then
		return React.createElement(SurveyModal, {
			isOpen = t1.isOpen,
			onClose = t1.onClose,
			title = t1.title,
			footer = t1.footer,
			children = t1.children
		})
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y"
	}, t1.children)
end

return React.memo(SurfaceWrapper)
