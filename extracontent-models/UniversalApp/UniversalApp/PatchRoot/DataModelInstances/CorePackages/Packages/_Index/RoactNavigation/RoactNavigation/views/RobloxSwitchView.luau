local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object
local React = require(ParentParent.React)
local SceneView = require(scriptParent.SceneView)
local t1 = {
	keepVisitedScreensMounted = false
}
local v7 = React.Component:extend("RobloxSwitchView")

function v7.getDerivedStateFromProps(p1, p2) -- line: 16
	-- upvalues: Object (copy), t1 (copy)
	local state = p1.navigation.state
	local key = state.routes[state.index].key
	local descriptors = p1.descriptors
	local keepVisitedScreensMounted = Object.assign(table.clone(t1), p1.navigationConfig or {}).keepVisitedScreensMounted
	local t2 = {
		[key] = true
	}

	if keepVisitedScreensMounted and p2.visitedScreenKeys then
		for v15 in p2.visitedScreenKeys do
			if descriptors[v15] ~= nil then
				t2[v15] = true
			end
		end
	end

	return {
		visitedScreenKeys = t2
	}
end
function v7.init(p3) -- line: 44
	p3.state = {}
end
function v7.render(p4) -- line: 48
	-- upvalues: React (copy), SceneView (copy)
	local state = p4.props.navigation.state
	local screenProps = p4.props.screenProps
	local descriptors = p4.props.descriptors
	local visitedScreenKeys = p4.state.visitedScreenKeys
	local key = state.routes[state.index].key
	local t3 = {}

	for v24, v25 in descriptors do
		local v26 = v24 == key

		if visitedScreenKeys[v24] == true then
			t3["card_" .. v24] = React.createElement("Frame", {
				BackgroundTransparency = 1,
				ClipsDescendants = false,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				Visible = v26
			}, {
				Content = React.createElement(SceneView, {
					component = v25.getComponent(),
					navigation = v25.navigation,
					screenProps = screenProps
				})
			})
		end
	end

	return React.createElement("Folder", nil, t3)
end

return v7
