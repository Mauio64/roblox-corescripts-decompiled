local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local DataHydration = require(BuildExperienceParent.DataHydration)
local React = require(BuildExperienceParent.React)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local PlaceVersionHistory = require(BuildExperienceParent.DataHydration.PlaceVersionHistory)
local GetVersionInformationStore = require(BuildExperience.Stores.GetVersionInformationStore)

require(script.Parent.VersionTitleDescriptionPageView)

local DataStatus = DataHydration.DataStatus

local function useVersionTitleDescriptionPageViewModel(t1: {[any]: any}) -- line: 22
	-- upvalues: GetVersionInformationStore (copy), PlaceVersionHistory (copy), React (copy), SignalsReact (copy), DataStatus (copy)
	local v11 = GetVersionInformationStore()
	local v12 = PlaceVersionHistory.getPlaceVersionHistoryStore()
	local v13 = React.useMemo(function() -- line: 25
		-- upvalues: v12 (copy), t1 (copy)
		return v12.getAndFetchHistory(t1.placeId)
	end, {
		t1.placeId,
		v12
	})
	local v14 = SignalsReact.useSignalState(v13.data)
	local v15 = SignalsReact.useSignalState(v13.status)
	local v16 = SignalsReact.useSignalState(v11.getDraft)
	local v17 = if v16 == nil or v16.placeId ~= t1.placeId then nil else v16
	local v18 = if v14 == nil then nil else v14.placeVersions[1]
	local v19 = if v18 == nil then nil else v18.title
	local v20 = if v18 == nil then nil else v18.description
	local v21 = if v17 == nil then v19 or "" else v17.title
	local v22 = if v17 == nil then v20 or "" else v17.description
	local v23 = v17 ~= nil or (v15 == DataStatus.Ready or v15 == DataStatus.Failed)
	local v24, v25 = React.useBinding("")
	local v26, v27 = React.useBinding("")
	local v28 = React.useRef("")
	local v29 = React.useRef("")
	local v30, v31 = React.useState(nil)

	React.useEffect(function() -- line: 48
		-- upvalues: v23 (copy), v30 (copy), t1 (copy), v28 (copy), v21 (copy), v29 (copy), v22 (copy), v25 (copy), v27 (copy), v31 (copy)
		if not v23 or v30 == t1.placeId then
			return
		end

		v28.current = v21
		v29.current = v22
		v25(v21)
		v27(v22)
		v31(t1.placeId)
	end, {
		v22,
		v21,
		v30,
		v23,
		t1.placeId
	})

	local v32 = React.useCallback(function() -- line: 69
		-- upvalues: v30 (copy), t1 (copy), v24 (copy), v26 (copy), v28 (copy), v29 (copy), v11 (copy)
		if v30 ~= t1.placeId then
			return
		end

		local v34 = v24:getValue()
		local v35 = v26:getValue()

		if v34 == v28.current and v35 == v29.current then
			return
		end

		v11.setDraft(t1.placeId, v34, v35)
		v28.current = v34
		v29.current = v35
	end, {
		v26,
		v30,
		t1.placeId,
		v24,
		v11
	})

	React.useEffect(function() -- line: 93
		-- upvalues: v32 (copy)
		return v32
	end, { v32 })

	local v33 = React.useCallback(function() -- line: 97
		-- upvalues: v32 (copy), t1 (copy)
		v32()
		t1.onBack()
	end, {
		t1.onBack,
		v32
	})

	return {
		isReady = v30 == t1.placeId,
		onBack = v33,
		onDescriptionChanged = v27,
		onFocusLost = v32,
		onTitleChanged = v25,
		titleText = v24,
		descriptionText = v26,
		layoutOrder = t1.layoutOrder,
		testId = t1.testId
	}
end

return useVersionTitleDescriptionPageViewModel
