local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local FFlagEnablePaidAds = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagEnablePaidAds")
local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignCard")
local CreateAdCampaignSheetView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/CreateAdCampaignSheet/CreateAdCampaignSheetView")
local useCreateAdCampaignSheetViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/CreateAdCampaignSheet/useCreateAdCampaignSheetViewModel")

local function getCampaignTerms(p2)
	if p2.runStartTimeMs == nil then
		return nil
	end

	return { runStartTimeMs = p2.runStartTimeMs }
end

local function MountedCreateAdCampaignSheet(p2)
	local v5 = useCreateAdCampaignSheetViewModel(p2)
	return React.createElement(CreateAdCampaignSheetView, v5)
end

local function CreateAdCampaignSheetContainer(props)
	local state, setState = React.useState(props.isOpen)

	local isOpen = FFlagEnablePaidAds and props.isOpen
	local useState = React.useState
	local v6 = if isOpen then props.runStartTimeMs ~= nil and {
		runStartTimeMs = props.runStartTimeMs
	} or nil else nil

	local state2, setState2 = useState({ wasOpen = isOpen, terms = v6 })

	local v7 = state2.wasOpen ~= isOpen
	local v8

	if FFlagBuildAgentAdCampaignCard and isOpen and props.runStartTimeMs ~= nil then
		local terms = state2.terms
		v8 = terms == nil or terms.runStartTimeMs ~= props.runStartTimeMs
	else
		v8 = false
	end

	local v9

	if v7 or FFlagBuildAgentAdCampaignCard and v8 then
		v9 = { wasOpen = isOpen, terms = 0 }
		local v10 = if isOpen then props.runStartTimeMs ~= nil and {
			runStartTimeMs = props.runStartTimeMs
		} or nil else state2.terms
		v9.terms = v10

		setState2(v9)
	else
		v9 = state2
	end

	React.useEffect(function()
		if props.isOpen then
			setState(true)
		end
	end, { props.isOpen })

	if not state or FFlagEnablePaidAds and props.campaignOffers == nil then
		return nil
	end

	local v10

	if not FFlagEnablePaidAds then
		v10 = props
		return React.createElement(MountedCreateAdCampaignSheet, v10)
	end

	local terms = v9.terms

	if terms == nil then
		return nil
	end

	v10 = table.clone(props)
	v10.runStartTimeMs = terms.runStartTimeMs

	return React.createElement(MountedCreateAdCampaignSheet, v10)
end

return CreateAdCampaignSheetContainer
