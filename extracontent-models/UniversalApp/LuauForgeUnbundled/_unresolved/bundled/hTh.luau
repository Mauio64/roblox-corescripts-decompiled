local module = require("@luauforge/bundled/hSF")
local module2 = require("@luauforge/bundled/hST")
local crossPlayCapabilities = require("@luauforge/bundled/hSJ").Enum.CrossPlayCapabilities
local getUserSettingsPlatform = require("@luauforge/bundled/hSK").thunks.GetUserSettingsPlatform
local module3 = require("@luauforge/bundled/hSK")
local updateUserSettingsPlatform = module3.thunks.UpdateUserSettingsPlatform
local roduxNetworking = module3.roduxNetworking
local module4 = require("@luauforge/bundled/hSS")
local module5 = require("@luauforge/bundled/hSU")
local module6 = require("@luauforge/bundled/hSV")
local module7 = require("@luauforge/bundled/hSW")
local module8 = require("@luauforge/bundled/hSX")
local module9 = require("@luauforge/bundled/hSY")
local module10 = require("@luauforge/bundled/hTb")
local module11 = require("@luauforge/bundled/hTa")
local defineFastFlag = game:DefineFastFlag("CrossPlayActuallyResetErrorStates", false)

local privilegeCheckResults = module11.PrivilegeCheckResults

local v5 = {
	Status = {},
	SystemPrivileges = {},
	LuaError = nil,
	HttpError = nil,
	SystemError = nil,
	NetworkStatus = {}
}

local reducer = module2.createReducer(v5, {
	[getUserSettingsPlatform.Succeeded.name] = function(p2, p3)
		local crossPlaySettingsKey = p3.additionalData.crossPlaySettingsKey
		local v7 = p3.responseBody[crossPlaySettingsKey] or {}

		local join = module.Dictionary.join
		local v8 = {
			Status = module.Dictionary.join(p2.Status, v7),
			LuaError = 0,
			HttpError = 0
		}
		local v9 = if defineFastFlag then module.None else nil
		v8.LuaError = v9
		local v10 = if defineFastFlag then module.None else nil
		v8.HttpError = v10
		return join(p2, v8)
	end,
	[getUserSettingsPlatform.Failed.name] = function(p2, p3)
		local join = module.Dictionary.join
		local v7 = { Status = {}, HttpError = p3.error, LuaError = 0 }
		local v8 = if defineFastFlag then module.None else nil
		v7.LuaError = v8
		return join(p2, v7)
	end,
	[updateUserSettingsPlatform.Succeeded.name] = function(p2, p3)
		local crossPlayValue = p3.additionalData.crossPlayValue

		local join = module.Dictionary.join
		local v7 = {
			Status = module.Dictionary.join(p2.Status, { isEnabled = crossPlayValue }),
			LuaError = 0,
			HttpError = 0
		}

		local v8 = if defineFastFlag then module.None else nil
		v7.LuaError = v8
		local v9 = if defineFastFlag then module.None else nil
		v7.HttpError = v9
		return join(p2, v7)
	end,
	[updateUserSettingsPlatform.Failed.name] = function(p2, p3)
		local join = module.Dictionary.join
		local v7 = { HttpError = p3.error, LuaError = 0 }
		local v8 = if defineFastFlag then module.None else nil
		v7.LuaError = v8
		return join(p2, v7)
	end,
	[module8.name] = function(p2, p3)
		local v7 = p3.privileges[crossPlayCapabilities.CrossPlatform] or {}

		local v8 = v7.Success
			and v7.CanJoinGame
			and v7.PrivilegeCheckResult == privilegeCheckResults.NO_ISSUE

		local join = module.Dictionary.join
		local v9 = {
			Status = module.Dictionary.join(p2.Status, { isSystemPrivilegeEnabled = v8 }),
			SystemPrivileges = module.Dictionary.join(p2.SystemPrivileges, p3.privileges),
			SystemError = 0
		}
		local v10 = if defineFastFlag then module.None else nil
		v9.SystemError = v10
		return join(p2, v9)
	end,
	[module9.name] = function(p2, p3)
		return module.Dictionary.join(p2, {
			Status = module.Dictionary.join(p2.Status, {
				isSystemPrivilegeEnabled = false
			}),
			SystemPrivileges = {},
			SystemError = p3.error
		})
	end,
	[module10.name] = function(p2)
		local join = module.Dictionary.join
		local v7 = {
			Status = module.Dictionary.join(p2.Status, {
				isSystemPrivilegeEnabled = false
			}),
			SystemPrivileges = {},
			SystemError = 0
		}
		local v8 = if defineFastFlag then module.None else nil
		v7.SystemError = v8
		return join(p2, v7)
	end,
	[module7.name] = function(p2, p3)
		local crossPlayValue = p3.crossPlayValue

		return module.Dictionary.join(p2, {
			Status = module.Dictionary.join(p2.Status, {
				isEnabled = crossPlayValue,
				isSystemPrivilegeEnabled = crossPlayValue
			})
		})
	end,
	[module4.name] = function(p2, p3)
		local join = module.Dictionary.join
		local v7 = { Status = {}, LuaError = p3.error, HttpError = 0 }
		local v8 = if defineFastFlag then module.None else nil
		v7.HttpError = v8
		return join(p2, v7)
	end,
	[module6.name] = function(p2, p3)
		local join = module.Dictionary.join
		local v7 = { Status = {}, LuaError = p3.error, HttpError = 0 }
		local v8 = if defineFastFlag then module.None else nil
		v7.HttpError = v8
		return join(p2, v7)
	end,
	[module5.name] = function()
		return v5
	end
})

local combineReducers = module2.combineReducers({
	NetworkStatus = roduxNetworking.installReducer()
})

return function(p2, p3)
	local v7 = reducer(p2, p3)
	return module.Dictionary.join(v7, combineReducers(v7, p3))
end
