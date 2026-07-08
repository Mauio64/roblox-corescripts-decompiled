local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local withNavigation = require(script.Parent.withNavigation)
local Events = require(ParentParent.Events)
local t1 = {
	[Events.WillFocus] = "onWillFocus",
	[Events.DidFocus] = "onDidFocus",
	[Events.WillBlur] = "onWillBlur",
	[Events.DidBlur] = "onDidBlur"
}
local v7 = React.Component:extend("NavigationEvents")

function v7.didMount(p1) -- line: 51
	p1:subscribeAll()
end
function v7.didUpdate(p2, p3) -- line: 58
	if p2.props.navigation ~= p3.navigation then
		p2:removeAll()
		p2:subscribeAll()
	end
end
function v7.willUnmount(p4) -- line: 66
	p4:removeAll()
end
function v7.getPropListener(p5, p6) -- line: 70
	-- upvalues: t1 (copy)
	return p5.props[t1[p6]]
end
function v7.subscribeAll(p7) -- line: 74
	-- upvalues: t1 (copy)
	local navigation = p7.props.navigation

	p7.subscriptions = {}

	for v16 in t1 do
		p7.subscriptions[v16] = navigation.addListener(v16, function(...) -- line: 80
			-- upvalues: p7 (copy), v16 (copy)
			local v21 = p7:getPropListener(v16)

			if v21 then
				v21(...)
			end
		end)
	end
end
function v7.removeAll(p8) -- line: 90
	-- upvalues: t1 (copy)
	for v18 in t1 do
		local v19 = p8.subscriptions[v18]

		if v19 then
			v19.remove()
			p8.subscriptions[v18] = nil
		end
	end
end
function v7.render(_) -- line: 100
	return nil
end

return withNavigation(v7)
