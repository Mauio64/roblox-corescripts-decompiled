local parent = script.Parent.Parent.Parent

local ReactRoblox = require(parent.Dev.ReactRoblox)

return function(callback, value)
	local total = 0
	local v = value or 1

	while total < v and not callback() do
		ReactRoblox.act(function()
			total += task.wait()
		end)
	end
end
