local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux")
local dictionary = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/llama").Dictionary
local none = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/llama").None
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Logger"):new("ExpChat/Reducers/TextChannels")

local GetFFlagTextChatEnableUniverseChatTabs = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Flags/GetFFlagTextChatEnableUniverseChatTabs")
local FFlagExpChatFixBackspaceNilTargetChannel = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Flags/FFlagExpChatFixBackspaceNilTargetChannel")

local ChatInputBarActivatedTeamMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/ChatInputBarActivatedTeamMode")
local ChatInputBarActivatedWhisperMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/ChatInputBarActivatedWhisperMode")
local ChatInputBarResetTargetChannel = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/ChatInputBarResetTargetChannel")
local ClientAppLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/ClientAppLoaded")
local LocalTeamChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/LocalTeamChanged")
local LocalTextChannelParticipantRemoved = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/LocalTextChannelParticipantRemoved")
local TargetTextChannelPropertyChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/TargetTextChannelPropertyChanged")
local TextChatChannelSelected = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/TextChatChannelSelected")
local TextChannelCreated = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/TextChannelCreated")
local TextChannelRemoved = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/TextChannelRemoved")
local PlayerRemoved = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/PlayerRemoved")
local UniverseChatChannelSelected = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Actions/UniverseChatChannelSelected")

local function getTeamTextChannelFromTeam(items, p2)
	local v6 = "RBXTeam" .. p2.TeamColor.Name

	for k, item in pairs(items) do
		if k == v6 then
			return item
		end
	end

	return nil
end

return Rodux.createReducer(
	{
		allTextChannels = {},
		targetTextChannel = nil,
		selectedChannelName = nil,
		currentTeam = nil
	},
	{
		[ClientAppLoaded.name] = function(p2, p3)
			local join = dictionary.join
			local v8 = if p3.team == nil then none else p3.team
			return join(p2, { currentTeam = v8 })
		end,
		[TextChannelCreated.name] = function(p2, p3)
			v5:trace("TextChannelCreated: {}", p3.textChannel.Name)
			return dictionary.join(p2, {
				allTextChannels = dictionary.join(p2.allTextChannels, {
					[p3.textChannel.Name] = p3.textChannel
				})
			})
		end,
		[TextChannelRemoved.name] = function(p2, p3)
			local v7 = dictionary.removeKey(p2.allTextChannels, p3.textChannel.Name)
			local v8 = if p3.textChannel == p2.targetTextChannel then v7.RBXGeneral or none else p2.targetTextChannel

			return dictionary.join(p2, { allTextChannels = v7, targetTextChannel = v8 })
		end,
		[LocalTextChannelParticipantRemoved.name] = function(p2, p3)
			local join = dictionary.join
			local v8

			if p3.textChannel == p2.targetTextChannel then
				if p3.textChannel == p2.allTextChannels.RBXGeneral then
					v8 = none
				else
					v8 = p2.allTextChannels.RBXGeneral or none
				end
			else
				v8 = p2.targetTextChannel
			end

			return join(p2, { targetTextChannel = v8 })
		end,
		[TargetTextChannelPropertyChanged.name] = function(p2, p3)
			v5:trace("TargetTextChannelPropertyChanged dispatched")

			if p3.textChannel == nil then
				return p2
			end

			if GetFFlagTextChatEnableUniverseChatTabs() then
				return dictionary.join(p2, {
					targetTextChannel = p3.textChannel,
					selectedChannelName = p3.textChannel.Name
				})
			end

			local join = dictionary.join
			local v8 = if p3.textChannel == nil then none else p3.textChannel
			return join(p2, { targetTextChannel = v8 })
		end,
		[TextChatChannelSelected.name] = function(p2, p3)
			v5:trace("TextChatChannelSelected dispatched: {}", p3.channelName)

			local allTextChannel = p2.allTextChannels[p3.channelName]

			if allTextChannel == nil then
				return p2
			end

			return dictionary.join(p2, {
				targetTextChannel = allTextChannel,
				selectedChannelName = p3.channelName
			})
		end,
		[LocalTeamChanged.name] = function(p2, p3)
			if p3.team then
				v5:trace("LocalTeamChanged dispatched with team: {}", p3.team.Name)

				if not (p2.targetTextChannel and string.find(p2.targetTextChannel.Name, "^RBXTeam")) then
					return dictionary.join(p2, { currentTeam = p3.team })
				end

				local allTextChannels = p2.allTextChannels
				local v7 = "RBXTeam" .. p3.team.TeamColor.Name
				local v9

				for k, allTextChannel in pairs(allTextChannels) do
					if k == v7 then
						v9 = allTextChannel
						break
					end
				end

				local join = dictionary.join
				local v10 = { currentTeam = p3.team, targetTextChannel = 0 }

				if v9 == nil then
					v9 = p2.allTextChannels.RBXGeneral
				end

				v10.targetTextChannel = v9
				return join(p2, v10)
			end

			v5:trace("LocalTeamChanged dispatched with no team")

			if p2.targetTextChannel and string.find(p2.targetTextChannel.Name, "^RBXTeam") then
				return dictionary.join(p2, {
					currentTeam = none,
					targetTextChannel = p2.allTextChannels.RBXGeneral or p2.targetTextChannel
				})
			end

			return dictionary.join(p2, { currentTeam = none })
		end,
		[ChatInputBarActivatedTeamMode.name] = function(p2, p3)
			if p2.currentTeam == nil then
				v5:trace("ChatInputBarActivatedTeamMode but not on a team")
				return p2
			end

			assert(p2.currentTeam, "This should be unreachable")

			local allTextChannels = p2.allTextChannels
			local v7 = "RBXTeam" .. p2.currentTeam.TeamColor.Name
			local v9

			for k, allTextChannel in pairs(allTextChannels) do
				if k == v7 then
					v9 = allTextChannel
					break
				end
			end

			v5:trace("ChatInputBarActivatedTeamMode - set targetTextChannel to {}", v9 and v9.Name or "nil")

			if v9 == nil then
				return p2
			end

			local join = dictionary.join

			if v9 == nil then
				v9 = none
			end

			return join(p2, { targetTextChannel = v9 })
		end,
		[ChatInputBarResetTargetChannel.name] = function(p2, p3)
			if FFlagExpChatFixBackspaceNilTargetChannel and p3.isGlobalTabActive then
				return dictionary.join(p2, { targetTextChannel = none })
			end

			return dictionary.join(p2, {
				targetTextChannel = p2.allTextChannels.RBXGeneral or p2.targetTextChannel
			})
		end,
		[ChatInputBarActivatedWhisperMode.name] = function(p2, p3)
			v5:trace(
				"ChatInputBarActivatedTeamMode - set targetTextChannel to {}",
				p3.textChannel and p3.textChannel.Name or "nil"
			)

			if p3.textChannel == nil then
				return p2
			end

			return dictionary.join(p2, {
				allTextChannels = dictionary.join(p2.allTextChannels, {
					[p3.textChannel.Name] = p3.textChannel
				}),
				targetTextChannel = p3.textChannel
			})
		end,
		[PlayerRemoved.name] = function(p2, p3)
			local function isRemovedPlayerInWhisperChannel(value)
				return string.find(value, "RBXWhisper:") and string.find(value, p3.userId)
			end

			local v7 = p2.targetTextChannel

			if v7 then
				local name = v7.Name

				if string.find(name, "RBXWhisper:") and string.find(name, p3.userId) then
					v7 = p2.allTextChannels.RBXGeneral
				end
			end

			local filtered = dictionary.filter(p2.allTextChannels, function(p4, value): boolean
				return not (string.find(value, "RBXWhisper:") and string.find(value, p3.userId))
			end)

			return dictionary.join(p2, {
				targetTextChannel = v7,
				allTextChannels = filtered
			})
		end,
		[UniverseChatChannelSelected.name] = function(p2, p3)
			v5:trace("UniverseChatChannelSelected dispatched: {}", p3.channelName)

			return dictionary.join(p2, {
				targetTextChannel = none,
				selectedChannelName = p3.channelName
			})
		end
	}
)
