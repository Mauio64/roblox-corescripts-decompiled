local parent = script.Parent
local UIManager = require(parent.UIManager)
local Constants = require(parent.Constants)

return function(p, panelType)
	local uiGroup = Constants.ROACT_PANEL_UIGROUP_MAP[panelType]

	local cameraFixedPanelProp = uiGroup
		and { uiGroupElementOffset = Constants.ROACT_PANEL_UIGROUP_ELEMENT_OFFSET_MAP[panelType] }
		or nil

	local v = {
		panelObject = p.current,
		uiType = Constants.SpatialUIType.SpatialUIRoact,
		panelType = panelType,
		headScale = 1,
		panelPositionProps = { uiGroup = uiGroup, cameraFixedPanelProp = cameraFixedPanelProp }
	}

	UIManager.getInstance():registerRoactPanel(panelType, v)
end
