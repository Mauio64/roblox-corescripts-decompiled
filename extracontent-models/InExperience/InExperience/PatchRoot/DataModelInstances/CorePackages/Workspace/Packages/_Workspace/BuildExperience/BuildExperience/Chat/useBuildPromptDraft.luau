local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)
local FFlagBuildExperienceDeveloperProductContext = require(BuildExperience.Flags.FFlagBuildExperienceDeveloperProductContext)

local GetBuildPromptDraftStore = require(BuildExperience.Stores.GetBuildPromptDraftStore)
local chatTypes = require(script.Parent.chatTypes)

local function useBuildPromptDraft(p: number?, p2: string?, callback, callback2, flag: boolean?, current)
	local buildPromptDraftStore = GetBuildPromptDraftStore()
	local v = SignalsReact.useSignalState(buildPromptDraftStore.getPendingDraft)
	local ref

	if FFlagBuildExperienceDeveloperProductContext then
		ref = React.useRef(current)
		ref.current = current
	else
		ref = nil
	end

	React.useEffect(function()
		if
			FFlagBuildExperienceMonetizationNativeUI
			and (flag == false or buildPromptDraftStore.getPendingDraft() ~= v)
		then
			return
		end

		if
			v == nil
			or v.universeId ~= p
			or v.sessionId ~= nil and v.sessionId ~= p2
			or not FFlagBuildExperienceDeveloperProductContext and v.resourceAttachments ~= nil
		then
			return
		end

		if FFlagBuildExperienceDeveloperProductContext and v.resourceAttachments ~= nil then
			local current2

			if ref ~= nil then
				current2 = ref.current
			end

			if current2 == nil then
				return
			end

			current2.clearComposerResourceAttachments()

			for _, resourceAttachment in v.resourceAttachments do
				if current2.findComposerResourceAttachmentIndexByUri(chatTypes.getResourceAttachmentUri(resourceAttachment)) ~= nil then
					continue
				end

				current2.addComposerResourceAttachment(resourceAttachment)
			end
		end

		callback(v.text)

		if v.autoSend == true and (callback2 == nil or not callback2()) then
			return
		end

		buildPromptDraftStore.consumeDraft(p, p2)
	end, FFlagBuildExperienceMonetizationNativeUI and {
		v or false,
		buildPromptDraftStore,
		p or false,
		p2 or false,
		callback,
		callback2 or false,
		flag ~= false
	} or { v, buildPromptDraftStore, p, p2, callback, callback2 })
end

return useBuildPromptDraft
