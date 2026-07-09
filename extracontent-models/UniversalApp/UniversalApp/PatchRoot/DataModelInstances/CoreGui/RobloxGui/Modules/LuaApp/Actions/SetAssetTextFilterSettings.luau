local Modules = game:GetService("CoreGui").RobloxGui.Modules

return require(Modules.Common.Action)(script.Name, function(s1: string, b1: boolean) -- line: 4
	return {
		universeId = s1,
		containsStrongLanguage = b1
	}
end)
