local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)

local roact = dependencies.Roact
local extended = roact.Component:extend("ExternalEventConnection")

function extended:init()
	self.connection = nil
end

function extended.render(p)
	return roact.oneChild(p.props[roact.Children])
end

function extended:didMount()
	self.connection = self.props.event:Connect(self.props.callback)
end

function extended:didUpdate(p)
	if self.props.event ~= p.event or self.props.callback ~= p.callback then
		self.connection:Disconnect()

		self.connection = self.props.event:Connect(self.props.callback)
	end
end

function extended:willUnmount()
	if self.connection then
		self.connection:Disconnect()
		self.connection = nil
	end
end

return extended
