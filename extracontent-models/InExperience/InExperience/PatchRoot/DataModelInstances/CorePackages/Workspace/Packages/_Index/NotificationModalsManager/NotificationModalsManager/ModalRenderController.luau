local parent = script.Parent.Parent
local ReactRoblox = require(parent.ReactRoblox)
local React = require(parent.React)

local NotificationModalBase = require(script.Parent.Components.NotificationModalBase)

local v = nil
local v2 = {}

local function UpdateRoot(p) -- 3 equivalent calls inferred from this helper
	if v2 and v2.ModalKey ~= p.ModalKey and v2.Params and v2.Params.CloseCallback then
		v2.Params.CloseCallback()
	end

	v2 = p
	v:render(React.createElement(NotificationModalBase, p))
end

local ModalRenderController = {}

function ModalRenderController.OpenModal(modalKey: string, component, params): boolean
	if not v then
		local notificationModals = Instance.new("Folder")
		notificationModals.Name = "NotificationModals"
		notificationModals.Parent = game:GetService("CoreGui")
		v = ReactRoblox.createRoot(notificationModals)
	end

	UpdateRoot({ -- inferred equivalent call
		ModalKey = modalKey,
		Component = component,
		Params = params,
		CloseModal = function()
			if v and modalKey == v2.ModalKey then
				UpdateRoot({}) -- inferred equivalent call
			end
		end
	})

	return true
end

function ModalRenderController.CloseModal(p: string)
	if v and p == v2.ModalKey then
		UpdateRoot({}) -- inferred equivalent call
	end
end

return ModalRenderController
