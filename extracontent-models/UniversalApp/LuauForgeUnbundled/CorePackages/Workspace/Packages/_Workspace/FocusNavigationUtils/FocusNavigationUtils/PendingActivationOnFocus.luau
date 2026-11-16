local v5 = nil

local v6 = {
	get = function()
		return v5
	end,
	set = function(p2)
		v5 = p2
	end,
	cancel = function()
		local v7 = v5

		if v7 == nil then
			return
		end

		v5 = nil
		pcall(task.cancel, v7.thread)
	end
}

function v6.flush()
	local v7 = v5

	if v7 == nil then
		return nil
	end

	v6.cancel()
	return v7.activate()
end

return v6
