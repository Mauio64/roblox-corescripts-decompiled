local parent = script.Parent.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local withNavigation = require(script.Parent.withNavigation)
local Events = require(parent.Events)

local v = {
	[Events.WillFocus] = "onWillFocus",
	[Events.DidFocus] = "onDidFocus",
	[Events.WillBlur] = "onWillBlur",
	[Events.DidBlur] = "onDidBlur"
}

local extended = React.Component:extend("NavigationEvents")

function extended:didMount()
	self:subscribeAll()
end

function extended:didUpdate(p)
	if self.props.navigation ~= p.navigation then
		self:removeAll()
		self:subscribeAll()
	end
end

function extended:willUnmount()
	self:removeAll()
end

function extended:getPropListener(p)
	return self.props[v[p]]
end

function extended:subscribeAll()
	local navigation = self.props.navigation

	self.subscriptions = {}

	for k in v do
		self.subscriptions[k] = navigation.addListener(k, function(...)
			local propListener = self:getPropListener(k)

			if propListener then
				propListener(...)
			end
		end)
	end
end

function extended:removeAll()
	for k in v do
		local subscription = self.subscriptions[k]

		if not subscription then
			continue
		end

		subscription.remove()
		self.subscriptions[k] = nil
	end
end

function extended.render(_): nil
	return nil
end

return withNavigation(extended)
