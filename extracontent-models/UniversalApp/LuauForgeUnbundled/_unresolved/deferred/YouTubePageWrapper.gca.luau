local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/fot")
local module2 = require("@luauforge/deferred/fow")
local module3 = require("@luauforge/bundled/fue")
local module4 = require("@luauforge/deferred/fud")
local module5 = require("@luauforge/bundled/fus")
local module6 = require("@luauforge/deferred/fuc")

local function YouTubePageWrapper(props)
	local isVisible = props.isVisible
	local displayOrder = props.DisplayOrder
	local url = props.url
	local title = props.title
	local transitionAnimation = props.transitionAnimation

	local v5 = module4(transitionAnimation)
	assert(
		transitionAnimation == nil or transitionAnimation == module3.None or v5 ~= nil,
		string.format("Unhandled transition animation: %q", (tostring(transitionAnimation)))
	)

	local jsonEncode = HttpService:JSONEncode({
		url = url,
		title = title,
		animated = transitionAnimation ~= module3.None,
		transitionAnimation = v5
	})

	return React.createElement(module2, {
		isVisible = isVisible,
		DisplayOrder = displayOrder,
		notificationData = jsonEncode,
		notificationType = module.OPEN_YOUTUBE_VIDEO
	})
end

if require("@luauforge/bundled/fQI")() then
	return function(props)
		return React.createElement(module6, {
			url = props.url,
			title = props.title,
			transitionAnimation = props.transitionAnimation,
			windowType = module5.Dialog,
			overlayProps = {
				isVisible = props.isVisible,
				DisplayOrder = props.DisplayOrder
			}
		})
	end
end

return YouTubePageWrapper
