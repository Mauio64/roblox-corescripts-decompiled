local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dVn")

return function(callback, p2)
	return callback(module.NOTIFICATION_URL .. "v2/notifications/notification-preferences", "POST", {
		postBody = HttpService:JSONEncode({
			updatedPreferences = {
				{
					notificationType = "PromotionalEmails",
					notificationChannel = "Email",
					preferenceStatus = p2 and "Personalized" or "None"
				}
			}
		})
	}):catch(function() end)
end
