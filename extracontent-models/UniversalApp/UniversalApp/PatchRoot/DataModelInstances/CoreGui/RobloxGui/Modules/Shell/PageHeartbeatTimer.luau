local Analytics = require(script.Parent.Analytics)
local t1 = {
	2,
	10
}
local t2 = {}
local t3 = {}

local function createDelayedTask(p1, p2, p3) -- line: 11
	local u10 = false

	task.delay(p1, function() -- line: 14
		-- upvalues: u10 (ref), p3 (copy), p2 (copy)
		if not u10 then
			p3(p2)
		end
	end)

	return function() -- line: 19
		-- upvalues: u10 (ref)
		u10 = true
	end
end
local function cancelTasks() -- line: 24
	-- upvalues: t2 (ref)
	for _, v in ipairs(t2) do
		if v ~= nil then
			v()
		end
	end

	t2 = {}
end

function t3.onPageChanged(p4) -- line: 33
	-- upvalues: cancelTasks (copy), t1 (copy), t2 (ref), Analytics (copy)
	cancelTasks()

	for i, v in ipairs(t1) do
		local v16 = t2

		local function v17(p5) -- line: 39
			-- upvalues: Analytics (copy), p4 (copy)
			Analytics.reportPageHeartbeat(p5, p4)
		end

		local u18 = false

		task.delay(v, function() -- line: 14
			-- upvalues: u18 (ref), v17 (copy), i (copy)
			if not u18 then
				v17(i)
			end
		end)
		v16[i] = function() -- line: 19
			-- upvalues: u18 (ref)
			u18 = true
		end
	end
end

return t3
