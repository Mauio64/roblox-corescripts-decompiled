local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Signals")
local RecipientSource = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/RecipientSource")
local ShareSheetTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/telemetry/ShareSheetTelemetry")

local function createUniversalShareSheetStore()
	local signal, v5 = Signals.createSignal(false)

	local signal2, v6 = Signals.createSignal(nil)

	local function hide(replaced)
		v5(false)
		local v7 = signal2(false)

		if v7 == nil then
			return
		end

		v6(nil)
		ShareSheetTelemetry.logLifecycle({
			context = v7.context,
			telemetryId = v7.telemetryId or "",
			lifecycleType = ShareSheetTelemetry.LifecycleType.Close,
			closeReason = replaced or ShareSheetTelemetry.CloseReason.Programmatic,
			recipientSource = v7.recipientSource
		})

		if v7.onHidden then
			v7.onHidden()
		end
	end

	local function show(data)
		if data.recipientSource ~= nil and not RecipientSource.isValidRecipientSource(data.recipientSource) then
			error(`Invalid recipient source {data.recipientSource}`)
		end

		hide(ShareSheetTelemetry.CloseReason.Replaced)
		v6(table.clone(data))
		ShareSheetTelemetry.logLifecycle({
			context = data.context,
			telemetryId = data.telemetryId or "",
			lifecycleType = ShareSheetTelemetry.LifecycleType.Open,
			recipientSource = data.recipientSource
		})

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
