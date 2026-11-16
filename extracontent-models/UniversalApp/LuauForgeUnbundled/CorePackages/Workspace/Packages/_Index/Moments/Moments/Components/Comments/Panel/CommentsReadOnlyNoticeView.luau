local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local useLocalization = Localization.Hooks.useLocalization

local v5 = { readOnly = "Feature.Moments.Label.CommentsReadOnly" }

local function CommentsReadOnlyNoticeView()
	local v6 = useLocalization(v5)

	return React.createElement(Foundation.Text, {
		Text = v6.readOnly,
		tag = "auto-xy text-body-small content-muted",
		testId = "moments-comments-read-only"
	})
end

return CommentsReadOnlyNoticeView
