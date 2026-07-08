local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")
local SduiSharedUtilitiesParent = SduiSharedUtilities.Parent
local React = require(SduiSharedUtilitiesParent.React)
local SignalsReact = require(SduiSharedUtilitiesParent.SignalsReact)
local getSduiPageEntrySnackbarStore = require(SduiSharedUtilities.getSduiPageEntrySnackbarStore)

local function usePageEntrySnackbar(s1: string) -- line: 15
	-- upvalues: getSduiPageEntrySnackbarStore (copy), SignalsReact (copy), React (copy)
	local v8 = getSduiPageEntrySnackbarStore().getSignal(s1)
	local v9 = SignalsReact.useSignalState(v8)
	local v10 = React.useCallback(function() -- line: 20
		-- upvalues: s1 (copy), getSduiPageEntrySnackbarStore (copy)
		if s1 then
			getSduiPageEntrySnackbarStore().hide(s1)
		end
	end, { s1 })

	React.useEffect(function() -- line: 27
		-- upvalues: v9 (copy), s1 (copy), getSduiPageEntrySnackbarStore (copy)
		if v9 == nil then
			return
		end

		local v11 = v9.durationSeconds or 4
		local thread = task.delay(v11, function() -- line: 33
			-- upvalues: s1 (copy), getSduiPageEntrySnackbarStore (copy)
			if s1 then
				getSduiPageEntrySnackbarStore().hide(s1)
			end
		end)

		return function() -- line: 39
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, { v9 })

	return {
		snackbarConfig = v9,
		dismissSnackbar = v10,
		onDismiss = v10
	}
end

return usePageEntrySnackbar
