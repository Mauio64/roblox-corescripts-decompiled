local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local PlaceVersionHistory = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/PlaceVersionHistory")

local GetVersionInformationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetVersionInformationStore")
local ConfigurationActionTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/ConfigurationActionTelemetry")
local FFlagBuildExperienceActionOutcomeTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceActionOutcomeTelemetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionTitleDescriptionPage/VersionTitleDescriptionPageView")

local dataStatus = DataHydration.DataStatus

local function useVersionTitleDescriptionPageViewModel(data)
	local v5 = GetVersionInformationStore()
	local placeVersionHistoryStore = PlaceVersionHistory.getPlaceVersionHistoryStore()
	local v6 = React.useMemo(function()
		return placeVersionHistoryStore.fetchHistory(data.placeId)
	end, { data.placeId, placeVersionHistoryStore })
	local v7 = SignalsReact.useSignalState(v6.data)
	local v8 = SignalsReact.useSignalState(v6.status)
	local v9 = SignalsReact.useSignalState(v5.getDraft)

	if v9 == nil or v9.placeId ~= data.placeId then
		v9 = nil
	end

	local v10 = if v7 ~= nil then v7.placeVersions[1] else nil
	local title = if v10 ~= nil then v10.title else nil
	local description = if v10 ~= nil then v10.description else nil
	local v11 = v9 == nil and (title or "") or v9.title
	local v12 = v9 == nil and (description or "") or v9.description
	local v13 = v8 == dataStatus.Ready or v8 == dataStatus.Failed
	local v14 = v9 ~= nil or v13
	local v15, v16 = React.useBinding("")
	local v17, v18 = React.useBinding("")
	local ref = React.useRef("")
	local ref2 = React.useRef("")
	local state, setState = React.useState(nil)

	React.useEffect(function()
		if not v14 then
			return
		end

		local v19 = v15:getValue() ~= ref.current or v17:getValue() ~= ref2.current

		if state == data.placeId and v19 then
			return
		end

		ref.current = v11
		ref2.current = v12
		v16(v11)
		v18(v12)
		setState(data.placeId)
	end, { v17, v12, v11, state, v14, data.placeId, v15 })

	local v19 = React.useCallback(function()
		if state ~= data.placeId then
			return
		end

		local value = v15:getValue()
		local value2 = v17:getValue()

		if value == ref.current and value2 == ref2.current then
			return
		end

		v5.setDraft(data.placeId, value, value2)

		if FFlagBuildExperienceActionOutcomeTelemetry then
			ConfigurationActionTelemetry.sendSuccess(ConfigurationActionTelemetry.Action.VersionDetailsSave, {
				placeId = data.placeId
			}, nil, {
				changedFields = ConfigurationActionTelemetry.getChangedFields(value ~= ref.current, value2 ~= ref2.current)
			})
		end

		ref.current = value
		ref2.current = value2
	end, { v17, state, data.placeId, v15, v5 })

	React.useEffect(function()
		return v19
	end, { v19 })

	local v20 = React.useCallback(function()
		v19()
		data.onBack()
	end, { data.onBack, v19 })

	return {
		isReady = state == data.placeId,
		onBack = v20,
		onDescriptionChanged = v18,
		onFocusLost = v19,
		onTitleChanged = v16,
		titleText = v15,
		descriptionText = v17,
		layoutOrder = data.layoutOrder,
		testId = data.testId
	}
end

return useVersionTitleDescriptionPageViewModel
