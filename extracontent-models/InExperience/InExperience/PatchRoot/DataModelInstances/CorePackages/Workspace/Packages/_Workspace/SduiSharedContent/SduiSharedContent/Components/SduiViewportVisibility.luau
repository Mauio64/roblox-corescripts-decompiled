local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Impressions = require(parent.Impressions)
local ViewportVisibilityImpressionsDetector = Impressions.ViewportVisibilityImpressionsDetector

local View = Foundation.View

local function SduiViewportVisibility(props)
	local ref = React.useRef(nil)
	local v = props.onView ~= nil

	local threshold = math.clamp(props.visibilityThreshold or 0.5, 0.01, 1)

	local createElement = React.createElement
	local v2 = {
		tag = props.tag or "size-full-0 auto-y",
		LayoutOrder = props.layoutOrder,
		Visible = props.visible,
		ref = 0
	}
	local ref2

	if v then
		ref2 = ref
	end

	v2.ref = ref2
	local element = createElement(View, v2, { Content = props.contentComponent })

	if v then
		return React.createElement(React.Fragment, nil, {
			Content = element,
			Detector = React.createElement(ViewportVisibilityImpressionsDetector, {
				targetRef = ref,
				onImpression = props.onView,
				threshold = threshold
			})
		})
	end

	return element
end

return React.memo(SduiViewportVisibility)
