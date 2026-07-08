local scriptParent = script.Parent
local UIManager = require(scriptParent.UIManager)
local Constants = require(scriptParent.Constants)

return function(t1: {[any]: any}, p1) -- line: 7
	-- upvalues: Constants (copy), UIManager (copy)
	local t2 = nil
	local v7 = Constants.ROACT_PANEL_UIGROUP_MAP[p1]

	if v7 then
		t2 = {
			uiGroupElementOffset = Constants.ROACT_PANEL_UIGROUP_ELEMENT_OFFSET_MAP[p1]
		}
	end

	local t3 = {
		headScale = 1,
		panelObject = t1.current,
		uiType = Constants.SpatialUIType.SpatialUIRoact,
		panelType = p1,
		panelPositionProps = {
			uiGroup = v7,
			cameraFixedPanelProp = t2
		}
	}

	UIManager.getInstance():registerRoactPanel(p1, t3)
end
