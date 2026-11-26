local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/Foundation")
local sheet = Foundation.Sheet
local useScaledValue = Foundation.Hooks.useScaledValue

require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/DataHydration")

local InExperienceDetailsPromptErrorContent = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/InExperienceDetailsPrompt/Features/InExperienceDetailsPromptErrorContent")
local InExperienceDetailsPromptHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/InExperienceDetailsPrompt/Features/InExperienceDetailsPromptHeader")
local InExperienceDetailsPromptContent = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/InExperienceDetailsPrompt/Features/InExperienceDetailsPromptContent")
local InExperienceDetailsPromptActions = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/InExperienceDetailsPrompt/Features/InExperienceDetailsPromptActions")

local fFlagLuaAppIedpOverlayAndNavigationFix = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/SharedFlags").FFlagLuaAppIedpOverlayAndNavigationFix
local fFlagLuaAppIedpFixPlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/SharedFlags").FFlagLuaAppIedpFixPlayButton

local function sheetChildren(props)
	if props.errorType then
		return {
			Content = React.createElement(sheet.Content, nil, {
				ErrorContent = React.createElement(InExperienceDetailsPromptErrorContent, {
					errorType = props.errorType
				})
			})
		}
	end

	local v5 = {
		Header = React.createElement(InExperienceDetailsPromptHeader, {
			name = props.name,
			imageUri = props.imageUri,
			creator = props.creator
		}),
		Content = React.createElement(sheet.Content, nil, {
			MainContent = React.createElement(InExperienceDetailsPromptContent, {
				ageRecommendation = props.ageRecommendation,
				rating = props.rating
			})
		}),
		Actions = 0
	}

	local createElement = React.createElement
	local v7 = {
		playability = props.playability,
		onJoin = props.onJoin,
		rootPlaceId = 0,
		playabilityRetrievalStatus = 0
	}
	local v8 = if fFlagLuaAppIedpFixPlayButton then props.rootPlaceId else nil
	v7.rootPlaceId = v8
	v7.playabilityRetrievalStatus = props.playabilityRetrievalStatus
	v5.Actions = createElement(InExperienceDetailsPromptActions, v7)
	return v5
end

local function InExperienceDetailsPrompt(props)
	local v5 = useScaledValue(260)

	local createElement = React.createElement
	local root = sheet.Root
	local v6 = {
		ref = props.focusRootRef,
		sheetRef = 0,
		preferCenterSheet = true,
		snapPoints = 0,
		onClose = 0
	}
	local v7 = if fFlagLuaAppIedpOverlayAndNavigationFix then props.sheetRef else nil
	v6.sheetRef = v7

	v6.snapPoints = { v5 }
	v6.onClose = props.onClose
	return createElement(root, v6, sheetChildren(props))
end

return InExperienceDetailsPrompt
