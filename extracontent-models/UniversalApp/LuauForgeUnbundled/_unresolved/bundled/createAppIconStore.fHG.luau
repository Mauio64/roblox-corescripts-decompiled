local CorePackages = game:GetService("CorePackages")

local Signals = require(CorePackages.Packages.Signals)
local module = require("@luauforge/bundled/fHC")
local module2 = require("@luauforge/bundled/fHH")
local systemThemeService = require("@luauforge/bundled/fGL").GetSystemThemeService()

local module3 = require("@luauforge/bundled/fHI")

local function defaultNow()
	return DateTime.now().UnixTimestamp
end

local function defaultWindowSeconds()
	return module3
end

local function createAppIconStore(p2, p3, p4, p5)
	local v5 = p4 or defaultNow
	local v6 = p5 or defaultWindowSeconds
	local signal, v7 = Signals.createSignal(module2.getAppliedAppIcon(p3))
	local v8 = 0

	local function applyToDevice(p6)
		if p6 == signal(false) then
			return
		end

		if systemThemeService then
			systemThemeService:setAppIcon(module.NATIVE_NAME[p6])
		end

		v7(p6)
		module2.setAppliedAppIcon(p6, p3)
	end

	local function setAppIcon(p6)
		if p6 ~= signal(false) then
			if systemThemeService then
				systemThemeService:setAppIcon(module.NATIVE_NAME[p6])
			end

			v7(p6)
			module2.setAppliedAppIcon(p6, p3)
		end

		if v8 > 0 and signal(false) == p6 then
			module2.setPick(v8, p6, p3)
		end
	end

	local function syncActiveUser(p6, p7, callback)
		v8 = p6
		local v9 = v5()
		local v10 = v9 - v6()
		local plusActivity = module2.getPlusActivity(p3)
		local flag = false

		if p6 > 0 then
			local v11 = tostring(p6)

			if p7 then
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

		if p6 > 0 and p7 then
			local v12 = module2.getPicks(p3)[tostring(p6)] or module.AppIcon.Default

			if v12 == signal(false) then
				return
			end

			if systemThemeService then
				systemThemeService:setAppIcon(module.NATIVE_NAME[v12])
			end

			v7(v12)
			module2.setAppliedAppIcon(v12, p3)
		else
			local v12 = signal(false)

			if not module.REQUIRES_PLUS[v12] or callback(v12) or v11 then
				return
			end

			local default = module.AppIcon.Default

			if default == signal(false) then
				return
			end

			if systemThemeService then
				systemThemeService:setAppIcon(module.NATIVE_NAME[default])
			end

			v7(default)
			module2.setAppliedAppIcon(default, p3)
		end
	end

	return {
		getAppIcon = signal,
		setAppIcon = setAppIcon,
		syncActiveUser = syncActiveUser
	}
end

return createAppIconStore
