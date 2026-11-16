local CloudClientOffer = script:FindFirstAncestor("CloudClientOffer")

require(CloudClientOffer.createCloudClientOffer)

return {
	RobloxReality = {
		title = "Try Roblox Reality",
		body = "Roblox Reality gives your favorite games a fresh look. Try an early preview, then tell us what you think.",
		features = { "15 minute demo", "Graphics that look like real life", "Only for Plus subscribers" },
		accept = "Play",
		decline = "Play without Roblox Reality"
	},
	CloudPlay = {
		title = "Play with Cloud Play",
		body = "Cloud Play runs the game on Roblox's computers, so it may load faster and have fewer crashes. It only lasts while you're playing this game.",
		features = {},
		accept = "Play",
		decline = "Play without Cloud Play"
	}
}
