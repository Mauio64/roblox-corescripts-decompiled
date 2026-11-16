local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local fFlagBuildExperienceLibrary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceLibrary

local FFlagBuildExperienceInertResourceAttachmentChip = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceInertResourceAttachmentChip")

local chip = Foundation.Chip
local view = Foundation.View

local chipSize = Foundation.Enums.ChipSize
local chipVariant = Foundation.Enums.ChipVariant

local function ChatResourceAttachmentList(props)
	local children = {}
	local testId = props.testId or "ChatResourceAttachmentList"
	local v5

	if FFlagBuildExperienceInertResourceAttachmentChip then
		v5 = props.onActivateAttachment == nil
	else
		v5 = fFlagBuildExperienceLibrary

		if v5 then
			v5 = props.onRemove == nil and props.onActivateAttachment == nil
		end
	end

	for k, attachment in props.attachments do
		local onRemove = props.onRemove
		local onActivateAttachment = props.onActivateAttachment
		local formatted = `Attachment-{k}`
		local createElement = React.createElement
		local v7 = {
			LayoutOrder = k,
			onActivated = not v5 and function()
				if onActivateAttachment ~= nil then
					onActivateAttachment(k)
				elseif onRemove ~= nil then
					onRemove(k)
				end
			end or nil,
			Selectable = if v5 then false else nil,
			size = chipSize.Small,
			text = 0,
			trailing = 0,
			variant = 0,
			testId = 0
		}
		local v9 = if attachment.type == "resource_link" then attachment.name else attachment.resource.uri
		v7.text = v9
		local v10

		if onRemove ~= nil then
			if v5 or onActivateAttachment ~= nil then
				v10 = {
					iconName = Foundation.Enums.IconName.X,
					onActivated = function()
						onRemove(k)
					end
				}
			else
				v10 = Foundation.Enums.IconName.X
			end
		end

		v7.trailing = v10

		v7.variant = chipVariant.Standard
		v7.testId = `{testId}.Attachment.{k}`
		children[formatted] = createElement(chip, v7)
	end

	return React.createElement(view, {
		LayoutOrder = props.LayoutOrder,
		tag = {
			["row wrap gap-small size-full-0 auto-y"] = true,
			["align-x-right"] = props.alignRight == true
		},
		testId = testId
	}, children)
end

return React.memo(ChatResourceAttachmentList)
