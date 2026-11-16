local HttpService = game:GetService("HttpService")

local function getDeepLink(result)
	if typeof(result) ~= "table" or typeof(result.type) ~= "string" or string.lower(result.type) ~= "ads" then
		return nil
	end

	local universeId = result.universeId
	local v

	if typeof(universeId) == "number" or typeof(universeId) == "string" then
		v = tonumber(universeId)
	end

	if v == nil or v <= 0 or v % 1 ~= 0 then
		return nil
	end

	return `roblox://navigation/build?universeId={v}&type=ads`
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

			local success, result = pcall(HttpService.JSONDecode, HttpService, data.visualItem.actionEventParams)
			local v

			if success then
				v = getDeepLink(result)
			end

			if v ~= nil then
				callback2(data.notificationData.id)
				callback(v)
			end
		end)
	end
}
