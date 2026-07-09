local CrossPlay = script:FindFirstAncestor("CrossPlay")
local CrossPlayParent = CrossPlay.Parent
local React = require(CrossPlayParent.React)
local useDispatch = require(CrossPlayParent.RoactUtils).Hooks.RoactRodux.useDispatch
local LinkingProtocol = require(CrossPlayParent.LinkingProtocol).LinkingProtocol
local useAppPolicy = require(CrossPlayParent.UniversalAppPolicy).useAppPolicy
local GetUserSettingsPlatform = require(CrossPlay.Networking).thunks.GetUserSettingsPlatform
local UpdateUserSettingsPlatform = require(CrossPlay.Networking).thunks.UpdateUserSettingsPlatform
local CrossPlayFetchFailed = require(CrossPlay.Actions.CrossPlayFetchFailed)
local CrossPlaySettingsReset = require(CrossPlay.Actions.CrossPlaySettingsReset)
local CrossPlayUpdateFailed = require(CrossPlay.Actions.CrossPlayUpdateFailed)
local CrossPlaySetValue = require(CrossPlay.Actions.CrossPlaySetValue)
local CrossPlaySetPrivileges = require(CrossPlay.Actions.CrossPlaySetPrivileges)
local CrossPlayGetPrivilegesFailed = require(CrossPlay.Actions.CrossPlayGetPrivilegesFailed)
local CrossPlayStubSystemPrivileges = require(CrossPlay.Actions.CrossPlayStubSystemPrivileges)
local CrossPlayResetPrivileges = require(CrossPlay.Actions.CrossPlayResetPrivileges)
local getPlatformPrivilegeSettings = require(script.Parent.getPlatformPrivilegeSettings)

local function useCrossPlayApi() -- line: 19
	-- upvalues: useAppPolicy (copy), useDispatch (copy), React (copy), GetUserSettingsPlatform (copy), UpdateUserSettingsPlatform (copy), CrossPlayResetPrivileges (copy), getPlatformPrivilegeSettings (copy), CrossPlaySetPrivileges (copy), CrossPlayUpdateFailed (copy), CrossPlayGetPrivilegesFailed (copy), CrossPlayStubSystemPrivileges (copy), CrossPlayFetchFailed (copy), LinkingProtocol (copy), CrossPlaySetValue (copy), CrossPlaySettingsReset (copy)
	local v19 = useAppPolicy(function(p1) -- line: 20
		return p1.useLegacyCrossPlayApi()
	end)
	local v20 = useAppPolicy(function(p2) -- line: 23
		return p2.useCrossPlaySystemUi()
	end)
	local v21 = useAppPolicy(function(p3) -- line: 26
		return p3.getCrossPlayUri()
	end)
	local v22 = useAppPolicy(function(p4) -- line: 29
		return p4.getCrossPlayCapabilities()
	end)
	local v23 = useAppPolicy(function(p5) -- line: 32
		return p5.getCrossPlaySettingsKey()
	end)
	local v24 = useAppPolicy(function(p6) -- line: 35
		return p6.getCrossPlayQueryParam()
	end)
	local v25 = useDispatch()
	local v26 = React.useCallback(function() -- line: 41
		-- upvalues: v25 (copy), GetUserSettingsPlatform (copy), v24 (copy), v23 (copy), v19 (copy)
		return v25(GetUserSettingsPlatform.API(v24, v23, v19))
	end, {
		v25,
		v24,
		v23,
		v19
	})
	local v27 = React.useCallback(function(p7) -- line: 50
		-- upvalues: v25 (copy), UpdateUserSettingsPlatform (copy), v24 (copy), v23 (copy), v19 (copy)
		return v25(UpdateUserSettingsPlatform.API(v24, v23, p7, v19))
	end, {
		v25,
		v24,
		v23,
		v19
	})
	local v28 = React.useCallback(function(p8) -- line: 67
		-- upvalues: v25 (copy), CrossPlayResetPrivileges (copy), getPlatformPrivilegeSettings (copy), v22 (copy), CrossPlaySetPrivileges (copy), v27 (copy), CrossPlayUpdateFailed (copy), CrossPlayGetPrivilegesFailed (copy)
		v25(CrossPlayResetPrivileges())

		return getPlatformPrivilegeSettings(v22):andThen(function(p9) -- line: 71
			-- upvalues: v25 (copy), CrossPlaySetPrivileges (copy), p8 (copy), v27 (copy), CrossPlayUpdateFailed (copy)
			v25(CrossPlaySetPrivileges(p9))

			if p9.CrossPlatform.CanJoinGame ~= p8 then
				return v27(p9.CrossPlatform.CanJoinGame):catch(function(p10) -- line: 76
					-- upvalues: v25 (copy), CrossPlayUpdateFailed (copy)
					v25(CrossPlayUpdateFailed(p10))
				end)
			end
		end):catch(function(p11) -- line: 81
			-- upvalues: v25 (copy), CrossPlayGetPrivilegesFailed (copy)
			v25(CrossPlayGetPrivilegesFailed(p11))
		end)
	end, {
		v25,
		v22,
		v27
	})
	local v29 = React.useCallback(function() -- line: 87
		-- upvalues: v26 (copy), v20 (copy), v28 (copy), v23 (copy), getPlatformPrivilegeSettings (copy), v22 (copy), v25 (copy), CrossPlayStubSystemPrivileges (copy), CrossPlayFetchFailed (copy)
		return v26():andThen(function(p12) -- line: 90
			-- upvalues: v20 (copy), v28 (copy), v23 (copy), getPlatformPrivilegeSettings (copy), v22 (copy), v25 (copy), CrossPlayStubSystemPrivileges (copy)
			if v20 then
				return v28(p12.responseBody[v23].isEnabled)
			end

			getPlatformPrivilegeSettings(v22):andThen(function(p13) -- line: 94
				-- upvalues: v25 (copy), CrossPlayStubSystemPrivileges (copy)
				v25(CrossPlayStubSystemPrivileges(p13))
			end)
		end):catch(function(p14) -- line: 99
			-- upvalues: v25 (copy), CrossPlayFetchFailed (copy)
			v25(CrossPlayFetchFailed(p14))
		end)
	end, {
		v25,
		v23,
		v28,
		v26,
		v20
	})
	local v30 = React.useCallback(function() -- line: 112
		-- upvalues: v20 (copy), v21 (copy), LinkingProtocol (copy)
		if v20 and v21 then
			LinkingProtocol.default:openURL(v21)
		end
	end, {
		v20,
		v21
	})
	local v31 = React.useCallback(function(b1: boolean) -- line: 119
		-- upvalues: v20 (copy), v30 (copy), v25 (copy), CrossPlaySetValue (copy), v27 (copy), v29 (copy), CrossPlayUpdateFailed (copy)
		if v20 then
			v30()

			return
		end

		v25(CrossPlaySetValue(b1))

		return v27(b1):andThen(function() -- line: 128
			-- upvalues: v29 (copy)
			v29()
		end):catch(function(p15) -- line: 131
			-- upvalues: v25 (copy), CrossPlayUpdateFailed (copy)
			v25(CrossPlayUpdateFailed(p15))
		end)
	end, {
		v25,
		v27,
		v29,
		v30
	})
	local v32 = React.useCallback(function() -- line: 144
		-- upvalues: v25 (copy), CrossPlaySettingsReset (copy)
		v25(CrossPlaySettingsReset())
	end, { v25 })

	return (React.useMemo(function() -- line: 149
		-- upvalues: v29 (copy), v32 (copy), v31 (copy), v30 (copy)
		return {
			fetch = v29,
			reset = v32,
			update = v31,
			invokeSystemUi = v30
		}
	end, {
		v29,
		v32,
		v31,
		v30
	}))
end

return useCrossPlayApi
