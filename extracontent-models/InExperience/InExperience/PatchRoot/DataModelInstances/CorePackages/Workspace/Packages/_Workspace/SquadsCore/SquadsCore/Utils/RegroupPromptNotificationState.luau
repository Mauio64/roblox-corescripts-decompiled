local GuiService = game:GetService("GuiService")
local RegroupPromptNotificationState = {}

local activeNotifId = nil
local activeSquadId = nil

function RegroupPromptNotificationState.setActive(p, p2: string?)
	activeNotifId = p
	activeSquadId = p2
end

function RegroupPromptNotificationState.getActiveNotifId()
	return activeNotifId
end

function RegroupPromptNotificationState.getActiveSquadId()
	return activeSquadId
end

function RegroupPromptNotificationState.clearActive(p)
	if p == nil or activeNotifId == p then
		activeNotifId = nil
		activeSquadId = nil
	end
end

function RegroupPromptNotificationState.dismissNotification(p)
	if p == nil then
		return
	end

	pcall(function()
		GuiService:DismissNotification(p)
	end)
	RegroupPromptNotificationState.clearActive(p)
end

return RegroupPromptNotificationState
