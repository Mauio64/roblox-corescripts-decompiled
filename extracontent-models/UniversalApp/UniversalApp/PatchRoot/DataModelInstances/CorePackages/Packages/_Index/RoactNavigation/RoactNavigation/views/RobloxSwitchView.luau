local parent = script.Parent
local parent2 = parent.Parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object
local React = require(parent2.React)
local SceneView = require(parent.SceneView)

local v = { keepVisitedScreensMounted = false }

local extended = React.Component:extend("RobloxSwitchView")

function extended.getDerivedStateFromProps(data, p)
	local state = data.navigation.state
	local key = state.routes[state.index].key
	local descriptors = data.descriptors

	local keepVisitedScreensMounted = Object.assign(table.clone(v), data.navigationConfig or {}).keepVisitedScreensMounted

	local visitedScreenKeys = { [key] = true }

	if keepVisitedScreensMounted and p.visitedScreenKeys then
		for k in p.visitedScreenKeys do
			if descriptors[k] ~= nil then
				visitedScreenKeys[k] = true
			end
		end
	end

	return { visitedScreenKeys = visitedScreenKeys }
end

function extended:init()
	self.state = {}
end

function extended.render(p)
	local state = p.props.navigation.state
	local screenProps = p.props.screenProps
	local descriptors = p.props.descriptors
	local visitedScreenKeys = p.state.visitedScreenKeys
	local key = state.routes[state.index].key

	local children = {}

	for k, descriptor in descriptors do
		local visible = k == key

		if visitedScreenKeys[k] == true then
			children["card_" .. k] = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ClipsDescendants = false,
				BorderSizePixel = 0,
				Visible = visible
			}, {
				Content = React.createElement(SceneView, {
					component = descriptor.getComponent(),
					navigation = descriptor.navigation,
					screenProps = screenProps
				})
			})
		end
	end

	return React.createElement("Folder", nil, children)
end

return extended
