local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Error = LuauPolyfill.Error

local console = require(script.Parent.console)

local messageSet = {}

local ReactComponentStackFrame = require(script.Parent.ReactComponentStackFrame)

local describeUnknownElementTypeFrameInDEV = ReactComponentStackFrame.describeUnknownElementTypeFrameInDEV

local ReactSharedInternals = require(script.Parent.ReactSharedInternals)

local ErrorHandlingroblox = require(script.Parent["ErrorHandling.roblox"])
local describeError = ErrorHandlingroblox.describeError

local ReactDebugCurrentFrame = ReactSharedInternals.ReactDebugCurrentFrame

local function setCurrentlyValidatingElement(data) -- 4 equivalent calls inferred from this helper
	if ReactGlobals.__DEV__ then
		if data then
			local owner = data._owner

			local kind = data.type
			local source = data._source
			local v

			if owner ~= nil then
				v = owner.type
			end

			local v2 = describeUnknownElementTypeFrameInDEV(kind, source, v)

			ReactDebugCurrentFrame.setExtraStackFrame(v2)
		else
			ReactDebugCurrentFrame.setExtraStackFrame(nil)
		end
	end
end

local function checkPropTypes(items, callback, p, p2: string, value: string?, data)
	if ReactGlobals.__DEV__ or ReactGlobals.__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
		if items and callback then
			console.warn("You've defined both propTypes and validateProps on " .. (value or "a component"))
		end

		if callback then
			if typeof(callback) == "function" then
				local v, v2 = callback(p)

				if not v then
					local v3 = string.format(
						"validateProps failed on a %s type in %s: %s",
						p2,
						value or "<UNKNOWN Component>",
						(tostring(v2 or "<Validator function did not supply a message>"))
					)

					error(v3)
				end
			else
				console.error(("validateProps must be a function, but it is a %s.\nCheck the definition of the component %q."):format(
					typeof(callback),
					value or ""
				))
			end
		end

		if items then
			assert(typeof(items) == "table", "propTypes needs to be a table")

			for k, _ in items do
				local _, result = xpcall(function()
					if typeof(items[k]) ~= "function" then
						local v = Error.new((value or "React class") .. ": " .. p2 .. " type `" .. k .. "` is invalid; " .. "it must be a function, usually from the `prop-types` package, but received `" .. typeof(items[k]) .. "`.This often happens because of typos such as `PropTypes.function` instead of `PropTypes.func`.")

						v.name = "Invariant Violation"
						error(v)
					end

					return items[k](p, k, value, p2, nil, "SECRET_DO_NOT_PASS_THIS_OR_YOU_WILL_BE_FIRED")
				end, describeError)

				local v = typeof(result) == "table"

				if result ~= nil and not v then
					setCurrentlyValidatingElement(data) -- inferred equivalent call
					console.error(string.format(
						"%s: type specification of %s `%s` is invalid; the type checker function must return `nil` or an `Error` but returned a %s. You may have forgotten to pass an argument to the type checker creator (arrayOf, instanceOf, objectOf, oneOf, oneOfType, and shape all require an argument).",
						value or "React class",
						p2,
						k,
						(typeof(result))
					))
					setCurrentlyValidatingElement() -- inferred equivalent call
				end

				if not (v and messageSet[result.message] == nil) then
					continue
				end

				messageSet[tostring(result.message)] = true
				setCurrentlyValidatingElement(data) -- inferred equivalent call
				console.warn(string.format("Failed %s type: %s", p2, (tostring(result.message))))
				setCurrentlyValidatingElement() -- inferred equivalent call
			end
		end
	end
end

return checkPropTypes
