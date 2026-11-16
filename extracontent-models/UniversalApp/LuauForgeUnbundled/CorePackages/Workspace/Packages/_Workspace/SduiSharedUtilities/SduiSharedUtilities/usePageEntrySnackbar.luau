local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SignalsReact")
local getSduiPageEntrySnackbarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/getSduiPageEntrySnackbarStore")

local function usePageEntrySnackbar(p2)
	local signal = getSduiPageEntrySnackbarStore().getSignal(p2)

	local v5 = SignalsReact.useSignalState(signal)

	local v6 = React.useCallback(function()
		if p2 then
			getSduiPageEntrySnackbarStore().hide(p2)
		end
	end, { p2 })

	React.useEffect(function()
		if v5 == nil then
			return
		end

		local durationSeconds = v5.durationSeconds or 4
		local thread = task.delay(durationSeconds, function()
			if p2 then
				getSduiPageEntrySnackbarStore().hide(p2)
			end
		end)

		return function()
			task.cancel(thread)
		end
	end, { v5 })

	return { snackbarConfig = v5, dismissSnackbar = v6, onDismiss = v6 }
end

return usePageEntrySnackbar
