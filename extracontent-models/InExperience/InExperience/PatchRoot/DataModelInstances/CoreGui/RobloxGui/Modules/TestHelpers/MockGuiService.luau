local MockGuiService = {}
MockGuiService.__index = MockGuiService

function MockGuiService.new()
	local bindableEvent = Instance.new("BindableEvent")

	local v = {
		broadcasts = {},
		NativeClose = {
			Connect = function(self, onEvent)
				return bindableEvent.Event:Connect(onEvent)
			end
		},
		MenuIsOpen = false,
		openedMenus = {}
	}

	setmetatable(v, { __index = MockGuiService })

	return v
end

function MockGuiService:SetMenuIsOpen(p, p2)
	if p then
		table.insert(self.openedMenus, p2)
	else
		local index = table.find(self.openedMenus, p2)

		if index then
			table.remove(self.openedMenus, index)
		end
	end

	self.MenuIsOpen = #self.openedMenus > 0
end

function MockGuiService.BroadcastNotification(p, p2, notification)
	table.insert(p.broadcasts, { data = p2, notification = notification })
end

function MockGuiService.GetNotificationTypeList(_)
	return { NATIVE_EXIT = 35, RESTART_APP = 41 }
end

return MockGuiService
