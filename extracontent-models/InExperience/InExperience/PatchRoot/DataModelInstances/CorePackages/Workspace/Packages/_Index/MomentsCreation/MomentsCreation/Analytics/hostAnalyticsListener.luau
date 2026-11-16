local v = nil
local HostAnalyticsListener = {}

function HostAnalyticsListener.register(callback)
	v = callback
	return function()
		if v == callback then
			v = nil
		end
	end
end

function HostAnalyticsListener.get()
	return v
end

return HostAnalyticsListener
