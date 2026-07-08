local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local function openWebview(s1: string) -- line: 5
	-- upvalues: HttpService (copy), GuiService (copy)
	local _ = {
		FullScreen = 0,
		FormSheet = 2
	}
	local json = HttpService:JSONEncode({
		title = "",
		presentationStyle = 2,
		visible = true,
		url = s1
	})

	GuiService:BroadcastNotification(json, 20)
end

return openWebview
