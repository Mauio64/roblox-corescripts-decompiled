local AppStorageService = game:GetService("AppStorageService")

local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local React = require(CorePackages.Packages.React)
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local module2 = require("@luauforge/bundled/fvN")
local module3 = require("@luauforge/bundled/ise")

local module4 = require("@luauforge/bundled/isf")

local module5 = require("@luauforge/bundled/isg")
local module6 = require("@luauforge/bundled/ioB")
local module7 = require("@luauforge/bundled/irO")

local module8 = require("@luauforge/bundled/ish")
local module9 = require("@luauforge/bundled/isi")

local extended = React.Component:extend("LuaAppRootErrorBoundary")

function extended.getDerivedStateFromError(p2)
	return { hasError = true }
end

function extended:init()
	self.state = { hasError = false }
	self.restartThread = nil

	function self.scheduleAutoRestart()
		local props = self.props

		if self.restartThread then
			return "claimed"
		end

		local v5 = if props.now then props.now() else os.time()
		local v6 = module8(props.appStorage or AppStorageService, v5, module5)

		if v6 ~= "claimed" then
			return v6
		end

		local function restart()
			self.restartThread = nil
			(props.guiService or GuiService):BroadcastNotification("", module2.RESTART_LUA_APP)
		end
		local v7 = self
		local v8 = if props.delay then props.delay(module4, restart) else task.delay(module4, restart)
		v7.restartThread = v8

		return v6
	end
end

function extended.componentDidCatch(p2, p3, p4)
	local v5 = p2.scheduleAutoRestart()
	LoggingProtocol.default:logRobloxTelemetryCounter(module3, 1, { restart = v5 })

	module9(p3, p4 and p4.componentStack or nil)

	if module6 then
		pcall(module7.recordUnmount, nil, { trigger = "boundary", restart = v5 })
	end
end

function extended:willUnmount()
	if self.restartThread then
		pcall(task.cancel, self.restartThread)
		self.restartThread = nil
	end
end

function extended.render(p2)
	if p2.state.hasError then
		return nil
	end

	return p2.props.children
end

return extended
