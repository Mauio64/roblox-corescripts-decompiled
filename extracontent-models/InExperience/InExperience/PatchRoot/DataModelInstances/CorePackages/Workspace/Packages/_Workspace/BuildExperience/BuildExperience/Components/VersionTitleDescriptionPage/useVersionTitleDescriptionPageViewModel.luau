local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local DataHydration = require(parent.DataHydration)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local PlaceVersionHistory = require(parent.DataHydration.PlaceVersionHistory)

local GetVersionInformationStore = require(BuildExperience.Stores.GetVersionInformationStore)
require(script.Parent.VersionTitleDescriptionPageView)

local DataStatus = DataHydration.DataStatus

local function useVersionTitleDescriptionPageViewModel(data)
	local versionInformationStore = GetVersionInformationStore()
	local placeVersionHistoryStore = PlaceVersionHistory.getPlaceVersionHistoryStore()
	local v = React.useMemo(function()
		return placeVersionHistoryStore.fetchHistory(data.placeId)
	end, { data.placeId, placeVersionHistoryStore })
	local v2 = SignalsReact.useSignalState(v.data)
	local v3 = SignalsReact.useSignalState(v.status)
	local v4 = SignalsReact.useSignalState(versionInformationStore.getDraft)

	if v4 == nil or v4.placeId ~= data.placeId then
		v4 = nil
	end

	local v5

	if v2 ~= nil then
		v5 = v2.placeVersions[1]
	end

	local title

	if v5 ~= nil then
		title = v5.title
	end

	local description

	if v5 ~= nil then
		description = v5.description
	end

	local current = v4 == nil and (title or "") or v4.title
	local current2 = v4 == nil and (description or "") or v4.description
	local v6 = v3 == DataStatus.Ready or v3 == DataStatus.Failed
	local v7 = v4 ~= nil or v6
	local titleText, onTitleChanged = React.useBinding("")
	local descriptionText, onDescriptionChanged = React.useBinding("")
	local ref = React.useRef("")
	local ref2 = React.useRef("")
	local state, setState = React.useState(nil)

	React.useEffect(function()
		if not v7 then
			return
		end

		local v8 = titleText:getValue() ~= ref.current or descriptionText:getValue() ~= ref2.current

		if state == data.placeId and v8 then
			return
		end

		ref.current = current
		ref2.current = current2
		onTitleChanged(current)
		onDescriptionChanged(current2)
		setState(data.placeId)
	end, { descriptionText, current2, current, state, v7, data.placeId, titleText })

	local onFocusLost = React.useCallback(function()
		if state ~= data.placeId then
			return
		end

		local current3 = titleText:getValue()
		local current4 = descriptionText:getValue()

		if current3 == ref.current and current4 == ref2.current then
			return
		end

		versionInformationStore.setDraft(data.placeId, current3, current4)
		ref.current = current3
		ref2.current = current4
	end, { descriptionText, state, data.placeId, titleText, versionInformationStore })

	React.useEffect(function()
		return onFocusLost
	end, { onFocusLost })

	local onBack = React.useCallback(function()
		onFocusLost()
		data.onBack()
	end, { data.onBack, onFocusLost })

	return {
		isReady = state == data.placeId,
		onBack = onBack,
		onDescriptionChanged = onDescriptionChanged,
		onFocusLost = onFocusLost,
		onTitleChanged = onTitleChanged,
		titleText = titleText,
		descriptionText = descriptionText,
		layoutOrder = data.layoutOrder,
		testId = data.testId
	}
end

return useVersionTitleDescriptionPageViewModel
