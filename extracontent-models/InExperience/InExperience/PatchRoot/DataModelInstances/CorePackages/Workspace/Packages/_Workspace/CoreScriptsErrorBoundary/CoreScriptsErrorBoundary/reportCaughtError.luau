local formatCaughtError = require(script.Parent.formatCaughtError)

local function reportCaughtError(p, p2)
	local v = formatCaughtError(p, p2)
	task.spawn(function()
		error(v, 0)
	end)
end

return reportCaughtError
