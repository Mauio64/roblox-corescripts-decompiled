local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationModalsManager/ReactRoblox")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationModalsManager/React")

local NotificationModalBase = require("@game/CorePackages/Workspace/Packages/_Index/NotificationModalsManager/NotificationModalsManager/Components/NotificationModalBase")

local v5 = nil
local v6 = {}

local function UpdateRoot(p2)
	if v6 and v6.ModalKey ~= p2.ModalKey and v6.Params and v6.Params.CloseCallback then
		v6.Params.CloseCallback()
	end

	v6 = p2
	v5:render(React.createElement(NotificationModalBase, p2))
end

return {
	OpenModal = function(p2, p3, p4): boolean
		if not v5 then
			local notificationModals = Instance.new("Folder")
			notificationModals.Name = "NotificationModals"
			notificationModals.Parent = game:GetService("CoreGui")
			v5 = ReactRoblox.createRoot(notificationModals)
		end

		local v7 = {
			ModalKey = p2,
			Component = p3,
			Params = p4,
			CloseModal = function()
				if v5 and p2 == v6.ModalKey then
					local v9 = {}

					if v6 and v6.ModalKey ~= v9.ModalKey and v6.Params and v6.Params.CloseCallback then
						v6.Params.CloseCallback()
					end

					v6 = v9
					v5:render(React.createElement(NotificationModalBase, v9))
				end
			end
		}

		if v6 and v6.ModalKey ~= v7.ModalKey and v6.Params and v6.Params.CloseCallback then
			v6.Params.CloseCallback()
		end

		v6 = v7
		v5:render(React.createElement(NotificationModalBase, v7))

		return true
	end,
	CloseModal = function(p2)
		if v5 and p2 == v6.ModalKey then
			local v7 = {}

			if v6 and v6.ModalKey ~= v7.ModalKey and v6.Params and v6.Params.CloseCallback then
				v6.Params.CloseCallback()
			end

			v6 = v7
			v5:render(React.createElement(NotificationModalBase, v7))
		end
	end
}
