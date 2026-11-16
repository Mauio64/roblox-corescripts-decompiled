local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local parent = SduiSharedUtilities.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local getSduiPageEntrySnackbarStore = require(SduiSharedUtilities.getSduiPageEntrySnackbarStore)

local function usePageEntrySnackbar(p: string)
	local signal = getSduiPageEntrySnackbarStore().getSignal(p)

	local snackbarConfig = SignalsReact.useSignalState(signal)

	local v = React.useCallback(function()
		if p then
			getSduiPageEntrySnackbarStore().hide(p)
		end
	end, { p })

	React.useEffect(function()
		if snackbarConfig == nil then
			return
		end

		local durationSeconds = snackbarConfig.durationSeconds or 4
		local thread = task.delay(durationSeconds, function()
			if p then
				getSduiPageEntrySnackbarStore().hide(p)
			end
		end)

		return function()
			task.cancel(thread)
		end
	end, { snackbarConfig })

	return { snackbarConfig = snackbarConfig, dismissSnackbar = v, onDismiss = v }
end

return usePageEntrySnackbar
