local Parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent
local React = require(Parent.React)
local useLoadingTimers = require(script.Parent.useLoadingTimers)

local function useFetchTimeLogging(t1: {[any]: any}) -- line: 26
	-- upvalues: useLoadingTimers (copy), React (copy)
	local v6 = useLoadingTimers({})
	local v7 = React.useRef("")
	local loading = t1.loading
	local error = t1.error

	React.useEffect(function() -- line: 33
		-- upvalues: loading (copy), v7 (copy), v6 (copy), t1 (copy), error (copy)
		if loading then
			v7.current = v6.start(t1.timerKey)
		end

		if not loading and v7.current == t1.timerKey then
			local v10 = v6.stop(t1.timerKey)

			v7.current = ""

			if error then
				t1.onError(v10, t1.timerKey)

				return
			end

			t1.onSuccess(v10, t1.timerKey)
		end
	end, {
		t1.timerKey,
		loading,
		error
	})
end

return useFetchTimeLogging
