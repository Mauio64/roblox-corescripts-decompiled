local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.SduiCompat)

local Banner = Foundation.Banner

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

local function withOnClose(p, onClose) -- 2 equivalent calls inferred from this helper
	if onClose then
		p.onClose = onClose
	end

	return p
end

local function SduiBanner(props)
	if props.size == "Small" then
		return React.createElement(Banner, withOnClose({ -- inferred equivalent call
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
		}, props.onClose))
	else
		local media = props.media
		local media2 = props.media and props.mediaWidth and {
			image = props.media,
			width = props.mediaWidth
		} or media

		return React.createElement(Banner, withOnClose({ -- inferred equivalent call
			size = props.size,
			density = props.density,
			title = props.title,
			description = props.description,
			media = media2,
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
		}, props.onClose))
	end
end

return React.memo(SduiBanner)
