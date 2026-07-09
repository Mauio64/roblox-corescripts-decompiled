local ParentParent = script.Parent.Parent
local ReactRoblox = require(ParentParent.ReactRoblox)
local React = require(ParentParent.React)
local NotificationModalBase = require(script.Parent.Components.NotificationModalBase)
local u5 = nil
local t1 = {}

local function UpdateRoot(p1) -- line: 13
	-- upvalues: t1 (ref), u5 (ref), React (copy), NotificationModalBase (copy)
	if t1 and (t1.ModalKey ~= p1.ModalKey and t1.Params and t1.Params.CloseCallback) then
		t1.Params.CloseCallback()
	end

	t1 = p1
	u5:render(React.createElement(NotificationModalBase, p1))
end

return {
	OpenModal = function(s1: string, p2, p3) -- line: 28
		-- upvalues: u5 (ref), ReactRoblox (copy), t1 (ref), React (copy), NotificationModalBase (copy)
		if not u5 then
			local Folder = Instance.new("Folder")

			Folder.Name = "NotificationModals"
			Folder.Parent = game:GetService("CoreGui")
			u5 = ReactRoblox.createRoot(Folder)
		end

		local t3 = {
			ModalKey = s1,
			Component = p2,
			Params = p3,
			CloseModal = function() -- line: 40
				-- upvalues: s1 (copy), u5 (ref), t1 (ref), React (copy), NotificationModalBase (copy)
				local v16 = s1

				if u5 and v16 == t1.ModalKey then
					local t2 = {}

					if t1 and t1.ModalKey ~= t2.ModalKey and t1.Params and t1.Params.CloseCallback then
						t1.Params.CloseCallback()
					end

					t1 = t2
					u5:render(React.createElement(NotificationModalBase, t2))
				end
			end
		}

		if t1 and t1.ModalKey ~= t3.ModalKey and t1.Params and t1.Params.CloseCallback then
			t1.Params.CloseCallback()
		end

		t1 = t3
		u5:render(React.createElement(NotificationModalBase, t3))

		return true
	end,
	CloseModal = function(s2: string) -- line: 22
		-- upvalues: u5 (ref), t1 (ref), React (copy), NotificationModalBase (copy)
		if u5 and s2 == t1.ModalKey then
			local t4 = {}

			if t1 and t1.ModalKey ~= t4.ModalKey and t1.Params and t1.Params.CloseCallback then
				t1.Params.CloseCallback()
			end

			t1 = t4
			u5:render(React.createElement(NotificationModalBase, t4))
		end
	end
}
