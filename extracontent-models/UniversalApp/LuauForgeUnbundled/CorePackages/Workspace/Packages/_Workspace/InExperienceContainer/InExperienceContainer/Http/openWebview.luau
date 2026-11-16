local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local function openWebview(p2)
	local v5 = { FullScreen = 0, FormSheet = 2 }

	GuiService:BroadcastNotification(
		HttpService:JSONEncode({
			title = "",
			presentationStyle = 2,
			visible = true,
			url = p2
		}),
		20
	)
end

return openWebview
