local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useLocalization = Localization.Hooks.useLocalization

local v = {
	seeTranslation = "Feature.Moments.Action.CommentSeeTranslation",
	seeOriginal = "Feature.Moments.Action.CommentSeeOriginal"
}

local function nonEmpty(p: string?) -- 2 equivalent calls inferred from this helper
	return if not (p == nil or p == "") then p else nil
end

local function CommentTranslationToggle(props)
	local v2 = useLocalization(v)
	local text

	if props.isShowingTranslation then
		text = nonEmpty(v2.seeOriginal) or "See original" -- inferred equivalent call
	else
		text = nonEmpty(v2.seeTranslation) or "See translation" -- inferred equivalent call
	end

	local onToggle = props.onToggle
	local commentId = props.commentId
	local onActivated = React.useCallback(function()
		onToggle(commentId)
	end, { onToggle, commentId })

	return React.createElement(Foundation.Button, {
		text = text,
		size = InputSize.XSmall,
		variant = ButtonVariant.Utility,
		onActivated = onActivated,
		LayoutOrder = props.LayoutOrder,
		testId = `moments-comment-translation-toggle-{commentId}`
	})
end

return React.memo(CommentTranslationToggle)
