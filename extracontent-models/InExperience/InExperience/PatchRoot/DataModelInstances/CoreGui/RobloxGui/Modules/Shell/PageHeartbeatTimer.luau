local Analytics = require(script.Parent.Analytics)

local v = { 2, 10 }
local v2 = {}

local function createDelayedTask(duration, i, fn) -- 1 equivalent call inferred from this helper
	local v3 = false

	task.delay(duration, function()
		if not v3 then
			fn(i)
		end
	end)
	return function()
		v3 = true
	end
end

local function cancelTasks()
	for _, v3 in ipairs(v2) do
		if v3 ~= nil then
			v3()
		end
	end

	v2 = {}
end

return {
	onPageChanged = function(p)
		cancelTasks()

		for i, v3 in ipairs(v) do
			local function fn(p2)
				Analytics.reportPageHeartbeat(p2, p)
			end

			v2[i] = createDelayedTask(v3, i, fn) -- inferred equivalent call
		end
	end
}
