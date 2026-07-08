local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local inspect = LuauPolyfill.util.inspect
local setTimeout = LuauPolyfill.setTimeout
local Shared = require(ParentParent.Shared)
local console = Shared.console
local errorToString = Shared.errorToString

require(script.Parent.ReactInternalTypes)
require(script.Parent.ReactCapturedValue)

local showErrorDialog = require(script.Parent.ReactFiberErrorDialog).showErrorDialog
local ClassComponent = require(script.Parent.ReactWorkTags).ClassComponent
local getComponentName = require(ParentParent.Shared).getComponentName

return {
	logCapturedError = function(p1, p2) -- line: 34
		-- upvalues: showErrorDialog (copy), ReactGlobals (copy), ClassComponent (copy), console (copy), getComponentName (copy), inspect (copy), setTimeout (copy), errorToString (copy)
		local ok, result = pcall(function() -- line: 35
			-- upvalues: showErrorDialog (copy), p1 (copy), p2 (copy), ReactGlobals (copy), ClassComponent (copy), console (copy), getComponentName (copy), inspect (copy)
			if showErrorDialog(p1, p2) == false then
				return nil
			end

			local value = p2.value

			if ReactGlobals.__DEV__ then
				local source = p2.source
				local v18 = p2.stack or ""

				if value ~= nil and value._suppressLogging then
					if p1.tag == ClassComponent then
						return
					end

					console.error(value)
				end

				local v19 = if source == nil then nil else getComponentName(source.type)
				local v20 = not v19 and "The above error occurred in one of your React components:" or "The above error occurred in the <" .. tostring(v19) .. "> component:"
				local v21 = getComponentName(p1.type)
				local v22 = v20 .. "\n" .. v18 .. "\n\n" .. (not v21 and "Consider adding an error boundary to your tree to customize error handling behavior.\nVisit https://reactjs.org/link/error-boundaries to learn more about error boundaries." or "React will try to recreate this component tree from scratch " .. "using the error boundary you provided, " .. v21 .. ".")

				console.error(v22)
			else
				console.error(inspect(value))
			end

			return nil
		end)

		if not ok then
			warn("failed to error with error: " .. inspect(result))
			setTimeout(function() -- line: 126
				-- upvalues: errorToString (copy), result (copy)
				error(errorToString(result))
			end)
		end
	end
}
