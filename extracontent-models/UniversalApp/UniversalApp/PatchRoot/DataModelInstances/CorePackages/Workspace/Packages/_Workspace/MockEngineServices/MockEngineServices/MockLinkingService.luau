local t1 = {}

t1.__index = t1

function t1.new(_) -- line: 4
	-- upvalues: t1 (copy)
	local t2 = {
		emtpyUrlDataForStartDelivery = false,
		lastLuaUrl = nil,
		switchedToSettingsApp = false,
		settingsAppRoute = nil,
		OnLuaUrl = {
			CallCallbacksWith = function(p2, p3, p4, s1: string?) -- line: 7
				for _, v9 in p2.callbacks do
					v9(p3, p4, s1)
				end
			end,
			callbacks = {},
			Connect = function(p5, p6) -- line: 13
				local callbacks = p5.callbacks

				table.insert(callbacks, p6)

				return {
					Disconnect = function() -- line: 17
						-- upvalues: callbacks (copy), p6 (copy)
						for v27, v28 in callbacks do
							if v28 == p6 then
								table.remove(callbacks, v27)
							end
						end
					end
				}
			end
		},
		SetEmptyUrlDataForStartDelivery = function(p7, b1: boolean) -- line: 28
			p7.emtpyUrlDataForStartDelivery = b1
		end,
		StartLuaUrlDelivery = function(p8) -- line: 31
			if p8.emtpyUrlDataForStartDelivery then
				return {}
			end

			return nil
		end,
		StopLuaUrlDelivery = function(_) -- line: 38
		end,
		OpenUrl = function(_, _) -- line: 39
			return true
		end,
		IsUrlRegistered = function(_, _) -- line: 42
			return true
		end,
		GetLastLuaUrl = function(p14) -- line: 46
			return p14.lastLuaUrl
		end,
		SetLastLuaUrl = function(p15, s2: string) -- line: 49
			p15.lastLuaUrl = s2
		end,
		SwitchToSettingsApp = function(p16, s3: string?) -- line: 54
			p16.switchedToSettingsApp = true
			p16.settingsAppRoute = s3
		end,
		SupportsSwitchToSettingsApp = function(_) -- line: 58
			return true
		end
	}

	setmetatable(t2, {
		__index = t1
	})

	return t2
end

return t1
