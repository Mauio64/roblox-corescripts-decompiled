local HttpService = game:GetService("HttpService")

local function getDeepLink(result)
	if
		typeof(result) ~= "table"
		or typeof(result.type) ~= "string"
		or string.lower(result.type) ~= "ads"
	then
		return nil
	end

	local universeId = result.universeId
	local v5

	if typeof(universeId) == "number" or typeof(universeId) == "string" then
		v5 = tonumber(universeId)
	end

	if v5 == nil or v5 <= 0 or v5 % 1 ~= 0 then
		return nil
	end

	return `roblox://navigation/build?universeId={v5}&type=ads`
end

return {
	NotificationType = "BuildAdsCampaign",
	EventName = "BuildAdsCampaign",
	getDeepLink = getDeepLink,
	connect = function(object, callback, callback2)
		return object:RegisterCallback(object.ToastEvents.UserAction, "BuildAdsCampaign", function(data)
			if
				typeof(data) ~= "table"
				or data.userActionType ~= "click"
				or typeof(data.visualItem) ~= "table"
				or data.visualItem.eventName ~= "BuildAdsCampaign"
				or typeof(data.visualItem.actionEventParams) ~= "string"
				or typeof(data.notificationData) ~= "table"
				or typeof(data.notificationData.id) ~= "string"
			then
				return
			end

			local success, result = pcall(
				HttpService.JSONDecode,
				HttpService,
				data.visualItem.actionEventParams
			)
			local v5 = if success then getDeepLink(result) else nil

			if v5 ~= nil then
				callback2(data.notificationData.id)
				callback(v5)
			end
		end)
	end
}
