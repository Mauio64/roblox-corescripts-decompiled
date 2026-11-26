local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local screenSizeImpressionsTracker = require("@luauforge/bundled/egA").ScreenSizeImpressionsTracker
local sendSocialLinksImpressionsEvent = require("@luauforge/bundled/dzG").Events.sendSocialLinksImpressionsEvent

return function(props)
	local v5 = React.useCallback(function(list)
		if #list == 0 or props.socialLinks == nil then
			return
		end

		local v6 = {}
		local urls = {}
		local types = {}

		for i = 1, #list do
			local socialLink = props.socialLinks[i]

			if not socialLink then
				continue
			end

			table.insert(v6, i)
			table.insert(urls, socialLink.url or "")
			table.insert(types, socialLink.type or "")
		end

		sendSocialLinksImpressionsEvent({
			item_positions = table.concat(v6, ","),
			social_link_urls = table.concat(urls, ","),
			social_link_types = table.concat(types, ","),
			social_link_display_type = "badge",
			assignment_id = tonumber(props.universeId),
			assignment_type = "game",
			page = props.pageContext
		})
	end, { props.socialLinks, props.universeId, props.pageContext })

	return React.createElement(screenSizeImpressionsTracker, {
		parentRef = props.parentRef,
		pageContext = props.pageContext,
		impressionsTag = props.impressionsTag,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		sendImpressions = v5
	})
end
