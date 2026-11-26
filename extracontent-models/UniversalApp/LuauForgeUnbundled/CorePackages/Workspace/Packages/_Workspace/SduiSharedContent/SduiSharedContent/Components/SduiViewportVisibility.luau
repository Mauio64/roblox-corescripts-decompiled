local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local viewportVisibilityImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Impressions").ViewportVisibilityImpressionsDetector

local view = Foundation.View

local function SduiViewportVisibility(props)
	local ref = React.useRef(nil)
	local v5 = props.onView ~= nil

	local v6 = math.clamp(props.visibilityThreshold or 0.5, 0.01, 1)

	local element = React.createElement(view, {
		tag = props.tag or "size-full-0 auto-y",
		LayoutOrder = props.layoutOrder,
		Visible = props.visible,
		ref = if v5 then ref else nil
	}, { Content = props.contentComponent })

	if v5 then
		return React.createElement(React.Fragment, nil, {
			Content = element,
			Detector = React.createElement(viewportVisibilityImpressionsDetector, {
				targetRef = ref,
				onImpression = props.onView,
				threshold = v6
			})
		})
	end

	return element
end

return React.memo(SduiViewportVisibility)
