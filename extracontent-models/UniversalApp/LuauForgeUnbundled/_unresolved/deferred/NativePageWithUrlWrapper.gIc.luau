local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local HttpService = game:GetService("HttpService")

local module = require("@luauforge/deferred/fvQ")
local module2 = require("@luauforge/bundled/fBF")
local module3 = require("@luauforge/deferred/fBE")
local module4 = require("@luauforge/bundled/egZ")
local module5 = require("@luauforge/deferred/fBD")
local module6 = require("@luauforge/deferred/fBL")

local module7 = require("@luauforge/bundled/gvh")
local module8 = require("@luauforge/deferred/fBS")

local function NativePageWithUrlWrapper(data)
	local isVisible = data.isVisible
	local displayOrder = data.DisplayOrder
	local v5 = if module8 then module6(data.url) else data.url
	local title = data.title
	local titleKey = data.titleKey
	local transitionAnimation = data.transitionAnimation
	local notificationType = data.notificationType
	local onClose = data.onClose

	local v6 = module3(transitionAnimation)
	assert(
		transitionAnimation == nil or transitionAnimation == module2.None or v6 ~= nil,
		string.format("Unhandled transition animation: %q", (tostring(transitionAnimation)))
	)

	local v7 = transitionAnimation ~= module2.None

	local function fn(title2)
		local jsonEncode = HttpService:JSONEncode({
			url = v5,
			title = title2,
			animated = v7,
			transitionAnimation = v6
		})

		return React.createElement(module, {
			isVisible = isVisible,
			DisplayOrder = displayOrder,
			notificationData = jsonEncode,
			notificationType = notificationType,
			onClose = onClose
		})
	end

	if titleKey == nil or title ~= nil then
		return fn(title)
	end

	return module4({ title = titleKey })(function(p2)
		return fn(p2.title)
	end)
end

if module7() then
	return function(props)
		return React.createElement(module5, {
			url = props.url,
			title = props.title,
			titleKey = props.titleKey,
			searchParams = props.searchParams,
			transitionAnimation = props.transitionAnimation,
			windowCloseCallback = props.onClose,
			overlayProps = {
				isVisible = props.isVisible,
				DisplayOrder = props.DisplayOrder
			}
		})
	end
end

return NativePageWithUrlWrapper
