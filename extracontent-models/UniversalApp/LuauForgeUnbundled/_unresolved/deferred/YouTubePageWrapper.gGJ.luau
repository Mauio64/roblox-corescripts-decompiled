local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/fvN")
local module2 = require("@luauforge/deferred/fvQ")
local module3 = require("@luauforge/bundled/fBF")
local module4 = require("@luauforge/deferred/fBE")
local module5 = require("@luauforge/bundled/fBT")
local module6 = require("@luauforge/deferred/fBD")

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

if require("@luauforge/bundled/gvh")() then
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
