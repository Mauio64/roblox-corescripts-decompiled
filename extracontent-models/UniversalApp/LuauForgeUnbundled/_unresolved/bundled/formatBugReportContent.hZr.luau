require("@luauforge/bundled/hZk")

local function formatBugReportContent(data, p2)
	local description = data.description or ""
	local v5 = p2 < #description and "..." or ""
	return {
		title = string.sub(description, 1, p2) .. v5,
		description = table.concat({
			description,
			"\n",
			"*Metadata:*",
			`- User ID: {data.userId}`,
			`- User Name: {data.userDisplayName}`,
			`- Screen: {data.additionalInfo.screen}`,
			`- Locale: {data.additionalInfo.locale}`,
			`- Client Channel: {data.additionalInfo.clientChannel}`,
			`- CoreScript Version: {data.additionalInfo.coreScriptVersion}`,
			`- Manufacturer: {data.systemInfo.manufacturer}`,
			`- Device Name: {data.systemInfo.deviceName}`,
			`- OS: {data.systemInfo.baseOs}`,
			`- System Version: {data.systemInfo.systemVersion}`,
			`- App Version: {data.systemInfo.appVersion}`,
			`- Network Type: {data.systemInfo.networkType}`,
			"\n\n",
			data.logUrl and `[Backtrace Device Log|{data.logUrl}]` or ""
		}, "\n")
	}
end

return formatBugReportContent
