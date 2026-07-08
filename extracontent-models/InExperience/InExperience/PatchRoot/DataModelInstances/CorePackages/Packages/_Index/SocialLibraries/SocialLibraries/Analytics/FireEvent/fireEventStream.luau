local ParentParent = script.Parent.Parent.Parent
local llama = require(ParentParent.dependencies).llama

require(script.Parent.Types)

local toStringAdditionalArgs = require(script.Parent.toStringAdditionalArgs)
local getEventInfo = require(script.Parent.getEventInfo)
local optionallyLog = require(script.Parent.optionallyLog)
local compose = require(script.Parent.Parent.Parent.RoduxTools.compose)
local isEnum = require(script.Parent.Parent.Parent.Utils.isEnum)

local function v8(p1, p2) -- line: 22
	-- upvalues: llama (copy)
	if not p1 or not p2 then
		return {}
	end

	return llama.Dictionary.map(p1, function(p3, p4) -- line: 27
		-- upvalues: p2 (copy), llama (copy)
		local v20 = p2[p4]

		if v20 then
			if type(v20) == "function" then
				return (v20(p3))
			end

			return p3
		end

		return llama.None
	end)
end
local function v9(t1: {[any]: any}) -- line: 37
	-- upvalues: toStringAdditionalArgs (copy)
	return string.format("context: (%s), eventName: (%s), additionalInfo: (%s)", t1.context, t1.eventType, toStringAdditionalArgs(t1.additionalInfo))
end

return function(t2: {[any]: any}) -- line: 54
	-- upvalues: getEventInfo (copy), compose (copy), optionallyLog (copy), v9 (copy), llama (copy), isEnum (copy), v8 (copy)
	local v16 = getEventInfo(t2.eventList)

	return function(p5, p6) -- line: 64
		-- upvalues: v16 (copy), compose (copy), optionallyLog (copy), t2 (copy), v9 (copy), llama (copy), isEnum (copy), v8 (copy)
		local v24 = v16(p5)
		local v25 = compose
		local v26 = optionallyLog(t2.loggerImpl, v9)
		local eventStreamImpl = t2.eventStreamImpl
		local v28 = v25(v26, function(t3: {[any]: any}) -- line: 47
			-- upvalues: eventStreamImpl (copy)
			eventStreamImpl:setRBXEventStream(t3.context, t3.eventType, t3.additionalInfo)

			return t3
		end)
		local t4 = {
			context = v24.context.rawValue(),
			eventType = v24.eventType.rawValue()
		}
		local join = llama.Dictionary.join
		local v31 = t2.infoForAllEvents or {}
		local additionalInfo = v24.additionalInfo

		t4.additionalInfo = join(v31, llama.Dictionary.map(additionalInfo or {}, function(p7) -- line: 13
			-- upvalues: isEnum (copy)
			if isEnum(p7) then
				return p7.rawValue()
			end

			return p7
		end), v8(p6, v24.formatRulesForAdditionalInfo))
		v28(t4)

		return p5, p6
	end
end
