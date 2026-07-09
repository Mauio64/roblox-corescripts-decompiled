local InExperienceDetailsPrompt = script:FindFirstAncestor("InExperienceDetailsPrompt")
local InExperienceDetailsPromptParent = InExperienceDetailsPrompt.Parent
local React = require(InExperienceDetailsPromptParent.React)
local Foundation = require(InExperienceDetailsPromptParent.Foundation)
local Sheet = Foundation.Sheet
local useScaledValue = Foundation.Hooks.useScaledValue

require(InExperienceDetailsPromptParent.DataHydration)

local InExperienceDetailsPromptErrorContent = require(InExperienceDetailsPrompt.Features.InExperienceDetailsPromptErrorContent)
local InExperienceDetailsPromptHeader = require(InExperienceDetailsPrompt.Features.InExperienceDetailsPromptHeader)
local InExperienceDetailsPromptContent = require(InExperienceDetailsPrompt.Features.InExperienceDetailsPromptContent)
local InExperienceDetailsPromptActions = require(InExperienceDetailsPrompt.Features.InExperienceDetailsPromptActions)
local FFlagLuaAppIedpOverlayAndNavigationFix = require(InExperienceDetailsPromptParent.SharedFlags).FFlagLuaAppIedpOverlayAndNavigationFix
local FFlagLuaAppIedpFixPlayButton = require(InExperienceDetailsPromptParent.SharedFlags).FFlagLuaAppIedpFixPlayButton

local function sheetChildren(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), Sheet (copy), InExperienceDetailsPromptErrorContent (copy), InExperienceDetailsPromptHeader (copy), InExperienceDetailsPromptContent (copy), InExperienceDetailsPromptActions (copy), FFlagLuaAppIedpFixPlayButton (copy)
	if t1.errorType then
		return {
			Content = React.createElement(Sheet.Content, nil, {
				ErrorContent = React.createElement(InExperienceDetailsPromptErrorContent, {
					errorType = t1.errorType
				})
			})
		}
	end

	return {
		Header = React.createElement(InExperienceDetailsPromptHeader, {
			name = t1.name,
			imageUri = t1.imageUri,
			creator = t1.creator
		}),
		Content = React.createElement(Sheet.Content, nil, {
			MainContent = React.createElement(InExperienceDetailsPromptContent, {
				ageRecommendation = t1.ageRecommendation,
				rating = t1.rating
			})
		}),
		Actions = React.createElement(InExperienceDetailsPromptActions, {
			playability = t1.playability,
			onJoin = t1.onJoin,
			rootPlaceId = if not FFlagLuaAppIedpFixPlayButton then nil else t1.rootPlaceId,
			playabilityRetrievalStatus = t1.playabilityRetrievalStatus
		})
	}
end
local function InExperienceDetailsPrompt2(t2: {[any]: any}) -- line: 74
	-- upvalues: useScaledValue (copy), React (copy), Sheet (copy), FFlagLuaAppIedpOverlayAndNavigationFix (copy), sheetChildren (copy)
	local v17 = useScaledValue(260)

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		ref = t2.focusRootRef,
		sheetRef = if not FFlagLuaAppIedpOverlayAndNavigationFix then nil else t2.sheetRef,
		snapPoints = { v17 },
		onClose = t2.onClose
	}, (sheetChildren(t2)))
end

return InExperienceDetailsPrompt2
