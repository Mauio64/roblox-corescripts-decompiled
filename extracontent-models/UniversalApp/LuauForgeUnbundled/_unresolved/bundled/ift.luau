local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local Roact = require(CorePackages.Packages.Roact)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/ecq")

local extended = Roact.Component:extend("EventStreamUpdateComponent")

function extended.render(p2): nil
	return nil
end

function extended:didMount()
	local analytics = self.props.analytics
	local releasePeriod = self.props.releasePeriod

	local function releaseStream()
		analytics.EventStream:releaseRBXEventStream()
	end

	self.releaseEvents = true
	spawn(function()
		wait(releasePeriod)

		while self.releaseEvents do
			analytics.EventStream:releaseRBXEventStream()

			wait(releasePeriod)
		end
	end)

	if not RunService:IsStudio() then
		game:BindToClose(function()
			self.releaseEvents = false
			analytics.EventStream:releaseRBXEventStream()
		end)
	end
end

return roactServices.connect({ analytics = module })(extended)
