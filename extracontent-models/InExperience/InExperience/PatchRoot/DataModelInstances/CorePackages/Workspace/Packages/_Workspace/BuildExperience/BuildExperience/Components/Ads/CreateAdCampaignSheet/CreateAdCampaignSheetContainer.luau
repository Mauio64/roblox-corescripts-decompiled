local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent
local React = require(parent.React)

local FFlagEnablePaidAds = require(BuildExperience.Flags.FFlagEnablePaidAds)
local FFlagBuildAgentAdCampaignCard = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignCard)
local CreateAdCampaignSheetView = require(script.Parent.CreateAdCampaignSheetView)
local useCreateAdCampaignSheetViewModel = require(script.Parent.useCreateAdCampaignSheetViewModel)

local function getCampaignTerms(props) -- 2 equivalent calls inferred from this helper
	if props.runStartTimeMs == nil then
		return nil
	end

	return { runStartTimeMs = props.runStartTimeMs }
end

local function MountedCreateAdCampaignSheet(p)
	local v = useCreateAdCampaignSheetViewModel(p)
	return React.createElement(CreateAdCampaignSheetView, v)
end

local function CreateAdCampaignSheetContainer(props)
	local state, setState = React.useState(props.isOpen)

	local isOpen = FFlagEnablePaidAds and props.isOpen
	local useState = React.useState
	local terms2

	if isOpen then
		terms2 = getCampaignTerms(props) -- inferred equivalent call
	end

	local state2, setState2 = useState({ wasOpen = isOpen, terms = terms2 })

	local v = state2.wasOpen ~= isOpen
	local v2

	if FFlagBuildAgentAdCampaignCard and isOpen and props.runStartTimeMs ~= nil then
		local terms = state2.terms
		v2 = terms == nil or terms.runStartTimeMs ~= props.runStartTimeMs
	else
		v2 = false
	end

	local v3

	if v or FFlagBuildAgentAdCampaignCard and v2 then
		v3 = { wasOpen = isOpen, terms = 0 }
		local terms

		if isOpen then
			terms = getCampaignTerms(props) -- inferred equivalent call
		else
			terms = state2.terms
		end

		v3.terms = terms

		setState2(v3)
	else
		v3 = state2
	end

	React.useEffect(function()
		if props.isOpen then
			setState(true)
		end
	end, { props.isOpen })

	if not state or FFlagEnablePaidAds and props.campaignOffers == nil then
		return nil
	end

	local v4

	if not FFlagEnablePaidAds then
		v4 = props
		return React.createElement(MountedCreateAdCampaignSheet, v4)
	end

	local terms = v3.terms

	if terms == nil then
		return nil
	end

	v4 = table.clone(props)
	v4.runStartTimeMs = terms.runStartTimeMs

	return React.createElement(MountedCreateAdCampaignSheet, v4)
end

return CreateAdCampaignSheetContainer
