local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local llama = require(ParentParent.dependencies).llama

require(script.Parent.Parent.Types)

local toStringAdditionalArgs = require(script.Parent.toStringAdditionalArgs)
local getEventInfo = require(script.Parent.getEventInfo)
local optionallyLog = require(script.Parent.optionallyLog)
local isEnum = require(script.Parent.Parent.Parent.Utils.isEnum)
local Dash = require(ParentParentParent.Dash)

local function v9(p1, p2) -- line: 27
	-- upvalues: llama (copy)
	if not p1 or not p2 then
		return {}
	end

	return llama.Dictionary.map(p1, function(p3, p4) -- line: 32
		-- upvalues: p2 (copy), llama (copy)
		local v23 = p2[p4]

		if v23 then
			if type(v23) == "function" then
				return (v23(p3))
			end

			return p3
		end

		return llama.None
	end)
end
local function v10(t1: {[any]: any}) -- line: 42
	-- upvalues: toStringAdditionalArgs (copy)
	return string.format("context: (%s), eventName: (%s), additionalInfo: (%s)", t1.context, t1.eventType, toStringAdditionalArgs(t1.additionalInfo))
end
local function v11(p5, b1: boolean?) -- line: 51
	return function(t2: {[any]: any}) -- line: 52
		-- upvalues: b1 (copy), p5 (copy)
		if b1 then
			p5:sendEventDeferred(t2.context, t2.eventType, t2.additionalInfo)

			return t2
		end

		p5:setRBXEventStream(t2.context, t2.eventType, t2.additionalInfo)

		return t2
	end
end

return function(t3: {[any]: any}) -- line: 63
	-- upvalues: getEventInfo (copy), v11 (copy), Dash (copy), optionallyLog (copy), v10 (copy), llama (copy), isEnum (copy), v9 (copy)
	local v19 = getEventInfo(t3.eventList)

	return function(p6, p7) -- line: 73
		-- upvalues: v19 (copy), v11 (copy), t3 (copy), Dash (copy), optionallyLog (copy), v10 (copy), llama (copy), isEnum (copy), v9 (copy)
		local v27 = v19(p6)
		local _ = v11
		local v29 = if not t3.getInfoForAllEvents then t3.infoForAllEvents else t3.getInfoForAllEvents()
		local pipe = Dash.pipe
		local eventStreamImpl = t3.eventStreamImpl
		local shouldUseSendEventDeferred = t3.shouldUseSendEventDeferred
		local v33 = pipe(function(t4: {[any]: any}) -- line: 52
			-- upvalues: shouldUseSendEventDeferred (copy), eventStreamImpl (copy)
			if shouldUseSendEventDeferred then
				eventStreamImpl:sendEventDeferred(t4.context, t4.eventType, t4.additionalInfo)

				return t4
			end

			eventStreamImpl:setRBXEventStream(t4.context, t4.eventType, t4.additionalInfo)

			return t4
		end, optionallyLog(t3.loggerImpl, v10))
		local t5 = {
			context = v27.context,
			eventType = v27.eventType
		}
		local join = llama.Dictionary.join
		local v36 = v29 or {}
		local additionalInfo = v27.additionalInfo

		t5.additionalInfo = join(v36, llama.Dictionary.map(additionalInfo or {}, function(p8) -- line: 16
			-- upvalues: isEnum (copy)
			if isEnum(p8) then
				return p8.rawValue()
			end

			return p8
		end), v9(p7, v27.formatRulesForAdditionalInfo))
		v33(t5)

		return p6, p7
	end
end
