local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local module2 = require("@luauforge/bundled/irU")

local function getDefaultDependencies()
	return {
		scriptContext = game:GetService("ScriptContext"),
		coreGui = game:GetService("CoreGui"),
		appStorage = game:GetService("AppStorageService"),
		logCounter = function(p2)
			LoggingProtocol.default:logRobloxTelemetryCounter(module2, 1, { kind = p2 })
		end,
		defer = function(callback)
			task.defer(callback)
		end
	}
end

local function reportPendingFromPreviousLaunch(p2)
	local appStorage = p2.appStorage
	local success, item = pcall(appStorage.GetItem, appStorage, "LuaAppPendingStartupFatalError")

	if not success or type(item) ~= "string" or item == "" then
		return
	end

	pcall(function()
		appStorage:SetItem("LuaAppPendingStartupFatalError", "")
		appStorage:Flush()
	end)
	p2.logCounter(item)
end

return {
	start = function(p2, p3)
		local v5 = p3 or getDefaultDependencies()
		local appStorage = v5.appStorage

		reportPendingFromPreviousLaunch(v5)

		local v6 = false
		local errorDetailedConnection = nil
		local childAddedConnection = nil

		local function stopWatching()
			errorDetailedConnection:Disconnect()
			childAddedConnection:Disconnect()
		end

		local function report(p4)
			errorDetailedConnection:Disconnect()
			childAddedConnection:Disconnect()

			if not pcall(function()
				appStorage:SetItem("LuaAppPendingStartupFatalError", p4)
				appStorage:Flush()
			end) then
				v5.logCounter(p4)
			end
		end

		childAddedConnection = v5.coreGui.ChildAdded:Connect(function(child)
			if child.Name == "App" then
				errorDetailedConnection:Disconnect()
				childAddedConnection:Disconnect()
			end
		end)
		errorDetailedConnection = v5.scriptContext.ErrorDetailed:Connect(function(value)
			if string.find(value, "------ Error caught by React ------", 1, true) == nil then
				v5.defer(function()
					if errorDetailedConnection.Connected and not v6 and coroutine.status(p2) == "dead" then
						errorDetailedConnection:Disconnect()
						childAddedConnection:Disconnect()

						local v7 = "starter_death"

						if not pcall(function()
							appStorage:SetItem("LuaAppPendingStartupFatalError", v7)
							appStorage:Flush()
						end) then
							v5.logCounter("starter_death")
						end
					end
				end)
				return
			end

			errorDetailedConnection:Disconnect()
			childAddedConnection:Disconnect()

			local v7 = "root_error"

			if not pcall(function()
				appStorage:SetItem("LuaAppPendingStartupFatalError", v7)
				appStorage:Flush()
			end) then
				v5.logCounter("root_error")
			end
		end)

		return {
			markRootMounted = function()
				v6 = true
			end
		}
	end
}
