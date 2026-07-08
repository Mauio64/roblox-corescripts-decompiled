local ParentParent = script.Parent.Parent
local PlatformEnum = require(ParentParent.Enums.PlatformEnum)
local VRFTUXEventHandler = require(ParentParent.Events.VR.VRFTUXEventHandler)
local Events = require(ParentParent.Events.Events)
local t1 = {
	[PlatformEnum.QuestVR] = VRFTUXEventHandler
}

return {
	StartEvents = function(p1, n1: number, p2: ((...any) -> ...any)) -- line: 14
		-- upvalues: t1 (copy), Events (copy)
		local v9 = t1[p1]
		local v10 = Events[p1][n1]

		if v10 then
			for _, v in pairs(v10) do
				v9.StartEvent(v, p2)
			end
		end
	end,
	StopEvents = function(p3, n2: number) -- line: 25
		-- upvalues: t1 (copy), Events (copy)
		local v15 = t1[p3]
		local v16 = Events[p3][n2]

		if v16 then
			for _, v in pairs(v16) do
				v15.StopEvent(v)
			end
		end
	end
}
