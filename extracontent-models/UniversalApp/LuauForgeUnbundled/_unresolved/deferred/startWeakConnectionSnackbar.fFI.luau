local module = require("@luauforge/deferred/fEH")
local module2 = require("@luauforge/deferred/fEJ")

local colorMode = module.Enums.ColorMode
local wifiSignalGood = module.Enums.IconName.WifiSignalGood

local dark = colorMode.Dark

local v5 = {
	kind = "snackbar",
	title = "Weak connection.",
	icon = wifiSignalGood,
	colorMode = dark
}

local function startWeakConnectionSnackbar(instance, callback)
	local total = 0
	local thread = nil
	local v6 = true
	local flag = false

	local function cancelPendingCheck()
		if thread then
			task.cancel(thread)
			thread = nil
		end
	end

	local function joinWithoutCloudPlay()
		if flag then
			return
		end

		flag = true
		v6 = false

		if thread then
			task.cancel(thread)
			thread = nil
		end

		callback()
	end

	local v7 = {
		kind = "snackbar",
		title = "Your connection is still weak.",
		icon = wifiSignalGood,
		actionText = "Join without Cloud Play",
		onAction = joinWithoutCloudPlay,
		colorMode = dark
	}
	local function scheduleCheck()
		if thread then
			task.cancel(thread)
			thread = nil
		end

		local v8 = total >= 30 and 20 or 10
		thread = task.delay(v8, function()
			thread = nil

			if not (v6 and instance.IsConnectionWeak) then
				total = 0
				return
			end

			total += v8
			local v9 = if total >= 30 then v7 else v5
			local v10 = total >= 30 and 10 or 4
			module2.displaySnackbar(v9, v10)
			scheduleCheck()
		end)
	end

	local function onConnectionWeakChanged()
		if instance.IsConnectionWeak then
			if thread == nil and total == 0 then
				if thread then
					task.cancel(thread)
					thread = nil
				end

				local v8 = total >= 30 and 20 or 10
				thread = task.delay(v8, function()
					thread = nil

					if not (v6 and instance.IsConnectionWeak) then
						total = 0
						return
					end

					total += v8
					local v9 = if total >= 30 then v7 else v5
					local v10 = total >= 30 and 10 or 4
					module2.displaySnackbar(v9, v10)
					scheduleCheck()
				end)
			end
		else
			if thread then
				task.cancel(thread)
				thread = nil
			end

			total = 0
		end
	end

	if instance.IsConnectionWeak then
		if thread then
			task.cancel(thread)
			thread = nil
		end

		local v8 = total >= 30 and 20 or 10
		thread = task.delay(v8, function()
			thread = nil

			if not (v6 and instance.IsConnectionWeak) then
				total = 0
				return
			end

			total += v8
			local v9 = if total >= 30 then v7 else v5
			local v10 = total >= 30 and 10 or 4
			module2.displaySnackbar(v9, v10)
			scheduleCheck()
		end)
	end

	local isConnectionWeakChangedConnection = instance:GetPropertyChangedSignal("IsConnectionWeak"):Connect(onConnectionWeakChanged)

	return function()
		v6 = false

		if thread then
			task.cancel(thread)
			thread = nil
		end

		isConnectionWeakChangedConnection:Disconnect()
	end
end

return startWeakConnectionSnackbar
