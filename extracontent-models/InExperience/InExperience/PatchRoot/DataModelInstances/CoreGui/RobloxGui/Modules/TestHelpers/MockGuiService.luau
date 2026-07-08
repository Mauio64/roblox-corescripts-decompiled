local t1 = {}

t1.__index = t1

function t1.new() -- line: 4
	-- upvalues: t1 (copy)
	local BindableEvent = Instance.new("BindableEvent")
	local t2 = {
		MenuIsOpen = false,
		broadcasts = {},
		NativeClose = {
			Connect = function(_, p2) -- line: 10
				-- upvalues: BindableEvent (copy)
				return BindableEvent.Event:Connect(p2)
			end
		},
		openedMenus = {}
	}

	setmetatable(t2, {
		__index = t1
	})

	return t2
end
function t1.SetMenuIsOpen(p3, p4, p5) -- line: 23
	if p4 then
		table.insert(p3.openedMenus, p5)
	else
		local v7 = table.find(p3.openedMenus, p5)

		if v7 then
			table.remove(p3.openedMenus, v7)
		end
	end

	p3.MenuIsOpen = #p3.openedMenus > 0
end
function t1.BroadcastNotification(p6, p7, p8) -- line: 36
	table.insert(p6.broadcasts, {
		data = p7,
		notification = p8
	})
end
function t1.GetNotificationTypeList(_) -- line: 45
	return {
		NATIVE_EXIT = 35,
		RESTART_APP = 41
	}
end

return t1
