require(script.Parent.Parent.BugReporterTypes)

local function formatBugReportContent(p1, n1: number) -- line: 5
	local v4 = p1.description or ""
	local v5 = not (n1 < #v4) and "" or "..."
	local v6 = string.sub(v4, 1, n1) .. v5
	local v7 = table.concat({
		v4,
		"\n",
		"*Metadata:*",
		`- User ID: { p1.userId }`,
		`- User Name: { p1.userDisplayName }`,
		`- Screen: { p1.additionalInfo.screen }`,
		`- Locale: { p1.additionalInfo.locale }`,
		`- Client Channel: { p1.additionalInfo.clientChannel }`,
		`- CoreScript Version: { p1.additionalInfo.coreScriptVersion }`,
		`- Manufacturer: { p1.systemInfo.manufacturer }`,
		`- Device Name: { p1.systemInfo.deviceName }`,
		`- OS: { p1.systemInfo.baseOs }`,
		`- System Version: { p1.systemInfo.systemVersion }`,
		`- App Version: { p1.systemInfo.appVersion }`,
		`- Network Type: { p1.systemInfo.networkType }`,
		"\n\n",
		p1.logUrl and `[Backtrace Device Log|{ p1.logUrl }]` or ""
	}, "\n")

	return {
		title = v6,
		description = v7
	}
end

return formatBugReportContent
