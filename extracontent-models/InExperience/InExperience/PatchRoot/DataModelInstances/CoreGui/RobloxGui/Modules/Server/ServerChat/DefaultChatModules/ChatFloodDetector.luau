local ClientChatModules = game:GetService("Chat"):WaitForChild("ClientChatModules")
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))
local v3 = false
local ok, result = pcall(function() -- line: 11
	return UserSettings():IsUserFeatureEnabled("UserAddChatThrottlingToAllChannels")
end)

if ok then
	v3 = result
end

local u6 = true

if v3 then
	u6 = false
end

local t1 = {}
local t2 = {}
local ChatLocalization = nil

pcall(function() -- line: 33
	-- upvalues: ChatLocalization (ref)
	ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization)
end)

if ChatLocalization == nil then
	ChatLocalization = {}
end

if not ChatLocalization.FormatMessageToSend or not ChatLocalization.LocalizeFormattedMessage then
	function ChatLocalization.FormatMessageToSend(_, _, p3) -- line: 37
		return p3
	end
end

local function EnterTimeIntoLog(p4) -- line: 40
	table.insert(p4, tick() + 15)
end
local function Run(p5) -- line: 44
	-- upvalues: t2 (copy), t1 (copy), u6 (ref), ChatLocalization (ref), ChatConstants (copy)
	local function FloodDetectionProcessCommandsFunction(p6, _, p8) -- line: 45
		-- upvalues: t2 (copy), p5 (copy), t1 (copy), u6 (ref), ChatLocalization (ref)
		if t2[p6] then
			return false
		end

		local Speaker = p5:GetSpeaker(p6)

		if not Speaker then
			return false
		end

		if not Speaker:GetPlayer() then
			return false
		end

		if not t1[p6] then
			t1[p6] = {}
		end

		local v22

		if u6 then
			if not t1[p6][p8] then
				t1[p6][p8] = {}
			end

			v22 = t1[p6][p8]
		else
			v22 = t1[p6]
		end

		local timestamp = tick()

		while #v22 > 0 and timestamp > v22[1] do
			table.remove(v22, 1)
		end

		if #v22 < 7 then
			table.insert(v22, tick() + 15)

			return false
		end

		local v24 = math.ceil(v22[1] - timestamp)

		Speaker:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatFloodDetector_MessageDisplaySeconds", string.format("You must wait %d %s before sending another message!", v24, not (v24 > 1) and "second" or "seconds"), "RBX_NUMBER", (tostring(v24))), p8)

		return true
	end

	p5:RegisterProcessCommandsFunction("flood_detection", FloodDetectionProcessCommandsFunction, ChatConstants.LowPriority)
	p5.SpeakerRemoved:connect(function(p9) -- line: 102
		-- upvalues: t1 (copy)
		t1[p9] = nil
	end)
end

return Run
