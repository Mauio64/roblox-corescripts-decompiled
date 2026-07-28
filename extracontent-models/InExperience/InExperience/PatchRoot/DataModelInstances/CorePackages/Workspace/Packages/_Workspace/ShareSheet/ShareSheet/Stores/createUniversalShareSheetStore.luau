local ShareSheet = script:FindFirstAncestor("ShareSheet")
local ShareSheetParent = ShareSheet.Parent
local Signals = require(ShareSheetParent.Signals)
local ShareSheetTelemetry = require(ShareSheet.telemetry.ShareSheetTelemetry)

local function createUniversalShareSheetStore() -- line: 32
	-- upvalues: Signals (copy), ShareSheetTelemetry (copy)
	local v6, v7 = Signals.createSignal(nil)

	return {
		getRequest = v6,
		show = function(t1: {[any]: any}) -- line: 48
			-- upvalues: v6 (copy), v7 (copy), ShareSheetTelemetry (copy)
			local v10 = v6(false)

			if v10 ~= nil then
				v7(nil)

				if v10.onHidden then
					v10.onHidden()
				end
			end

			v7(table.clone(t1))
			ShareSheetTelemetry.logShareSheetOpened({
				context = t1.context,
				url = t1.url,
				telemetryId = t1.telemetryId or ""
			})

			if t1.onShown then
				t1.onShown()
			end
		end,
		hide = function() -- line: 36
			-- upvalues: v6 (copy), v7 (copy)
			local v8 = v6(false)

			if v8 == nil then
				return
			end

			v7(nil)

			if v8.onHidden then
				v8.onHidden()
			end
		end
	}
end

return createUniversalShareSheetStore
