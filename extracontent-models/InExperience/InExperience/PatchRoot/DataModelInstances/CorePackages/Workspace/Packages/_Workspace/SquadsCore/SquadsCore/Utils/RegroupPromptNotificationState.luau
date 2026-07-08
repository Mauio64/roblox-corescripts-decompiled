local GuiService = game:GetService("GuiService")
local t1 = {}
local u3 = nil
local u4 = nil

function t1.setActive(p1, s1: string?) -- line: 7
	-- upvalues: u3 (ref), u4 (ref)
	u3 = p1
	u4 = s1
end
function t1.getActiveNotifId() -- line: 12
	-- upvalues: u3 (ref)
	return u3
end
function t1.getActiveSquadId() -- line: 16
	-- upvalues: u4 (ref)
	return u4
end
function t1.clearActive(p2) -- line: 20
	-- upvalues: u3 (ref), u4 (ref)
	if p2 == nil or p2 == u3 then
		u3 = nil
		u4 = nil
	end
end
function t1.dismissNotification(p3) -- line: 27
	-- upvalues: GuiService (copy), t1 (copy)
	if p3 == nil then
		return
	end

	pcall(function() -- line: 31
		-- upvalues: GuiService (copy), p3 (copy)
		GuiService:DismissNotification(p3)
	end)
	t1.clearActive(p3)
end

return t1
