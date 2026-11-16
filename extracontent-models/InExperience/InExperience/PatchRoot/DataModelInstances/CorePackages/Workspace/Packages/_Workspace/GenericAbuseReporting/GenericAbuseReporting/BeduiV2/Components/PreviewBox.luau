local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local includeProfileFrame = game:DefineFastFlag("AbuseReportingUseProfileFrameThumbnail", false)

if includeProfileFrame then
	local SharedFlags = require(parent.SharedFlags)
	includeProfileFrame = SharedFlags.GetFFlagProfileFrameThumbnailEnabled()
end

local Avatar = Foundation.Avatar
local Image = Foundation.Image
local Text = Foundation.Text
local View = Foundation.View

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local useExperienceDetails = require(GenericAbuseReporting.BeduiV2.Hooks.Enrichment.useExperienceDetails)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)

local function UserPreview(p)
	local preview = p.preview

	if not preview then
		return nil
	end

	return React.createElement(
		View,
		{
			tag = "row align-y-center gap-medium size-full-0 auto-y padding-medium radius-medium bg-surface-200",
			LayoutOrder = p.layoutOrder
		},
		{
			Avatar = preview.id ~= nil and React.createElement(Avatar, {
				userId = tonumber(preview.id),
				includeProfileFrame = includeProfileFrame,
				LayoutOrder = 1
			}),
			TextContainer = (preview.displayName or preview.username) and React.createElement(
				View,
				{ tag = "col fill auto-xy", LayoutOrder = 2 },
				{
					DisplayName = preview.displayName and React.createElement(Text, {
						Text = preview.displayName,
						RichText = true,
						tag = "auto-xy text-wrap text-align-x-left content-emphasis",
						LayoutOrder = 1
					}),
					Username = preview.username and React.createElement(Text, {
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

local function ChatPreview(p)
	local preview = p.preview

	if preview then
		return React.createElement(
			View,
			{
				tag = "gap-xsmall size-full-0 auto-y padding-medium radius-medium bg-surface-200",
				LayoutOrder = p.layoutOrder
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

local function ExperiencePreview(p)
	local preview = p.preview
	local v = useExperienceDetails(preview.id)

	if preview then
		return React.createElement(
			View,
			{
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-medium radius-medium bg-surface-200",
				LayoutOrder = p.layoutOrder
			},
			{
				ExperienceIcon = React.createElement(Image, {
					Image = `rbxthumb://type=GameIcon&id={preview.id}&w=50&h=50`,
					Size = UDim2.fromOffset(40, 40),
					tag = "radius-medium"
				}),
				Name = React.createElement(Text, {
					Text = v and v.name or preview.title or "",
					RichText = true,
					tag = "auto-xy text-wrap text-align-x-left"
				})
			}
		)
	end

	return nil
end

local function PreviewBox(p)
	local preview = p.preview

	if preview.type == "user" then
		return React.createElement(UserPreview, { preview = preview, layoutOrder = p.layoutOrder })
	end

	if preview.type == "chat" then
		return React.createElement(ChatPreview, { preview = preview, layoutOrder = p.layoutOrder })
	end

	if preview.type == "experience" then
		return React.createElement(ExperiencePreview, {
			preview = preview,
			layoutOrder = p.layoutOrder
		})
	end

	return nil
end

return React.memo(PreviewBox)
