local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local function openWebview(url: string)
	local _ = { FullScreen = 0, FormSheet = 2 }

	GuiService:BroadcastNotification(
		HttpService:JSONEncode({ title = "", presentationStyle = 2, visible = true, url = url }),
		20
	)
end

return openWebview
