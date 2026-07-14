local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local GuiService = game:GetService("GuiService")
local Signals = require(ParentParentParent.Signals)
local resolveDisplayName = require(ParentParent.Common.resolveDisplayName)
local getHeadshotThumbnail = require(ParentParent.Common.getHeadshotThumbnail)
local v7, v8 = Signals.createSignal(nil)
local u9 = v8
local v10, v11 = Signals.createSignal(nil)
local u12 = v10
local u13 = v11
local u14 = nil
local u15 = nil
local u16 = false
local n1 = 0

local function fallbackMenuData(p1, vector2: Vector2?) -- line: 102
	-- upvalues: GuiService (copy), n1 (ref), u13 (ref), u9 (ref), u15 (ref), resolveDisplayName (copy), getHeadshotThumbnail (copy)
	local t1 = {}

	if GuiService:GetInspectMenuEnabled() then
		table.insert(t1, {
			key = "examine",
			label = "Examine avatar",
			onActivated = function() -- line: 108
				-- upvalues: GuiService (copy), p1 (copy), n1 (ref), u13 (ref), u9 (ref), u15 (ref)
				GuiService:InspectPlayerFromUserIdWithCtx(p1.UserId, "leaderBoard")
				n1 += 1
				u13(nil)
				u9(nil)
				u13(nil)

				if u15 then
					u15()
				end
			end
		})
	end

	return {
		player = p1,
		header = {
			displayName = resolveDisplayName(p1),
			username = `@{ p1.Name }`,
			thumbnail = getHeadshotThumbnail(p1.UserId)
		},
		items = t1,
		anchorPosition = vector2
	}
end

return {
	getMenuData = v7,
	setMenuData = function(p2) -- line: 49
		-- upvalues: u13 (ref), u9 (ref)
		u13(nil)
		u9(p2)
	end,
	setMenuDataIfCurrent = function(p3, n2: number) -- line: 86
		-- upvalues: n1 (ref), u13 (ref), u9 (ref)
		if n2 ~= n1 then
			return false
		end

		u13(nil)
		u9(p3)

		return true
	end,
	openContextMenu = function(p4, vector2: Vector2?) -- line: 125
		-- upvalues: n1 (ref), u13 (ref), u14 (ref), fallbackMenuData (copy), u9 (ref)
		n1 += 1
		u13(nil)

		if u14 then
			u14(p4, vector2, n1)

			return
		end

		local v31 = fallbackMenuData(p4, vector2)

		u13(nil)
		u9(v31)
	end,
	closeContextMenu = function() -- line: 63
		-- upvalues: n1 (ref), u13 (ref), u9 (ref), u15 (ref)
		n1 += 1
		u13(nil)
		u9(nil)
		u13(nil)

		if u15 then
			u15()
		end
	end,
	setContextMenuOpener = function(p5: ((...any) -> ...any)?) -- line: 138
		-- upvalues: u14 (ref)
		u14 = p5
	end,
	setOnDismiss = function(p6: ((...any) -> ...any)?) -- line: 72
		-- upvalues: u15 (ref)
		u15 = p6
	end,
	setSuppressNextDismissRestore = function(b1: boolean) -- line: 76
		-- upvalues: u16 (ref)
		u16 = b1
	end,
	takeSuppressNextDismissRestore = function() -- line: 80
		-- upvalues: u16 (ref)
		local v22 = u16

		u16 = false

		return v22
	end,
	buildMenuHeader = function(p7) -- line: 94
		-- upvalues: resolveDisplayName (copy), getHeadshotThumbnail (copy)
		return {
			displayName = resolveDisplayName(p7),
			username = `@{ p7.Name }`,
			thumbnail = getHeadshotThumbnail(p7.UserId)
		}
	end,
	reset = function() -- line: 142
		-- upvalues: n1 (ref), u13 (ref), u9 (ref), u14 (ref), u15 (ref), u16 (ref)
		n1 += 1
		u13(nil)
		u9(nil)
		u13(nil)
		u14 = nil
		u15 = nil
		u16 = false
	end,
	getPendingConfirmKey = u12,
	activateMenuItem = function(t2: {[any]: any}) -- line: 151
		-- upvalues: u12 (ref), u13 (ref)
		if t2.requiresConfirm then
			if u12() == t2.key then
				u13(nil)

				if t2.onActivated then
					t2.onActivated()

					return
				end
			else
				u13(t2.key)
			end

			return
		end

		if u12() ~= nil then
			u13(nil)
		end

		if t2.onActivated then
			t2.onActivated()
		end
	end
}
