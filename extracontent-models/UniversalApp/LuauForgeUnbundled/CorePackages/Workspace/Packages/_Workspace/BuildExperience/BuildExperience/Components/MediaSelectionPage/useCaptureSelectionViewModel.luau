local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local FFlagBuildExperienceLocalizeCaptureShowMore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceLocalizeCaptureShowMore")

local useLocalization = Localization.Hooks.useLocalization

local function useCaptureSelectionViewModel(p2)
	local v5 = SignalsReact.useSignalState(p2.captureSource.getCaptures)
	local v6 = SignalsReact.useSignalState(p2.captureSource.getIsFinished)
	local state, setState = React.useState(nil)
	local v7

	if FFlagBuildExperienceLocalizeCaptureShowMore then
		v7 = useLocalization({ showMore = LocalizationStrings.MEDIA_SELECTION_SHOW_MORE })
	end

	local v8 = {
		captures = v5,
		selectedCapture = state,
		previewContent = React.useMemo(function()
			if state == nil or typeof(state) ~= "Object" then
				return nil
			end

			return Content.fromObject(state)
		end, { state }),
		isFinished = v6,
		onCaptureSelected = React.useCallback(function(p3)
			setState(p3)
		end, {}),
		onConfirm = React.useCallback(function()
			if state ~= nil then
				p2.onCaptureConfirmed(state)
			end
		end, { state, p2.onCaptureConfirmed }),
		onShowMore = p2.captureSource.fetchMore,
		showMoreText = 0
	}
	local v9 = if FFlagBuildExperienceLocalizeCaptureShowMore then v7.showMore else nil
	v8.showMoreText = v9
	return v8
end

return useCaptureSelectionViewModel
