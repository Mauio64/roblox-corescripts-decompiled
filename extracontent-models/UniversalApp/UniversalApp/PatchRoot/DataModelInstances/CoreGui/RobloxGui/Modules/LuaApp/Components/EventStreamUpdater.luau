local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local v7 = Roact.Component:extend("EventStreamUpdateComponent")

function v7.render(_) -- line: 10
	return nil
end
function v7.didMount(p2) -- line: 14
	-- upvalues: RunService (copy)
	local analytics = p2.props.analytics
	local releasePeriod = p2.props.releasePeriod

	local function releaseStream() -- line: 18
		-- upvalues: analytics (copy)
		analytics.EventStream:releaseRBXEventStream()
	end

	p2.releaseEvents = true
	spawn(function() -- line: 26
		-- upvalues: releasePeriod (copy), p2 (copy), analytics (copy)
		wait(releasePeriod)

		while p2.releaseEvents do
			analytics.EventStream:releaseRBXEventStream()
			wait(releasePeriod)
		end
	end)

	if not RunService:IsStudio() then
		game:BindToClose(function() -- line: 36
			-- upvalues: p2 (copy), analytics (copy)
			p2.releaseEvents = false
			analytics.EventStream:releaseRBXEventStream()
		end)
	end
end

return RoactServices.connect({
	analytics = RoactAnalytics
})(v7)
