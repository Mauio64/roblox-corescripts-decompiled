local GroupPeekSdui = script:FindFirstAncestor("GroupPeekSdui")
local parent = GroupPeekSdui.Parent

local GroupPeekSduiConstants = require(GroupPeekSdui.GroupPeekSduiConstants)

local SharedFlags = require(parent.SharedFlags)

local function registerGroupAnnouncementActions()
	if SharedFlags.FFlagSduiCustomFormEnabled then
		local CustomForms = require(parent.CustomForms)
		CustomForms.getSduiCustomFormVerticalRegistry().registerVertical(GroupPeekSduiConstants.CUSTOM_FORM_VERTICAL, {
			submit = require(GroupPeekSdui.CustomForm.submitGroupCustomFormResponse),
			fetchResults = require(GroupPeekSdui.CustomForm.fetchGroupCustomFormResults)
		})
	end

	if SharedFlags.FFlagSduiReactionsComponent then
		local SduiSharedContent = require(parent.SduiSharedContent)
		SduiSharedContent.getSduiContentReactionVerticalRegistry().registerVertical(
			GroupPeekSduiConstants.CONTENT_REACTION_VERTICAL,
			{
				toggle = require(GroupPeekSdui.Reactions.toggleAnnouncementReaction)
			}
		)
	end
end

return registerGroupAnnouncementActions
