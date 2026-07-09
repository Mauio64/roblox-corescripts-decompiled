local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local t = require(CorePackages.Packages.t)
local AppCard = require(CorePackages.Workspace.Packages.RobloxAppNavigationCore).AppCard
local SceneView = RoactNavigation.SceneView
local FFlagAXUsePreloadingSwitchView = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXUsePreloadingSwitchView
local t1 = {
	keepVisitedScreensMounted = false
}
local v10 = Roact.Component:extend("PreloadingSwitchView")

v10.validateProps = t.interface({
	navigation = t.interface({
		state = t.interface({
			index = t.number,
			routes = t.array(t.table)
		})
	}),
	navigationConfig = t.optional(t.interface({
		keepVisitedScreensMounted = t.optional(t.boolean)
	})),
	screenProps = t.optional(t.any),
	descriptors = t.table
})

function v10.getDerivedStateFromProps(p1, p2) -- line: 42
	-- upvalues: Cryo (copy), t1 (copy)
	local state = p1.navigation.state
	local key = state.routes[state.index].key
	local descriptors = p1.descriptors
	local keepVisitedScreensMounted = Cryo.Dictionary.join(t1, p1.navigationConfig or {}).keepVisitedScreensMounted
	local t2 = {
		[key] = true
	}

	if keepVisitedScreensMounted then
		for v19 in p2.visitedScreenKeys or {} do
			if descriptors[v19] ~= nil then
				t2[v19] = true
			end
		end
	end

	return {
		visitedScreenKeys = t2
	}
end

local function alwaysRenderScreen(p3) -- line: 68
	return p3.options and p3.options.alwaysRendered
end

function v10.render(p4) -- line: 72
	-- upvalues: FFlagAXUsePreloadingSwitchView (copy), Roact (copy), AppCard (copy), SceneView (copy)
	local state = p4.props.navigation.state
	local screenProps = p4.props.screenProps
	local descriptors = p4.props.descriptors
	local visitedScreenKeys = p4.state.visitedScreenKeys
	local key = state.routes[state.index].key
	local t3 = {}

	for v28, v29 in descriptors do
		local v30 = v28 == key

		if visitedScreenKeys[v28] == true or v29.options and v29.options.alwaysRendered then
			t3["card_" .. v28] = if not FFlagAXUsePreloadingSwitchView then Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ClipsDescendants = false,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				Visible = v30
			}, {
				Content = Roact.createElement(SceneView, {
					component = v29.getComponent(),
					navigation = v29.navigation,
					screenProps = screenProps
				})
			}) else Roact.createElement(AppCard, {
				isActive = v30,
				descriptor = v29,
				screenProps = screenProps,
				isVisible = v30
			})
		end
	end

	return Roact.createElement("Folder", nil, t3)
end

return v10
