local HttpService = game:GetService("HttpService")

local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, p2)
	return callback(Url.NOTIFICATION_URL .. "v2/notifications/notification-preferences", "POST", {
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
