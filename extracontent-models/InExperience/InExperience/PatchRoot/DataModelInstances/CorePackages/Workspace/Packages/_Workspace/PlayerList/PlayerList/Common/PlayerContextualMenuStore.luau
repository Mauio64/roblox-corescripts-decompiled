local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local GuiService = game:GetService("GuiService")
local Signals = require(ParentParentParent.Signals)
local resolveDisplayName = require(ParentParent.Common.resolveDisplayName)
local getHeadshotThumbnail = require(ParentParent.Common.getHeadshotThumbnail)
local v7, v8 = Signals.createSignal(nil)
local u9 = v8
local u10 = nil
local u11 = nil
local n1 = 0

local function fallbackMenuData(p1, vector2: Vector2?) -- line: 82
	-- upvalues: GuiService (copy), n1 (ref), u9 (ref), u11 (ref), resolveDisplayName (copy), getHeadshotThumbnail (copy)
	local t1 = {}

	if GuiService:GetInspectMenuEnabled() then
		table.insert(t1, {
			key = "examine",
			label = "Examine avatar",
			onActivated = function() -- line: 88
				-- upvalues: GuiService (copy), p1 (copy), n1 (ref), u9 (ref), u11 (ref)
				GuiService:InspectPlayerFromUserIdWithCtx(p1.UserId, "leaderBoard")
				n1 += 1
				u9(nil)

				if u11 then
					u11()
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
	setMenuData = u9,
	setMenuDataIfCurrent = function(p2, n2: number) -- line: 63
		-- upvalues: n1 (ref), u9 (ref)
		if n2 ~= n1 then
			return false
		end

		u9(p2)

		return true
	end,
	openContextMenu = function(p3, vector2: Vector2?) -- line: 105
		-- upvalues: n1 (ref), u10 (ref), u9 (ref), fallbackMenuData (copy)
		n1 += 1

		if u10 then
			u10(p3, vector2, n1)

			return
		end

		u9((fallbackMenuData(p3, vector2)))
	end,
	closeContextMenu = function() -- line: 48
		-- upvalues: n1 (ref), u9 (ref), u11 (ref)
		n1 += 1
		u9(nil)

		if u11 then
			u11()
		end
	end,
	setContextMenuOpener = function(p4: ((...any) -> ...any)?) -- line: 115
		-- upvalues: u10 (ref)
		u10 = p4
	end,
	setOnDismiss = function(p5: ((...any) -> ...any)?) -- line: 56
		-- upvalues: u11 (ref)
		u11 = p5
	end,
	buildMenuHeader = function(p6) -- line: 74
		-- upvalues: resolveDisplayName (copy), getHeadshotThumbnail (copy)
		return {
			displayName = resolveDisplayName(p6),
			username = `@{ p6.Name }`,
			thumbnail = getHeadshotThumbnail(p6.UserId)
		}
	end,
	reset = function() -- line: 119
		-- upvalues: n1 (ref), u9 (ref), u10 (ref), u11 (ref)
		n1 += 1
		u9(nil)
		u10 = nil
		u11 = nil
	end
}
