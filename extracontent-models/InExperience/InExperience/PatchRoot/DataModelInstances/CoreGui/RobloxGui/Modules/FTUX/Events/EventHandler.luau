local parent = script.Parent.Parent
local PlatformEnum = require(parent.Enums.PlatformEnum)
local VRFTUXEventHandler = require(parent.Events.VR.VRFTUXEventHandler)
local Events = require(parent.Events.Events)

local VRFTUXEventHandlersByQuestVR = { [PlatformEnum.QuestVR] = VRFTUXEventHandler }
local EventHandler = {}

function EventHandler.StartEvents(p, p2: number, callback)
	local v = VRFTUXEventHandlersByQuestVR[p]

	local v2 = Events[p][p2]

	if v2 then
		for _, v3 in pairs(v2) do
			v.StartEvent(v3, callback)
		end
	end
end

function EventHandler.StopEvents(p, p2: number)
	local v = VRFTUXEventHandlersByQuestVR[p]

	local v2 = Events[p][p2]

	if v2 then
		for _, v3 in pairs(v2) do
			v.StopEvent(v3)
		end
	end
end

return EventHandler
