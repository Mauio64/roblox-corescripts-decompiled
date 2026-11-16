local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local Signals = require(parent.Signals)
local FFlagShareSheetPeoplePickerEnabled = require(ShareSheet.Flags.FFlagShareSheetPeoplePickerEnabled)
local SharedFlags = require(parent.SharedFlags)
local FFlagShareSheetFriendsSort = SharedFlags.FFlagShareSheetFriendsSort
local RecipientSource = require(ShareSheet.Recipients.RecipientSource)
local ShareSheetTelemetry = require(ShareSheet.telemetry.ShareSheetTelemetry)

local function createUniversalShareSheetStore()
	local signal, setIsPeoplePickerDisplayed = Signals.createSignal(false)

	local signal2, v = Signals.createSignal(nil)

	local function hide(replaced)
		if FFlagShareSheetPeoplePickerEnabled then
			setIsPeoplePickerDisplayed(false)
		end

		local v2 = signal2(false)

		if v2 == nil then
			return
		end

		v(nil)
		local logLifecycle = ShareSheetTelemetry.logLifecycle
		local v3 = {
			context = v2.context,
			telemetryId = v2.telemetryId or "",
			lifecycleType = ShareSheetTelemetry.LifecycleType.Close,
			closeReason = replaced or ShareSheetTelemetry.CloseReason.Programmatic,
			recipientSource = 0
		}
		local recipientSource

		if FFlagShareSheetFriendsSort then
			recipientSource = v2.recipientSource
		end

		v3.recipientSource = recipientSource
		logLifecycle(v3)

		if v2.onHidden then
			v2.onHidden()
		end
	end

	local function show(data)
		if
			FFlagShareSheetFriendsSort
			and data.recipientSource ~= nil
			and not RecipientSource.isValidRecipientSource(data.recipientSource)
		then
			error(`Invalid recipient source {data.recipientSource}`)
		end

		hide(ShareSheetTelemetry.CloseReason.Replaced)
		v(table.clone(data))
		local logLifecycle = ShareSheetTelemetry.logLifecycle
		local v2 = {
			context = data.context,
			telemetryId = data.telemetryId or "",
			lifecycleType = ShareSheetTelemetry.LifecycleType.Open,
			recipientSource = 0
		}
		local recipientSource

		if FFlagShareSheetFriendsSort then
			recipientSource = data.recipientSource
		end

		v2.recipientSource = recipientSource
		logLifecycle(v2)

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
