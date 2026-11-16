local parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent

local React = require(parent.React)

local useLoadingTimers = require(script.Parent.useLoadingTimers)

local function useFetchTimeLogging(data)
	local v = useLoadingTimers({})
	local ref = React.useRef("")

	local loading = data.loading
	local err = data.error

	React.useEffect(function()
		if loading then
			ref.current = v.start(data.timerKey)
		end

		if not loading and ref.current == data.timerKey then
			local v2 = v.stop(data.timerKey)
			ref.current = ""

			if err then
				data.onError(v2, data.timerKey)
			else
				data.onSuccess(v2, data.timerKey)
			end
		end
	end, { data.timerKey, loading, err })
end

return useFetchTimeLogging
