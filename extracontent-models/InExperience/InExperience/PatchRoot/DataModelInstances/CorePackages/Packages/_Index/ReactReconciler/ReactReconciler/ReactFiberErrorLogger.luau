local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)

local inspect = LuauPolyfill.util.inspect
local setTimeout = LuauPolyfill.setTimeout

local Shared = require(parent.Shared)
local console = Shared.console
local errorToString = Shared.errorToString

require(script.Parent.ReactInternalTypes)

require(script.Parent.ReactCapturedValue)

local ReactFiberErrorDialog = require(script.Parent.ReactFiberErrorDialog)
local showErrorDialog = ReactFiberErrorDialog.showErrorDialog
local ReactWorkTags = require(script.Parent.ReactWorkTags)
local ClassComponent = ReactWorkTags.ClassComponent
local Shared2 = require(parent.Shared)
local getComponentName = Shared2.getComponentName

return {
	logCapturedError = function(p, data)
		local success, result = pcall(function()
			if showErrorDialog(p, data) == false then
				return nil
			end

			local value = data.value

			if ReactGlobals.__DEV__ then
				local source = data.source
				local stack = data.stack or ""

				if value ~= nil and value._suppressLogging then
					if p.tag == ClassComponent then
						return
					end

					console.error(value)
				end

				local v

				if source ~= nil then
					v = getComponentName(source.type)
				end

				local v2 = not v and "The above error occurred in one of your React components:"
					or "The above error occurred in the <" .. tostring(v) .. "> component:"

				local componentName = getComponentName(p.type)

				local v3 = v2 .. "\n" .. stack .. "\n\n" .. (not componentName and "Consider adding an error boundary to your tree to customize error handling behavior.\nVisit https://reactjs.org/link/error-boundaries to learn more about error boundaries." or "React will try to recreate this component tree from scratch " .. "using the error boundary you provided, " .. componentName .. ".")

				console.error(v3)
			else
				console.error(inspect(value))
			end

			return nil
		end)

		if not success then
			warn("failed to error with error: " .. inspect(result))

			setTimeout(function()
				error(errorToString(result))
			end)
		end
	end
}
