local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

require(BuildExperience.Chat.chatTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary

local FFlagBuildExperienceInertResourceAttachmentChip = require(BuildExperience.Flags.FFlagBuildExperienceInertResourceAttachmentChip)

local Chip = Foundation.Chip
local View = Foundation.View

local ChipSize = Foundation.Enums.ChipSize
local ChipVariant = Foundation.Enums.ChipVariant

local function ChatResourceAttachmentList(props)
	local children = {}
	local testId = props.testId or "ChatResourceAttachmentList"
	local v

	if FFlagBuildExperienceInertResourceAttachmentChip then
		v = props.onActivateAttachment == nil
	else
		v = FFlagBuildExperienceLibrary

		if v then
			if props.onRemove == nil then
				v = props.onActivateAttachment == nil
			else
				v = false
			end
		end
	end

	for k, attachment in props.attachments do
		local onRemove = props.onRemove
		local onActivateAttachment = props.onActivateAttachment
		local formatted = `Attachment-{k}`
		local createElement = React.createElement
		local v2 = {
			LayoutOrder = k,
			onActivated = not v and function()
				if onActivateAttachment ~= nil then
					onActivateAttachment(k)
				elseif onRemove ~= nil then
					onRemove(k)
				end
			end or nil,
			Selectable = not v and nil,
			size = ChipSize.Small,
			text = 0,
			trailing = 0,
			variant = 0,
			testId = 0
		}
		local text

		if attachment.type == "resource_link" then
			text = attachment.name
		else
			text = attachment.resource.uri
		end

		v2.text = text
		local trailing

		if onRemove ~= nil then
			if v or onActivateAttachment ~= nil then
				trailing = {
					iconName = Foundation.Enums.IconName.X,
					onActivated = function()
						onRemove(k)
					end
				}
			else
				trailing = Foundation.Enums.IconName.X
			end
		end

		v2.trailing = trailing

		v2.variant = ChipVariant.Standard
		v2.testId = `{testId}.Attachment.{k}`
		children[formatted] = createElement(Chip, v2)
	end

	return React.createElement(View, {
		LayoutOrder = props.LayoutOrder,
		tag = {
			["row wrap gap-small size-full-0 auto-y"] = true,
			["align-x-right"] = props.alignRight == true
		},
		testId = testId
	}, children)
end

return React.memo(ChatResourceAttachmentList)
