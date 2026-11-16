local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)

local extended = Roact.PureComponent:extend("SignalConnection")

extended.validateProps = t.strictInterface({ callback = t.callback, signal = t.table })

function extended:init()
	self.connection = nil
end

function extended.render(p2): nil
	return nil
end

function extended:didMount()
	self.connection = self.props.signal:connect(self.props.callback)
end

function extended:didUpdate(p2)
	if self.props.callback ~= p2.callback or self.props.signal ~= p2.signal then
		self.connection:disconnect()
		self.connection = self.props.signal:connect(self.props.callback)
	end
end

function extended:willUnmount()
	if self.connection then
		self.connection:disconnect()
		self.connection = nil
	end
end

return extended
