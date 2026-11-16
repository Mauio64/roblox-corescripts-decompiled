local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Signals")
local FFlagShareSheetPeoplePickerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetPeoplePickerEnabled")
local fFlagShareSheetFriendsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SharedFlags").FFlagShareSheetFriendsSort
local RecipientSource = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/RecipientSource")
local ShareSheetTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/telemetry/ShareSheetTelemetry")

local function createUniversalShareSheetStore()
	local signal, v5 = Signals.createSignal(false)

	local signal2, v6 = Signals.createSignal(nil)

	local function hide(replaced)
		if FFlagShareSheetPeoplePickerEnabled then
			v5(false)
		end

		local v7 = signal2(false)

		if v7 == nil then
			return
		end

		v6(nil)
		local logLifecycle = ShareSheetTelemetry.logLifecycle
		local v8 = {
			context = v7.context,
			telemetryId = v7.telemetryId or "",
			lifecycleType = ShareSheetTelemetry.LifecycleType.Close,
			closeReason = replaced or ShareSheetTelemetry.CloseReason.Programmatic,
			recipientSource = 0
		}
		local v9 = if fFlagShareSheetFriendsSort then v7.recipientSource else nil
		v8.recipientSource = v9
		logLifecycle(v8)

		if v7.onHidden then
			v7.onHidden()
		end
	end

	local function show(data)
		if
			fFlagShareSheetFriendsSort
			and data.recipientSource ~= nil
			and not RecipientSource.isValidRecipientSource(data.recipientSource)
		then
			error(`Invalid recipient source {data.recipientSource}`)
		end

		hide(ShareSheetTelemetry.CloseReason.Replaced)
		v6(table.clone(data))
		local logLifecycle = ShareSheetTelemetry.logLifecycle
		local v7 = {
			context = data.context,
			telemetryId = data.telemetryId or "",
			lifecycleType = ShareSheetTelemetry.LifecycleType.Open,
			recipientSource = 0
		}
		local v8 = if fFlagShareSheetFriendsSort then data.recipientSource else nil
		v7.recipientSource = v8
		logLifecycle(v7)

		if data.onShown then
			data.onShown()
		end
	end

	return {
		getIsPeoplePickerDisplayed = signal,
		getRequest = signal2,
		setIsPeoplePickerDisplayed = v5,
		show = show,
		hide = hide
	}
end

return createUniversalShareSheetStore
