local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")
local FFlagBuildExperienceDeveloperProductContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceDeveloperProductContext")

local GetBuildPromptDraftStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildPromptDraftStore")
local chatTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

local function useBuildPromptDraft(p2, p3, callback, callback2, p4, current)
	local v5 = GetBuildPromptDraftStore()
	local v6 = SignalsReact.useSignalState(v5.getPendingDraft)
	local ref

	if FFlagBuildExperienceDeveloperProductContext then
		ref = React.useRef(current)
		ref.current = current
	else
		ref = nil
	end

	React.useEffect(function()
		if FFlagBuildExperienceMonetizationNativeUI and (p4 == false or v5.getPendingDraft() ~= v6) then
			return
		end

		if
			v6 == nil
			or v6.universeId ~= p2
			or v6.sessionId ~= nil and v6.sessionId ~= p3
			or not FFlagBuildExperienceDeveloperProductContext and v6.resourceAttachments ~= nil
		then
			return
		end

		if FFlagBuildExperienceDeveloperProductContext and v6.resourceAttachments ~= nil then
			local current2 = if ref ~= nil then ref.current else nil

			if current2 == nil then
				return
			end

			current2.clearComposerResourceAttachments()

			for k, resourceAttachment in v6.resourceAttachments do
				if current2.findComposerResourceAttachmentIndexByUri(chatTypes.getResourceAttachmentUri(resourceAttachment)) ~= nil then
					continue
				end

				current2.addComposerResourceAttachment(resourceAttachment)
			end
		end

		callback(v6.text)

		if v6.autoSend == true and (callback2 == nil or not callback2()) then
			return
		end

		v5.consumeDraft(p2, p3)
	end, FFlagBuildExperienceMonetizationNativeUI and {
		v6 or false,
		v5,
		p2 or false,
		p3 or false,
		callback,
		callback2 or false,
		p4 ~= false
	} or { v6, v5, p2, p3, callback, callback2 })
end

return useBuildPromptDraft
