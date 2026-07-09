local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalyticsAppRouter = require(Modules.LuaApp.Services.RoactAnalyticsAppRouter)
local t1 = {
	2,
	10
}
local v7 = Roact.PureComponent:extend("PageHeartbeatTimer")

function v7.init(p1) -- line: 11
	-- upvalues: t1 (copy)
	p1.tasks = {}

	function p1.createDelayedTask(p2, p3, p4, p5) -- line: 14
		-- upvalues: p1 (copy)
		local u17 = false;

		(p1.props.mockTaskDelay and p1.props.mockTaskDelay or task.delay)(p2, function() -- line: 17
			-- upvalues: u17 (ref), p5 (copy), p3 (copy), p4 (copy)
			if not u17 then
				p5(p3, p4)
			end
		end)

		return function() -- line: 22
			-- upvalues: u17 (ref)
			u17 = true
		end
	end
	function p1.cancelTasks() -- line: 27
		-- upvalues: p1 (copy)
		for _, v in ipairs(p1.tasks) do
			if v ~= nil then
				v()
			end
		end

		p1.tasks = {}
	end
	function p1.onPageChanged() -- line: 36
		-- upvalues: p1 (copy), t1 (copy)
		local analytics = p1.props.analytics
		local currentPageGoal = p1.props.currentPageGoal

		p1.cancelTasks()

		for i, v in ipairs(t1) do
			p1.tasks[i] = p1.createDelayedTask(v, i, currentPageGoal, function(p6, p7) -- line: 45
				-- upvalues: p1 (copy), analytics (copy)
				if p7 == p1.props.currentPageGoal then
					analytics.reportPageHeartbeat(p6, p7)
				end
			end)
		end
	end
end
function v7.render(_) -- line: 55
end
function v7.didUpdate(p9) -- line: 57
	p9.onPageChanged()
end
function v7.didMount(p10) -- line: 61
	p10.onPageChanged()
end
function v7.willUnmount(p11) -- line: 65
	p11.cancelTasks()
end

return RoactServices.connect({
	analytics = RoactAnalyticsAppRouter
})(v7)
