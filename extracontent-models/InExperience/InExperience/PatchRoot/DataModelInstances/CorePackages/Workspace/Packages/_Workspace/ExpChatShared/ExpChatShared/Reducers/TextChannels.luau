local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local parent = ExpChatShared.Parent
local Rodux = require(parent.Rodux)
local llama = require(parent.llama)
local dictionary = llama.Dictionary
local llama2 = require(parent.llama)
local none = llama2.None
local Logger = require(ExpChatShared.Logger)
local v = Logger:new("ExpChat/Reducers/" .. script.Name)

local GetFFlagTextChatEnableUniverseChatTabs = require(ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs)
local FFlagExpChatFixBackspaceNilTargetChannel = require(ExpChatShared.Flags.FFlagExpChatFixBackspaceNilTargetChannel)

local Actions = ExpChatShared.Actions
local ChatInputBarActivatedTeamMode = require(Actions.ChatInputBarActivatedTeamMode)
local ChatInputBarActivatedWhisperMode = require(Actions.ChatInputBarActivatedWhisperMode)
local ChatInputBarResetTargetChannel = require(Actions.ChatInputBarResetTargetChannel)
local ClientAppLoaded = require(Actions.ClientAppLoaded)
local LocalTeamChanged = require(Actions.LocalTeamChanged)
local LocalTextChannelParticipantRemoved = require(Actions.LocalTextChannelParticipantRemoved)
local TargetTextChannelPropertyChanged = require(Actions.TargetTextChannelPropertyChanged)
local TextChatChannelSelected = require(Actions.TextChatChannelSelected)
local TextChannelCreated = require(Actions.TextChannelCreated)
local TextChannelRemoved = require(Actions.TextChannelRemoved)
local PlayerRemoved = require(Actions.PlayerRemoved)
local UniverseChatChannelSelected = require(Actions.UniverseChatChannelSelected)

local function getTeamTextChannelFromTeam(allTextChannels, p) -- 2 equivalent calls inferred from this helper
	local v2 = "RBXTeam" .. p.TeamColor.Name

	for k, item in pairs(allTextChannels) do
		if k == v2 then
			return item
		end
	end

	return nil
end

return Rodux.createReducer(
	{ allTextChannels = {}, targetTextChannel = nil, selectedChannelName = nil, currentTeam = nil },
	{
		[ClientAppLoaded.name] = function(p, p2)
			local join = dictionary.join
			local currentTeam = if p2.team == nil then none else p2.team
			return join(p, { currentTeam = currentTeam })
		end,
		[TextChannelCreated.name] = function(p, p2)
			v:trace("TextChannelCreated: {}", p2.textChannel.Name)
			return dictionary.join(p, {
				allTextChannels = dictionary.join(p.allTextChannels, {
					[p2.textChannel.Name] = p2.textChannel
				})
			})
		end,
		[TextChannelRemoved.name] = function(p, p2)
			local allTextChannels = dictionary.removeKey(p.allTextChannels, p2.textChannel.Name)
			local targetTextChannel

			if p2.textChannel == p.targetTextChannel then
				targetTextChannel = allTextChannels.RBXGeneral or none
			else
				targetTextChannel = p.targetTextChannel
			end

			return dictionary.join(p, {
				allTextChannels = allTextChannels,
				targetTextChannel = targetTextChannel
			})
		end,
		[LocalTextChannelParticipantRemoved.name] = function(p, p2)
			local join = dictionary.join
			local targetTextChannel

			if p2.textChannel == p.targetTextChannel then
				if p2.textChannel == p.allTextChannels.RBXGeneral then
					targetTextChannel = none
				else
					targetTextChannel = p.allTextChannels.RBXGeneral or none
				end
			else
				targetTextChannel = p.targetTextChannel
			end

			return join(p, { targetTextChannel = targetTextChannel })
		end,
		[TargetTextChannelPropertyChanged.name] = function(p, p2)
			v:trace("TargetTextChannelPropertyChanged dispatched")

			if p2.textChannel == nil then
				return p
			end

			if GetFFlagTextChatEnableUniverseChatTabs() then
				return dictionary.join(p, {
					targetTextChannel = p2.textChannel,
					selectedChannelName = p2.textChannel.Name
				})
			end

			local join = dictionary.join
			local targetTextChannel

			if p2.textChannel == nil then
				targetTextChannel = none
			else
				targetTextChannel = p2.textChannel
			end

			return join(p, { targetTextChannel = targetTextChannel })
		end,
		[TextChatChannelSelected.name] = function(p, p2)
			v:trace("TextChatChannelSelected dispatched: {}", p2.channelName)

			local allTextChannel = p.allTextChannels[p2.channelName]

			if allTextChannel == nil then
				return p
			end

			return dictionary.join(p, {
				targetTextChannel = allTextChannel,
				selectedChannelName = p2.channelName
			})
		end,
		[LocalTeamChanged.name] = function(p, p2)
			if p2.team then
				v:trace("LocalTeamChanged dispatched with team: {}", p2.team.Name)

				if not (p.targetTextChannel and string.find(p.targetTextChannel.Name, "^RBXTeam")) then
					return dictionary.join(p, { currentTeam = p2.team })
				end

				local targetTextChannel = getTeamTextChannelFromTeam(p.allTextChannels, p2.team) -- inferred equivalent call

				local join = dictionary.join
				local v2 = { currentTeam = p2.team, targetTextChannel = 0 }

				if targetTextChannel == nil then
					targetTextChannel = p.allTextChannels.RBXGeneral
				end

				v2.targetTextChannel = targetTextChannel
				return join(p, v2)
			end

			v:trace("LocalTeamChanged dispatched with no team")

			if p.targetTextChannel and string.find(p.targetTextChannel.Name, "^RBXTeam") then
				return dictionary.join(p, {
					currentTeam = none,
					targetTextChannel = p.allTextChannels.RBXGeneral or p.targetTextChannel
				})
			end

			return dictionary.join(p, { currentTeam = none })
		end,
		[ChatInputBarActivatedTeamMode.name] = function(p, _)
			if p.currentTeam == nil then
				v:trace("ChatInputBarActivatedTeamMode but not on a team")
				return p
			end

			assert(p.currentTeam, "This should be unreachable")

			local targetTextChannel = getTeamTextChannelFromTeam(p.allTextChannels, p.currentTeam) -- inferred equivalent call
			v:trace(
				"ChatInputBarActivatedTeamMode - set targetTextChannel to {}",
				targetTextChannel and targetTextChannel.Name or "nil"
			)

			if targetTextChannel == nil then
				return p
			end

			local join = dictionary.join

			if targetTextChannel == nil then
				targetTextChannel = none
			end

			return join(p, { targetTextChannel = targetTextChannel })
		end,
		[ChatInputBarResetTargetChannel.name] = function(p, p2)
			if FFlagExpChatFixBackspaceNilTargetChannel and p2.isGlobalTabActive then
				return dictionary.join(p, { targetTextChannel = none })
			end

			return dictionary.join(p, {
				targetTextChannel = p.allTextChannels.RBXGeneral or p.targetTextChannel
			})
		end,
		[ChatInputBarActivatedWhisperMode.name] = function(p, p2)
			v:trace(
				"ChatInputBarActivatedTeamMode - set targetTextChannel to {}",
				p2.textChannel and p2.textChannel.Name or "nil"
			)

			if p2.textChannel == nil then
				return p
			end

			return dictionary.join(p, {
				allTextChannels = dictionary.join(p.allTextChannels, {
					[p2.textChannel.Name] = p2.textChannel
				}),
				targetTextChannel = p2.textChannel
			})
		end,
		[PlayerRemoved.name] = function(p, p2)
			local function isRemovedPlayerInWhisperChannel(value) -- 2 equivalent calls inferred from this helper
				return string.find(value, "RBXWhisper:") and string.find(value, p2.userId)
			end

			local targetTextChannel = p.targetTextChannel

			if targetTextChannel and isRemovedPlayerInWhisperChannel(targetTextChannel.Name) then -- inferred equivalent call
				targetTextChannel = p.allTextChannels.RBXGeneral
			end

			local filtered = dictionary.filter(p.allTextChannels, function(_, value): boolean
				return not isRemovedPlayerInWhisperChannel(value) -- inferred equivalent call
			end)

			return dictionary.join(p, {
				targetTextChannel = targetTextChannel,
				allTextChannels = filtered
			})
		end,
		[UniverseChatChannelSelected.name] = function(p, p2)
			v:trace("UniverseChatChannelSelected dispatched: {}", p2.channelName)

			return dictionary.join(p, {
				targetTextChannel = none,
				selectedChannelName = p2.channelName
			})
		end
	}
)
