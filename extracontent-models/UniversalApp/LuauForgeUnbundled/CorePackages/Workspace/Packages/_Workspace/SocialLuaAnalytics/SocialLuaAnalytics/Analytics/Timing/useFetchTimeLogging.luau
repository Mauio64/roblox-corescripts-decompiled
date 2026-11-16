local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/React")

local useLoadingTimers = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Timing/useLoadingTimers")

local function useFetchTimeLogging(data)
	local v5 = useLoadingTimers({})
	local ref = React.useRef("")

	local loading = data.loading
	local err = data.error

	React.useEffect(function()
		if loading then
			ref.current = v5.start(data.timerKey)
		end

		if not loading and ref.current == data.timerKey then
			local v6 = v5.stop(data.timerKey)
			ref.current = ""

			if err then
				data.onError(v6, data.timerKey)
			else
				data.onSuccess(v6, data.timerKey)
			end
		end
	end, { data.timerKey, loading, err })
end

return useFetchTimeLogging
