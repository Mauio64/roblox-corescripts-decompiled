local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local SocialLibraries = require(AppChat.SocialLibraries)
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local Logger = require(script.Parent.Logger)
local presenceSortComparator = SocialLibraries.Utils.presenceSortComparator
local SortedList = SocialLibraries.Components.SortedList
local ParticipantEntryRightFrame = require(script.Parent.ParticipantEntryRightFrame)
local ParticipantEntry = require(script.Parent.ParticipantEntry)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)
local getFFlagAppChatParticipantDialogFoundationMenu = require(AppChat.Flags.getFFlagAppChatParticipantDialogFoundationMenu)
local t1 = {
	entryHeight = 64,
	pendingKey = "Feature.Chat.Label.Pending",
	invitedKey = "Feature.SettingsHub.Label.Invited",
	LayoutOrder = 0,
	entries = {},
	onEntryActivated = function(_, _) -- line: 36
		-- upvalues: Logger (copy)
		Logger:warning("onEntryActivated was not passed to ParticipantList")
	end,
	sortComparator = presenceSortComparator
}

function ParticipantList(t2: {[any]: any}) -- line: 49
	-- upvalues: Cryo (copy), t1 (copy), getFFlagAppChatParticipantDialogFoundationMenu (copy), React (copy), useLocalization (copy), ParticipantEntry (copy), FFlagDebugAppChatEnableDomLocators (copy), DomLocators (copy), ParticipantEntryRightFrame (copy), SortedList (copy)
	local v20 = Cryo.Dictionary.join(t1, t2)
	local v21 = v20.onEntryActivated or t1.onEntryActivated
	local v22 = getFFlagAppChatParticipantDialogFoundationMenu()
	local u23 = nil

	if v22 then
		u23 = React.useRef({})
	end

	local v24 = useLocalization({
		pendingLabelText = v20.pendingKey,
		invitedLabelText = v20.invitedKey
	})
	local t3 = {}

	for _, v in pairs(v20.entries) do
		local t4 = {}
		local v29 = not v.isLocalUser
		local v30 = v.metadata and v.metadata.isPending

		if v29 or v30 then
			local t5 = {
				labelText = if not v30 then nil else v24.pendingLabelText,
				shouldShowDots = v29,
				testId = if not FFlagDebugAppChatEnableDomLocators or not v29 then nil else DomLocators.chatDetailsParticipantMoreButton(v.displayName)
			}

			if v22 and v29 then
				local str = tostring(v.id)
				local v33

				if u23 == nil then
					v33 = nil
				else
					if u23.current[str] == nil then
						u23.current[str] = React.createRef()
					end

					v33 = u23.current[str]
				end

				local v34 = v33

				t5.dotsRef = v34

				function t5.onDotsActivated() -- line: 119
					-- upvalues: v21 (copy), v (copy), v34 (copy)
					v21(v, v34)
				end
			else
				t5.dotsRef = nil
				t5.onDotsActivated = nil
			end

			t4.children = {
				rightFrame = React.createElement(ParticipantEntryRightFrame, t5)
			}
		end

		table.insert(t3, Cryo.Dictionary.join(t4, v))
	end

	return React.createElement(SortedList, {
		entries = t3,
		entryHeight = v20.entryHeight,
		renderEntry = function(p3, _) -- line: 76
			-- upvalues: v24 (copy), v22 (copy), u23 (ref), React (copy), v20 (copy), v21 (copy), ParticipantEntry (copy)
			local v38 = p3.metadata and p3.metadata.isInvited
			local str = tostring(p3.id)
			local t6 = {
				userId = p3.id,
				statusText = if not v38 then nil else v24.invitedLabelText
			}

			if v22 then
				local v41

				if u23 == nil then
					v41 = nil
				else
					if u23.current[str] == nil then
						u23.current[str] = React.createRef()
					end

					v41 = u23.current[str]
				end

				local v42 = v41

				t6.onActivated = str ~= v20.activeParticipantId and function() -- line: 89
					-- upvalues: v21 (copy), p3 (copy), v42 (copy)
					v21(p3, v42)
				end or nil
			else
				function t6.onActivated() -- line: 93
					-- upvalues: v21 (copy), p3 (copy)
					v21(p3, nil)
				end
			end

			return React.createElement(ParticipantEntry, t6, p3.children)
		end,
		sortComparator = v20.sortComparator,
		LayoutOrder = v20.LayoutOrder
	})
end

return memo(ParticipantList)
