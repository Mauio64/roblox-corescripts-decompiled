local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local v5 = game:DefineFastFlag("AbuseReportingUseProfileFrameThumbnail", false)
	and require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").GetFFlagProfileFrameThumbnailEnabled()

local avatar = Foundation.Avatar
local image = Foundation.Image
local text = Foundation.Text
local view = Foundation.View

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local useExperienceDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/Enrichment/useExperienceDetails")
local TextWithTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/TextWithTranslation")

local function UserPreview(p2)
	local preview = p2.preview

	if not preview then
		return nil
	end

	return React.createElement(
		view,
		{
			tag = "row align-y-center gap-medium size-full-0 auto-y padding-medium radius-medium bg-surface-200",
			LayoutOrder = p2.layoutOrder
		},
		{
			Avatar = preview.id ~= nil and React.createElement(avatar, {
				userId = tonumber(preview.id),
				includeProfileFrame = v5,
				LayoutOrder = 1
			}),
			TextContainer = (preview.displayName or preview.username) and React.createElement(
				view,
				{ tag = "col fill auto-xy", LayoutOrder = 2 },
				{
					DisplayName = preview.displayName and React.createElement(text, {
						Text = preview.displayName,
						RichText = true,
						tag = "auto-xy text-wrap text-align-x-left content-emphasis",
						LayoutOrder = 1
					}),
					Username = preview.username and React.createElement(text, {
						Text = "@" .. preview.username,
						RichText = true,
						tag = "auto-xy text-wrap text-align-x-left",
						LayoutOrder = 2
					})
				}
			)
		}
	)
end

local function ChatPreview(p2)
	local preview = p2.preview

	if preview then
		return React.createElement(
			view,
			{
				tag = "gap-xsmall size-full-0 auto-y padding-medium radius-medium bg-surface-200",
				LayoutOrder = p2.layoutOrder
			},
			{
				Message = React.createElement(TextWithTranslation, {
					input = preview.text,
					tag = "auto-xy text-wrap text-align-x-left"
				})
			}
		)
	end

	return nil
end

local function ExperiencePreview(p2)
	local preview = p2.preview
	local v6 = useExperienceDetails(preview.id)

	if preview then
		return React.createElement(
			view,
			{
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-medium radius-medium bg-surface-200",
				LayoutOrder = p2.layoutOrder
			},
			{
				ExperienceIcon = React.createElement(image, {
					Image = `rbxthumb://type=GameIcon&id={preview.id}&w=50&h=50`,
					Size = UDim2.fromOffset(40, 40),
					tag = "radius-medium"
				}),
				Name = React.createElement(text, {
					Text = v6 and v6.name or preview.title or "",
					RichText = true,
					tag = "auto-xy text-wrap text-align-x-left"
				})
			}
		)
	end

	return nil
end

local function PreviewBox(p2)
	local preview = p2.preview

	if preview.type == "user" then
		return React.createElement(UserPreview, {
			preview = preview,
			layoutOrder = p2.layoutOrder
		})
	end

	if preview.type == "chat" then
		return React.createElement(ChatPreview, {
			preview = preview,
			layoutOrder = p2.layoutOrder
		})
	end

	if preview.type == "experience" then
		return React.createElement(ExperiencePreview, {
			preview = preview,
			layoutOrder = p2.layoutOrder
		})
	end

	return nil
end

return React.memo(PreviewBox)
