local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local useLocalization = Localization.Hooks.useLocalization

local v5 = {
	seeTranslation = "Feature.Moments.Action.CommentSeeTranslation",
	seeOriginal = "Feature.Moments.Action.CommentSeeOriginal"
}

local function nonEmpty(p2)
	if p2 == nil or p2 == "" then
		return nil
	end

	return p2
end

local function CommentTranslationToggle(props)
	local v6 = useLocalization(v5)
	local v7

	if props.isShowingTranslation then
		local seeOriginal = v6.seeOriginal

		if seeOriginal == nil or seeOriginal == "" then
			seeOriginal = nil
		end

		v7 = seeOriginal or "See original"
	else
		local seeTranslation = v6.seeTranslation

		if seeTranslation == nil or seeTranslation == "" then
			seeTranslation = nil
		end

		v7 = seeTranslation or "See translation"
	end

	local onToggle = props.onToggle
	local commentId = props.commentId
	local v8 = React.useCallback(function()
		onToggle(commentId)
	end, { onToggle, commentId })

	return React.createElement(Foundation.Button, {
		text = v7,
		size = inputSize.XSmall,
		variant = buttonVariant.Utility,
		onActivated = v8,
		LayoutOrder = props.LayoutOrder,
		testId = `moments-comment-translation-toggle-{commentId}`
	})
end

return React.memo(CommentTranslationToggle)
