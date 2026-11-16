return {
	eventName = "appChatKeyStrokes",
	backends = { require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LoggingProtocol").TelemetryBackends.EventIngest },
	throttlingPercentage = 10000,
	lastUpdated = { 24, 5, 20 },
	description = "Tracks keystroke data for the chat conversation screen",
	links = "https://docs.google.com/document/d/1CIP98uWhheThwiGBioCeXJ_WDmnym5D-zmUe5cNxOJ0/edit?tab=t.0#heading=h.q5oxzu9wbzz6"
}
