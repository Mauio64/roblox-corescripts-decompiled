local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local makeEvents = require(Modules.AvatarExperience.Common.Util.makeEvents)
local Roact = require(CorePackages.Packages.Roact)
local SceneInteractionCallbacksContext = require(script.Parent.SceneInteractionCallbacksContext)
local SceneInteractionEventsContext = require(script.Parent.SceneInteractionEventsContext)
local v7 = Roact.PureComponent:extend("SceneInteractionProvider")

function v7.init(p1) -- line: 14
	-- upvalues: makeEvents (copy)
	local v9, v10, v11 = makeEvents({
		"panByDistance",
		"panByPixels",
		"rotateByRadians",
		"rotateByPixels",
		"setAngularVelocityByPixels",
		"zoomStraight",
		"zoomToPoint"
	})

	p1.events = v9
	p1.callbacks = v10
	p1.cleanups = v11
end
function v7.render(p2) -- line: 26
	-- upvalues: Roact (copy), SceneInteractionCallbacksContext (copy), SceneInteractionEventsContext (copy)
	return Roact.createElement(SceneInteractionCallbacksContext.Provider, {
		value = p2.callbacks
	}, {
		SceneInteractionEventsProvider = Roact.createElement(SceneInteractionEventsContext.Provider, {
			value = p2.events
		}, p2.props[Roact.Children])
	})
end
function v7.willUnmount(p3) -- line: 36
	for _, v15 in p3.cleanups do
		v15()
	end
end

return v7
