local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))

local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserAddChatThrottlingToAllChannels")
end)

if not success then
	result = false
end

local v = not result
local v2 = {}
local v3 = {}

local v4 = nil

pcall(function()
	local Chat2 = game:GetService("Chat")
	v4 = require(Chat2.ClientChatModules.ChatLocalization)
end)

if v4 == nil then
	v4 = {}
end

if not (v4.FormatMessageToSend and v4.LocalizeFormattedMessage) then
	function v4:FormatMessageToSend(_, p)
		return p
	end
end

local function EnterTimeIntoLog(list) -- 1 equivalent call inferred from this helper
	table.insert(list, tick() + 15)
end

local function Run(object)
	local function FloodDetectionProcessCommandsFunction(p, _, p2): boolean
		if v3[p] then
			return false
		end

		local speaker = object:GetSpeaker(p)

		if not (speaker and speaker:GetPlayer()) then
			return false
		end

		if not v2[p] then
			v2[p] = {}
		end

		local v5

		if v then
			if not v2[p][p2] then
				v2[p][p2] = {}
			end

			v5 = v2[p][p2]
		else
			v5 = v2[p]
		end

		local now = tick()

		while #v5 > 0 and v5[1] < now do
			table.remove(v5, 1)
		end

		if #v5 < 7 then
			EnterTimeIntoLog(v5) -- inferred equivalent call
			return false
		end

		local v6 = math.ceil(v5[1] - now)

		speaker:SendSystemMessage(
			v4:FormatMessageToSend(
				"GameChat_ChatFloodDetector_MessageDisplaySeconds",
				string.format(
					"You must wait %d %s before sending another message!",
					v6,
					v6 > 1 and "seconds" or "second"
				),
				"RBX_NUMBER",
				(tostring(v6))
			),
			p2
		)

		return true
	end

	object:RegisterProcessCommandsFunction(
		"flood_detection",
		FloodDetectionProcessCommandsFunction,
		ChatConstants.LowPriority
	)

	object.SpeakerRemoved:connect(function(p)
		v2[p] = nil
	end)
end

return Run
