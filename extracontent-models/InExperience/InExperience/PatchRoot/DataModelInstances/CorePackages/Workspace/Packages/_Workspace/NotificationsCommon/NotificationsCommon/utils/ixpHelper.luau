local IXPService = game:GetService("IXPService")

return {
	getIxpLayerData = function(s1: string) -- line: 3
		-- upvalues: IXPService (copy)
		local ok, result = pcall(function() -- line: 4
			-- upvalues: IXPService (copy), s1 (copy)
			return IXPService:GetUserLayerVariables(s1)
		end)

		return ok and result or nil
	end,
	logUserLayerExposure = function(s2: string) -- line: 11
		-- upvalues: IXPService (copy)
		pcall(function() -- line: 12
			-- upvalues: IXPService (copy), s2 (copy)
			IXPService:LogUserLayerExposure(s2)
		end)
	end
}
