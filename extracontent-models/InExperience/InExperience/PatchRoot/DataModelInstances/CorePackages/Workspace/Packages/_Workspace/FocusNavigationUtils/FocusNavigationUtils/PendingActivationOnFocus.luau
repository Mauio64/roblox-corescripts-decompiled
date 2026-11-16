local v = nil

local PendingActivationOnFocus = {
	get = function()
		return v
	end,
	set = function(p)
		v = p
	end,
	cancel = function()
		local v2 = v

		if v2 == nil then
			return
		end

		v = nil
		pcall(task.cancel, v2.thread)
	end
}

function PendingActivationOnFocus.flush()
	local v2 = v

	if v2 == nil then
		return nil
	end

	PendingActivationOnFocus.cancel()
	return v2.activate()
end

return PendingActivationOnFocus
