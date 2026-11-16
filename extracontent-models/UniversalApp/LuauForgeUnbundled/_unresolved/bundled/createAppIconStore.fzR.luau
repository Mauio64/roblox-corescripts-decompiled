local CorePackages = game:GetService("CorePackages")

local Signals = require(CorePackages.Packages.Signals)
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local module = require("@luauforge/bundled/fzM")
local module2 = require("@luauforge/bundled/fzS")
local module3 = require("@luauforge/bundled/fyV")

local module4 = require("@luauforge/bundled/fzT")

local function defaultNow()
	return DateTime.now().UnixTimestamp
end

local function defaultWindowSeconds()
	return module4
end

local function createAppIconStore(p2, p3, p4, p5, p6)
	local v5 = p5 or defaultNow
	local v6 = p6 or defaultWindowSeconds
	local signal, v7 = Signals.createSignal(module2.getAppliedAppIcon(p3))
	local v8 = 0

	local function applyToDevice(p7)
		if p7 == signal(false) then
			return
		end

		local v9 = p4 or module3.GetSystemThemeService()

		if v9 then
			local success, result = pcall(function()
				v9:setAppIcon(module.NATIVE_NAME[p7])
			end)

			if not success then
				logger:warning("[AppIcon] Failed to set app icon " .. p7 .. ": " .. tostring(result))
				return
			end
		end

		v7(p7)
		module2.setAppliedAppIcon(p7, p3)
	end

	local function setAppIcon(p7)
		applyToDevice(p7)

		if v8 > 0 and signal(false) == p7 then
			module2.setPick(v8, p7, p3)
		end
	end

	local function syncActiveUser(p7, p8, callback)
		v8 = p7
		local v9 = v5()
		local v10 = v9 - v6()
		local plusActivity = module2.getPlusActivity(p3)
		local flag = false

		if p7 > 0 then
			local v11 = tostring(p7)

			if p8 then
				plusActivity[v11] = v9
				flag = true
			elseif plusActivity[v11] ~= nil then
				plusActivity[v11] = nil
				flag = true
			end
		end

		local v11 = false

		for k, v12 in plusActivity do
			if v12 < v10 then
				plusActivity[k] = nil
				flag = true
			else
				v11 = true
			end
		end

		if flag then
			module2.setPlusActivity(plusActivity, p3)
		end

		if p7 > 0 and p8 then
			applyToDevice(module2.getPicks(p3)[tostring(p7)] or module.AppIcon.Default)
		else
			local v12 = signal(false)

			if module.REQUIRES_PLUS[v12] and not (callback(v12) or v11) then
				applyToDevice(module.AppIcon.Default)
			end
		end
	end

	return {
		getAppIcon = signal,
		setAppIcon = setAppIcon,
		syncActiveUser = syncActiveUser
	}
end

return createAppIconStore
