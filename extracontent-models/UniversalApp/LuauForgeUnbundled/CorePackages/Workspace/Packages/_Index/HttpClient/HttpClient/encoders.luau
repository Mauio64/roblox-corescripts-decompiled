local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/types")

return {
	encodeJson = function(p2)
		return HttpService:JSONEncode(p2), "application/json"
	end,
	encodeRaw = function(p2)
		return function(p3)
			local typeName = typeof(p3)

			if typeName ~= "string" and typeName ~= "buffer" then
				error(`encodeRaw: expected string or buffer body, got {typeName}`)
			end

			return p3, p2
		end
	end
}
