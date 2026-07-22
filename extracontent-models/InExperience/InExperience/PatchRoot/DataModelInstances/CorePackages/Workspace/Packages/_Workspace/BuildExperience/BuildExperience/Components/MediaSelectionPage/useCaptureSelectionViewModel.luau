local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)

local function useCaptureSelectionViewModel(t1: {[any]: any}) -- line: 23
	-- upvalues: SignalsReact (copy), React (copy)
	local v6 = SignalsReact.useSignalState(t1.captureSource.getCaptures)
	local v7 = SignalsReact.useSignalState(t1.captureSource.getIsFinished)
	local v8, v9 = React.useState(nil)
	local v10 = React.useMemo(function() -- line: 28
		-- upvalues: v8 (copy)
		if v8 ~= nil and typeof(v8) == "Object" then
			return Content.fromObject(v8)
		end

		return nil
	end, { v8 })
	local v11 = React.useCallback(function(p1) -- line: 35
		-- upvalues: v9 (copy)
		v9(p1)
	end, {})
	local v12 = React.useCallback(function() -- line: 39
		-- upvalues: v8 (copy), t1 (copy)
		if v8 ~= nil then
			t1.onCaptureConfirmed(v8)
		end
	end, {
		v8,
		t1.onCaptureConfirmed
	})

	return {
		captures = v6,
		selectedCapture = v8,
		previewContent = v10,
		isFinished = v7,
		onCaptureSelected = v11,
		onConfirm = v12,
		onShowMore = t1.captureSource.fetchMore
	}
end

return useCaptureSelectionViewModel
