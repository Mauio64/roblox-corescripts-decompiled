local SduiActionParams = {}

function SduiActionParams.getStringParam(p, p2: string, p3: string?)
	local v = p[p2]
	return if typeof(v) == "string" then v else p3
end

function SduiActionParams.getBooleanParam(p, p2: string, flag: boolean)
	local v = p[p2]
	return if typeof(v) == "boolean" then v else flag
end

function SduiActionParams.getCallbackParam(p, p2: string, callback)
	local v = p[p2]

	if typeof(v) == "function" then
		return function()
			v()
		end
	end

	return callback
end

return SduiActionParams
