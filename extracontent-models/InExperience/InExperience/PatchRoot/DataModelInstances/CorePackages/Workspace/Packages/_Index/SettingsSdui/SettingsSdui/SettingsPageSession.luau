local HttpService = game:GetService("HttpService")

local v = ""
local SettingsPageSession = {}

function SettingsPageSession.Get(_)
	if v == "" then
		v = HttpService:GenerateGUID(false)
	end

	return v
end

function SettingsPageSession.Refresh(_)
	v = HttpService:GenerateGUID(false)
	return v
end

return SettingsPageSession
