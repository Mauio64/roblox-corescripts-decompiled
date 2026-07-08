return {
	createSignalIfSupported = function() -- line: 11
		local AbortController = _G.AbortController

		if typeof(AbortController) == "nil" then
			return {
				controller = false,
				signal = false
			}
		end

		local v2 = AbortController.new()
		local signal = v2.signal

		return {
			controller = v2,
			signal = signal
		}
	end
}
