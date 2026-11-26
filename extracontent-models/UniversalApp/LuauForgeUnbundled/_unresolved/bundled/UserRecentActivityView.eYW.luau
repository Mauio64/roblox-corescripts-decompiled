local module = require("@luauforge/bundled/eYQ")
local module2 = require("@luauforge/bundled/eYX")
local enums = module2.Enums

local friendsActivityFeed = require("@luauforge/bundled/eYU").FriendsActivityFeed

local useLocalization = require("@luauforge/bundled/eYY").Hooks.useLocalization

local sheet = module2.Sheet
local view = module2.View
local text = module2.Text

local fFlagEnableRecentActivityInspectAndBuy = require("@luauforge/bundled/eYV").FFlagEnableRecentActivityInspectAndBuy

local v5 = {
	screenTitleWithUsername = "Feature.FriendsActivityFeed.Label.ScreenTitleWithUsername",
	screenTitleNoUsername = "Feature.FriendsActivityFeed.Label.ScreenTitleNoUsername"
}

local function UserRecentActivityView(props)
	local feedSource = props.feedSource
	local primaryName = props.primaryName

	local v6 = (primaryName == nil or primaryName == "")
		and "When this user has new updates, they will show up here."
		or `When {primaryName} has new updates, they will show up here.`

	local v7 = useLocalization({
		pageTitle = (primaryName == nil or primaryName == "") and "Feature.FriendsActivityFeed.Label.ScreenTitleNoUsername" or {
			"Feature.FriendsActivityFeed.Label.ScreenTitleWithUsername",
			username = primaryName
		}
	})

	local createElement = module.createElement
	local root = sheet.Root
	local v8 = {
		onClose = props.onClose,
		isOpen = props.isOpen,
		snapPoints = { 1 },
		size = enums.DialogSize.Large
	}
	local v9 = {
		Header = module.createElement(sheet.Header, { hasCloseAffordance = true }, {
			HeaderTitle = module.createElement(text, {
				tag = "size-full-0 auto-y text-title-large text-align-x-center bg-action-subtle",
				Text = v7.pageTitle
			})
		}),
		Content = 0
	}

	local createElement2 = module.createElement
	local content = sheet.Content
	local createElement3 = module.createElement
	local v15

	if feedSource ~= nil then
		local createElement4 = module.createElement

		local v18 = if fFlagEnableRecentActivityInspectAndBuy then props.onAvatarActivated else nil
		v15 = createElement4(friendsActivityFeed, {
			source = feedSource,
			emptyStateDescription = v6,
			isScrollEnabled = false,
			onAvatarActivated = v18
		})
	end

	v9.Content = createElement2(content, nil, {
		Body = createElement3(view, { tag = "size-full-0 auto-y" }, { Feed = v15 })
	})
	return createElement(root, v8, v9)
end

return UserRecentActivityView
