local CrossPlay = script:FindFirstAncestor("CrossPlay")
local CrossPlayParent = CrossPlay.Parent
local Cryo = require(CrossPlayParent.Cryo)
local Rodux = require(CrossPlayParent.Rodux)
local CrossPlayCapabilities = require(CrossPlayParent.UniversalAppPolicy).Enum.CrossPlayCapabilities
local GetUserSettingsPlatform = require(CrossPlay.Networking).thunks.GetUserSettingsPlatform
local Networking = require(CrossPlay.Networking)
local UpdateUserSettingsPlatform = Networking.thunks.UpdateUserSettingsPlatform
local roduxNetworking = Networking.roduxNetworking
local CrossPlayFetchFailed = require(CrossPlay.Actions.CrossPlayFetchFailed)
local CrossPlaySettingsReset = require(CrossPlay.Actions.CrossPlaySettingsReset)
local CrossPlayUpdateFailed = require(CrossPlay.Actions.CrossPlayUpdateFailed)
local CrossPlaySetValue = require(CrossPlay.Actions.CrossPlaySetValue)
local CrossPlaySetPrivileges = require(CrossPlay.Actions.CrossPlaySetPrivileges)
local CrossPlayGetPrivilegesFailed = require(CrossPlay.Actions.CrossPlayGetPrivilegesFailed)
local CrossPlayResetPrivileges = require(CrossPlay.Actions.CrossPlayResetPrivileges)
local Constants = require(CrossPlay.Hooks.Constants)
local v18 = game:DefineFastFlag("CrossPlayActuallyResetErrorStates", false)
local PrivilegeCheckResults = Constants.PrivilegeCheckResults
local t1 = {
	LuaError = nil,
	HttpError = nil,
	SystemError = nil,
	Status = {},
	SystemPrivileges = {},
	NetworkStatus = {}
}
local v21 = Rodux.createReducer(t1, {
	[GetUserSettingsPlatform.Succeeded.name] = function(t2: {[any]: any}, p1) -- line: 60
		-- upvalues: Cryo (copy), v18 (copy)
		local crossPlaySettingsKey = p1.additionalData.crossPlaySettingsKey
		local v26 = p1.responseBody[crossPlaySettingsKey] or {}

		return Cryo.Dictionary.join(t2, {
			Status = Cryo.Dictionary.join(t2.Status, v26),
			LuaError = if not v18 then nil else Cryo.None,
			HttpError = if not v18 then nil else Cryo.None
		})
	end,
	[GetUserSettingsPlatform.Failed.name] = function(t3: {[any]: any}, p2) -- line: 70
		-- upvalues: Cryo (copy), v18 (copy)
		return Cryo.Dictionary.join(t3, {
			Status = {},
			HttpError = p2.error,
			LuaError = if not v18 then nil else Cryo.None
		})
	end,
	[UpdateUserSettingsPlatform.Succeeded.name] = function(t4: {[any]: any}, p3) -- line: 77
		-- upvalues: Cryo (copy), v18 (copy)
		local crossPlayValue = p3.additionalData.crossPlayValue

		return Cryo.Dictionary.join(t4, {
			Status = Cryo.Dictionary.join(t4.Status, {
				isEnabled = crossPlayValue
			}),
			LuaError = if not v18 then nil else Cryo.None,
			HttpError = if not v18 then nil else Cryo.None
		})
	end,
	[UpdateUserSettingsPlatform.Failed.name] = function(t5: {[any]: any}, p4) -- line: 88
		-- upvalues: Cryo (copy), v18 (copy)
		return Cryo.Dictionary.join(t5, {
			HttpError = p4.error,
			LuaError = if not v18 then nil else Cryo.None
		})
	end,
	[CrossPlaySetPrivileges.name] = function(t6: {[any]: any}, p5) -- line: 94
		-- upvalues: CrossPlayCapabilities (copy), PrivilegeCheckResults (copy), Cryo (copy), v18 (copy)
		local v36 = p5.privileges[CrossPlayCapabilities.CrossPlatform] or {}
		local v37 = v36.Success and (v36.CanJoinGame and v36.PrivilegeCheckResult == PrivilegeCheckResults.NO_ISSUE)

		return Cryo.Dictionary.join(t6, {
			Status = Cryo.Dictionary.join(t6.Status, {
				isSystemPrivilegeEnabled = v37
			}),
			SystemPrivileges = Cryo.Dictionary.join(t6.SystemPrivileges, p5.privileges),
			SystemError = if not v18 then nil else Cryo.None
		})
	end,
	[CrossPlayGetPrivilegesFailed.name] = function(t7: {[any]: any}, p6) -- line: 109
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t7, {
			Status = Cryo.Dictionary.join(t7.Status, {
				isSystemPrivilegeEnabled = false
			}),
			SystemPrivileges = {},
			SystemError = p6.error
		})
	end,
	[CrossPlayResetPrivileges.name] = function(t8: {[any]: any}) -- line: 118
		-- upvalues: Cryo (copy), v18 (copy)
		return Cryo.Dictionary.join(t8, {
			Status = Cryo.Dictionary.join(t8.Status, {
				isSystemPrivilegeEnabled = false
			}),
			SystemPrivileges = {},
			SystemError = if not v18 then nil else Cryo.None
		})
	end,
	[CrossPlaySetValue.name] = function(t9: {[any]: any}, p7) -- line: 127
		-- upvalues: Cryo (copy)
		local crossPlayValue = p7.crossPlayValue

		return Cryo.Dictionary.join(t9, {
			Status = Cryo.Dictionary.join(t9.Status, {
				isEnabled = crossPlayValue,
				isSystemPrivilegeEnabled = crossPlayValue
			})
		})
	end,
	[CrossPlayFetchFailed.name] = function(t10: {[any]: any}, p8) -- line: 137
		-- upvalues: Cryo (copy), v18 (copy)
		return Cryo.Dictionary.join(t10, {
			Status = {},
			LuaError = p8.error,
			HttpError = if not v18 then nil else Cryo.None
		})
	end,
	[CrossPlayUpdateFailed.name] = function(t11: {[any]: any}, p9) -- line: 144
		-- upvalues: Cryo (copy), v18 (copy)
		return Cryo.Dictionary.join(t11, {
			Status = {},
			LuaError = p9.error,
			HttpError = if not v18 then nil else Cryo.None
		})
	end,
	[CrossPlaySettingsReset.name] = function() -- line: 151
		-- upvalues: t1 (copy)
		return t1
	end
})
local v22 = Rodux.combineReducers({
	NetworkStatus = roduxNetworking.installReducer()
})

return function(p10, p11) -- line: 160
	-- upvalues: v21 (copy), Cryo (copy), v22 (copy)
	local v50 = v21(p10, p11)

	return Cryo.Dictionary.join(v50, v22(v50, p11))
end
