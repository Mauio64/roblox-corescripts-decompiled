local module = require("@luauforge/bundled/ego")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/iaZ")

local v5 = { 2, 10 }

local extended = module.PureComponent:extend("PageHeartbeatTimer")

function extended:init()
	self.tasks = {}

	function self.createDelayedTask(p2, p3, p4, callback)
		local v6 = false
		(self.props.mockTaskDelay and self.props.mockTaskDelay or task.delay)(p2, function()
			if not v6 then
				callback(p3, p4)
			end
		end)
		return function()
			v6 = true
		end
	end

	function self.cancelTasks()
		for i, task2 in ipairs(self.tasks) do
			if task2 ~= nil then
				task2()
			end
		end

		self.tasks = {}
	end

	function self.onPageChanged()
		local analytics = self.props.analytics
		local currentPageGoal = self.props.currentPageGoal
		self.cancelTasks()

		for i, v6 in ipairs(v5) do
			self.tasks[i] = self.createDelayedTask(v6, i, currentPageGoal, function(p2, p3)
				if self.props.currentPageGoal == p3 then
					analytics.reportPageHeartbeat(p2, p3)
				end
			end)
		end
	end
end

function extended.render(p2) end

function extended.didUpdate(p2)
	p2.onPageChanged()
end

function extended.didMount(p2)
	p2.onPageChanged()
end

function extended.willUnmount(p2)
	p2.cancelTasks()
end

return roactServices.connect({ analytics = module2 })(extended)
