local parent = script.Parent.Parent
local parent2 = parent.Parent

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local Signals = require(parent2.Signals)
local resolveDisplayName = require(parent.Common.resolveDisplayName)
local getHeadshotThumbnail = require(parent.Common.getHeadshotThumbnail)
require(script.Parent.PlayerListContextMenuTelemetryAction)

local contextMenuTelemetry = nil
local function getContextMenuTelemetry() -- 3 equivalent calls inferred from this helper
	if contextMenuTelemetry == nil then
		local PlayerListContextMenuTelemetry = require(script.Parent.PlayerListContextMenuTelemetry)
		contextMenuTelemetry = PlayerListContextMenuTelemetry
	end

	return contextMenuTelemetry
end

local signal, v = Signals.createSignal(nil)

local signal2, v2 = Signals.createSignal(nil)

local v3 = {}
local count = 0

local function consumeOnceGroup(onceGroup: string) -- 2 equivalent calls inferred from this helper
	count += 1
	local v4 = count
	v3[onceGroup] = v4
	task.delay(5, function()
		if v3[onceGroup] == v4 then
			v3[onceGroup] = nil
		end
	end)
end

local function setMenuData(p)
	local v4

	if p == nil then
		v4 = false
	else
		v4 = signal(false) == nil
	end

	v2(nil)
	table.clear(v3)
	v(p)

	if v4 then
		getContextMenuTelemetry().logAction("menu_open", p.telemetry) -- inferred equivalent call
	end
end

local v4 = nil
local v5 = nil
local v6 = false

local count2 = 0

local function closeContextMenu()
	local v7 = signal(false)
	count2 += 1
	v2(nil)

	if v7 == nil then
		return
	end

	getContextMenuTelemetry().logAction("menu_close", v7.telemetry) -- inferred equivalent call
	v2(nil)
	table.clear(v3)
	v(nil)

	if v5 then
		v5()
	end
end

local function setOnDismiss(callback)
	v5 = callback
end

local function setSuppressNextDismissRestore(flag: boolean)
	v6 = flag
end

local function takeSuppressNextDismissRestore()
	local v7 = v6
	v6 = false
	return v7
end

local function setMenuDataIfCurrent(p, p2: number): boolean
	if p2 ~= count2 then
		return false
	end

	setMenuData(p)
	return true
end

local function buildMenuHeader(p) -- 1 equivalent call inferred from this helper
	return {
		displayName = resolveDisplayName(p),
		username = `@{p.Name}`,
		thumbnail = getHeadshotThumbnail(p.UserId)
	}
end

local function fallbackMenuData(player, anchorPosition: Vector2?)
	local items = {}

	if GuiService:GetInspectMenuEnabled() then
		table.insert(items, {
			key = "examine",
			label = "Examine avatar",
			telemetryAction = "avatar_examine",
			onActivated = function()
				GuiService:InspectPlayerFromUserIdWithCtx(player.UserId, "leaderBoard")
				closeContextMenu()
			end
		})
	end

	local localPlayer = Players.LocalPlayer
	return {
		player = player,
		header = buildMenuHeader(player), -- inferred equivalent call
		items = items,
		anchorPosition = anchorPosition,
		telemetry = {
			isSelf = localPlayer ~= nil and player == localPlayer
		}
	}
end

local function openContextMenu(player, anchorPosition: Vector2?, p) -- 1 equivalent call inferred from this helper
	count2 += 1

	v2(nil)

	if v4 then
		v4(player, anchorPosition, count2, p)
	else
		setMenuData(fallbackMenuData(player, anchorPosition))
	end
end

local v7 = nil
local v8 = nil

local function getAnchorRow()
	local v9 = signal(false)
	return if not (v9 == nil or v9.player ~= v8) then v7 else nil
end

local function toggleContextMenu(p, vector2: Vector2?, p2)
	local v9 = signal(false)

	if v9 ~= nil and v9.player == p then
		closeContextMenu()
		return
	end

	v8 = p
	v7 = p2
	openContextMenu(p, vector2) -- inferred equivalent call
end

local function setContextMenuOpener(callback)
	v4 = callback
end

local function reset()
	count2 += 1
	v2(nil)
	table.clear(v3)
	v(nil)

	v2(nil)
	v4 = nil
	v5 = nil
	v6 = false
	v7 = nil
	v8 = nil
end

local function logItemActivated(data) -- 2 equivalent calls inferred from this helper
	if data.telemetryAction ~= nil then
		local v9 = signal(false)
		getContextMenuTelemetry().logAction(data.telemetryAction, v9 and v9.telemetry) -- inferred equivalent call
	end
end

local function activateMenuItem(data)
	if data.onceGroup ~= nil and v3[data.onceGroup] ~= nil then
		return
	end

	if data.requiresConfirm then
		if signal2() == data.key then
			if data.onceGroup ~= nil then
				consumeOnceGroup(data.onceGroup) -- inferred equivalent call
			end

			v2(nil)
			logItemActivated(data) -- inferred equivalent call

			if data.onActivated then
				data.onActivated()
			end
		else
			v2(data.key)
		end
	else
		if signal2() ~= nil then
			v2(nil)
		end

		if data.onceGroup ~= nil then
			consumeOnceGroup(data.onceGroup) -- inferred equivalent call
		end

		logItemActivated(data) -- inferred equivalent call

		if data.onActivated then
			data.onActivated()
		end
	end
end

return {
	getMenuData = signal,
	setMenuData = setMenuData,
	setMenuDataIfCurrent = setMenuDataIfCurrent,
	openContextMenu = openContextMenu,
	toggleContextMenu = toggleContextMenu,
	getAnchorRow = getAnchorRow,
	closeContextMenu = closeContextMenu,
	setContextMenuOpener = setContextMenuOpener,
	setOnDismiss = setOnDismiss,
	setSuppressNextDismissRestore = setSuppressNextDismissRestore,
	takeSuppressNextDismissRestore = takeSuppressNextDismissRestore,
	buildMenuHeader = buildMenuHeader,
	reset = reset,
	getPendingConfirmKey = signal2,
	activateMenuItem = activateMenuItem
}
