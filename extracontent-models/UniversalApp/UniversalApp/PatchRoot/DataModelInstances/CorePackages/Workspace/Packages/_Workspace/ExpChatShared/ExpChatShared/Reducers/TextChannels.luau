local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local ExpChatSharedParent = ExpChatShared.Parent
local Rodux = require(ExpChatSharedParent.Rodux)
local Dictionary = require(ExpChatSharedParent.llama).Dictionary
local None = require(ExpChatSharedParent.llama).None
local v6 = require(ExpChatShared.Logger):new("ExpChat/Reducers/" .. script.Name)
local GetFFlagTextChatEnableUniverseChatTabs = require(ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs)
local Actions = ExpChatShared.Actions
local ChatInputBarActivatedTeamMode = require(Actions.ChatInputBarActivatedTeamMode)
local ChatInputBarActivatedWhisperMode = require(Actions.ChatInputBarActivatedWhisperMode)
local ChatInputBarResetTargetChannel = require(Actions.ChatInputBarResetTargetChannel)
local ClientAppLoaded = require(Actions.ClientAppLoaded)
local LocalTeamChanged = require(Actions.LocalTeamChanged)
local LocalTextChannelParticipantRemoved = require(Actions.LocalTextChannelParticipantRemoved)
local TargetTextChannelPropertyChanged = require(Actions.TargetTextChannelPropertyChanged)
local TextChannelCreated = require(Actions.TextChannelCreated)
local TextChannelRemoved = require(Actions.TextChannelRemoved)
local PlayerRemoved = require(Actions.PlayerRemoved)
local UniverseChatChannelSelected = require(Actions.UniverseChatChannelSelected)
local t1 = {
	targetTextChannel = nil,
	selectedChannelName = nil,
	currentTeam = nil,
	allTextChannels = {}
}

local function getTeamTextChannelFromTeam(t2: {[any]: any}, p1) -- line: 37
	local v24 = "RBXTeam" .. p1.TeamColor.Name

	for k, v in pairs(t2) do
		if k == v24 then
			return v
		end
	end

	return nil
end

return Rodux.createReducer(t1, {
	[ClientAppLoaded.name] = function(t3: {[any]: any}, p2) -- line: 49
		-- upvalues: Dictionary (copy), None (copy)
		return Dictionary.join(t3, {
			currentTeam = if p2.team ~= nil then p2.team else None
		})
	end,
	[TextChannelCreated.name] = function(t4: {[any]: any}, p3) -- line: 55
		-- upvalues: v6 (copy), Dictionary (copy)
		v6:trace("TextChannelCreated: {}", p3.textChannel.Name)

		return Dictionary.join(t4, {
			allTextChannels = Dictionary.join(t4.allTextChannels, {
				[p3.textChannel.Name] = p3.textChannel
			})
		})
	end,
	[TextChannelRemoved.name] = function(t5: {[any]: any}, p4) -- line: 64
		-- upvalues: Dictionary (copy), None (copy)
		local v33 = Dictionary.removeKey(t5.allTextChannels, p4.textChannel.Name)
		local v34 = if p4.textChannel ~= t5.targetTextChannel then t5.targetTextChannel else v33.RBXGeneral or None

		return Dictionary.join(t5, {
			allTextChannels = v33,
			targetTextChannel = v34
		})
	end,
	[LocalTextChannelParticipantRemoved.name] = function(t6: {[any]: any}, p5) -- line: 76
		-- upvalues: Dictionary (copy), None (copy)
		return Dictionary.join(t6, {
			targetTextChannel = if p5.textChannel ~= t6.targetTextChannel then t6.targetTextChannel else if p5.textChannel ~= t6.allTextChannels.RBXGeneral then t6.allTextChannels.RBXGeneral or None else None
		})
	end,
	[TargetTextChannelPropertyChanged.name] = function(t7: {[any]: any}, p6) -- line: 89
		-- upvalues: v6 (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), Dictionary (copy), None (copy)
		v6:trace("TargetTextChannelPropertyChanged dispatched")

		if p6.textChannel == nil then
			return t7
		end

		if GetFFlagTextChatEnableUniverseChatTabs() then
			return Dictionary.join(t7, {
				targetTextChannel = p6.textChannel,
				selectedChannelName = p6.textChannel.Name
			})
		end

		return Dictionary.join(t7, {
			targetTextChannel = if p6.textChannel ~= nil then p6.textChannel else None
		})
	end,
	[LocalTeamChanged.name] = function(t8: {[any]: any}, p7) -- line: 108
		-- upvalues: v6 (copy), Dictionary (copy), None (copy)
		if p7.team then
			v6:trace("LocalTeamChanged dispatched with team: {}", p7.team.Name)

			if t8.targetTextChannel and string.find(t8.targetTextChannel.Name, "^RBXTeam") then
				local allTextChannels = t8.allTextChannels
				local v42 = "RBXTeam" .. p7.team.TeamColor.Name
				local v45

				for k, v in pairs(allTextChannels) do
					if k == v42 then
						v45 = v

						return Dictionary.join(t8, {
							currentTeam = p7.team,
							targetTextChannel = if v45 ~= nil then v45 else t8.allTextChannels.RBXGeneral
						})
					end
				end

				v45 = nil

				return Dictionary.join(t8, {
					currentTeam = p7.team,
					targetTextChannel = if v45 ~= nil then v45 else t8.allTextChannels.RBXGeneral
				})
			end

			return Dictionary.join(t8, {
				currentTeam = p7.team
			})
		end

		v6:trace("LocalTeamChanged dispatched with no team")

		return Dictionary.join(t8, {
			currentTeam = None,
			targetTextChannel = t8.allTextChannels.RBXGeneral or t8.targetTextChannel
		})
	end,
	[ChatInputBarActivatedTeamMode.name] = function(t9: {[any]: any}, _) -- line: 134
		-- upvalues: v6 (copy), Dictionary (copy), None (copy)
		if t9.currentTeam == nil then
			v6:trace("ChatInputBarActivatedTeamMode but not on a team")

			return t9
		end

		assert(t9.currentTeam, "This should be unreachable")

		local allTextChannels = t9.allTextChannels
		local v49 = "RBXTeam" .. t9.currentTeam.TeamColor.Name
		local g53 = nil
		local v52 = nil

		for k, v in pairs(allTextChannels) do
			if k == v49 then
				v52 = v
				g53 = true
			end

			if g53 then
				break
			end
		end

		if not g53 then
			v52 = nil
		end

		g53 = false
		v6:trace("ChatInputBarActivatedTeamMode - set targetTextChannel to {}", v52 and v52.Name or "nil")

		if v52 == nil then
			return t9
		end

		return Dictionary.join(t9, {
			targetTextChannel = if v52 ~= nil then v52 else None
		})
	end,
	[ChatInputBarResetTargetChannel.name] = function(t10: {[any]: any}, _) -- line: 157
		-- upvalues: Dictionary (copy)
		return Dictionary.join(t10, {
			targetTextChannel = t10.allTextChannels.RBXGeneral or t10.targetTextChannel
		})
	end,
	[ChatInputBarActivatedWhisperMode.name] = function(t11: {[any]: any}, p10) -- line: 163
		-- upvalues: v6 (copy), Dictionary (copy)
		v6:trace("ChatInputBarActivatedTeamMode - set targetTextChannel to {}", p10.textChannel and p10.textChannel.Name or "nil")

		if p10.textChannel == nil then
			return t11
		end

		return Dictionary.join(t11, {
			allTextChannels = Dictionary.join(t11.allTextChannels, {
				[p10.textChannel.Name] = p10.textChannel
			}),
			targetTextChannel = p10.textChannel
		})
	end,
	[PlayerRemoved.name] = function(t12: {[any]: any}, p11) -- line: 181
		-- upvalues: Dictionary (copy)
		local function isRemovedPlayerInWhisperChannel(p12) -- line: 182
			-- upvalues: p11 (copy)
			return string.find(p12, "RBXWhisper:") and string.find(p12, p11.userId)
		end

		local targetTextChannel = t12.targetTextChannel

		if targetTextChannel then
			local targetTextChannelName = targetTextChannel.Name

			if string.find(targetTextChannelName, "RBXWhisper:") and string.find(targetTextChannelName, p11.userId) then
				targetTextChannel = t12.allTextChannels.RBXGeneral
			end
		end

		local v63 = Dictionary.filter(t12.allTextChannels, function(_, p14) -- line: 191
			-- upvalues: p11 (copy)
			return not (string.find(p14, "RBXWhisper:") and string.find(p14, p11.userId))
		end)

		return Dictionary.join(t12, {
			targetTextChannel = targetTextChannel,
			allTextChannels = v63
		})
	end,
	[UniverseChatChannelSelected.name] = function(t13: {[any]: any}, p15) -- line: 204
		-- upvalues: v6 (copy), Dictionary (copy), None (copy)
		v6:trace("UniverseChatChannelSelected dispatched: {}", p15.channelName)

		return Dictionary.join(t13, {
			targetTextChannel = None,
			selectedChannelName = p15.channelName
		})
	end
})
