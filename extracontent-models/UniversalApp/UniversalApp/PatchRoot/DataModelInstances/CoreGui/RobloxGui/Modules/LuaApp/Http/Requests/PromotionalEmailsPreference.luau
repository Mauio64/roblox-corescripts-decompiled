local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2) -- line: 14
	-- upvalues: Url (copy), HttpService (copy)
	local v6 = Url.NOTIFICATION_URL .. "v2/notifications/notification-preferences"
	local s1 = "None"

	if p2 then
		s1 = "Personalized"
	end

	local t1 = {
		notificationType = "PromotionalEmails",
		notificationChannel = "Email",
		preferenceStatus = s1
	}

	return p1(v6, "POST", {
		postBody = HttpService:JSONEncode({
			updatedPreferences = { t1 }
		})
	}):catch(function() -- line: 34
	end)
end
