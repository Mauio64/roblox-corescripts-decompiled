local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local banner = Foundation.Banner

local function getThumbnail(props)
	if props.thumbnailComponent then
		return { type = "Slot", children = props.thumbnailComponent }
	end

	if props.thumbnailIcon then
		return { type = "Icon", icon = props.thumbnailIcon }
	end

	if props.thumbnailImage then
		return { type = "Image", image = props.thumbnailImage }
	end

	if props.thumbnailUserId then
		return {
			type = "Avatar",
			userId = props.thumbnailUserId,
			userPresence = props.thumbnailUserPresence
		}
	end

	return nil
end

local function withOnClose(p2, onClose)
	if onClose then
		p2.onClose = onClose
	end

	return p2
end

local function SduiBanner(props)
	if props.size == "Small" then
		local createElement = React.createElement

		local v6 = {
			size = "Small",
			density = props.density,
			title = props.title,
			description = props.description,
			thumbnail = getThumbnail(props),
			actions = props.primaryAction and {
				primary = { onActivated = props.primaryAction }
			} or nil,
			LayoutOrder = props.layoutOrder,
			AnchorPoint = props.anchorPoint,
			Position = props.position,
			Visible = props.visible,
			ZIndex = props.zIndex,
			testId = props.testId
		}
		local onClose = props.onClose

		if onClose then
			v6.onClose = onClose
		end

		return createElement(banner, v6)
	else
		local media = props.media
		local v5 = props.media and props.mediaWidth and {
				image = props.media,
				width = props.mediaWidth
			}
			or media

		local createElement = React.createElement

		local v7 = {
			size = props.size,
			density = props.density,
			title = props.title,
			description = props.description,
			media = v5,
			actions = (props.primaryAction or props.secondaryActionText and props.secondaryAction) and {
				primary = props.primaryAction and { onActivated = props.primaryAction } or nil,
				secondary = props.secondaryActionText and props.secondaryAction and {
					text = props.secondaryActionText,
					onActivated = props.secondaryAction
				} or nil
			} or nil,
			LayoutOrder = props.layoutOrder,
			AnchorPoint = props.anchorPoint,
			Position = props.position,
			Visible = props.visible,
			ZIndex = props.zIndex,
			testId = props.testId
		}
		local onClose = props.onClose

		if onClose then
			v7.onClose = onClose
		end

		return createElement(banner, v7)
	end
end

return React.memo(SduiBanner)
