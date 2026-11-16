return {
	createSignalIfSupported = function()
		local abortController = _G.AbortController

		if typeof(abortController) == "nil" then
			return { controller = false, signal = false }
		end

		local controller = abortController.new()
		return { controller = controller, signal = controller.signal }
	end
}
