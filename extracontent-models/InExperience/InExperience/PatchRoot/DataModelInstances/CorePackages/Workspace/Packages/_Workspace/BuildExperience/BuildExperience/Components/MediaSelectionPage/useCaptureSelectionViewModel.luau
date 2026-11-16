local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local function useCaptureSelectionViewModel(p)
	local captures = SignalsReact.useSignalState(p.captureSource.getCaptures)
	local isFinished = SignalsReact.useSignalState(p.captureSource.getIsFinished)
	local state, setState = React.useState(nil)

	return {
		captures = captures,
		selectedCapture = state,
		previewContent = React.useMemo(function()
			if state == nil or typeof(state) ~= "Object" then
				return nil
			end

			return Content.fromObject(state)
		end, { state }),
		isFinished = isFinished,
		onCaptureSelected = React.useCallback(function(p2)
			setState(p2)
		end, {}),
		onConfirm = React.useCallback(function()
			if state ~= nil then
				p.onCaptureConfirmed(state)
			end
		end, { state, p.onCaptureConfirmed }),
		onShowMore = p.captureSource.fetchMore
	}
end

return useCaptureSelectionViewModel
