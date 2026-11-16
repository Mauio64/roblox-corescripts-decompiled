local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local useLocalization = Localization.Hooks.useLocalization

local v = { readOnly = "Feature.Moments.Label.CommentsReadOnly" }

local function CommentsReadOnlyNoticeView()
	local v2 = useLocalization(v)

	return React.createElement(Foundation.Text, {
		Text = v2.readOnly,
		tag = "auto-xy text-body-small content-muted",
		testId = "moments-comments-read-only"
	})
end

return CommentsReadOnlyNoticeView
