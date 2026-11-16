local HttpService = game:GetService("HttpService")

require(script.Parent.types)
local Encoders = {}

function Encoders.encodeJson(p)
	return HttpService:JSONEncode(p), "application/json"
end

function Encoders.encodeRaw(p: string)
	return function(p2)
		local typeName = typeof(p2)

		if typeName ~= "string" and typeName ~= "buffer" then
			error(`encodeRaw: expected string or buffer body, got {typeName}`)
		end

		return p2, p
	end
end

return Encoders
