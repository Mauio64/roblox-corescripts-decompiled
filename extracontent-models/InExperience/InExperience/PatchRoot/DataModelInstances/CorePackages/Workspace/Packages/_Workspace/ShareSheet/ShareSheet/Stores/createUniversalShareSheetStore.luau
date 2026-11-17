local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local Signals = require(parent.Signals)
local RecipientSource = require(ShareSheet.Recipients.RecipientSource)
local ShareSheetTelemetry = require(ShareSheet.telemetry.ShareSheetTelemetry)

local function createUniversalShareSheetStore()
	local signal, setIsPeoplePickerDisplayed = Signals.createSignal(false)

	local signal2, v = Signals.createSignal(nil)

	local function hide(replaced)
		setIsPeoplePickerDisplayed(false)
		local v2 = signal2(false)

		if v2 == nil then
			return
		end

		v(nil)
		ShareSheetTelemetry.logLifecycle({
			context = v2.context,
			telemetryId = v2.telemetryId or "",
			lifecycleType = ShareSheetTelemetry.LifecycleType.Close,
			closeReason = replaced or ShareSheetTelemetry.CloseReason.Programmatic,
			recipientSource = v2.recipientSource
		})

		if v2.onHidden then
			v2.onHidden()
		end
	end

	local function show(data)
		if data.recipientSource ~= nil and not RecipientSource.isValidRecipientSource(data.recipientSource) then
			error(`Invalid recipient source {data.recipientSource}`)
		end

		hide(ShareSheetTelemetry.CloseReason.Replaced)
		v(table.clone(data))
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
		setIsPeoplePickerDisplayed = setIsPeoplePickerDisplayed,
		show = show,
		hide = hide
	}
end

return createUniversalShareSheetStore
