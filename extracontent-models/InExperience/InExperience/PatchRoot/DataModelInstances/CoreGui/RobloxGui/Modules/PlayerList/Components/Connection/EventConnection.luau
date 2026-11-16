local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)

local extended = Roact.Component:extend("EventConnection")

function extended:init()
	self.connection = nil
end

function extended:didMount()
	self.connection = self.props.event:Connect(self.props.callback)
end

function extended.render(_): nil
	return nil
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
