local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local t = require(CorePackages.Packages.t)
local appCard = require("@luauforge/bundled/dCw").AppCard
local sceneView = RoactNavigation.SceneView

local fFlagAXUsePreloadingSwitchView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUsePreloadingSwitchView

local v5 = { keepVisitedScreensMounted = false }

local extended = Roact.Component:extend("PreloadingSwitchView")

extended.validateProps = t.interface({
	navigation = t.interface({
		state = t.interface({ index = t.number, routes = t.array(t.table) })
	}),
	navigationConfig = t.optional(t.interface({
		keepVisitedScreensMounted = t.optional(t.boolean)
	})),
	screenProps = t.optional(t.any),
	descriptors = t.table
})

function extended.getDerivedStateFromProps(data, p2)
	local state = data.navigation.state
	local key = state.routes[state.index].key
	local descriptors = data.descriptors

	local keepVisitedScreensMounted = Cryo.Dictionary.join(v5, data.navigationConfig or {}).keepVisitedScreensMounted

	local v6 = { [key] = true }

	if keepVisitedScreensMounted then
		for k in p2.visitedScreenKeys or {} do
			if descriptors[k] ~= nil then
				v6[k] = true
			end
		end
	end

	return { visitedScreenKeys = v6 }
end

local function alwaysRenderScreen(p2)
	return p2.options and p2.options.alwaysRendered
end

function extended.render(p2)
	local state = p2.props.navigation.state
	local screenProps = p2.props.screenProps
	local descriptors = p2.props.descriptors
	local visitedScreenKeys = p2.state.visitedScreenKeys
	local key = state.routes[state.index].key

	local v6 = {}

	for k, descriptor in descriptors do
		local v7 = k == key

		if not (visitedScreenKeys[k] == true or descriptor.options and descriptor.options.alwaysRendered) then
			continue
		end

		local v8 = "card_" .. k
		local v9 = if fFlagAXUsePreloadingSwitchView then Roact.createElement(appCard, {
			isActive = v7,
			descriptor = descriptor,
			screenProps = screenProps,
			isVisible = v7
		}) else Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = false,
			BorderSizePixel = 0,
			Visible = v7
		}, {
			Content = Roact.createElement(sceneView, {
				component = descriptor.getComponent(),
				navigation = descriptor.navigation,
				screenProps = screenProps
			})
		})
		v6[v8] = v9
	end

	return Roact.createElement("Folder", nil, v6)
end

return extended
