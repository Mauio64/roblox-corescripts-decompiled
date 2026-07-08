local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent.Parent
local v3, v4 = require(ParentParent.Signals).createSignal("")

return {
	Get = function(_) -- line: 15
		-- upvalues: v3 (copy), HttpService (copy), v4 (copy)
		local v6 = v3(false)

		if v6 == "" then
			v6 = HttpService:GenerateGUID(false)
			v4(v6)
		end

		return v6
	end,
	Refresh = function(_) -- line: 24
		-- upvalues: HttpService (copy), v4 (copy)
		local guid = HttpService:GenerateGUID(false)

		v4(guid)

		return guid
	end,
	GetSignal = function(_) -- line: 30
		-- upvalues: v3 (copy)
		return v3
	end
}
