local inExperienceDetailsPrompt = script:FindFirstAncestor("InExperienceDetailsPrompt")
local parent = inExperienceDetailsPrompt.Parent
local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Sheet = Foundation.Sheet
local useScaledValue = Foundation.Hooks.useScaledValue

require(parent.DataHydration)

local InExperienceDetailsPromptErrorContent = require(inExperienceDetailsPrompt.Features.InExperienceDetailsPromptErrorContent)
local InExperienceDetailsPromptHeader = require(inExperienceDetailsPrompt.Features.InExperienceDetailsPromptHeader)
local InExperienceDetailsPromptContent = require(inExperienceDetailsPrompt.Features.InExperienceDetailsPromptContent)
local InExperienceDetailsPromptActions = require(inExperienceDetailsPrompt.Features.InExperienceDetailsPromptActions)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppIedpOverlayAndNavigationFix = SharedFlags.FFlagLuaAppIedpOverlayAndNavigationFix
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppIedpFixPlayButton = SharedFlags2.FFlagLuaAppIedpFixPlayButton

local function sheetChildren(props)
	if props.errorType then
		return {
			Content = React.createElement(Sheet.Content, nil, {
				ErrorContent = React.createElement(InExperienceDetailsPromptErrorContent, {
					errorType = props.errorType
				})
			})
		}
	end

	local v = {
		Header = React.createElement(InExperienceDetailsPromptHeader, {
			name = props.name,
			imageUri = props.imageUri,
			creator = props.creator
		}),
		Content = React.createElement(Sheet.Content, nil, {
			MainContent = React.createElement(InExperienceDetailsPromptContent, {
				ageRecommendation = props.ageRecommendation,
				rating = props.rating
			})
		}),
		Actions = 0
	}

	local createElement = React.createElement
	local v2 = {
		playability = props.playability,
		onJoin = props.onJoin,
		rootPlaceId = 0,
		playabilityRetrievalStatus = 0
	}
	local rootPlaceId

	if FFlagLuaAppIedpFixPlayButton then
		rootPlaceId = props.rootPlaceId
	end

	v2.rootPlaceId = rootPlaceId
	v2.playabilityRetrievalStatus = props.playabilityRetrievalStatus
	v.Actions = createElement(InExperienceDetailsPromptActions, v2)
	return v
end

local function InExperienceDetailsPrompt(props)
	local v = useScaledValue(260)

	local createElement = React.createElement
	local root = Sheet.Root
	local v2 = {
		ref = props.focusRootRef,
		sheetRef = 0,
		preferCenterSheet = true,
		snapPoints = 0,
		onClose = 0
	}
	local sheetRef

	if FFlagLuaAppIedpOverlayAndNavigationFix then
		sheetRef = props.sheetRef
	end

	v2.sheetRef = sheetRef

	v2.snapPoints = { v }
	v2.onClose = props.onClose
	return createElement(root, v2, sheetChildren(props))
end

return InExperienceDetailsPrompt
