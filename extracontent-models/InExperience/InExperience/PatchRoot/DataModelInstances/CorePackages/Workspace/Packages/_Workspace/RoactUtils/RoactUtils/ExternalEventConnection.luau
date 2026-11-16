local parent = script:FindFirstAncestor("RoactUtils").Parent

local SharedFlags = require(parent.SharedFlags)
local GetFFlagMigrateRoactUtilsToReactUtils = SharedFlags.GetFFlagMigrateRoactUtilsToReactUtils
local ReactUtils = require(parent.ReactUtils)

if GetFFlagMigrateRoactUtilsToReactUtils() then
	return ReactUtils.EventConnection
end

local Roact = require(parent.Roact)
local extended = Roact.Component:extend("ExternalEventConnection")

function extended:init()
	self.connection = nil
end

function extended.render(p)
	return Roact.oneChild(p.props[Roact.Children])
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
