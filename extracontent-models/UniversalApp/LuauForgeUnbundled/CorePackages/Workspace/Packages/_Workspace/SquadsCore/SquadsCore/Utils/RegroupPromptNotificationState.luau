local GuiService = game:GetService("GuiService")
local v5 = {}

local activeNotifId = nil
local activeSquadId = nil

function v5.setActive(p2, p3)
	activeNotifId = p2
	activeSquadId = p3
end

function v5.getActiveNotifId()
	return activeNotifId
end

function v5.getActiveSquadId()
	return activeSquadId
end

function v5.clearActive(p2)
	if p2 == nil or activeNotifId == p2 then
		activeNotifId = nil
		activeSquadId = nil
	end
end

function v5.dismissNotification(p2)
	if p2 == nil then
		return
	end

	pcall(function()
		GuiService:DismissNotification(p2)
	end)
	v5.clearActive(p2)
end

return v5
