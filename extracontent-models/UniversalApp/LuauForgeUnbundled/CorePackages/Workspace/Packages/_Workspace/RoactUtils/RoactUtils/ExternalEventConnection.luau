local getFFlagMigrateRoactUtilsToReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/SharedFlags").GetFFlagMigrateRoactUtilsToReactUtils
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/ReactUtils")

if getFFlagMigrateRoactUtilsToReactUtils() then
	return ReactUtils.EventConnection
end

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/Roact")
local extended = Roact.Component:extend("ExternalEventConnection")

function extended:init()
	self.connection = nil
end

function extended.render(p2)
	return Roact.oneChild(p2.props[Roact.Children])
end

function extended:didMount()
	self.connection = self.props.event:Connect(self.props.callback)
end

function extended:didUpdate(p2)
	if self.props.event ~= p2.event or self.props.callback ~= p2.callback then
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
