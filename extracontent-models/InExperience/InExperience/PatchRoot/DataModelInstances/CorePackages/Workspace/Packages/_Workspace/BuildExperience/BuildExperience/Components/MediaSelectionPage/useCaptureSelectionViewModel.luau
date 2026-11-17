local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Localization = require(parent.Localization)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local FFlagBuildExperienceLocalizeCaptureShowMore = require(BuildExperience.Flags.FFlagBuildExperienceLocalizeCaptureShowMore)

local useLocalization = Localization.Hooks.useLocalization

local function useCaptureSelectionViewModel(p)
	local captures = SignalsReact.useSignalState(p.captureSource.getCaptures)
	local isFinished = SignalsReact.useSignalState(p.captureSource.getIsFinished)
	local state, setState = React.useState(nil)
	local v

	if FFlagBuildExperienceLocalizeCaptureShowMore then
		v = useLocalization({ showMore = LocalizationStrings.MEDIA_SELECTION_SHOW_MORE })
	end

	local v2 = {
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
		onShowMore = p.captureSource.fetchMore,
		showMoreText = 0
	}
	local showMoreText

	if FFlagBuildExperienceLocalizeCaptureShowMore then
		showMoreText = v.showMore
	end

	v2.showMoreText = showMoreText
	return v2
end

return useCaptureSelectionViewModel
